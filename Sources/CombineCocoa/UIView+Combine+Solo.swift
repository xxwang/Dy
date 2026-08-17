import Combine
import UIKit

// MARK: - UIView 手势发布者
public extension UIView {
    /// 已添加手势的缓存键（避免重复添加同一手势）
    private static var cc_gestureCacheKey: UInt8 = 0

    private var cc_gestureCache: [String: UIGestureRecognizer] {
        get { cc_getAssociatedObject(forKey: &Self.cc_gestureCacheKey) as? [String: UIGestureRecognizer] ?? [:] }
        set { cc_setAssociatedObject(newValue, forKey: &Self.cc_gestureCacheKey) }
    }

    /// 获取或创建并缓存手势识别器（同一 key 复用，不重复添加）
    private func cc_cachedGesture<G: UIGestureRecognizer>(key: String, make: () -> G) -> G {
        if let existing = cc_gestureCache[key] as? G {
            return existing
        }
        let recognizer = make()
        addGestureRecognizer(recognizer)
        var cache = cc_gestureCache
        cache[key] = recognizer
        cc_gestureCache = cache
        return recognizer
    }

    /// 将手势识别器包装为 `ControlEvent`（订阅取消时移除 target）
    private func cc_event<G: UIGestureRecognizer>(_ recognizer: G) -> ControlEvent<G> {
        let publisher = SubscribePublisher<G> { (subscriber: AnySubscriber<G, Never>) in
            let target = ClosureTarget {
                _ = subscriber.receive(recognizer)
            }
            recognizer.addTarget(target, action: #selector(ClosureTarget.invoke))
            subscriber.receive(subscription: ControlEventSubscription(target: target) {
                recognizer.removeTarget(target, action: #selector(ClosureTarget.invoke))
            })
        }.eraseToAnyPublisher()
        return ControlEvent(publisher)
    }

    // MARK: 具体手势

    /// 点击手势
    var solo_tapGesturePublisher: ControlEvent<UITapGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "tap") { UITapGestureRecognizer() })
    }

    /// 轻扫手势（可指定方向，不同方向各自缓存）
    func solo_swipeGesturePublisher(_ direction: UISwipeGestureRecognizer.Direction = .right) -> ControlEvent<UISwipeGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "swipe-\(direction.rawValue)") {
            let recognizer = UISwipeGestureRecognizer()
            recognizer.direction = direction
            return recognizer
        })
    }

    /// 长按手势
    var solo_longPressGesturePublisher: ControlEvent<UILongPressGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "longPress") { UILongPressGestureRecognizer() })
    }

    /// 拖动手势
    var solo_panGesturePublisher: ControlEvent<UIPanGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "pan") { UIPanGestureRecognizer() })
    }

    /// 捏合手势
    var solo_pinchGesturePublisher: ControlEvent<UIPinchGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "pinch") { UIPinchGestureRecognizer() })
    }

    /// 旋转手势
    var solo_rotationGesturePublisher: ControlEvent<UIRotationGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "rotation") { UIRotationGestureRecognizer() })
    }

    /// 屏幕边缘拖动手势
    var solo_screenEdgePanGesturePublisher: ControlEvent<UIScreenEdgePanGestureRecognizer> {
        isUserInteractionEnabled = true
        return cc_event(cc_cachedGesture(key: "screenEdgePan") { UIScreenEdgePanGestureRecognizer() })
    }
}
