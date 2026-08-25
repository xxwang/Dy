import UIKit

// MARK: - String(系统图标)
public extension String {
    /// 创建单色图标
    /// - Parameters:
    ///   - color: 图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    func dy_monochromeSymbol(
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return DySymbol.monochrome(for: self, color: color, configuration: configuration)
    }

    /// 创建分层图标
    /// - Parameters:
    ///   - hierarchicalColor: 分层图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func dy_hierarchicalSymbol(
        hierarchicalColor: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return DySymbol.hierarchical(for: self, hierarchicalColor: hierarchicalColor, configuration: configuration)
    }

    /// 创建调色板图标
    /// - Parameters:
    ///   - paletteColors: 调色板图标颜色数组
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func dy_paletteSymbol(
        paletteColors: [UIColor],
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return DySymbol.palette(for: self, paletteColors: paletteColors, configuration: configuration)
    }

    /// 创建多色图标
    /// - Parameter configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func dy_multicolorSymbol(
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return DySymbol.multicolor(for: self, configuration: configuration)
    }
}
