import UIKit
import CoreImage

// MARK: - 属性
public extension UIColor {
    /// 生成一个随机颜色
    static var dy_random: UIColor {
        let red = CGFloat.random(in: 0 ... 1)
        let green = CGFloat.random(in: 0 ... 1)
        let blue = CGFloat.random(in: 0 ... 1)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - 颜色组成(RGB)
public extension UIColor {
    /// 安全获取 `RGBA` 分量(0.0 ～ 1.0)
    /// - Returns: `(red, green, blue, alpha)` 元组,若无法转换则返回 `nil`
    var dy_rgbaComponents: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (red: r, green: g, blue: b, alpha: a)
    }

    /// 获取 `RGB` 分量(标准化为 0...1 范围)
    var dy_rgbComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let (r, g, b, _) = self.dy_rgbaComponents
        return (r, g, b)
    }

    /// 安全获取 `RGB` 分量(0 ～ 255 整数)
    /// - Returns: `(red, green, blue)` 元组(Int,范围 0–255),若无法转换则返回 `nil`
    var dy_rgbIntComponents: (red: Int, green: Int, blue: Int)? {
        let rgba = self.dy_rgbaComponents
        return (
            red: Int((rgba.red * 255).rounded()),
            green: Int((rgba.green * 255).rounded()),
            blue: Int((rgba.blue * 255).rounded())
        )
    }

    /// 安全获取 `RGB` 分量(0.0 ～ 1.0 浮点)
    /// - Returns: `(red, green, blue)` 元组(`CGFloat`),若无法转换则返回 `nil`
    var dy_rgbFloatComponents: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let rgba = self.dy_rgbaComponents
        return (red: rgba.red, green: rgba.green, blue: rgba.blue)
    }
}

// MARK: - 颜色组成(HSBA)
public extension UIColor {
    /// 安全获取 `HSBA` 分量(色相、饱和度、亮度、透明度)
    /// - Returns: `(hue, saturation, brightness, alpha)` 元组(0.0 ～ 1.0),若无法转换则返回 `nil`
    var dy_hsbaComponents: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return (hue: h, saturation: s, brightness: b, alpha: a)
    }
}

// MARK: - 颜色组成(单独成员)
public extension UIColor {
    /// 获取红色分量(0.0 ～ 1.0)
    var dy_redComponent: CGFloat? {
        return self.dy_rgbaComponents.red
    }

    /// 获取绿色分量(0.0 ～ 1.0)
    var dy_greenComponent: CGFloat? {
        return self.dy_rgbaComponents.green
    }

    /// 获取蓝色分量(0.0 ～ 1.0)
    var dy_blueComponent: CGFloat? {
        return self.dy_rgbaComponents.blue
    }

    /// 获取透明度分量(0.0 ～ 1.0)
    var dy_alphaComponent: CGFloat? {
        return self.dy_rgbaComponents.alpha
    }

    /// 获取色相分量(0.0 ～ 1.0)
    var dy_hueComponent: CGFloat? {
        return self.dy_hsbaComponents.hue
    }

    /// 获取饱和度分量(0.0 ～ 1.0)
    var dy_saturationComponent: CGFloat? {
        return self.dy_hsbaComponents.saturation
    }

    /// 获取亮度分量(0.0 ～ 1.0)
    var dy_brightnessComponent: CGFloat? {
        return self.dy_hsbaComponents.brightness
    }
}

