import UIKit

// MARK: - String(系统图标)
public extension String {
    /// 创建单色图标
    /// - Parameters:
    ///   - color: 图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    func solo_monochromeSymbol(
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.monochrome(for: self, color: color, configuration: configuration)
    }

    /// 创建分层图标
    /// - Parameters:
    ///   - hierarchicalColor: 分层图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func solo_hierarchicalSymbol(
        hierarchicalColor: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.hierarchical(for: self, hierarchicalColor: hierarchicalColor, configuration: configuration)
    }

    /// 创建调色板图标
    /// - Parameters:
    ///   - paletteColors: 调色板图标颜色数组
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func solo_paletteSymbol(
        paletteColors: [UIColor],
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.palette(for: self, paletteColors: paletteColors, configuration: configuration)
    }

    /// 创建多色图标
    /// - Parameter configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func solo_multicolorSymbol(
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.multicolor(for: self, configuration: configuration)
    }
}
