import UIKit

// MARK: - 常用方法
public extension UIFont {
    /// 在控制台显示设备上所有可用字体
    static func dy_showAllFonts() {
        let families = UIFont.familyNames.sorted()
        print("UIFont 共 \(families.count) 个字体家族：")
        print("────────────────────────────────────────────────────────────")
        for family in families {
            print("🔤 \(family)")
            let fonts = UIFont.fontNames(forFamilyName: family).sorted()
            for name in fonts {
                print("   • \(name)")
            }
            print("────────────────────────────────────────────────────────────")
        }
    }
}

// MARK: - 自定义字体
public extension UIFont {
    /// 返回支持`Dynamic Type`的 `PingFang` 字体
    /// - Parameters:
    ///   - style: 文本样式（决定缩放基准）
    ///   - weight: 字重（`Regular, Medium, Semibold` 等）
    /// - Returns: 自动响应系统字体大小的 `UIFont`
    static func dy_pingFang(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        // 获取对应字重的 PingFang 字体名
        let fontName: String = switch weight {
        case .ultraLight: "PingFangSC-UltraLight"
        case .thin: "PingFangSC-Thin"
        case .light: "PingFangSC-Light"
        case .regular: "PingFangSC-Regular"
        case .medium: "PingFangSC-Medium"
        case .semibold: "PingFangSC-Semibold"
        case .bold: "PingFangSC-Bold"
        case .heavy: "PingFangSC-Heavy"
        case .black: "PingFangSC-Heavy"
        default: "PingFangSC-Regular"
        }

        // 创建基础字体（使用 TextStyle 的默认字号作为参考）
        let baseFontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        guard let baseFont = UIFont(name: fontName, size: baseFontSize) else {
            return UIFont.preferredFont(forTextStyle: style)
        }

        // 使用 UIFontMetrics 绑定到 Dynamic Type
        let metrics = UIFontMetrics(forTextStyle: style)

        return metrics.scaledFont(for: baseFont)
    }
}