// MARK: - 构造方法
public extension UIColor {
    /// 使用十六进制颜色字符串创建 `UIColor`
    /// - Note: `#RRGGBB`、`RRGGBB`、`#RGB`、`RGB`
    /// - Parameters:
    ///   - hex: 十六进度颜色字符串
    ///   - alpha: 透明度
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let normalized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "0x", with: "")

        guard !normalized.isEmpty else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }

        var hexValue: UInt64 = 0
        guard Scanner(string: normalized).scanHexInt64(&hexValue) else {
            self.init(white: 1.0, alpha: 0.0)
            return
        }

        let (r, g, b): (CGFloat, CGFloat, CGFloat)
        switch normalized.count {
        case 3:
            let r8 = ((hexValue >> 8) & 0xF) * 17
            let g8 = ((hexValue >> 4) & 0xF) * 17
            let b8 = (hexValue & 0xF) * 17
            r = CGFloat(r8); g = CGFloat(g8); b = CGFloat(b8)
        case 6:
            let r8 = (hexValue >> 16) & 0xFF
            let g8 = (hexValue >> 8) & 0xFF
            let b8 = hexValue & 0xFF
            r = CGFloat(r8); g = CGFloat(g8); b = CGFloat(b8)
        default:
            self.init(white: 1.0, alpha: 0.0)
            return
        }

        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: alpha.dy_clamped(to: 0 ... 1)
        )
    }

    /// 使用 `ARGB` 十六进制字符串创建 `UIColor`(包含透明度)
    /// - Note: 支持格式：`#AARRGGBB`、`AARRGGBB`、`#ARGB`、`ARGB`
    /// - Parameter argbHex: 带透明度的ARGB十六进度颜色字符串
    convenience init?(argbHex: String) {
        let normalized = argbHex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .replacingOccurrences(of: "0x", with: "")

        guard !normalized.isEmpty else { return nil }

        var hexValue: UInt64 = 0
        guard Scanner(string: normalized).scanHexInt64(&hexValue) else { return nil }

        let (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat)
        switch normalized.count {
        case 4:
            let alpha4 = (hexValue >> 12) & 0xF
            let red4 = (hexValue >> 8) & 0xF
            let green4 = (hexValue >> 4) & 0xF
            let blue4 = hexValue & 0xF
            a = CGFloat(alpha4 * 17) / 255.0
            r = CGFloat(red4 * 17) / 255.0
            g = CGFloat(green4 * 17) / 255.0
            b = CGFloat(blue4 * 17) / 255.0
        case 6:
            let red8 = (hexValue >> 16) & 0xFF
            let green8 = (hexValue >> 8) & 0xFF
            let blue8 = hexValue & 0xFF
            a = 1.0
            r = CGFloat(red8) / 255.0
            g = CGFloat(green8) / 255.0
            b = CGFloat(blue8) / 255.0
        case 8:
            let alpha8 = (hexValue >> 24) & 0xFF
            let red8 = (hexValue >> 16) & 0xFF
            let green8 = (hexValue >> 8) & 0xFF
            let blue8 = hexValue & 0xFF
            a = CGFloat(alpha8) / 255.0
            r = CGFloat(red8) / 255.0
            g = CGFloat(green8) / 255.0
            b = CGFloat(blue8) / 255.0
        default:
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a.dy_clamped(to: 0 ... 1))
    }

    /// 使用十六进制 `Int` 值创建颜色(如 `0xFF5733`)
    /// - Parameters:
    ///   - hex: `Int`类型十六进度颜色
    ///   - alpha: 透明度
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let r = CGFloat((hex >> 16) & 0xFF)
        let g = CGFloat((hex >> 8) & 0xFF)
        let b = CGFloat(hex & 0xFF)
        self.init(
            red: r / 255.0,
            green: g / 255.0,
            blue: b / 255.0,
            alpha: alpha.dy_clamped(to: 0 ... 1)
        )
    }

    /// 使用`0–255`范围的 `RGB` 值创建颜色
    /// - Parameters:
    ///   - r: 红色
    ///   - g: 绿色
    ///   - b: 蓝色
    ///   - alpha: 透明度
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(
            red: (r.dy_clamped(to: 0 ... 255)) / 255.0,
            green: (g.dy_clamped(to: 0 ... 255)) / 255.0,
            blue: (b.dy_clamped(to: 0 ... 255)) / 255.0,
            alpha: alpha.dy_clamped(to: 0 ... 1)
        )
    }

    /// 为浅色/深色模式分别指定颜色
    /// - Parameters:
    ///   - light: 浅色
    ///   - dark: 深色
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traits in
            traits.userInterfaceStyle == .dark ? dark : light
        }
    }
}

// MARK: - 转换
public extension UIColor {
    /// 从十六进制字符串创建 `UIColor`(支持` #RGB, #RRGGBB, 0xRRGGBB`)
    /// - Parameters:
    ///   - hex: 十六进制字符串
    ///   - alpha: 透明度
    /// - Returns: `UIColor`
    static func dy_color(from hex: String, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(hex: hex, alpha: alpha)
    }

