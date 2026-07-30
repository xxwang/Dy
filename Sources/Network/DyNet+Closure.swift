import Foundation
import Alamofire

// MARK: - 传统闭包回调 · 普通请求
//
// 与 `DyNet+Combine`、`DyNet+Concurrency` 相互独立，提供最朴素的
// `completion: @escaping (Result<..., DyNetError>) -> Void` 调用方式。
// 适合不想引入 Combine、也不想用 async/await 的场景（如老项目、简单回调链）。
//
// 回调统一在**主线程**派发（Alamofire 默认主队列回包 + stub 手动 dispatch 到 main），
// 可直接在闭包里更新 UI。
public extension DyNet {
    /// 传统闭包入口（原始响应）。
    ///
    /// 传输层失败走 `DyNetError`；HTTP 4xx/5xx 仍作为正常 `DyResponse` 回调（状态码可见）。
    /// - Parameter endpoint: 接口定义。
    /// - Parameter completion: 主线程回调，成功拿 `DyResponse`，失败拿 `DyNetError`。
    func request(
        _ endpoint: DyEndpoint,
        completion: @escaping (Result<DyResponse, DyNetError>) -> Void
    ) {
        if dy_closureStub(endpoint, deliver: completion) {
            return
        }

        do {
            let req = try resolvableRequest(endpoint)
            let plugins = self.plugins
            plugins.forEach { $0.willSend(req, endpoint: endpoint) }
            req.responseData { af in
                let result = DyNet.map(af)
                plugins.forEach { $0.didReceive(result, endpoint: endpoint) }
                completion(result)
            }
        } catch {
            completion(.failure(DyNet.mapBuildError(error)))
        }
    }

