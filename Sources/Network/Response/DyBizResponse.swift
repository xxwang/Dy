import Foundation

/// 通用业务响应包裹（对标后端 `{code, message, data, timestamp}` 约定）。
///
/// 仅作为“可选(opt-in)”解析工具使用：本网络层**不强制**走业务码校验，
/// 只有调用 `DyResponse.mapBusiness` 时才按 `successCode` 判定成败。
public struct DyBizResponse<T: Decodable>: Decodable {
    public let code: Int
    public let message: String
    public let data: T?
    public let timestamp: TimeInterval?

    /// 是否业务成功（与 `DyNetConfig.shared.successCode` 比较）。
    public var isSuccess: Bool {
        code == DyNetConfig.shared.successCode
    }
}

/// 无业务数据的占位模型，用于“只关心成功与否、无 data”的接口：
/// `let _: DyEmpty = try response.mapBusiness(DyEmpty.self)`。
public struct DyEmpty: Decodable {}
