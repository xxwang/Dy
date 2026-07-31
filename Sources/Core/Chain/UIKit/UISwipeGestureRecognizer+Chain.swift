import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UISwipeGestureRecognizer {
    /// 设置滑动手势的方向
    /// - Parameter direction: 滑动方向
    /// - Returns: `Self`
    @discardableResult
    func direction(_ direction: UISwipeGestureRecognizer.Direction) -> Self {
        base.direction = direction
        return self
    }

    /// 设置触发滑动手势所需的同时触摸点数量
    /// - Parameter count: 触摸点数量（如 1 指或 2 指滑动），默认为 1
    /// - Returns: `Self`
    @discardableResult
    func numberOfTouchesRequired(_ count: Int) -> Self {
        base.numberOfTouchesRequired = count
        return self
    }
}
