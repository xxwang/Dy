import UIKit

// MARK: - 链式设置属性
@available(iOS 15.0, *)
public extension DyWrapper where Base: UISheetPresentationController {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    func delegate(_ delegate: (any UISheetPresentationControllerDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置抽屉档位
    /// - Parameter detents: 抽屉支持的高度档位（如 .medium(), .large()）
    /// - Returns: `Self`
    @discardableResult
    func detents(_ detents: [UISheetPresentationController.Detent]) -> Self {
        base.detents = detents
        return self
    }

    /// 是否显示顶部横条（grabber）
    /// - Parameter prefersGrabberVisible: 是否显示小横条
    /// - Returns: `Self`
    @discardableResult
    func prefersGrabberVisible(_ prefersGrabberVisible: Bool) -> Self {
        base.prefersGrabberVisible = prefersGrabberVisible
        return self
    }

    /// 设置来源视图（主要用于 .formSheet 定位）
    /// - Parameter sourceView: 来源视图
    /// - Returns: `Self`
    @discardableResult
    func sourceView(_ sourceView: UIView?) -> Self {
        base.sourceView = sourceView
        return self
    }

    /// 是否根据内容自动调整抽屉大小（iOS 17+）
    /// - Parameter prefersPageSizing: 是否启用自动适配
    /// - Returns: `Self`
    @available(iOS 17.0, *)
    @discardableResult
    func prefersPageSizing(_ prefersPageSizing: Bool) -> Self {
        base.prefersPageSizing = prefersPageSizing
        return self
    }

    /// 紧凑高度下是否从底部边缘附着（如 iPhone 竖屏）
    /// - Parameter prefersEdgeAttachedInCompactHeight: 是否底部附着
    /// - Returns: `Self`
    @discardableResult
    func prefersEdgeAttachedInCompactHeight(_ prefersEdgeAttachedInCompactHeight: Bool) -> Self {
        base.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        return self
    }

    /// 边缘附着时宽度是否遵循 preferredContentSize
    /// - Parameter widthFollowsPreferredContentSizeWhenEdgeAttached: 是否使用内容宽度
    /// - Returns: `Self`
    @discardableResult
    func widthFollowsPreferredContentSizeWhenEdgeAttached(_ widthFollowsPreferredContentSizeWhenEdgeAttached: Bool) -> Self {
        base.widthFollowsPreferredContentSizeWhenEdgeAttached = widthFollowsPreferredContentSizeWhenEdgeAttached
        return self
    }

    /// 重新计算档位（用于动态更新后）
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func invalidateDetents() -> Self {
        base.invalidateDetents()
        return self
    }

    /// 设置最大不暗化档位（小于此档位背景变暗）
    /// - Parameter identifier: 档位标识符（如 .medium）
    /// - Returns: `Self`
    @discardableResult
    func largestUndimmedDetentIdentifier(_ largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier) -> Self {
        base.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        return self
    }

    /// 滚动到顶部时是否自动展开到 large 档位
    /// - Parameter prefersScrollingExpandsWhenScrolledToEdge: 是否自动展开
    /// - Returns: `Self`
    @discardableResult
    func prefersScrollingExpandsWhenScrolledToEdge(_ prefersScrollingExpandsWhenScrolledToEdge: Bool) -> Self {
        base.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        return self
    }
}
