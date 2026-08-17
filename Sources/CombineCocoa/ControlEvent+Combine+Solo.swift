import Combine
import UIKit

// MARK: - ControlEvent

/// 控件事件发布者。
///
/// 当 `UIControl` 的指定事件（或手势识别器）触发时发出元素；**永远不会失败**（`Failure == Never`）。
/// 取消订阅时自动移除 `target`/`action`，避免悬挂引用与内存泄漏。
///
/// 例：
/// ```swift
/// button.solo_tapPublisher
///     .sink { print("tapped") }
///     .store(in: &cancellables)
/// ```
public struct ControlEvent<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let publisher: AnyPublisher<Value, Never>

    public func receive<S: Subscriber>(subscriber: S)
        where S.Failure == Failure, S.Input == Output
    {
        publisher.receive(subscriber: subscriber)
    }

    /// 由已构造好的 `AnyPublisher` 包装（推荐通过模块内的 `SubscribePublisher` 构造）。
    init(_ publisher: AnyPublisher<Value, Never>) {
        self.publisher = publisher
    }
}
