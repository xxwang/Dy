import UIKit

public class DySymbol {
    /// 创建单色图标
    /// - Parameters:
    ///   - name: 图标名称
    ///   - color: 图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    public static func monochrome(
        for name: String,
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        let configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        return UIImage(systemName: name, withConfiguration: configuration)?
            .withTintColor(color, renderingMode: .alwaysOriginal)
    }

    /// 创建分层图标
    /// - Parameters:
    ///   - name: 图标名称
    ///   - hierarchicalColor: 分层图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    public static func hierarchical(
        for name: String,
        hierarchicalColor: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        var configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        configuration = configuration.applying(
            UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor)
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }

    /// 创建调色板图标
    /// - Parameters:
    ///   - name: 图标名称
    ///   - paletteColors: 调色板图标颜色数组
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    public static func palette(
        for name: String,
        paletteColors: [UIColor],
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        var configuration = if let configuration {
            configuration
        } else {
            UIImage.SymbolConfiguration(
                pointSize: 20,
                weight: .regular,
                scale: .default
            )
        }

        configuration = configuration.applying(
            UIImage.SymbolConfiguration(paletteColors: paletteColors)
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }
}

// MARK: - String(系统图标)
public extension DyWrapper where Base == String {
    /// 创建单色图标
    /// - Parameters:
    ///   - color: 图标颜色
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    func monochromeSymbol(
        color: UIColor,
        configuration: UIImage.SymbolConfiguration? = nil
    ) -> UIImage? {
        return DySymbol.monochrome(for: base, color: color, configuration: configuration)
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
        return DySymbol.hierarchical(for: base, hierarchicalColor: hierarchicalColor, configuration: configuration)
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
        return DySymbol.palette(for: base, paletteColors: paletteColors, configuration: configuration)
    }
}
