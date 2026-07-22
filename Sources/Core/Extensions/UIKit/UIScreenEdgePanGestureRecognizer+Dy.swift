import UIKit

// MARK: - 链式设置属性
public extension UIScreenEdgePanGestureRecognizer {
    /// 设置触发边缘
    /// - Parameter edges: 触发边缘
    /// - Returns: `Self`
    @discardableResult
    func dy_edges(_ edges: UIRectEdge) -> Self {
        self.edges = edges
        return self
    }
}
