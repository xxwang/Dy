import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UITabBar {
    /// 设置代理
    /// - Parameter tabBarDelegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: any UITabBarDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置是否半透明
    /// - Parameter isTranslucent: 是否半透明
    /// - Returns: `Self`
    @discardableResult
    func isTranslucent(_ isTranslucent: Bool) -> Self {
        base.isTranslucent = isTranslucent
        let appearance = base.standardAppearance
        isTranslucent ? appearance.configureWithTransparentBackground() : appearance.configureWithDefaultBackground()
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置标题字体
    /// - Parameters:
    ///   - font: 要设置的字体
    ///   - state: 状态(如 `normal` 或 `selected`)
    /// - Returns: `Self`
    @discardableResult
    func titleFont(_ font: UIFont, for state: UIControl.State) -> Self {
        let appearance = base.standardAppearance
        if state == .normal {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
        } else if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.font] = font
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
        }
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance

        return self
    }

    /// 设置标题颜色
    /// - Parameters:
    ///   - color: 要设置的颜色
    ///   - state: 状态(如 `normal` 或 `selected`)
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State) -> Self {
        let appearance = base.standardAppearance
        if state == .normal {
            var attributes = appearance.stackedLayoutAppearance.normal.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes
            base.unselectedItemTintColor = color
        } else if state == .selected {
            var attributes = appearance.stackedLayoutAppearance.selected.titleTextAttributes
            attributes[.foregroundColor] = color
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes
            base.tintColor = color
        }
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance

        return self
    }

    /// 设置背景颜色
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

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.backgroundImage = backgroundImage
        appearance.backgroundEffect = nil
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance

        return self
    }

    /// 设置标题文字的偏移
    /// - Parameter offset: 偏移量
    /// - Returns: `Self`
    @discardableResult
    func titlePositionAdjustment(_ offset: UIOffset) -> Self {
        let appearance = base.standardAppearance
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = offset
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = offset
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance

        return self
    }

    /// 设置阴影图片
    /// - Parameter shadowImage: 阴影图片
    /// - Returns: `Self`
    @discardableResult
    func shadowImage(_ shadowImage: UIImage?) -> Self {
        let appearance = base.standardAppearance
        appearance.shadowImage = shadowImage?.withRenderingMode(.alwaysOriginal)
        base.standardAppearance = appearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置滚动时外观与标准外观一致
    /// - Returns: `Self`
    @discardableResult
    func scrollEdgeAppearance() -> Self {
        let appearance = base.standardAppearance
        base.scrollEdgeAppearance = appearance
        return self
    }

    /// 设置选中指示器图片
    /// - Parameter selectionIndicatorImage: 选中指示器图片
    /// - Returns: `Self`
    @discardableResult
    func selectionIndicatorImage(_ selectionIndicatorImage: UIImage) -> Self {
        base.selectionIndicatorImage = selectionIndicatorImage
        return self
    }
}

// MARK: - 方法
public extension DyWrapper where Base: UITabBar {
    /// 设置圆角
    /// - Parameters:
    ///   - corners: 需要设置圆角的角
    ///   - radius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func corner(maskedCorners: CACornerMask, radius: CGFloat) -> Self {
        self.base
            .dy
            .maskedCorners(maskedCorners)
            .cornerRadius(radius)
            .masksToBounds(true)
        return self
    }
}
