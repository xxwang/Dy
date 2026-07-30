import Foundation
import Alamofire

/// 多环境标识（dev / test / prod）。
public enum DyEnvironment: Sendable, Equatable {
    case development
    case testing
    case production
}

/// 全局网络配置单例。
///
/// 把“基地址、全局请求头（如鉴权 token）、全局参数、超时、调试开关、成功业务码”
/// 收敛到一处，支持运行时切换（例如登录后更新 token、切换环境）。
///
/// 注意：请在发起请求前于主线程完成初始配置；运行期修改会立即对后续请求生效。
public final class DyNetConfig {
    public static let shared = DyNetConfig()

    /// 当前环境。
    public private(set) var environment: DyEnvironment = .production

    /// 默认基地址；`DyEndpoint.baseURL` 默认从这里读取。
    public private(set) var baseURL: URL

    /// 注入到每个请求的全局头（接口自身的 `headers` 会覆盖同名项）。
    public private(set) var globalHeaders: HTTPHeaders = []

    /// 注入到 `.parameters` 任务的全局参数（接口参数覆盖同名项）。
    public private(set) var globalParameters: [String: Any] = [:]

    /// 请求超时（秒）；`>0` 时作为默认超时，接口 `requestTimeout` 可覆盖。
    public var timeout: TimeInterval = 0

    /// 调试开关（可驱动日志插件等）。
    public var isDebug: Bool = false

    /// 业务成功码；用于 `DyResponse.mapBusiness` 的默认判定（默认 200）。
    public var successCode: Int = 200

    private init() {
        self.baseURL = URL(string: "https://api.example.com")!
        #warning("请在 App 启动时调用 DyNetConfig.shared.setup(environment:baseURL:) 替换占位 URL")
    }

    // MARK: - 环境 / 基地址

    public func setup(environment: DyEnvironment, baseURL: URL) {
        self.environment = environment
        self.baseURL = baseURL
    }

    public func setBaseURL(_ url: URL) {
        self.baseURL = url
    }

    // MARK: - 全局头

    public func updateGlobalHeaders(_ headers: HTTPHeaders) {
        for (name, value) in headers.dictionary {
            globalHeaders.add(name: name, value: value)
        }
    }

    public func removeGlobalHeader(_ name: String) {
        globalHeaders.remove(name: name)
    }

    public func clearGlobalHeaders() {
        globalHeaders = []
    }

    // MARK: - 全局参数

    public func updateGlobalParameters(_ parameters: [String: Any]) {
        for (key, value) in parameters {
            globalParameters[key] = value
        }
    }

    public func clearGlobalParameters() {
        globalParameters = [:]
    }
}
