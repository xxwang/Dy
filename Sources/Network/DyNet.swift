@_exported import Alamofire
import Foundation

/// stub 行为（对标 Moya 的 `StubBehavior`）：用于单元测试时直接返回样例数据，跳过真实网络。
public enum DyStub {
    /// 不发 stub，走真实网络。
    case never

    /// 立即返回样例数据。
    case immediate

    /// 延迟若干秒后返回样例数据（模拟网络耗时）。
    case delayed(seconds: TimeInterval)
}

/// 网络门面（对标 Moya 的 `MoyaProvider`；类型改名 `DyNet` 更简洁）。
///
/// 负责：把 `DyEndpoint` 构建成请求 → 应用插件 → 调用 Alamofire 发请求
/// （或按 `stubClosure` 直接返回样例数据，跳过网络）。
///
/// 四套调用方式相互独立：
/// - `request(_:)` / `request(_:as:)` / `request(_:biz:)` —— async/await 并发（见 `DyNet+Concurrency`）
/// - `publisher(_:)` / `publisher(_:as:)` / `publisher(_:biz:)` —— Combine（见 `DyNet+Combine`）
/// - `request(_:completion:)` / `upload(_:progress:completion:)` / `download(_:to:progress:completion:)` —— 传统闭包回调（见 `DyNet+Closure`）
/// - `download(_:)` / `downloadPublisher(_:)` —— 文件下载（前两套各自已含 download 入口）
public final class DyNet {
    /// 底层 Alamofire `Session`，可注入自定义配置（超时、拦截器、证书锁定等）。
    public let session: Session

    /// 生效的插件列表。
    public let plugins: [DyNetPlugin]

    /// 每个接口是否走 stub 的决策闭包，默认 `.never`。
    public let stubClosure: (DyEndpoint) -> DyStub

    /// 是否对在途请求去重（相同 method+url+body 复用同一底层请求，避免连点重复发）。默认关闭。
    public let trackInflights: Bool

    /// 在途请求指纹表（仅 `trackInflights` 为 true 时生效）。
    private let lock = NSLock()
    private var inflight: [String: DataRequest] = [:]

    public init(
        session: Session = .default,
        plugins: [DyNetPlugin] = [],
        stubClosure: @escaping (DyEndpoint) -> DyStub = { _ in .never },
        trackInflights: Bool = false
    ) {
        self.session = session
        self.plugins = plugins
        self.stubClosure = stubClosure
        self.trackInflights = trackInflights
    }

    /// 便捷共享实例（插件为空）。
    public static let shared = DyNet()
}

// MARK: - 请求构建

extension DyNet {
    /// 构建基础 `URLRequest`（基地址 + 路径 + 方法 + 头），并依次应用插件 `prepare`。
    ///
    /// 头会先注入全局头（`DyNetConfig.shared.globalHeaders`），再叠加接口自身 `headers`（同名覆盖）；
    /// 除非接口声明 `ignoresGlobalHeaders`。超时按接口 `requestTimeout` 或全局 `timeout` 设置。
    func prepareBaseRequest(_ endpoint: DyEndpoint) -> URLRequest {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue

        if endpoint.ignoresGlobalHeaders {
            request.headers = endpoint.headers
        } else {
            var headers = DyNetConfig.shared.globalHeaders
            for (name, value) in endpoint.headers.dictionary {
                headers.add(name: name, value: value)
            }
            request.headers = headers
        }

        var result = request
        for plugin in plugins {
            result = plugin.prepare(result, endpoint: endpoint)
        }

        let timeout = endpoint.requestTimeout
            ?? (DyNetConfig.shared.timeout > 0 ? DyNetConfig.shared.timeout : nil)
        if let timeout {
            result.timeoutInterval = timeout
        }

        return result
    }

    /// 根据 `DyTask` 把参数 / JSON 体编码进 `request`（upload 除外，upload 单独走 multipart 路径）。
    func applyTaskEncoding(_ request: inout URLRequest, _ task: DyTask) throws {
        switch task {
        case .plain, .uploadMultipart:
            break
        case let .parameters(parameters, encoding):
            // 先合并全局参数，接口参数覆盖同名项。
            let merged = DyNetConfig.shared.globalParameters.merging(parameters) { $1 }
            do {
                request = try encoding.encode(request, with: merged)
            } catch {
                throw DyNetError.encodeFailure(error)
            }
        case let .json(encodable):
            do {
                request.httpBody = try JSONEncoder().encode(DyEncodableBox(encodable))
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                throw DyNetError.encodeFailure(error)
            }
        }
    }

