import UIKit

// MARK: - 方法
public extension UIImage.SymbolConfiguration {
    /// 默认配置(`pointSize: 20, weight: .regular, scale: .default`)
    static func dy_default() -> UIImage.SymbolConfiguration {
        return UIImage.SymbolConfiguration(
            pointSize: 20,
            weight: .regular,
            scale: .default
        )
    }

    /// 快速创建自定义配置
    /// - Parameters:
    ///   - font: 字体
    ///   - textStyle: 文本样式
    ///   - pointSize: 字体大小
    ///   - weight: 字重
    ///   - scale: 缩放
    ///   - hierarchicalColor: 分层颜色
    ///   - paletteColors: 调色板颜色数组
    /// - Returns: `UIImage.SymbolConfiguration`
    static func custom(
        font: UIFont? = nil,
        textStyle: UIFont.TextStyle? = nil,
        pointSize: CGFloat? = nil,
        weight: UIImage.SymbolWeight? = nil,
        scale: UIImage.SymbolScale = .default,
        hierarchicalColor: UIColor? = nil,
        paletteColors: [UIColor]? = nil
    ) -> UIImage.SymbolConfiguration {
        var configuration = UIImage.SymbolConfiguration(scale: scale)
        if let font {
            configuration = configuration.applying(UIImage.SymbolConfiguration(font: font))
        }

        if let textStyle {
            configuration = configuration.applying(UIImage.SymbolConfiguration(textStyle: textStyle))
        }

        if let pointSize {
            configuration = configuration.applying(UIImage.SymbolConfiguration(pointSize: pointSize))
        }

        if let weight {
            configuration = configuration.applying(UIImage.SymbolConfiguration(weight: weight))
        }

        if let hierarchicalColor {
            configuration = configuration.applying(UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor))
        }

        if let paletteColors, paletteColors.count > 0 {
            configuration = configuration.applying(UIImage.SymbolConfiguration(paletteColors: paletteColors))
        }

        return configuration
    }
}
