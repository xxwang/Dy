import UIKit

// MARK: - 属性
public extension UITableViewCell {
    /// 返回当前 cell 所在的 `UITableView`(通过响应链查找)
    var dy_tableView: UITableView? {
        var responder: UIResponder? = self
        while responder != nil {
            if let tableView = responder as? UITableView {
                return tableView
            }
            responder = responder?.next
        }
        return nil
    }

    /// 返回当前 cell 在 tableView 中的 `IndexPath`(若存在)
    var dy_indexPath: IndexPath? {
        guard let tableView = self.dy_tableView else { return nil }
        return tableView.indexPath(for: self)
    }
}

// MARK: - 链式设置属性
public extension UITableViewCell {
    /// 设置单元格的选中样式
    ///
    /// - Parameter style: 选中样式(如 `.none`, `.gray`, `.blue` 等)
    /// - Returns: `Self`
    @discardableResult
    func dy_selectionStyle(_ style: UITableViewCell.SelectionStyle) -> Self {
        self.selectionStyle = style
        return self
    }
}
