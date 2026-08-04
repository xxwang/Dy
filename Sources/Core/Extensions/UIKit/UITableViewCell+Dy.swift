import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UITableViewCell {
    /// 返回当前 cell 所在的 `UITableView`(通过响应链查找)
    var tableView: UITableView? {
        var responder: UIResponder? = base
        while responder != nil {
            if let tableView = responder as? UITableView {
                return tableView
            }
            responder = responder?.next
        }
        return nil
    }

    /// 返回当前 cell 在 tableView 中的 `IndexPath`(若存在)
    var indexPath: IndexPath? {
        guard let tableView = self.tableView else { return nil }
        return tableView.indexPath(for: base)
    }
}
