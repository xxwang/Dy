import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGColor {
    /// 将 `CGColor` 转换为 `UIColor`
    func dy_uIColor() -> UIColor {
        return UIColor(cgColor: self)
    }
}
