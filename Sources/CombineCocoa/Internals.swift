import Combine
import Foundation
import UIKit

// MARK: - 内部辅助

/// target-action 桥接：将 `UIControl` / `UIGestureRecognizer` 的回调转发为闭包。
/// 由订阅持有的 `AnyCancellable` 强引用，订阅取消时随 `removeTarget` 一起释放，无悬挂引用。
final class ClosureTarget: NSObject {
    private let handler: () -> Void

    init(handler: @escaping () -> Void) {
        self.handler = handler
        super.init()
    }

    @objc func invoke(_ sender: Any) {
        handler()
    }
}

/// 控件事件的订阅：强持有 `target` 以保证其在订阅期间存活；取消时执行清理（如 `removeTarget`）。
/// 不直接依赖 `AnyCancellable`（本环境下其不遵循 `Subscription`），用最小 `Subscription` 实现。
final class ControlEventSubscription: Subscription {
    private let target: ClosureTarget
    private let cleanup: () -> Void

    init(target: ClosureTarget, cleanup: @escaping () -> Void) {
        self.target = target
        self.cleanup = cleanup
    }

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        cleanup()
    }
}

// MARK: - 关联对象（模块内私有，避免依赖 DyCore）
extension NSObject {
    /// 以 RETAIN 策略存储关联对象
    func cc_setAssociatedObject(
        _ value: Any?,
        forKey key: UnsafeRawPointer,
        policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(self, key, value, policy)
    }

    /// 读取关联对象
    func cc_getAssociatedObject(forKey key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(self, key)
    }
}

// MARK: - SubscribePublisher

/// 极简发布者：等价于 `AnyPublisher.init(_ subscribe:)` 的内部实现，
/// 用于以「subscribe 闭包」方式构造发布者而避开 `AnyPublisher` 两个 `init` 的重载歧义。
struct SubscribePublisher<Output>: Publisher {
    typealias Failure = Never

    private let subscribe: (AnySubscriber<Output, Failure>) -> Void

    init(_ subscribe: @escaping (AnySubscriber<Output, Failure>) -> Void) {
        self.subscribe = subscribe
    }

    func receive<S: Subscriber>(subscriber: S)
        where S.Failure == Failure, S.Input == Output
    {
        subscribe(AnySubscriber(subscriber))
    }
}
