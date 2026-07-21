import UIKit

// MARK: - 方法
public extension UIRectCorner {
    /// 将 `CACornerMask` 转换为 `UIRectCorner`
    /// - Returns: `UIRectCorner`
    func dy_toCACornerMask() -> CACornerMask {
        var corners: CACornerMask = []
        if self.contains(.topLeft) {
            corners.insert(.layerMinXMinYCorner)
        }
        if self.contains(.topRight) {
            corners.insert(.layerMaxXMinYCorner)
        }
        if self.contains(.bottomLeft) {
            corners.insert(.layerMinXMaxYCorner)
        }
        if self.contains(.bottomRight) {
            corners.insert(.layerMaxXMaxYCorner)
        }
        return corners
    }
}
