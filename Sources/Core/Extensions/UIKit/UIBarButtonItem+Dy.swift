import UIKit

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建一个具有固定宽度的空白占位按钮
    ///
    /// - Note:
    ///     虽然名称含 "`flexible`",但此实现为`固定宽度`,与系统 `.flexibleSpace` 不同
    ///     若需真正的弹性空间,请直接使用 `.init(barButtonSystemItem: .flexibleSpace, ...)`
    /// - Parameter width: 指定的固定宽度(单位：点)
    convenience init(fixedSpace width: CGFloat) {
        self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.width = width
    }
}
