import UIKit

// MARK: - 链式设置属性(自定义)
public extension DyWrapper where Base == UIImage.SymbolConfiguration {
    /// 设置文本样式
    /// - Parameter textStyle: 文本样式
    /// - Returns: `Self`
    @discardableResult
    func textStyle(_ textStyle: UIFont.TextStyle) -> Self {
        let configuration = UIImage.SymbolConfiguration(textStyle: textStyle)
        base = base.applying(configuration)
        return self
    }

    /// 设置缩放样式
    /// - Parameter scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func scale(_ scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(scale: scale)
        base = base.applying(configuration)
        return self
    }

    /// 设置自定义字体大小
    /// - Parameter pointSize: 自定义字体大小
    /// - Returns: `Self`
    @discardableResult
    func pointSize(_ pointSize: CGFloat) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize)
        base = base.applying(configuration)
        return self
    }

    /// 设置字体字重
    /// - Parameter weight: 字体字重
    /// - Returns: `Self`
    @discardableResult
    func weight(_ weight: UIImage.SymbolWeight) -> Self {
        let configuration = UIImage.SymbolConfiguration(weight: weight)
        base = base.applying(configuration)
        return self
    }

    /// 同时设置自定义字体大小和字重
    /// - Parameters:
    ///   - pointSize: 自定义字体大小
    ///   - weight: 字体字重
    /// - Returns: `Self`
    @discardableResult
    func pointSize(_ pointSize: CGFloat, weight: UIImage.SymbolWeight) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        base = base.applying(configuration)
        return self
    }

    /// 同时设置自定义字体大小字重和缩放
    /// - Parameters:
    ///   - pointSize: 自定义字体大小
    ///   - weight: 字体字重
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func pointSize(_ pointSize: CGFloat, weight: UIImage.SymbolWeight, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
        base = base.applying(configuration)
        return self
    }

    /// 同时设置文本样式和缩放
    /// - Parameters:
    ///   - textStyle: 文本样式
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func textStyle(_ textStyle: UIFont.TextStyle, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(textStyle: textStyle, scale: scale)
        base = base.applying(configuration)
        return self
    }

    /// 设置字体
    /// - Parameters:
    ///   - font: 字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        let configuration = UIImage.SymbolConfiguration(font: font)
        base = base.applying(configuration)
        return self
    }

    /// 同时设置字体和缩放
    /// - Parameters:
    ///   - font: 字体
    ///   - scale: 缩放样式
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont, scale: UIImage.SymbolScale) -> Self {
        let configuration = UIImage.SymbolConfiguration(font: font, scale: scale)
        base = base.applying(configuration)
        return self
    }

    /// 设置分层颜色
    /// - Parameter hierarchicalColor: 分层颜色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func hierarchicalColor(_ hierarchicalColor: UIColor) -> Self {
        let configuration = UIImage.SymbolConfiguration(hierarchicalColor: hierarchicalColor)
        base = base.applying(configuration)
        return self
    }

    /// 设置调色板
    /// - Parameter paletteColors: 调色板
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func paletteColors(_ paletteColors: [UIColor]) -> Self {
        let configuration = UIImage.SymbolConfiguration(paletteColors: paletteColors)
        base = base.applying(configuration)
        return self
    }

    /// 多色渲染偏好
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func preferringMulticolor() -> Self {
        let configuration = UIImage.SymbolConfiguration.preferringMulticolor()
        base = base.applying(configuration)
        return self
    }

    /// 单色渲染偏好
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func preferringMonochrome() -> Self {
        let configuration = UIImage.SymbolConfiguration.preferringMonochrome()
        base = base.applying(configuration)
        return self
    }
}
