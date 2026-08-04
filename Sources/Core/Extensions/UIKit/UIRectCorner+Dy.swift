import UIKit

extension UIRectCorner: DyExtension {}

// MARK: - 方法
public extension DyWrapper where Base == UIRectCorner {
    /// 将 `CACornerMask` 转换为 `UIRectCorner`
    /// - Returns: `UIRectCorner`
    func toCACornerMask() -> CACornerMask {
        var corners: CACornerMask = []
        if base.contains(.topLeft) {
            corners.insert(.layerMinXMinYCorner)
        }
        if base.contains(.topRight) {
            corners.insert(.layerMaxXMinYCorner)
        }
        if base.contains(.bottomLeft) {
            corners.insert(.layerMinXMaxYCorner)
        }
        if base.contains(.bottomRight) {
            corners.insert(.layerMaxXMaxYCorner)
        }
        return corners
    }
}
