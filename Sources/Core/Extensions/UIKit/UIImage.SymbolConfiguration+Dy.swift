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
            if #available(iOS 15.0, *) {
                configuration = configuration.applying(UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor))
            }
        }

        if let paletteColors, paletteColors.count > 0 {
            if #available(iOS 15.0, *) {
                configuration = configuration.applying(UIImage.SymbolConfiguration(paletteColors: paletteColors))
            }
        }

        return configuration
    }
}

// MARK: - 链式设置属性(自定义)
public extension UIImage.SymbolConfiguration {
    /// 设置文本样式
    /// - Parameter textStyle: 文本样式
    /// - Returns: `Self`
    @discardableResult
    func dy_textStyle(_ textStyle: UIFont.TextStyle) -> Self {
        let configuration = UIImage.SymbolConfiguration(textStyle: textStyle)
        return self.applying(configuration)
    }

    /// 设置缩放样式
    /// - Parameter scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func dy_scale(_ scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(scale: scale)
        return self.applying(configuration)
    }

    /// 设置自定义字体大小
    /// - Parameter pointSize: 自定义字体大小
    /// - Returns: `Self`
    @discardableResult
    func dy_pointSize(_ pointSize: CGFloat) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize)
        return self.applying(configuration)
    }

    /// 设置字体字重
    /// - Parameter weight: 字体字重
    /// - Returns: `Self`
    @discardableResult
    func dy_weight(_ weight: UIImage.SymbolWeight) -> Self {
        let configuration = UIImage.SymbolConfiguration(weight: weight)
        return self.applying(configuration)
    }

    /// 同时设置自定义字体大小和字重
    /// - Parameters:
    ///   - pointSize: 自定义字体大小
    ///   - weight: 字体字重
    /// - Returns: `Self`
    @discardableResult
    func dy_pointSize(_ pointSize: CGFloat, weight: UIImage.SymbolWeight) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        return self.applying(configuration)
    }

    /// 同时设置自定义字体大小字重和缩放
    /// - Parameters:
    ///   - pointSize: 自定义字体大小
    ///   - weight: 字体字重
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func dy_pointSize(_ pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        return self.applying(configuration)
    }

    /// 同时设置文本样式和缩放
    /// - Parameters:
    ///   - textStyle: 文本样式
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func dy_textStyle(_ textStyle: UIFont.TextStyle, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(textStyle: textStyle, scale: scale)
        return self.applying(configuration)
    }

    /// 设置字体
    /// - Parameters:
    ///   - font: 字体
    /// - Returns: `Self`
    @discardableResult
    func dy_font(_ font: UIFont) -> Self {
        let configuration = UIImage.SymbolConfiguration(font: font)
        return self.applying(configuration)
    }

    /// 同时设置字体和缩放
    /// - Parameters:
    ///   - font: 字体
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func dy_font(_ font: UIFont, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(font: font, scale: scale)
        return self.applying(configuration)
    }

    /// 设置分层颜色
    /// - Parameter hierarchicalColor: 分层颜色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_hierarchicalColor(_ hierarchicalColor: UIColor) -> Self {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor)
        return self.applying(configuration)
    }

    /// 设置调色板
    /// - Parameter paletteColors: 调色板
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_paletteColors(_ paletteColors: [UIColor]) -> Self {
        let configuration = UIImage.SymbolConfiguration(paletteColors: paletteColors)
        return self.applying(configuration)
    }

    /// 多色渲染偏好
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_preferringMulticolor() -> Self {
        let configuration = UIImage.SymbolConfiguration.preferringMulticolor()
        return self.applying(configuration)
    }

    /// 单色渲染偏好
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func dy_preferringMonochrome() -> Self {
        let configuration = UIImage.SymbolConfiguration.preferringMonochrome()
        return self.applying(configuration)
    }
}
