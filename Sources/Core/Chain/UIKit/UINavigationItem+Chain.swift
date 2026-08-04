import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UINavigationItem {
    /// 设置大标题的显示模式
    /// - Note: 需配合 `UINavigationBar.prefersLargeTitles = true` 使用
    /// - Parameter mode: 大标题显示模式
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func largeTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        base.largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航栏标题文本
    ///
    /// - Parameter title: 标题字符串
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 设置自定义标题视图
    /// - Note: 会覆盖 `title`
    /// - Parameter view: 自定义视图
    /// - Returns: `Self`
    @discardableResult
    func titleView(_ view: UIView?) -> Self {
        base.titleView = view
        return self
    }

    /// 设置返回按钮的外观
    /// - Note:影响下一个`push`进来的控制器的返回按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 按钮样式,默认为 `.plain`
    /// - Returns: `Self`
    @discardableResult
    func backBarButtonItem(title: String?, style: UIBarButtonItem.Style = .plain) -> Self {
        let backButton = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        base.backBarButtonItem = backButton
        return self
    }

    /// 设置左侧单个按钮
    ///
    /// - Parameter buttonItem: 左侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func leftBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        base.leftBarButtonItem = buttonItem
        return self
    }

    /// 设置右侧单个按钮
    ///
    /// - Parameter buttonItem: 右侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func rightBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        base.rightBarButtonItem = buttonItem
        return self
    }

    /// 设置左侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从左到右
    /// - Returns: `Self`
    @discardableResult
    func leftBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        base.leftBarButtonItems = items
        return self
    }

    /// 设置右侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从右到左
    /// - Returns: `Self`
    @discardableResult
    func rightBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        base.rightBarButtonItems = items
        return self
    }
}