    /// 生成真正要执行的 Alamofire 请求（已应用插件 prepare / willSend 之前）。
    /// - 返回 `DataRequest`（`UploadRequest` 为其子类）。
    func prepared(_ endpoint: DyEndpoint) throws -> DataRequest {
        let base = prepareBaseRequest(endpoint)
        switch endpoint.task {
        case let .uploadMultipart(builder):
            guard let url = base.url else {
                throw DyNetError.message("URLRequest.url is nil for upload")
            }
            return session.upload(
                multipartFormData: { builder($0) },
                to: url,
                method: base.method ?? .get,
                headers: base.headers
            )
        default:
            var final = base
            try applyTaskEncoding(&final, endpoint.task)
            return session.request(final)
        }
    }

    /// 解析出真正要执行的 `DataRequest`，并按需对在途请求去重。
    ///
    /// `trackInflights` 开启时：相同 `method+url+body` 指纹的并发请求会复用同一个底层
    /// Alamofire 请求（Alamofire 支持在同一请求上追加多个 `responseData`），避免按钮连点
    /// 发出重复请求。上传任务不参与去重。
    func resolvableRequest(_ endpoint: DyEndpoint) throws -> DataRequest {
        let req = try prepared(endpoint)
        guard trackInflights else { return req }
        if case .uploadMultipart = endpoint.task {
            return req
        }

        let key = Self.fingerprint(req.request)
        lock.lock()
        if let existing = inflight[key] {
            lock.unlock()
            return existing
        }
        inflight[key] = req
        lock.unlock()

        req.responseData { [weak self] _ in
            self?.lock.lock()
            self?.inflight.removeValue(forKey: key)
            self?.lock.unlock()
        }
        return req
    }

    /// 构建下载请求。仅把 `DyTask.plain` / `.parameters` 视作下载参数；`.json` / `.uploadMultipart` 不参与下载。
    func preparedDownload(_ endpoint: DyEndpoint, to destination: URL?) -> DownloadRequest {
        let base = prepareBaseRequest(endpoint)

        let dest: DownloadRequest.Destination = { _, response in
            if let url = destination {
                return (url, [.removePreviousFile, .createIntermediateDirectories])
            }
            let suggested = response.suggestedFilename ?? UUID().uuidString
            return (FileManager.default.temporaryDirectory.appendingPathComponent(suggested),
                    [.removePreviousFile, .createIntermediateDirectories])
        }

        let params: [String: Any]?
        let encoding: ParameterEncoding
        switch endpoint.task {
        case let .parameters(p, e):
            params = p; encoding = e
        default:
            params = nil; encoding = URLEncoding.default
        }
        let method = base.httpMethod.flatMap { HTTPMethod(rawValue: $0) } ?? .get
        guard let url = base.url else {
            preconditionFailure("Download URL must not be nil at this point")
        }
        return session.download(
            url,
            method: method,
            parameters: params,
            encoding: encoding,
            headers: base.headers,
            to: dest
        )
    }

    private static func fingerprint(_ request: URLRequest?) -> String {
        guard let request else { return UUID().uuidString }
        let method = request.httpMethod ?? ""
        let url = request.url?.absoluteString ?? ""
        let body = request.httpBody.map { $0.base64EncodedString() } ?? ""
        return "\(method)|\(url)|\(body)"
    }
}

// MARK: - 响应映射

extension DyNet {
    static func map(_ af: DataResponse<Data, AFError>) -> Result<DyResponse, DyNetError> {
        switch af.result {
        case let .success(data):
            let response = DyResponse(
                statusCode: af.response?.statusCode ?? -1,
                data: data,
                request: af.request,
                httpResponse: af.response
            )
            return .success(response)
        case let .failure(error):
            return .failure(.underlying(error))
        }
    }

    static func mapDownload(_ af: DownloadResponse<URL?, AFError>) -> Result<(DyResponse, URL), DyNetError> {
        switch af.result {
        case .success:
            let response = DyResponse(
                statusCode: af.response?.statusCode ?? -1,
                data: Data(),
                request: af.request,
                httpResponse: af.response
            )
            guard let fileURL = af.fileURL else {
                return .failure(.message("下载完成但未拿到文件地址"))
            }
            return .success((response, fileURL))
        case let .failure(error):
            return .failure(.underlying(error))
        }
    }

    /// 把下载结果里的 `DyResponse` 单独抽出（供插件 `didReceive` 使用）。
    static func downloadResultAsResponse(_ result: Result<(DyResponse, URL), DyNetError>) -> Result<DyResponse, DyNetError> {
        switch result {
        case let .success((response, _)): return .success(response)
        case let .failure(error): return .failure(error)
        }
    }

    static func mapBuildError(_ error: Error) -> DyNetError {
        if let dy = error as? DyNetError {
            return dy
        }
        return .encodeFailure(error)
    }
}

/// 让 `Encodable` 经 `JSONEncoder` 编码的透明装箱（用于 `DyTask.json`）。
struct DyEncodableBox: Encodable {
    private let _encode: (Encoder) throws -> Void

    init(_ wrapped: Encodable) {
        self._encode = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try _encode(encoder)
    }
}
