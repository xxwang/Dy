import UIKit

// MARK: - Cell 注册与复用
public extension UITableView {
    /// 使用类名注册`纯代码` `Cell`
    /// - Parameter cellType: `Cell` 类型(需继承 `UITableViewCell`)
    func dy_register(withCellClass cellType: (some UITableViewCell).Type) {
        register(cellType, forCellReuseIdentifier: cellType.identifier)
    }

    /// 使用 `Nib` 注册 `Cell`
    /// - Parameters:
    ///   - nib: Nib 对象(可为 nil)
    ///   - cellType: Cell 类型
    func dy_register(nib: UINib?, withCellClass cellType: (some UITableViewCell).Type) {
        register(nib, forCellReuseIdentifier: cellType.identifier)
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名必须与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认使用 `Cell` 所在 `Bundle`)
    func dy_register(nibWithCellClass cellType: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.identifier, bundle: bundle)
        register(nib, forCellReuseIdentifier: cellType.identifier)
    }

    /// 复用无 `indexPath` 的 `Cell`(适用于非标准场景,如动态高度估算)
    /// - Parameter cellType: 期望的 `Cell` 类型
    /// - Returns: 类型安全的 Cell 实例
    /// - Throws: 若未注册或类型不匹配,程序将 `crash`(开发期快速暴露问题)
    func dy_dequeueReusableCell<T: UITableViewCell>(withCellClass cellType: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier) as? T else {
            fatalError("未能复用 Cell: \(cellType). 请确认已通过 register 注册！")
        }
        return cell
    }

    /// 安全地复用带 `indexPath` 的 `Cell`(推荐用于` tableView(_:cellForRowAt:)`)
    /// - Parameters:
    ///   - cellType: 期望的 `Cell` 类型
    ///   - indexPath: 位置索引
    /// - Returns: 类型安全的 `Cell`
    func dy_dequeueReusableCell<T: UITableViewCell>(
        withCellClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath) as? T else {
            fatalError("未能复用 Cell: \(cellType). 请确认已注册！")
        }
        return cell
    }
}

// MARK: - Header/Footer 注册与复用
public extension UITableView {
    /// 使用类名注册 `Header/Footer View`(纯代码)
    func dy_register(withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    /// 使用 `Nib` 注册 `Header/Footer View`
    func dy_register(
        nib: UINib?,
        withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type
    ) {
        register(nib, forHeaderFooterViewReuseIdentifier: viewType.identifier)
    }

    /// 复用 `Header/Footer View`
    func dy_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(
        withHeaderFooterViewClass viewType: T.Type
    ) -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: viewType.identifier) as? T else {
            fatalError("未能复用 Header/Footer: \(viewType). 请确认已注册！")
        }
        return view
    }
}
