import Foundation
import Alamofire

/// 网络层错误。
public enum DyNetError: Error {
    /// URL 拼接非法。
    case invalidURL(URL)

    /// 请求参数 / 请求体编码失败。
    case encodeFailure(Error)

    /// Alamofire 底层错误（连接、超时、TLS 等传输层问题）。
    case underlying(AFError)

    /// 其他网络错误。
    case network(Error)

    /// 业务自定义消息。
    case message(String)

    /// 业务码非零：后端明确返回业务失败（`code` + `message`）。
    case business(code: Int, message: String)

    /// 业务成功但响应体无 `data`（期望有数据却为空）。
    case emptyResponseData

    /// 响应体解码失败（模型与 JSON 结构不匹配）。
    case decodeFailure(Error)
}

extension DyNetError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .invalidURL(url):
            return "无效的 URL: \(url.absoluteString)"
        case let .encodeFailure(error):
            return "请求参数编码失败: \(error.localizedDescription)"
        case let .underlying(error):
            return "网络错误: \(error.localizedDescription)"
        case let .network(error):
            return "网络错误: \(error.localizedDescription)"
        case let .message(text):
            return text
        case let .business(code, message):
            return "业务错误(\(code)): \(message)"
        case .emptyResponseData:
            return "响应成功但无数据"
        case let .decodeFailure(error):
            return "响应解析失败: \(error.localizedDescription)"
        }
    }
}
