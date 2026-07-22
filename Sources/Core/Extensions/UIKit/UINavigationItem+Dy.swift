import UIKit

// MARK: - 常用方法
public extension UINavigationItem {
    /// 将 `titleView` 设置为指定图片的 `UIImageView`
    /// - Note: 此操作会覆盖当前的 `titleView`
    ///
    /// - Parameters:
    ///   - image: 要显示的图片
    ///   - size: 图片视图的尺寸
    func dy_titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.clipsToBounds = true
        self.titleView = imageView
    }
}

// MARK: - 链式设置属性
public extension UINavigationItem {
    /// 设置大标题的显示模式
    /// - Note: 需配合 `UINavigationBar.prefersLargeTitles = true` 使用
    /// - Parameter mode: 大标题显示模式
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_largeTitleDisplayMode(_ mode: UINavigationItem.LargeTitleDisplayMode) -> Self {
        self.largeTitleDisplayMode = mode
        return self
    }

    /// 设置导航栏标题文本
    ///
    /// - Parameter title: 标题字符串
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置自定义标题视图
    /// - Note: 会覆盖 `title`
    /// - Parameter view: 自定义视图
    /// - Returns: `Self`
    @discardableResult
    func dy_titleView(_ view: UIView?) -> Self {
        self.titleView = view
        return self
    }

    /// 设置返回按钮的外观
    /// - Note:影响下一个`push`进来的控制器的返回按钮
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 按钮样式,默认为 `.plain`
    /// - Returns: `Self`
    @discardableResult
    func dy_backBarButtonItem(title: String?, style: UIBarButtonItem.Style = .plain) -> Self {
        let backButton = UIBarButtonItem(title: title, style: style, target: nil, action: nil)
        self.backBarButtonItem = backButton
        return self
    }

    /// 设置左侧单个按钮
    ///
    /// - Parameter buttonItem: 左侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func dy_leftBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        self.leftBarButtonItem = buttonItem
        return self
    }

    /// 设置右侧单个按钮
    ///
    /// - Parameter buttonItem: 右侧按钮项
    /// - Returns: `Self`
    @discardableResult
    func dy_rightBarButtonItem(_ buttonItem: UIBarButtonItem?) -> Self {
        self.rightBarButtonItem = buttonItem
        return self
    }

    /// 设置左侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从左到右
    /// - Returns: `Self`
    @discardableResult
    func dy_leftBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        self.leftBarButtonItems = items
        return self
    }

    /// 设置右侧多个按钮
    ///
    /// - Parameter items: 按钮数组,顺序从右到左
    /// - Returns: `Self`
    @discardableResult
    func dy_rightBarButtonItems(_ items: [UIBarButtonItem]?) -> Self {
        self.rightBarButtonItems = items
        return self
    }
}
