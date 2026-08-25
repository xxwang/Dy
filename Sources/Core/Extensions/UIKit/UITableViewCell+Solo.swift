import UIKit

// MARK: - 属性
public extension UITableViewCell {
    /// 返回当前 cell 所在的 `UITableView`(通过响应链查找)
    var solo_tableView: UITableView? {
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
    var solo_indexPath: IndexPath? {
        guard let tableView = self.solo_tableView else { return nil }
        return tableView.indexPath(for: self)
    }
}
