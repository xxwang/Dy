import CoreGraphics
import UIKit

extension CGImage: SoloExtension {}

// MARK: - 类型转换
public extension SoloWrapper where Base: CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    func toUIImage() -> UIImage? {
        return UIImage(cgImage: base)
    }
}
