import UIKit

// MARK: - 链式设置属性
public extension UIRotationGestureRecognizer {
    /// 设置当前旋转角度（通常用于重置累计值）
    /// - Parameter radians: 旋转角度（弧度），顺时针为正
    /// - Returns: `Self`
    @discardableResult
    func dy_rotation(_ radians: CGFloat) -> Self {
        self.rotation = radians
        return self
    }
}
