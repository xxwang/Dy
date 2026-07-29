import Foundation
import Alamofire

/// 维护“在途请求数”的计数器（线程安全）。
///
/// 用引用类型持有计数，使值类型的 `DyLoadingPlugin` 也能跨多次回调累积状态。
public final class DyLoadingCounter: @unchecked Sendable {
    private let lock = NSLock()
    private var count: Int = 0
    private let onChange: @Sendable (Int) -> Void

    /// - Parameter onChange: 在途数变化时的回调（由调用方保证线程）。
    public init(onChange: @escaping @Sendable (Int) -> Void) {
        self.onChange = onChange
    }

    func increment() {
        lock.lock(); count += 1; let current = count; lock.unlock()
        onChange(current)
    }

    func decrement() {
        lock.lock(); count -= 1; let current = count; lock.unlock()
        onChange(current)
    }
}

/// 全局 loading 计数插件：每次请求即将发出 `+1`，收到响应（成功或失败）`-1`。
///
/// 用法：
/// ```swift
/// let counter = DyLoadingCounter { n in showLoading(n > 0) }
/// let net = DyNet(plugins: [DyLoadingPlugin(counter: counter)])
/// ```
public struct DyLoadingPlugin: DyNetPlugin {
    private let counter: DyLoadingCounter

    public init(counter: DyLoadingCounter) {
        self.counter = counter
    }

    public func willSend(_ request: Request, endpoint: DyEndpoint) {
        counter.increment()
    }

    public func didReceive(_ result: Result<DyResponse, DyNetError>, endpoint: DyEndpoint) {
        counter.decrement()
    }
}
