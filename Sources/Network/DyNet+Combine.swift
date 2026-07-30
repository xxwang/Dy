import Combine
import Foundation
import Alamofire

// MARK: - Combine 请求
public extension DyNet {
    /// Combine 入口（原始响应）：返回 `AnyPublisher<DyResponse, DyNetError>`。
    ///
    /// 订阅被取消时会取消底层 Alamofire 请求；错误以 `DyNetError` 走 `failure`。
    func requestPublisher(_ endpoint: DyEndpoint) -> AnyPublisher<DyResponse, DyNetError> {
        let stub = stubClosure(endpoint)
        guard case .never = stub else {
            return Self.stubPublisher(endpoint: endpoint, behavior: stub, plugins: plugins)
        }

        return Future<DyResponse, DyNetError> { [weak self] promise in
            guard let self else { return }
            do {
                let req = try self.resolvableRequest(endpoint)
                let plugins = self.plugins
                plugins.forEach { $0.willSend(req, endpoint: endpoint) }
                req.responseData { af in
                    let result = DyNet.map(af)
                    plugins.forEach { $0.didReceive(result, endpoint: endpoint) }
                    promise(result)
                }
            } catch {
                promise(.failure(DyNet.mapBuildError(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    /// 泛型解码入口：直接回调传入模型类型 `T` 的实例（响应体本身就是 `T`）。
    ///
    /// 例：`net.publisher(api, as: UserModel.self)` → `AnyPublisher<UserModel, DyNetError>`。
    func publisher<T: Decodable>(_ endpoint: DyEndpoint, as type: T.Type) -> AnyPublisher<T, DyNetError> {
        requestPublisher(endpoint)
            .tryMap { try $0.map(type) }
            .mapError { ($0 as? DyNetError) ?? .decodeFailure($0) }
            .eraseToAnyPublisher()
    }

    /// 泛型业务码解码入口：响应体为 `{code, message, data}`，直接回调 `data` 的 `T` 实例。
    ///
    /// 例：`net.publisher(api, biz: UserModel.self)` → `AnyPublisher<UserModel, DyNetError>`。
    /// 业务码非零抛 `.business`、成功无 `data` 抛 `.emptyResponseData`。
    func publisher<T: Decodable>(_ endpoint: DyEndpoint, biz type: T.Type) -> AnyPublisher<T, DyNetError> {
        requestPublisher(endpoint)
            .tryMap { try $0.mapBusiness(type) }
            .mapError { ($0 as? DyNetError) ?? .decodeFailure($0) }
            .eraseToAnyPublisher()
    }
}

// MARK: - Combine 下载
public extension DyNet {
    /// 文件下载入口：回调 `(DyResponse, 本地文件 URL)`。
    ///
    /// - Parameters:
    ///   - endpoint: 接口（其 `task` 应为 `.plain` 或 `.parameters`）。
    ///   - destination: 期望保存路径；为 `nil` 时由系统决定临时位置。
    ///   - progress: 进度回调（0~1），在主线程由 Alamofire 驱动。
    func downloadPublisher(
        _ endpoint: DyEndpoint,
        to destination: URL? = nil,
        progress: ((Double) -> Void)? = nil
    ) -> AnyPublisher<(DyResponse, URL), DyNetError> {
        let stub = stubClosure(endpoint)
        guard case .never = stub else {
            let url = destination ?? FileManager.default.temporaryDirectory.appendingPathComponent("dy_stub")
            let response = DyResponse(statusCode: 200, data: endpoint.sampleData, request: nil, httpResponse: nil)
            return Just((response, url))
                .setFailureType(to: DyNetError.self)
                .eraseToAnyPublisher()
        }

        return Future<(DyResponse, URL), DyNetError> { [weak self] promise in
            guard let self else { return }
            let req = self.preparedDownload(endpoint, to: destination)
            let plugins = self.plugins
            plugins.forEach { $0.willSend(req, endpoint: endpoint) }
            if let progress {
                req.downloadProgress { p in progress(p.fractionCompleted) }
            }
            req.response { af in
                let result = DyNet.mapDownload(af)
                plugins.forEach { $0.didReceive(DyNet.downloadResultAsResponse(result), endpoint: endpoint) }
                promise(result)
            }
        }
        .eraseToAnyPublisher()
    }
}

// MARK: - 私有 stub 辅助（Combine）
extension DyNet {
    private static func stubPublisher(
        endpoint: DyEndpoint,
        behavior: DyStub,
        plugins: [DyNetPlugin]
    ) -> AnyPublisher<DyResponse, DyNetError> {
        let response = DyResponse(
            statusCode: 200,
            data: endpoint.sampleData,
            request: nil,
            httpResponse: nil
        )
        let result: Result<DyResponse, DyNetError> = .success(response)
        plugins.forEach { $0.didReceive(result, endpoint: endpoint) }

        switch behavior {
        case .immediate:
            return Just(response)
                .setFailureType(to: DyNetError.self)
                .eraseToAnyPublisher()
        case let .delayed(seconds):
            return Just(response)
                .delay(for: .seconds(seconds), scheduler: RunLoop.main)
                .setFailureType(to: DyNetError.self)
                .eraseToAnyPublisher()
        case .never:
            return Empty(completeImmediately: false).eraseToAnyPublisher()
        }
    }
}

// MARK: - 便捷订阅（sinkDy）
public extension AnyPublisher where Output == DyResponse, Failure == DyNetError {
    /// 简化订阅：成功拿到 `DyResponse`，失败拿到 `DyNetError`。
    ///
    /// 例：`net.requestPublisher(api).sinkDy { response in ... } receiveError: { error in ... }`
    func sinkDy(
        receiveValue: @escaping (DyResponse) -> Void,
        receiveError: @escaping (DyNetError) -> Void
    ) -> AnyCancellable {
        sink(
            receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receiveError(error)
                }
            },
            receiveValue: receiveValue
        )
    }
}
