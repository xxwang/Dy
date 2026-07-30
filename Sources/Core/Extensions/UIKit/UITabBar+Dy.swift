import UIKit

// MARK: - 链式设置属性
public extension UITabBar {
    /// 设置代理
    /// - Parameter tabBarDelegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: any UITabBarDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func dy_isTranslucent(_ isTranslucent: Bool) -> Self {
        self.isTranslucent = isTranslucent
        let appearance = self.standardAppearance
        isTranslucent ? appearance.configureWithTransparentBackground() : appearance.configureWithDefaultBackground()
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - state: 状态(如 `normal` 或 `selected`)
    /// - Returns: `Self`
    @discardableResult
    func dy_titleFont(_ font: UIFont, for state: UIControl.State) -> Self {
        let appearance = self.standardAppearance
        if state == .normal {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        } else if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        }
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }

        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 状态(如 `normal` 或 `selected`)
    /// - Returns: `Self`
    @discardableResult
    func dy_titleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        let appearance = self.standardAppearance
        if state == .normal {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        } else if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        }
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }

        return self
    }

    /// 设置图标颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 状态(如 `normal` 或 `selected`)
    /// - Returns: `Self`
    @discardableResult
    func dy_imageColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        let appearance = self.standardAppearance
        if state == .normal {
            appearance.stackedLayoutAppearance.normal.iconColor = color
        } else if state == .selected {
            appearance.stackedLayoutAppearance.selected.iconColor = color
        }
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
        return self
    }

    /// 设置背景颜色
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    override func dy_backgroundColor(_ color: UIColor?) -> Self {
        let appearance = self.standardAppearance
        appearance.backgroundColor = color
        appearance.backgroundEffect = nil
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }

        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundImage(_ backgroundImage: UIImage?) -> Self {
        let appearance = self.standardAppearance
        appearance.backgroundImage = backgroundImage
        appearance.backgroundEffect = nil
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }

        return self
    }

    /// 设置标题文字的偏移
    /// - Parameter offset: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func dy_titlePositionAdjustment(_ offset: UIOffset) -> Self {
        let appearance = self.standardAppearance
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
        return self
    }

    /// 设置阴影图片
    /// - Parameter shadowImage: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowImage(_ shadowImage: UIImage?) -> Self {
        let appearance = self.standardAppearance
        appearance.shadowImage = shadowImage?.withRenderingMode(.alwaysOriginal)
        self.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            self.scrollEdgeAppearance = appearance
        }
        return self
    }

    /// 设置滚动时外观与标准外观一致
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_scrollEdgeAppearance() -> Self {
        let appearance = self.standardAppearance
        self.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置选中指示器图片
    /// - Parameter selectionIndicatorImage: 选中指示器图片
    /// - Returns: `Self`
    @discardableResult
    func dy_selectionIndicatorImage(_ selectionIndicatorImage: UIImage) -> Self {
        self.selectionIndicatorImage = selectionIndicatorImage
        return self
    }
}

// MARK: - 链式方法
public extension UITabBar {
    /// 设置圆角
    /// - Parameters:
    ///   - corners: 需要设置圆角的角
    ///   - radius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func dy_corner(maskedCorners: CACornerMask, radius: CGFloat) -> Self {
        self.dy_maskedCorners(maskedCorners)
            .dy_cornerRadius(radius)
            .dy_masksToBounds(true)
        return self
    }
}
