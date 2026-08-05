import Foundation
import Alamofire
import os

/// 多环境标识（dev / test / prod）。
public enum DyEnvironment: Sendable, Equatable {
    case development
    case testing
    case production
}

/// 全局网络配置单例。
///
/// 把"基地址、全局请求头（如鉴权 token）、全局参数、超时、调试开关、成功业务码"
/// 收敛到一处，支持运行时切换（例如登录后更新 token、切换环境）。
///
/// 注意：请在发起请求前于主线程完成初始配置；内部使用 `os_unfair_lock` 保护可变状态，线程安全。
public final class DyNetConfig: @unchecked Sendable {
    public static let shared = DyNetConfig()

    private var _lock = os_unfair_lock()

    /// 当前环境。
    public var environment: DyEnvironment {
        _sync { _environment }
    }

    private var _environment: DyEnvironment = .production

    /// 默认基地址；`DyEndpoint.baseURL` 默认从这里读取。
    public var baseURL: URL {
        _sync { _baseURL }
    }

    private var _baseURL: URL = URL(string: "https://api.example.com")!

    /// 注入到每个请求的全局头（接口自身的 `headers` 会覆盖同名项）。
    public var globalHeaders: HTTPHeaders {
        _sync { _globalHeaders }
    }

    private var _globalHeaders: HTTPHeaders = []

    /// 注入到 `.parameters` 任务的全局参数（接口参数覆盖同名项）。
    public var globalParameters: [String: Any] {
        _sync { _globalParameters }
    }

    private var _globalParameters: [String: Any] = [:]

    /// 请求超时（秒）；`>0` 时作为默认超时，接口 `requestTimeout` 可覆盖。
    public var timeout: TimeInterval {
        get { _sync { _timeout } }
        set { _sync { _timeout = newValue } }
    }

    private var _timeout: TimeInterval = 0

    /// 调试开关（可驱动日志插件等）。
    public var isDebug: Bool {
        get { _sync { _isDebug } }
        set { _sync { _isDebug = newValue } }
    }

    private var _isDebug: Bool = false

    /// 业务成功码；用于 `DyResponse.mapBusiness` 的默认判定（默认 200）。
    public var successCode: Int {
        get { _sync { _successCode } }
        set { _sync { _successCode = newValue } }
    }

    private var _successCode: Int = 200

    private init() {
        #warning("请在 App 启动时调用 DyNetConfig.shared.setup(environment:baseURL:) 替换占位 URL")
    }

    private func _sync<T>(_ block: () -> T) -> T {
        os_unfair_lock_lock(&_lock)
        defer { os_unfair_lock_unlock(&_lock) }
        return block()
    }

    private func _sync(_ block: () -> Void) {
        os_unfair_lock_lock(&_lock)
        defer { os_unfair_lock_unlock(&_lock) }
        block()
    }

    // MARK: - 环境 / 基地址

    public func setup(environment: DyEnvironment, baseURL: URL) {
        _sync {
            self._environment = environment
            self._baseURL = baseURL
        }
    }

    public func setBaseURL(_ url: URL) {
        _sync { self._baseURL = url }
    }

    // MARK: - 全局头

    public func updateGlobalHeaders(_ headers: HTTPHeaders) {
        _sync {
            for (name, value) in headers.dictionary {
                _globalHeaders.add(name: name, value: value)
            }
        }
    }

    public func removeGlobalHeader(_ name: String) {
        _sync { _globalHeaders.remove(name: name) }
    }

    public func clearGlobalHeaders() {
        _sync { _globalHeaders = [] }
    }

    // MARK: - 全局参数

    public func updateGlobalParameters(_ parameters: [String: Any]) {
        _sync {
            for (key, value) in parameters {
                _globalParameters[key] = value
            }
        }
    }

    public func clearGlobalParameters() {
        _sync { _globalParameters = [:] }
    }
}
