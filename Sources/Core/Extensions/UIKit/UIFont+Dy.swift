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

// MARK: - 苹方字体
public extension UIFont {
    /// 按字重构建指定大小的苹方基础字体
    /// - Parameters:
    ///   - size: 字体大小
    ///   - weight: 字重
    /// - Returns:（不含 `Dynamic Type `缩放）的字体
    private static func dy_baseFont(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch weight {
        case .ultraLight: return UIFont(name: "PingFangSC-UltraLight", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .thin: return UIFont(name: "PingFangSC-Thin", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .light: return UIFont(name: "PingFangSC-Light", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .regular: return UIFont(name: "PingFangSC-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .medium: return UIFont(name: "PingFangSC-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        case .semibold: return UIFont(name: "PingFangSC-Semibold", size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
        default: return UIFont.systemFont(ofSize: size, weight: weight)
        }
    }

    /// 返回支持 `Dynamic Type` 的 `PingFang` 字体（字号由文本样式决定）
    /// - Parameters:
    ///   - style: 文本样式（决定缩放基准字号）
    ///   - weight: 字重（`Regular, Medium, Semibold` 等）
    /// - Returns: 自动响应系统字体大小的 `UIFont`
    static func dy_pf(forTextStyle style: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        // 参考字号:取对应 TextStyle 的系统默认字号作为基准
        let baseFontSize = UIFont.preferredFont(forTextStyle: style).pointSize
        let baseFont = self.dy_baseFont(size: baseFontSize, weight: weight)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: baseFont)
    }

    /// 返回指定字号的 `PingFang` 字体（**固定字号，不参与 Dynamic Type 缩放**）
    /// - Parameters:
    ///   - size: 字号（pt），精确生效
    ///   - weight: 字重
    /// - Returns: 指定大小的苹方字体
    static func dy_pf(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        self.dy_baseFont(size: size, weight: weight)
    }

    /// 返回指定字号、且支持 `Dynamic Type` 缩放的 `PingFang` 字体
    /// - Parameters:
    ///   - size: 字号（pt），作为 Dynamic Type 缩放的基准
    ///   - textStyle: 文本样式，决定 Dynamic Type 的缩放曲线（如 `.body` 缩放更灵敏）
    ///   - weight: 字重
    /// - Returns: 自动响应系统字体大小的苹方字体
    static func dy_pf(size: CGFloat, textStyle: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let baseFont = self.dy_baseFont(size: size, weight: weight)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: baseFont)
    }
}
