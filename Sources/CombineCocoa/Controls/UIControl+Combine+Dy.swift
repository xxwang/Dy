import Combine
import UIKit

// MARK: - UIControl 事件发布者

public extension UIControl {
    /// 通用事件发布者：监听指定的 `UIControl.Event`，取消订阅时自动解绑。
    /// - Parameter events: 要监听的控件事件（可多个，如 `[.touchDown, .touchUpInside]`）。
    /// - Returns: 发出 `UIControl` 自身的 `ControlEvent`。
    func dy_publisher(for events: UIControl.Event) -> ControlEvent<UIControl> {
        let publisher = SubscribePublisher<UIControl> { (subscriber: AnySubscriber<UIControl, Never>) in
            let target = ClosureTarget { [weak self] in
                guard let self else { return }
                _ = subscriber.receive(self)
            }
            self.addTarget(target, action: #selector(ClosureTarget.invoke), for: events)
            subscriber.receive(subscription: ControlEventSubscription(target: target) {
                self.removeTarget(target, action: #selector(ClosureTarget.invoke), for: events)
            })
        }.eraseToAnyPublisher()
        return ControlEvent(publisher)
    }

    /// 点击（`.touchUpInside`）。
    var dy_tapPublisher: ControlEvent<Void> {
        let publisher = SubscribePublisher<Void> { (subscriber: AnySubscriber<Void, Never>) in
            let target = ClosureTarget {
                _ = subscriber.receive(())
            }
            self.addTarget(target, action: #selector(ClosureTarget.invoke), for: .touchUpInside)
            subscriber.receive(subscription: ControlEventSubscription(target: target) {
                self.removeTarget(target, action: #selector(ClosureTarget.invoke), for: .touchUpInside)
            })
        }.eraseToAnyPublisher()
        return ControlEvent(publisher)
    }

    /// 值变化（`.valueChanged`），发出 `UIControl` 自身。
    var dy_valueChangedPublisher: ControlEvent<UIControl> {
        dy_publisher(for: .valueChanged)
    }
}
