import UIKit

// MARK: - String(系统图标)
public extension SoloWrapper where Base == String {
    /// 创建单色图标
    /// - Parameters:
    ///   - color: 图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    func monochromeSymbol(
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.monochrome(for: base, color: color, configuration: configuration)
    }

    /// 创建分层图标
    /// - Parameters:
    ///   - hierarchicalColor: 分层图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func hierarchicalSymbol(
        hierarchicalColor: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.hierarchical(for: base, hierarchicalColor: hierarchicalColor, configuration: configuration)
    }

    /// 创建调色板图标
    /// - Parameters:
    ///   - paletteColors: 调色板图标颜色数组
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func paletteSymbol(
        paletteColors: [UIColor],
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.palette(for: base, paletteColors: paletteColors, configuration: configuration)
    }

    /// 创建多色图标
    /// - Parameter configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    func multicolorSymbol(
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return SoloSymbol.multicolor(for: base, configuration: configuration)
    }
}