    /// 转换为`CIColor`
    func dy_toCIColor() -> CoreImage.CIColor {
        return CoreImage.CIColor(color: self)
    }

    /// 转换为指定尺寸的`UIImage`
    /// - Parameter size: 图片尺寸
    /// - Returns: `UIImage?`
    func dy_toImage(ofSize size: CGSize) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.setFillColor(self.cgColor)
        context.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 返回 RGB 整数表示(如 0xFF0000)
    func dy_toRGBInt() -> Int {
        let (r, g, b, _) = self.dy_rgbaComponents
        return (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)
    }

    /// 返回长格式十六进制字符串(#RRGGBB)
    /// - Parameter prefixed: 是否包含 `#` 前缀(默认 `true`)
    func dy_toHexString(prefixed: Bool = true) -> String {
        let (r, g, b, _) = self.dy_rgbaComponents
        let hex = String(format: "%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        return prefixed ? "#\(hex)" : hex
    }

    /// 尝试返回短格式十六进制(#RGB),若不能则返回长格式
    /// - Returns: `String`
    func dy_toShortHexOrLong() -> String {
        let long = self.dy_toHexString(prefixed: false)
        let chars = Array(long)
        guard chars.count == 6,
              chars[0] == chars[1],
              chars[2] == chars[3],
              chars[4] == chars[5]
        else {
            return "#\(long)"
        }
        return "#\(chars[0])\(chars[2])\(chars[4])"
    }
}

// MARK: - 色彩操作
public extension UIColor {
    /// 返回给定颜色的`互补色`(基于 `RGB` 空间)
    /// - 返回 `nil` 如果颜色无法转换为 `RGB`(如系统动态颜色)
    static func dy_complementary(for color: UIColor) -> UIColor? {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard color.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return UIColor(
            red: 1.0 - r,
            green: 1.0 - g,
            blue: 1.0 - b,
            alpha: a
        )
    }

    /// 获取互补色(基于 HSB 色相偏移 180°)
    var dy_complementary: UIColor {
        var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
        return UIColor(hue: complementaryHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    /// 增加亮度
    func dy_lighten(by amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: min(b + amount, 1.0), alpha: a)
    }

    /// 降低亮度
    func dy_darken(by amount: CGFloat = 0.2) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return UIColor(hue: h, saturation: s, brightness: max(b - amount, 0), alpha: a)
    }

    /// 确保饱和度不低于指定值
    func dy_withMinSaturation(_ minSaturation: CGFloat) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        let newSat = max(s, minSaturation)
        return UIColor(hue: h, saturation: newSat, brightness: b, alpha: a)
    }

    /// 混合两个颜色(按权重)
    static func dy_blend(_ color1: UIColor, weight1: CGFloat = 0.5, with color2: UIColor, weight2: CGFloat = 0.5) -> UIColor {
        let total = weight1 + weight2
        let w1 = weight1 / total
        let w2 = weight2 / total

        let (r1, g1, b1, a1) = color1.dy_rgbaComponents
        let (r2, g2, b2, a2) = color2.dy_rgbaComponents

        return UIColor(
            red: r1 * w1 + r2 * w2,
            green: g1 * w1 + g2 * w2,
            blue: b1 * w1 + b2 * w2,
            alpha: a1 * w1 + a2 * w2
        )
    }

    /// 在两个颜色之间插值
    static func dy_interpolate(from start: UIColor, to end: UIColor, progress: CGFloat) -> UIColor {
        let p = min(max(progress, 0), 1)
        let (sr, sg, sb, sa) = start.dy_rgbaComponents
        let (er, eg, eb, ea) = end.dy_rgbaComponents
        return UIColor(
            red: sr + (er - sr) * p,
            green: sg + (eg - sg) * p,
            blue: sb + (eb - sb) * p,
            alpha: sa + (ea - sa) * p
        )
    }
}

// MARK: - 判断
public extension UIColor {
    /// 判断颜色是否为暗色
    ///
    /// 使用亮度公式 `0.2126 * R + 0.7152 * G + 0.0722 * B` 计算亮度值,小于 0.5 视为暗色
    var dy_isDark: Bool {
        let components = self.dy_rgbComponents
        let luminance = 0.2126 * components.red + 0.7152 * components.green + 0.0722 * components.blue
        return luminance < 0.5
    }

