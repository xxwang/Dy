import UIKit

// MARK: - 常用方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条上的按钮和文字颜色,默认为白色
    func dy_transparent(with tintColor: UIColor = .white) {
        self.dy_isTranslucent(true)
            .dy_backgroundColor(.clear)
            .dy_backgroundImage(UIImage())
            .dy_barTintColor(.clear)
            .dy_tintColor(tintColor)
            .dy_shadowImage(UIImage())
            .dy_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background: 背景颜色
    ///   - text: 文字颜色
    func dy_colors(background: UIColor, text: UIColor) {
        self.dy_isTranslucent(false)
            .dy_backgroundColor(background)
            .dy_barTintColor(background)
            .dy_backgroundImage(UIImage())
            .dy_tintColor(text)
            .dy_titleTextAttributes([.foregroundColor: text])
    }
}

// MARK: - 链式设置属性
public extension UINavigationBar {
    /// 设置导航栏是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func dy_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否启用大标题
    /// - Parameter large: 是否启用大标题
    /// - Returns: `Self`
    @discardableResult
    func dy_prefersLargeTitles(_ large: Bool) -> Self {
        self.prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`
    @discardableResult
    func dy_titleFont(_ font: UIFont) -> Self {
        let appearance = self.standardAppearance
        appearance.titleTextAttributes[.font] = font
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置大标题字体
    /// - Parameter font: 大标题字体
    /// - Returns: `Self`
    @discardableResult
    func dy_largeTitleFont(_ font: UIFont) -> Self {
        let appearance = self.standardAppearance
        appearance.largeTitleTextAttributes[.font] = font
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置标题颜色
    /// - Parameter color: 标题颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_titleColor(_ color: UIColor?) -> Self {
        let appearance = self.standardAppearance
        appearance.titleTextAttributes[.foregroundColor] = color
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置大标题颜色
    /// - Parameter color: 大标题颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_largeTitleColor(_ color: UIColor?) -> Self {
        let appearance = self.standardAppearance
        appearance.largeTitleTextAttributes[.foregroundColor] = color
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的 `barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_barTintColor(_ color: UIColor?) -> Self {
        self.barTintColor = color
        return self
    }

    /// 设置导航栏的 `tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    override func dy_tintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    /// 设置导航栏的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    override func dy_backgroundColor(_ color: UIColor?) -> Self {
        let appearance = self.standardAppearance
        appearance.backgroundColor = color
        appearance.backgroundEffect = nil
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundImage(_ image: UIImage?) -> Self {
        let appearance = self.standardAppearance
        appearance.backgroundImage = image
        appearance.backgroundEffect = nil
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的阴影图片
    /// - Parameter image: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowImage(_ image: UIImage?) -> Self {
        let appearance = self.standardAppearance
        appearance.shadowImage = image?.withRenderingMode(.alwaysOriginal)
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    override func dy_shadowColor(_ color: UIColor?) -> Self {
        let appearance = self.standardAppearance
        appearance.shadowColor = color
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏滚动时的外观与标准外观一致
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollEdgeAppearance() -> Self {
        let appearance = self.standardAppearance
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏标题的文本属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`
    @discardableResult
    func dy_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        let appearance = self.standardAppearance
        appearance.titleTextAttributes = attributes
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        return self
    }
}
