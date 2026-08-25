import QuartzCore
import UIKit

// MARK: - 属性
public extension CACornerMask {
    /// 左上角(等价于 `.layerMinXMinYCorner`)
    static let dy_topLeft: CACornerMask = .layerMinXMinYCorner

    /// 右上角(等价于 `.layerMaxXMinYCorner`)
    static let dy_topRight: CACornerMask = .layerMaxXMinYCorner

    /// 左下角(等价于 `.layerMinXMaxYCorner`)
    static let dy_bottomLeft: CACornerMask = .layerMinXMaxYCorner

    /// 右下角(等价于 `.layerMaxXMaxYCorner`)
    static let dy_bottomRight: CACornerMask = .layerMaxXMaxYCorner

    /// 所有四个角
    static let dy_all: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMaxYCorner,
    ]
}

// MARK: - 方法
public extension CACornerMask {
    /// 将 `CACornerMask` 转换为 `UIRectCorner`
    /// - Returns: `UIRectCorner`
    func dy_uIRectCorner() -> UIRectCorner {
        var corners: UIRectCorner = []
        if self.contains(.layerMinXMinYCorner) {
            corners.insert(.topLeft)
        }
        if self.contains(.layerMaxXMinYCorner) {
            corners.insert(.topRight)
        }
        if self.contains(.layerMinXMaxYCorner) {
            corners.insert(.bottomLeft)
        }
        if self.contains(.layerMaxXMaxYCorner) {
            corners.insert(.bottomRight)
        }
        return corners
    }
}