    /// 判断颜色是否为黑色或白色
    ///
    /// 如果颜色接近纯黑(RGB 值均小于 0.09)或纯白(RGB 值均大于 0.91),则返回 true
    var dy_isBlackOrWhite: Bool {
        let components = self.dy_rgbComponents
        return (components.red > 0.91 && components.green > 0.91 && components.blue > 0.91) ||
            (components.red < 0.09 && components.green < 0.09 && components.blue < 0.09)
    }

    /// 判断颜色是否为黑色
    ///
    /// 若颜色非常接近黑色(RGB 值均小于 0.09),返回 true
    var dy_isBlack: Bool {
        let components = self.dy_rgbComponents
        return components.red < 0.09 && components.green < 0.09 && components.blue < 0.09
    }

    /// 判断颜色是否为白色
    ///
    /// 若颜色非常接近白色(RGB 值均大于 0.91),返回 true
    var dy_isWhite: Bool {
        let components = self.dy_rgbComponents
        return components.red > 0.91 && components.green > 0.91 && components.blue > 0.91
    }

    /// 比较当前颜色与另一个颜色的 `RGB` 组件差异是否超过阈值
    ///
    /// - Parameters:
    ///   - color: 要比较的颜色
    ///   - threshold: 差异阈值,默认 0.25
    /// - Returns: 如果颜色显著不同,返回 true
    func dy_isDistinct(from color: UIColor, threshold: CGFloat = 0.25) -> Bool {
        let bg = self.dy_rgbComponents
        let fg = color.self.dy_rgbComponents

        // 确保两个颜色都不是灰色系
        if abs(bg.red - bg.green) < 0.03 && abs(bg.red - bg.blue) < 0.03 &&
            abs(fg.red - fg.green) < 0.03 && abs(fg.red - fg.blue) < 0.03
        {
            return false
        }

        return abs(bg.red - fg.red) > threshold ||
            abs(bg.green - fg.green) > threshold ||
            abs(bg.blue - fg.blue) > threshold
    }

    /// 检查两种颜色之间是否存在足够的对比度
    ///
    /// 根据 `WCAG` 对比度标准,如果对比度大于 1.6,则认为有足够对比度
    ///
    /// - Parameter color: 要比较的颜色
    /// - Returns: 如果有足够对比度,返回 true
    func dy_hasSufficientContrast(with color: UIColor) -> Bool {
        let bg = self.dy_rgbComponents
        let fg = color.dy_rgbComponents

        let bgLum = 0.2126 * bg.red + 0.7152 * bg.green + 0.0722 * bg.blue
        let fgLum = 0.2126 * fg.red + 0.7152 * fg.green + 0.0722 * fg.blue
        let contrast = bgLum > fgLum ? (bgLum + 0.05) / (fgLum + 0.05) : (fgLum + 0.05) / (bgLum + 0.05)

        return contrast > 1.6
    }
}

// MARK: - 动态颜色
public extension UIColor {
    /// 使用相同的十六进制颜色创建动态颜色(浅色/深色模式下颜色相同)
    static func dy_dynamic(hex: String) -> UIColor {
        let color = UIColor.dy_color(from: hex)
        return self.dy_dynamic(light: color, dark: color)
    }

    /// 使用不同十六进制颜色创建动态颜色(分别指定浅色/深色模式)
    /// - Parameters:
    ///   - lightHex: 浅色模式下的颜色
    ///   - darkHex: 深色模式下的颜色
    /// - Returns: 动态颜色对象
    static func dy_dynamic(lightHex: String, darkHex: String) -> UIColor {
        let light = UIColor.dy_color(from: lightHex)
        let dark = UIColor.dy_color(from: darkHex)
        return self.dy_dynamic(light: light, dark: dark)
    }

    /// 使用相同的 `UIColor` 创建动态颜色
    static func dy_dynamic(color: UIColor) -> UIColor {
        self.dy_dynamic(light: color, dark: color)
    }

