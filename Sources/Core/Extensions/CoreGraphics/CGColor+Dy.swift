import CoreGraphics
import UIKit

extension CGColor: DyExtension {}

// MARK: - 类型转换
public extension DyWrapper where Base == CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    func toUIColor() -> UIColor {
        return UIColor(cgColor: base)
    }
}
