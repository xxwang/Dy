import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIControl {
    /// 设置控件启用状态
    /// - Parameter isEnabled: 是否启用
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 设置选中状态
    /// - Parameter isSelected: 是否选中
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isSelected(_ isSelected: Bool) -> Self {
        base.isSelected = isSelected
        return self
    }

    /// 设置高亮状态
    /// - Parameter isHighlighted: 是否高亮
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func isHighlighted(_ isHighlighted: Bool) -> Self {
        base.isHighlighted = isHighlighted
        return self
    }

    /// 设置内容垂直对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func contentVerticalAlignment(_ contentVerticalAlignment: UIControl.ContentVerticalAlignment) -> Self {
        base.contentVerticalAlignment = contentVerticalAlignment
        return self
    }

    /// 设置内容水平对齐方式
    /// - Parameter alignment: 对齐方式
    /// - Returns: 当前实例,支持链式调用
    @discardableResult
    func contentHorizontalAlignment(_ alignment: UIControl.ContentHorizontalAlignment) -> Self {
        base.contentHorizontalAlignment = alignment
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UIControl {
    /// 链式添加 `target-action`
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 方法选择器
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event = .touchUpInside) -> Self {
        base.addTarget(target, action: action, for: event)
        return self
    }

    /// 链式移除 `target-action`
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 方法选择器
    ///   - event: 事件类型,默认为 `.touchUpInside`
    /// - Returns: 当前实例
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector?, for event: UIControl.Event = .touchUpInside) -> Self {
        base.removeTarget(target, action: action, for: event)
        return self
    }
}
