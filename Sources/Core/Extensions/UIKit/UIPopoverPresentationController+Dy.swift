import UIKit

// MARK: - 链式配置(Popover)
public extension UIPopoverPresentationController {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: (any UIPopoverPresentationControllerDelegate)?) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置允许的箭头方向
    /// - Parameter directions: 箭头方向（如 .any, .up, .down）
    /// - Returns: `Self`
    @discardableResult
    func dy_permittedArrowDirections(_ directions: UIPopoverArrowDirection) -> Self {
        self.permittedArrowDirections = directions
        return self
    }

    /// 设置气泡指向的源视图
    /// - Parameter sourceView: 源视图
    /// - Returns: `Self`
    @discardableResult
    func dy_sourceView(_ sourceView: UIView?) -> Self {
        self.sourceView = sourceView
        return self
    }

    /// 设置源视图内的定位矩形
    /// - Parameter sourceRect: 源矩形（默认为 bounds）
    /// - Returns: `Self`
    @discardableResult
    func dy_sourceRect(_ sourceRect: CGRect) -> Self {
        self.sourceRect = sourceRect
        return self
    }

    /// 是否允许气泡覆盖源视图区域（iOS 9+）
    /// - Parameter canOverlap: 是否允许重叠
    /// - Returns: `Self`
    @discardableResult
    func dy_canOverlapSourceViewRect(_ canOverlap: Bool) -> Self {
        self.canOverlapSourceViewRect = canOverlap
        return self
    }

    /// 设置源 item（用于 `toolbar` / `navigation bar` 中的按钮）
    /// - Parameter sourceItem: 符合协议的源项
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func dy_sourceItem(_ sourceItem: (any UIPopoverPresentationControllerSourceItem)?) -> Self {
        self.sourceItem = sourceItem
        return self
    }

    /// 设置穿透视图（点击不关闭气泡的视图）
    /// - Parameter passthroughViews: 视图数组
    /// - Returns: `Self`
    @discardableResult
    func dy_passthroughViews(_ views: [UIView]?) -> Self {
        self.passthroughViews = views
        return self
    }

    /// 设置气泡背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// 设置气泡内边距（影响内容布局区域）
    /// - Parameter margins: 内边距
    /// - Returns: `Self`
    @discardableResult
    func dy_popoverLayoutMargins(_ margins: UIEdgeInsets) -> Self {
        self.popoverLayoutMargins = margins
        return self
    }

    /// 设置自定义气泡背景类（用于修改圆角、边框等）
    /// - Parameter backgroundClass: 继承自 `UIPopoverBackgroundView` 的类
    /// - Returns: `Self`
    @discardableResult
    func dy_popoverBackgroundViewClass(_ backgroundClass: (any UIPopoverBackgroundViewMethods.Type)?) -> Self {
        self.popoverBackgroundViewClass = backgroundClass
        return self
    }
}
