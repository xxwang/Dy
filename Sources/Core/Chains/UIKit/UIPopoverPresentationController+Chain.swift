import UIKit

// MARK: - 链式配置(Popover)
@MainActor
public extension DyWrapper where Base: UIPopoverPresentationController {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UIPopoverPresentationControllerDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置允许的箭头方向
    /// - Parameter directions: 箭头方向（如 .any, .up, .down）
    /// - Returns: `Self`
    @discardableResult
    func permittedArrowDirections(_ directions: UIPopoverArrowDirection) -> Self {
        base.permittedArrowDirections = directions
        return self
    }

    /// 设置气泡指向的源视图
    /// - Parameter sourceView: 源视图
    /// - Returns: `Self`
    @discardableResult
    func sourceView(_ sourceView: UIView?) -> Self {
        base.sourceView = sourceView
        return self
    }

    /// 设置源视图内的定位矩形
    /// - Parameter sourceRect: 源矩形（默认为 bounds）
    /// - Returns: `Self`
    @discardableResult
    func sourceRect(_ sourceRect: CGRect) -> Self {
        base.sourceRect = sourceRect
        return self
    }

    /// 是否允许气泡覆盖源视图区域（iOS 9+）
    /// - Parameter canOverlap: 是否允许重叠
    /// - Returns: `Self`
    @discardableResult
    func canOverlapSourceViewRect(_ canOverlap: Bool) -> Self {
        base.canOverlapSourceViewRect = canOverlap
        return self
    }

    /// 设置源 item（用于 `toolbar` / `navigation bar` 中的按钮）
    /// - Parameter sourceItem: 符合协议的源项
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func sourceItem(_ sourceItem: (any UIPopoverPresentationControllerSourceItem)?) -> Self {
        base.sourceItem = sourceItem
        return self
    }

    /// 设置穿透视图（点击不关闭气泡的视图）
    /// - Parameter passthroughViews: 视图数组
    /// - Returns: `Self`
    @discardableResult
    func passthroughViews(_ views: [UIView]?) -> Self {
        base.passthroughViews = views
        return self
    }

    /// 设置气泡背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }

    /// 设置气泡内边距（影响内容布局区域）
    /// - Parameter margins: 内边距
    /// - Returns: `Self`
    @discardableResult
    func popoverLayoutMargins(_ margins: UIEdgeInsets) -> Self {
        base.popoverLayoutMargins = margins
        return self
    }

    /// 设置自定义气泡背景类（用于修改圆角、边框等）
    /// - Parameter backgroundClass: 继承自 `UIPopoverBackgroundView` 的类
    /// - Returns: `Self`
    @discardableResult
    func popoverBackgroundViewClass(_ backgroundClass: (any UIPopoverBackgroundViewMethods.Type)?) -> Self {
        base.popoverBackgroundViewClass = backgroundClass
        return self
    }
}
