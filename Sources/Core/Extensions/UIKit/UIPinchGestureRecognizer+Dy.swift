import UIKit

// MARK: - 链式设置属性
public extension UIPinchGestureRecognizer {
    /// 设置当前缩放比例（通常用于重置累计值）
    /// - Parameter factor: 缩放因子（1.0 表示无缩放）
    /// - Returns: `Self`
    @discardableResult
    func dy_scale(_ factor: CGFloat) -> Self {
        self.scale = factor
        return self
    }
}
