import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIScreenEdgePanGestureRecognizer {
    /// 设置触发边缘
    /// - Parameter edges: 触发边缘
    /// - Returns: `Self`
    @discardableResult
    func edges(_ edges: UIRectEdge) -> Self {
        base.edges = edges
        return self
    }
}
