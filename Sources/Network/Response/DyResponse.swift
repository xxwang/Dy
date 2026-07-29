import Foundation

/// 统一后的网络响应包装。
///
/// 设计上**不校验 HTTP 状态码**（与 Moya 一致）：无论 2xx 还是 4xx/5xx，
/// 只要传输成功就进入 success，由调用方自行根据 `statusCode` 决策；
/// 只有连接层失败（无网、超时、TLS 等）才会走 `DyNetError`。
public struct DyResponse {
    /// HTTP 状态码（传输失败时为 -1）。
    public let statusCode: Int

    /// 响应体原始数据（下载场景下为空，文件见 `DyNet.download` 返回的 URL）。
    public let data: Data

    /// 实际发出的请求。
    public let request: URLRequest?

    /// 底层 `HTTPURLResponse`。
    public let httpResponse: HTTPURLResponse?

    public init(
        statusCode: Int,
        data: Data,
        request: URLRequest?,
        httpResponse: HTTPURLResponse?
    ) {
        self.statusCode = statusCode
        self.data = data
        self.request = request
        self.httpResponse = httpResponse
    }

    /// 以 UTF-8 解码的响应文本（调试用）。
    public var string: String? {
        String(data: data, encoding: .utf8)
    }

    /// 将响应体解码为 `Decodable` 模型（响应体本身就是该模型）。
    /// - Parameter type: 目标类型。
    /// - Parameter decoder: 解码器，默认 `JSONDecoder()`。
    public func map<D: Decodable>(_ type: D.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> D {
        try decoder.decode(type, from: data)
    }

    /// 把响应体解析为业务码包裹 `DyBizResponse<T>`，并按业务码判定成败（可选 opt-in）。
    ///
    /// 与“不校验 HTTP 状态码”的设计不冲突：这里校验的是 body 内的业务 `code`，
    /// 而非 HTTP 状态码。业务码非零抛 `DyNetError.business`；成功但无 `data` 抛 `emptyResponseData`。
    /// - Parameter type: `data` 字段的目标模型类型（可用 `DyEmpty` 表示无数据）。
    /// - Parameter successCode: 成功的业务码，默认取 `DyNetConfig.shared.successCode`。
    public func mapBusiness<T: Decodable>(
        _ type: T.Type,
        successCode: Int? = nil,
        using decoder: JSONDecoder = JSONDecoder()
    ) throws -> T {
        let expected = successCode ?? DyNetConfig.shared.successCode
        let wrapper = try decoder.decode(DyBizResponse<T>.self, from: data)
        guard wrapper.code == expected else {
            throw DyNetError.business(code: wrapper.code, message: wrapper.message)
        }
        guard let payload = wrapper.data else {
            throw DyNetError.emptyResponseData
        }
        return payload
    }
}

extension DyResponse: Equatable {}