    /// 使用不同 `UIColor` 创建动态颜色
    /// - Parameters:
    ///   - light: 浅色模式颜色
    ///   - dark: 深色模式颜色
    /// - Returns: 动态颜色
    static func dy_dynamic(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
}

// MARK: - 渐变
public extension UIColor {
    /// 创建可复用的渐变图层(推荐用于动态UI)
    ///
    /// - Parameters: 同上
    /// - Returns: 配置好的 `CAGradientLayer`
    static func dy_createGradientLayer(
        frame: CGRect,
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.frame = frame
        layer.colors = colors.count >= 2 ? colors.map(\.cgColor) : [UIColor.clear.cgColor]

        if let provided = locations, provided.count == colors.count {
            layer.locations = provided.map { NSNumber(value: Double($0)) }
        } else if colors.count >= 2 {
            layer.locations = (0 ..< colors.count).map { index in
                NSNumber(value: Double(index) / Double(colors.count - 1))
            }
        }

        layer.startPoint = startPoint
        layer.endPoint = endPoint
        return layer
    }

    /// 创建线性渐变图片(推荐用于背景、纹理等)
    ///
    /// - Note: 若需作为背景,建议直接使用 `gradientLayer` 并添加到`view.layer`
    ///
    /// - Parameters:
    ///   - size: 渐变区域尺寸(必填)
    ///   - colors: 至少两个颜色
    ///   - locations: 每个颜色的位置(0～1),若未提供则自动均匀分布
    ///   - startPoint: 渐变起点(单位坐标,默认左上角 `(0, 0)`)
    ///   - endPoint: 渐变终点(单位坐标,默认右下角 `(1, 1)`)
    /// - Returns: 渲染后的 `UIImage`,失败返回 `nil`
    static func dy_createGradientImage(
        size: CGSize,
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> UIImage? {
        guard size.width > 0, size.height > 0 else { return nil }
        guard colors.count >= 2 else { return nil }

        let finalLocations: [NSNumber] = if let provided = locations, provided.count == colors.count {
            provided.map { NSNumber(value: Double($0)) }
        } else {
            // 自动生成均匀分布
            (0 ..< colors.count).map { index in
                NSNumber(value: Double(index) / Double(colors.count - 1))
            }
        }

        let layer = CAGradientLayer()
        layer.frame = CGRect(origin: .zero, size: size)
        layer.colors = colors.map(\.cgColor)
        layer.locations = finalLocations
        layer.startPoint = startPoint
        layer.endPoint = endPoint

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 创建基于渐变图片的 `UIColor`(慎用：仅适用于固定尺寸平铺)
    ///
    /// - Warning: 此方法生成的 UIColor 使用 `patternImage`,会在视图中平铺
    ///   若尺寸与使用区域不一致,可能出现拉伸或重复建议优先使用 `createGradientLayer`
    static func dy_createGradientColor(
        size: CGSize,
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> UIColor? {
        guard let image = self.dy_createGradientImage(
            size: size,
            colors: colors,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint
        ) else { return nil }

        return UIColor(patternImage: image)
    }
}

// MARK: - [UIColor] 链式调用
public extension [UIColor] {
    /// 生成渐变图层
    func dy_createGradientLayer(
        frame: CGRect,
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> CAGradientLayer {
        UIColor.dy_createGradientLayer(
            frame: frame,
            colors: self,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    /// 生成渐变图片
    func dy_createGradientImage(
        size: CGSize,
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> UIImage? {
        UIColor.dy_createGradientImage(
            size: size,
            colors: self,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    /// 生成渐变 `UIColor`(谨慎使用)
    func dy_createGradientColor(
        size: CGSize,
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = .zero,
        endPoint: CGPoint = CGPoint(x: 1, y: 1)
    ) -> UIColor? {
        UIColor.dy_createGradientColor(
            size: size,
            colors: self,
            locations: locations,
            startPoint: startPoint,
            endPoint: endPoint
        )
    }
}

// MARK: - 常用方法
public extension UIColor {
    /// 设置颜色的透明度(链式调用)
    /// - Parameter alpha: 透明度(范围 0.0 ~ 1.0)
    /// - Returns: 透明度调整后的`UIColor`
    func dy_alpha(_ alpha: CGFloat) -> UIColor {
        return self.withAlphaComponent(alpha)
    }
}
