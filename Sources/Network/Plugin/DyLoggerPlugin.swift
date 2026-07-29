import Foundation
import os
import Alamofire

/// 内置日志插件：用 `os_log` 打印请求与响应概要。
///
/// 使用 `%{public}@` 格式符（iOS 10+ 可用），避免使用字符串插值形式（iOS 14+ 才支持），
/// 以兼容项目 iOS 13 下限。
public struct DyLoggerPlugin: DyNetPlugin {
    public init() {}

    public func willSend(_ request: Request, endpoint: DyEndpoint) {
        let method = request.request?.httpMethod ?? "-"
        let url = request.request?.url?.absoluteString ?? "-"
        os_log(.debug, "DyNet ▶ %{public}@ %{public}@", method, url)
    }

    public func didReceive(_ result: Result<DyResponse, DyNetError>, endpoint: DyEndpoint) {
        switch result {
        case let .success(response):
            os_log(.debug, "DyNet ◀ %ld bytes, status %ld", CLong(response.data.count), CLong(response.statusCode))
        case let .failure(error):
            os_log(.error, "DyNet ✗ %{public}@", error.localizedDescription)
        }
    }
}
