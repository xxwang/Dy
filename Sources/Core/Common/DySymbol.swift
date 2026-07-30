import UIKit

public final class DySymbol {
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
            .withTintColor(color).withRenderingMode(.alwaysOriginal)
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

    /// 创建多色图标(使用 SF Symbol 自带的层级颜色)
    /// - Parameters:
    ///   - name: 图标名称,需为多色符号(如 `"folder"`, `"alarm"`)
    ///   - configuration: 配置对象
    /// - Returns: `UIImage?`
    @available(iOS 15.0, *)
    public static func multicolor(
        for name: String,
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
            UIImage.SymbolConfiguration.preferringMulticolor()
        )
        return UIImage(systemName: name, withConfiguration: configuration)
    }
}

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
