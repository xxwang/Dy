import UIKit

// MARK: - 链式设置属性
public extension UISwipeGestureRecognizer {
    /// 设置滑动手势的方向
    /// - Parameter direction: 滑动方向
    /// - Returns: `Self`
    @discardableResult
    func dy_direction(_ direction: UISwipeGestureRecognizer.Direction) -> Self {
        self.direction = direction
        return self
    }

    /// 设置触发滑动手势所需的同时触摸点数量
    /// - Parameter count: 触摸点数量（如 1 指或 2 指滑动），默认为 1
    /// - Returns: `Self`
    @discardableResult
    func dy_numberOfTouchesRequired(_ count: Int) -> Self {
        self.numberOfTouchesRequired = count
        return self
    }
}
