import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIPinchGestureRecognizer {
    /// 设置当前缩放比例（通常用于重置累计值）
    /// - Parameter factor: 缩放因子（1.0 表示无缩放）
    /// - Returns: `Self`
    @discardableResult
    func scale(_ factor: CGFloat) -> Self {
        base.scale = factor
        return self
    }
}
