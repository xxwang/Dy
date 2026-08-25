import UIKit

// MARK: - Cell 注册与复用
public extension UITableView {
    /// 复用无 `indexPath` 的 `Cell`(适用于非标准场景,如动态高度估算)
    /// - Parameter cellType: 期望的 `Cell` 类型
    /// - Returns: 类型安全的 Cell 实例
    /// - Throws: 若未注册或类型不匹配,程序将 `crash`(开发期快速暴露问题)
    func solo_dequeueReusableCell<T: UITableViewCell>(withCellClass cellType: T.Type) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.solo_identifier) as? T else {
            assertionFailure("未能复用 Cell: \(cellType). 请确认已通过 register 注册！")
            return T()
        }
        return cell
    }

    /// 安全地复用带 `indexPath` 的 `Cell`(推荐用于` tableView(_:cellForRowAt:)`)
    /// - Parameters:
    ///   - cellType: 期望的 `Cell` 类型
    ///   - indexPath: 位置索引
    /// - Returns: 类型安全的 `Cell`
    func solo_dequeueReusableCell<T: UITableViewCell>(
        withCellClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(withIdentifier: cellType.solo_identifier, for: indexPath) as? T else {
            assertionFailure("未能复用 Cell: \(cellType). 请确认已注册！")
            return T()
        }
        return cell
    }

    /// 复用 `Header/Footer View`
    func solo_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withHeaderFooterViewClass viewType: T.Type
    ) -> T {
        guard let view = self.dequeueReusableHeaderFooterView(withIdentifier: viewType.solo_identifier) as? T else {
            assertionFailure("未能复用 Header/Footer: \(viewType). 请确认已注册！")
            return T()
        }
        return view
    }
}
