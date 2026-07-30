import Foundation
import Alamofire

// MARK: - 并发请求（async/await）
public extension DyNet {
    /// 并发（async/await）入口（原始响应）。
    ///
    /// - 传输层失败抛出 `DyNetError`；HTTP 4xx/5xx 仍作为正常 `DyResponse` 返回（状态码可见）。
    /// - 底层请求会随 enclosing `Task` 取消而取消（Alamofire 默认行为）。
    @discardableResult
    func request(_ endpoint: DyEndpoint) async throws -> DyResponse {
        let stub = stubClosure(endpoint)
        if case let .delayed(seconds) = stub {
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1000000000))
        }
        guard case .never = stub else {
            let response = DyResponse(
                statusCode: 200,
                data: endpoint.sampleData,
                request: nil,
                httpResponse: nil
            )
            plugins.forEach { $0.didReceive(.success(response), endpoint: endpoint) }
            return response
        }

        let req = try resolvableRequest(endpoint)
        let plugins = self.plugins
        plugins.forEach { $0.willSend(req, endpoint: endpoint) }

        return try await withCheckedThrowingContinuation { continuation in
            req.responseData { af in
                let result = DyNet.map(af)
                plugins.forEach { $0.didReceive(result, endpoint: endpoint) }
                switch result {
                case let .success(response):
                    continuation.resume(returning: response)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    /// 泛型解码入口（async/await）：直接返回传入模型类型 `T` 的实例（响应体本身就是 `T`）。
    func request<T: Decodable>(_ endpoint: DyEndpoint, as type: T.Type) async throws -> T {
        let response = try await request(endpoint)
        do {
            return try response.map(type)
        } catch {
            throw DyNetError.decodeFailure(error)
        }
    }

    /// 泛型业务码解码入口（async/await）：响应体为 `{code, message, data}`，直接返回 `data` 的 `T` 实例。
    func request<T: Decodable>(_ endpoint: DyEndpoint, biz type: T.Type) async throws -> T {
        let response = try await request(endpoint)
        do {
            return try response.mapBusiness(type)
        } catch {
            throw DyNetError.decodeFailure(error)
        }
    }
}

// MARK: - 并发下载（async/await）
public extension DyNet {
    /// 文件下载入口（async/await）：返回 `(DyResponse, 本地文件 URL)`。
    ///
    /// - Parameters:
    ///   - endpoint: 接口（其 `task` 应为 `.plain` 或 `.parameters`）。
    ///   - destination: 期望保存路径；为 `nil` 时由系统决定临时位置。
    ///   - progress: 进度回调（0~1）。
    func download(
        _ endpoint: DyEndpoint,
        to destination: URL? = nil,
        progress: ((Double) -> Void)? = nil
    ) async throws -> (DyResponse, URL) {
        let stub = stubClosure(endpoint)
        if case let .delayed(seconds) = stub {
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1000000000))
        }
        guard case .never = stub else {
            let response = DyResponse(
                statusCode: 200,
                data: endpoint.sampleData,
                request: nil,
                httpResponse: nil
            )
            plugins.forEach { $0.didReceive(.success(response), endpoint: endpoint) }
            let url = destination ?? FileManager.default.temporaryDirectory
            return (response, url)
        }

        let req = preparedDownload(endpoint, to: destination)
        let plugins = self.plugins
        plugins.forEach { $0.willSend(req, endpoint: endpoint) }
        if let progress {
            req.downloadProgress { p in progress(p.fractionCompleted) }
        }

        return try await withCheckedThrowingContinuation { continuation in
            req.response { af in
                let result = DyNet.mapDownload(af)
                plugins.forEach { $0.didReceive(DyNet.downloadResultAsResponse(result), endpoint: endpoint) }
                switch result {
                case let .success(value):
                    continuation.resume(returning: value)
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
