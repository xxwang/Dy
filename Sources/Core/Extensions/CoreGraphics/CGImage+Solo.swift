import CoreGraphics
import UIKit

// MARK: - 类型转换
public extension CGImage {
    /// 将 `CGImage` 转换为 `UIImage`
    func solo_uIImage() -> UIImage? {
        return UIImage(cgImage: self)
    }
}
