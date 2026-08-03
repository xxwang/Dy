import CoreGraphics
import UIKit

extension CGImage: DyExtension {}

// MARK: - 类型转换
public extension DyWrapper where Base: CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    func dy_toUIImage() -> UIImage? {
        return UIImage(cgImage: base)
    }
}
