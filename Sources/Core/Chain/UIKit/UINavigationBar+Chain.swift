import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UINavigationBar {
    /// 设置导航栏是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        return self
    }

    /// 设置是否启用大标题
    /// - Parameter large: 是否启用大标题
    /// - Returns: `Self`
    @discardableResult
    func prefersLargeTitles(_ large: Bool) -> Self {
        base.prefersLargeTitles = large
        return self
    }

    /// 设置标题字体
    /// - Parameter font: 标题字体
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes[.font] = font
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置大标题字体
    /// - Parameter font: 大标题字体
    /// - Returns: `Self`
    @discardableResult
    func largeTitleFont(_ font: UIFont) -> Self {
        let appearance = base.standardAppearance
        appearance.largeTitleTextAttributes[.font] = font
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置标题颜色
    /// - Parameter color: 标题颜色
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes[.foregroundColor] = color
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置大标题颜色
    /// - Parameter color: 大标题颜色
    /// - Returns: `Self`
    @discardableResult
    func largeTitleColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.largeTitleTextAttributes[.foregroundColor] = color
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的 `barTintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func barTintColor(_ color: UIColor?) -> Self {
        base.barTintColor = color
        return self
    }

    /// 设置导航栏的 `tintColor`
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 设置导航栏的背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundColor = color
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundImage = image
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的阴影图片
    /// - Parameter image: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func shadowImage(_ image: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowImage = image?.withRenderingMode(.alwaysOriginal)
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏的阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ color: UIColor?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowColor = color
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏滚动时的外观与标准外观一致
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance() -> Self {
        let appearance = base.standardAppearance
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置导航栏标题的文本属性
    /// - Parameter attributes: 富文本属性
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        let appearance = base.standardAppearance
        appearance.titleTextAttributes = attributes
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }
}
