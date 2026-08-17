import Combine
import UIKit

// MARK: - UIScrollView 滚动事件发布者（delegate 代理）

/// `UIScrollViewDelegate` 代理：接管滚动回调并转发给原有的 `delegate`，
/// 同时通过 `PassthroughSubject` 对外暴露各滚动事件，供 Combine 订阅。
final class ScrollViewDelegateProxy: NSObject, UIScrollViewDelegate {
    weak var originalDelegate: UIScrollViewDelegate?

    let didScroll = PassthroughSubject<Void, Never>()
    let willBeginDragging = PassthroughSubject<Void, Never>()
    let didEndDragging = PassthroughSubject<Void, Never>()
    let willBeginDecelerating = PassthroughSubject<Void, Never>()
    let didEndDecelerating = PassthroughSubject<Void, Never>()
    let didEndScrollingAnimation = PassthroughSubject<Void, Never>()
    let didZoom = PassthroughSubject<Void, Never>()
    let didChangeAdjustedContentInset = PassthroughSubject<Void, Never>()

    /// 未由本代理实现的 delegate 方法，转发给原 delegate
    override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) {
            return true
        }
        return originalDelegate?.responds(to: aSelector) ?? false
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        originalDelegate
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll.send(())
        originalDelegate?.scrollViewDidScroll?(scrollView)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging.send(())
        originalDelegate?.scrollViewWillBeginDragging?(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        didEndDragging.send(())
        originalDelegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        willBeginDecelerating.send(())
        originalDelegate?.scrollViewWillBeginDecelerating?(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndDecelerating.send(())
        originalDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation.send(())
        originalDelegate?.scrollViewDidEndScrollingAnimation?(scrollView)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        didZoom.send(())
        originalDelegate?.scrollViewDidZoom?(scrollView)
    }

    func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        didChangeAdjustedContentInset.send(())
        originalDelegate?.scrollViewDidChangeAdjustedContentInset?(scrollView)
    }
}

public extension UIScrollView {
    private static var cc_delegateProxyKey: UInt8 = 0

    /// 懒加载并缓存 delegate 代理（首次访问时接管 `delegate`，原 delegate 被保留并转发）
    private var cc_delegateProxy: ScrollViewDelegateProxy {
        if let existing = cc_getAssociatedObject(forKey: &Self.cc_delegateProxyKey) as? ScrollViewDelegateProxy {
            return existing
        }
        let proxy = ScrollViewDelegateProxy()
        proxy.originalDelegate = self.delegate
        self.delegate = proxy
        cc_setAssociatedObject(proxy, forKey: &Self.cc_delegateProxyKey)
        return proxy
    }

    /// 滚动中（contentOffset 变化）
    var solo_didScrollPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didScroll.eraseToAnyPublisher())
    }

    /// 即将开始拖拽
    var solo_willBeginDraggingPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.willBeginDragging.eraseToAnyPublisher())
    }

    /// 结束拖拽（含是否将继续减速）
    var solo_didEndDraggingPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didEndDragging.eraseToAnyPublisher())
    }

    /// 即将开始减速
    var solo_willBeginDeceleratingPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.willBeginDecelerating.eraseToAnyPublisher())
    }

    /// 结束减速
    var solo_didEndDeceleratingPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didEndDecelerating.eraseToAnyPublisher())
    }

    /// 滚动动画结束
    var solo_didEndScrollingAnimationPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didEndScrollingAnimation.eraseToAnyPublisher())
    }

    /// 缩放中
    var solo_didZoomPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didZoom.eraseToAnyPublisher())
    }

    /// 调整内容缩进变化
    var solo_didChangeAdjustedContentInsetPublisher: ControlEvent<Void> {
        ControlEvent(cc_delegateProxy.didChangeAdjustedContentInset.eraseToAnyPublisher())
    }
}