    /// 泛型解码入口：响应体本身就是模型 `T`，直接回调其实例。
    ///
    /// 例：`net.request(api, as: UserModel.self) { result in ... }`
    func request<T: Decodable>(
        _ endpoint: DyEndpoint,
        as type: T.Type,
        completion: @escaping (Result<T, DyNetError>) -> Void
    ) {
        request(endpoint) { result in
            switch result {
            case let .success(response):
                do { try completion(.success(response.map(type))) }
                catch { completion(.failure(.decodeFailure(error))) }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// 泛型业务码解码入口：响应体为 `{code, message, data}`，直接回调 `data` 的 `T` 实例。
    ///
    /// 业务码非零抛 `.business`、成功无 `data` 抛 `.emptyResponseData`。
    func request<T: Decodable>(
        _ endpoint: DyEndpoint,
        biz type: T.Type,
        completion: @escaping (Result<T, DyNetError>) -> Void
    ) {
        request(endpoint) { result in
            switch result {
            case let .success(response):
                do { try completion(.success(response.mapBusiness(type))) }
                catch { completion(.failure(.decodeFailure(error))) }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - 传统闭包回调 · 文件上传
public extension DyNet {
    /// 传统闭包上传入口（原始响应）。
    ///
    /// 接口 `task` 必须是 `.uploadMultipart`，否则回调 `.message` 错误。
    /// - Parameters:
    ///   - endpoint: 接口定义（其 `task` 应为 `.uploadMultipart`）。
    ///   - progress: 上传进度回调（0~1），主线程派发。
    ///   - completion: 主线程回调，成功拿 `DyResponse`，失败拿 `DyNetError`。
    func upload(
        _ endpoint: DyEndpoint,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<DyResponse, DyNetError>) -> Void
    ) {
        if dy_closureStub(endpoint, deliver: completion) {
            return
        }

        do {
            let req = try prepared(endpoint)
            guard let uploadReq = req as? UploadRequest else {
                completion(.failure(.message("接口 task 不是 uploadMultipart，无法走上传通道")))
                return
            }
            let plugins = self.plugins
            plugins.forEach { $0.willSend(uploadReq, endpoint: endpoint) }
            if let progress {
                uploadReq.uploadProgress { p in progress(p.fractionCompleted) }
            }
            uploadReq.responseData { af in
                let result = DyNet.map(af)
                plugins.forEach { $0.didReceive(result, endpoint: endpoint) }
                completion(result)
            }
        } catch {
            completion(.failure(DyNet.mapBuildError(error)))
        }
    }

    /// 上传 + 泛型解码：响应体本身就是模型 `T`，直接回调其实例。
    func upload<T: Decodable>(
        _ endpoint: DyEndpoint,
        as type: T.Type,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<T, DyNetError>) -> Void
    ) {
        upload(endpoint, progress: progress) { result in
            switch result {
            case let .success(response):
                do { try completion(.success(response.map(type))) }
                catch { completion(.failure(.decodeFailure(error))) }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    /// 上传 + 业务码解码：响应体为 `{code, message, data}`，直接回调 `data` 的 `T` 实例。
    func upload<T: Decodable>(
        _ endpoint: DyEndpoint,
        biz type: T.Type,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<T, DyNetError>) -> Void
    ) {
        upload(endpoint, progress: progress) { result in
            switch result {
            case let .success(response):
                do { try completion(.success(response.mapBusiness(type))) }
                catch { completion(.failure(.decodeFailure(error))) }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - 传统闭包回调 · 文件下载
public extension DyNet {
    /// 传统闭包下载入口：回调 `(DyResponse, 本地文件 URL)`。
    ///
    /// - Parameters:
    ///   - endpoint: 接口（其 `task` 应为 `.plain` 或 `.parameters`）。
    ///   - destination: 期望保存路径；为 `nil` 时由系统决定临时位置。
    ///   - progress: 下载进度回调（0~1），主线程派发。
    ///   - completion: 主线程回调，成功拿 `(DyResponse, URL)`，失败拿 `DyNetError`。
    func download(
        _ endpoint: DyEndpoint,
        to destination: URL? = nil,
        progress: ((Double) -> Void)? = nil,
        completion: @escaping (Result<(DyResponse, URL), DyNetError>) -> Void
    ) {
        let stub = stubClosure(endpoint)
        switch stub {
        case .never:
            break
        case .delayed, .immediate:
            let response = DyResponse(statusCode: 200, data: endpoint.sampleData, request: nil, httpResponse: nil)
            plugins.forEach { $0.didReceive(.success(response), endpoint: endpoint) }
            let url = destination ?? FileManager.default.temporaryDirectory
            let emit = { completion(.success((response, url))) }
            switch stub {
            case .immediate:
                DispatchQueue.main.async(execute: emit)
            case let .delayed(seconds):
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: emit)
            default:
                break
            }
            return
        }

        let req = preparedDownload(endpoint, to: destination)
        let plugins = self.plugins
        plugins.forEach { $0.willSend(req, endpoint: endpoint) }
        if let progress {
            req.downloadProgress { p in progress(p.fractionCompleted) }
        }
        req.response { af in
            let result = DyNet.mapDownload(af)
            plugins.forEach { $0.didReceive(DyNet.downloadResultAsResponse(result), endpoint: endpoint) }
            completion(result)
        }
    }
}

// MARK: - 传统闭包回调 · 便捷尾随闭包（success / failure 拆分，省去一层 switch）
public extension DyNet {
    /// `request` 的便捷版：成功 / 失败拆成两个闭包，主线程回调。
    func request(
        _ endpoint: DyEndpoint,
        success: @escaping (DyResponse) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        request(endpoint) { result in
            switch result {
            case let .success(response): success(response)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `request(_:as:)` 的便捷版。
    func request<T: Decodable>(
        _ endpoint: DyEndpoint,
        as type: T.Type,
        success: @escaping (T) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        request(endpoint, as: type) { result in
            switch result {
            case let .success(model): success(model)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `request(_:biz:)` 的便捷版。
    func request<T: Decodable>(
        _ endpoint: DyEndpoint,
        biz type: T.Type,
        success: @escaping (T) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        request(endpoint, biz: type) { result in
            switch result {
            case let .success(model): success(model)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `upload` 的便捷版。
    func upload(
        _ endpoint: DyEndpoint,
        progress: ((Double) -> Void)? = nil,
        success: @escaping (DyResponse) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        upload(endpoint, progress: progress) { result in
            switch result {
            case let .success(response): success(response)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `upload(_:as:)` 的便捷版。
    func upload<T: Decodable>(
        _ endpoint: DyEndpoint,
        as type: T.Type,
        progress: ((Double) -> Void)? = nil,
        success: @escaping (T) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        upload(endpoint, as: type, progress: progress) { result in
            switch result {
            case let .success(model): success(model)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `upload(_:biz:)` 的便捷版。
    func upload<T: Decodable>(
        _ endpoint: DyEndpoint,
        biz type: T.Type,
        progress: ((Double) -> Void)? = nil,
        success: @escaping (T) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        upload(endpoint, biz: type, progress: progress) { result in
            switch result {
            case let .success(model): success(model)
            case let .failure(error): failure(error)
            }
        }
    }

    /// `download` 的便捷版。
    func download(
        _ endpoint: DyEndpoint,
        to destination: URL? = nil,
        progress: ((Double) -> Void)? = nil,
        success: @escaping (DyResponse, URL) -> Void,
        failure: @escaping (DyNetError) -> Void
    ) {
        download(endpoint, to: destination, progress: progress) { result in
            switch result {
            case let .success((response, url)): success(response, url)
            case let .failure(error): failure(error)
            }
        }
    }
}

// MARK: - 私有 stub 辅助（传统闭包）
extension DyNet {
    /// 处理 stub（普通响应 / 上传共用）：命中 stub 时回调样例数据并 `return true`；
    /// `.never` 时返回 `false`，交由真实网络路径。回调统一派发到主线程。
    private func dy_closureStub(
        _ endpoint: DyEndpoint,
        deliver: @escaping (Result<DyResponse, DyNetError>) -> Void
    ) -> Bool {
        let stub = stubClosure(endpoint)
        switch stub {
        case .never:
            return false
        case .delayed, .immediate:
            let response = DyResponse(statusCode: 200, data: endpoint.sampleData, request: nil, httpResponse: nil)
            plugins.forEach { $0.didReceive(.success(response), endpoint: endpoint) }
            let emit = { deliver(.success(response)) }
            switch stub {
            case .immediate:
                DispatchQueue.main.async(execute: emit)
            case let .delayed(seconds):
                DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: emit)
            default:
                break
            }
            return true
        }
    }
}
