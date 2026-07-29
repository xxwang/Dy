import Foundation
import Alamofire

/// 网络插件（对标 Moya 的 `PluginType`）。
///
/// 用于把「鉴权头注入、日志、loading 计数、统一报错」等横切关注点从业务里抽离。
/// 所有方法都有空默认实现，按需重写即可。
public protocol DyNetPlugin: Sendable {
    /// 在请求发出前修改 `URLRequest`（如注入 token、签名）。
    func prepare(_ request: URLRequest, endpoint: DyEndpoint) -> URLRequest

    /// 请求即将发出。
    func willSend(_ request: Request, endpoint: DyEndpoint)

    /// 收到响应或失败（无论成功失败都会回调），参数为原始 `DyResponse`。
    func didReceive(_ result: Result<DyResponse, DyNetError>, endpoint: DyEndpoint)
}

public extension DyNetPlugin {
    func prepare(_ request: URLRequest, endpoint: DyEndpoint) -> URLRequest {
        request
    }

    func willSend(_ request: Request, endpoint: DyEndpoint) {}
    func didReceive(_ result: Result<DyResponse, DyNetError>, endpoint: DyEndpoint) {}
}
