import Foundation
import Alamofire

/// 网络接口定义（对标 Moya 的 `TargetType`）。
///
/// 用枚举遵从本协议，即可把所有接口集中、类型安全地收敛到一处，
/// 编译期就能拦住拼错路径、漏参数等低级错误。
public protocol DyEndpoint: Sendable {
    /// 基地址，例如 `https://api.example.com`。
    var baseURL: URL { get }

    /// 路径，会与 `baseURL` 拼接。
    var path: String { get }

    /// HTTP 方法。
    var method: HTTPMethod { get }

    /// 请求任务（参数编码 / JSON 体 / 上传等），见 `DyTask`。
    var task: DyTask { get }

    /// 请求头（会覆盖同名全局头）。
    var headers: HTTPHeaders { get }

    /// 单元测试 stub 用的样例数据；非 stub 模式不会被使用。
    var sampleData: Data { get }
}

public extension DyEndpoint {
    /// 默认从全局配置 `DyNetConfig.shared.baseURL` 读取；接口可显式覆盖（如支付域名）。
    var baseURL: URL {
        DyNetConfig.shared.baseURL
    }

    /// 默认空请求头。
    var headers: HTTPHeaders {
        HTTPHeaders()
    }

    /// 默认空样例数据。
    var sampleData: Data {
        Data()
    }

    /// 单个接口超时（秒）；为 `nil` 时回退到 `DyNetConfig.shared.timeout`。
    var requestTimeout: TimeInterval? {
        nil
    }

    /// 为 `true` 时跳过全局头注入（如登录接口不应带旧 token）。
    var ignoresGlobalHeaders: Bool {
        false
    }
}

/// 请求任务（对标 Moya 的 `Task`），描述这一次请求“带什么”。
public enum DyTask {
    /// 无参请求。
    case plain

    /// 普通参数请求（配合编码方式：URL / JSON / 自定义）。
    case parameters(parameters: [String: Any], encoding: ParameterEncoding)

    /// 将 `Encodable` 作为 JSON 请求体发送（最常用，配合 `Codable` 模型）。
    case json(Encodable)

    /// 上传 multipart 表单，在闭包里往 `MultipartFormData` 追加字段 / 文件。
    case uploadMultipart((MultipartFormData) -> Void)
}
