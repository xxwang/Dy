import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UITableViewCell {
    /// 设置单元格的选中样式
    ///
    /// - Parameter style: 选中样式(如 `.none`, `.gray`, `.blue` 等)
    /// - Returns: `Self`
    @discardableResult
    func selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        base.selectionStyle = style
        return self
    }
}
