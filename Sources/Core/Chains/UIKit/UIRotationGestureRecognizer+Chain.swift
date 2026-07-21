import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIRotationGestureRecognizer {
    /// 设置当前旋转角度（通常用于重置累计值）
    /// - Parameter radians: 旋转角度（弧度），顺时针为正
    /// - Returns: `Self`
    @discardableResult
    func rotation(_ radians: CGFloat) -> Self {
        base.rotation = radians
        return self
    }
}
