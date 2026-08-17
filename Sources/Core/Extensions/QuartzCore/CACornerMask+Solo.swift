import QuartzCore
import UIKit

extension CACornerMask: SoloExtension {}

// MARK: - 属性
public extension SoloWrapper where Base == CACornerMask {
    /// 左上角(等价于 `.layerMinXMinYCorner`)
    static let topLeft: CACornerMask = .layerMinXMinYCorner

    /// 右上角(等价于 `.layerMaxXMinYCorner`)
    static let topRight: CACornerMask = .layerMaxXMinYCorner

    /// 左下角(等价于 `.layerMinXMaxYCorner`)
    static let bottomLeft: CACornerMask = .layerMinXMaxYCorner

    /// 右下角(等价于 `.layerMaxXMaxYCorner`)
    static let bottomRight: CACornerMask = .layerMaxXMaxYCorner

    /// 所有四个角(等价于 `[.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]`)
    static let all: CACornerMask = [
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMaxYCorner,
    ]
}

// MARK: - 方法
public extension SoloWrapper where Base == CACornerMask {
    /// 将 `CACornerMask` 转换为 `UIRectCorner`
    /// - Returns: `UIRectCorner`
    func toUIRectCorner() -> UIRectCorner {
        var corners: UIRectCorner = []
        if base.contains(.layerMinXMinYCorner) {
            corners.insert(.topLeft)
        }
        if base.contains(.layerMaxXMinYCorner) {
            corners.insert(.topRight)
        }
        if base.contains(.layerMinXMaxYCorner) {
            corners.insert(.bottomLeft)
        }
        if base.contains(.layerMaxXMaxYCorner) {
            corners.insert(.bottomRight)
        }
        return corners
    }
}
