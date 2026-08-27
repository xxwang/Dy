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

public extension UIFont {
    /// 使用自定义字体
    /// - Parameters:
    ///   - name: 字体名称
    ///   - size: 字体大小
    /// - Returns: 固定大小的指定自定义字体
    static func dy_font(with name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }
}
