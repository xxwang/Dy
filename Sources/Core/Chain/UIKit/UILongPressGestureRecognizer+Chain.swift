import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: UILongPressGestureRecognizer {
    /// 设置触发长按所需的手指点击次数（轻点后长按）
    /// - Parameter count: 点击次数，默认为 0（即无需点击，直接长按）
    /// - Returns: `Self`
    @discardableResult
    func numberOfTapsRequired(_ count: Int) -> Self {
        base.numberOfTapsRequired = count
        return self
    }

    /// 设置触发长按所需的同时触摸点数量
    /// - Parameter count: 触摸点数量（如 1 指、2 指），默认为 1
    /// - Returns: `Self`
    @discardableResult
    func numberOfTouchesRequired(_ count: Int) -> Self {
        base.numberOfTouchesRequired = count
        return self
    }

    /// 设置触发长按所需的最短按压持续时间
    /// - Parameter duration: 时间间隔（秒），默认为 0.5 秒
    /// - Returns: `Self`
    @discardableResult
    func minimumPressDuration(_ duration: TimeInterval) -> Self {
        base.minimumPressDuration = duration
        return self
    }

    /// 设置允许的手指移动最大距离（超过则取消识别）
    /// - Parameter distance: 允许的移动半径（点），默认为 10.0
    /// - Returns: `Self`
    @discardableResult
    func allowableMovement(_ distance: CGFloat) -> Self {
        base.allowableMovement = distance
        return self
    }
}
