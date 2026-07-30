import UIKit

// MARK: - Cell 注册与复用
public extension UITableView {
    /// 使用类名注册`纯代码` `Cell`
    /// - Parameter cellType: `Cell` 类型(需继承 `UITableViewCell`)
    @discardableResult
    func dy_register(withCellClass cellType: (some UITableViewCell).Type) -> Self {
        self.register(cellType, forCellReuseIdentifier: cellType.identifier)
        return self
    }

    /// 使用 `Nib` 注册 `Cell`
    /// - Parameters:
    ///   - nib: Nib 对象(可为 nil)
    ///   - cellType: Cell 类型
    @discardableResult
    func dy_register(nib: UINib?, withCellClass cellType: (some UITableViewCell).Type) -> Self {
        self.register(nib, forCellReuseIdentifier: cellType.identifier)
        return self
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名必须与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认使用 `Cell` 所在 `Bundle`)
    @discardableResult
    func dy_register(nibWithCellClass cellType: (some UITableViewCell).Type, at bundleClass: AnyClass? = nil) -> Self {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.identifier, bundle: bundle)
        self.register(nib, forCellReuseIdentifier: cellType.identifier)
        return self
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
    @discardableResult
    func dy_register(withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type) -> Self {
        self.register(viewType, forHeaderFooterViewReuseIdentifier: viewType.identifier)
        return self
    }

    /// 使用 `Nib` 注册 `Header/Footer View`
    @discardableResult
    func dy_register(
        nib: UINib?,
        withHeaderFooterViewClass viewType: (some UITableViewHeaderFooterView).Type
    ) -> Self {
        self.register(nib, forHeaderFooterViewReuseIdentifier: viewType.identifier)
        return self
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

// MARK: - 链式设置属性
public extension UITableView {
    /// 设置 `delegate`
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UITableViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource`
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dy_dataSource(_ dataSource: UITableViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 链式注册 `Cell`(纯代码)
    /// - Parameter cellType: `UITableViewCell`子类
    /// - Returns: `Self`
    @discardableResult
    func dy_register(_ cellType: (some UITableViewCell).Type) -> Self {
        self.dy_register(withCellClass: cellType)
        return self
    }

    /// 设置行高(若使用自动布局,请设为 `UITableView.automaticDimension`)
    /// - Parameter height: 行高
    /// - Returns: `Self`
    @discardableResult
    func dy_rowHeight(_ height: CGFloat) -> Self {
        self.rowHeight = height
        return self
    }

    /// 设置段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func dy_sectionHeaderHeight(_ height: CGFloat) -> Self {
        self.sectionHeaderHeight = height
        return self
    }

    /// 设置段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func dy_sectionFooterHeight(_ height: CGFloat) -> Self {
        self.sectionFooterHeight = height
        return self
    }

    /// 设置预估行高(提升滚动性能)
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func dy_estimatedRowHeight(_ height: CGFloat) -> Self {
        self.estimatedRowHeight = height
        return self
    }

    /// 设置预估段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func dy_estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置预估段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func dy_estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        self.estimatedSectionFooterHeight = height
        return self
    }

    /// 是否让 `Cell` 的 `layoutMargins` 跟随` readable width`(影响 iOS 8+ 的左右留白)
    /// - Parameter enabled: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func dy_cellLayoutMarginsFollowReadableWidth(_ enabled: Bool) -> Self {
        self.cellLayoutMarginsFollowReadableWidth = enabled
        return self
    }

    /// 设置分割线样式
    /// - Parameter style: 分割线样式
    /// - Returns: `Self`
    @discardableResult
    func dy_separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        self.separatorStyle = style
        return self
    }

    /// 设置表格头部视图(`tableHeaderView`)
    /// - Parameter view: 列表头部视图
    /// - Returns: `Self`
    @discardableResult
    func dy_tableHeaderView(_ view: UIView?) -> Self {
        self.tableHeaderView = view
        return self
    }

    /// 设置表格尾部视图(`tableFooterView`)
    /// - Parameter view: 列表尾部视图
    /// - Returns: `Self`
    @discardableResult
    func dy_tableFooterView(_ view: UIView?) -> Self {
        self.tableFooterView = view
        return self
    }

    /// 移除表格头部视图
    /// - Returns: `Self`
    @discardableResult
    func dy_removeTableHeaderView() -> Self {
        self.tableHeaderView = nil
        return self
    }

    /// 移除表格尾部视图
    /// - Returns: `Self`
    @discardableResult
    func dy_removeTableFooterView() -> Self {
        self.tableFooterView = nil
        return self
    }

    /// 设置段头顶部额外间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_sectionHeaderTopPadding(_ padding: CGFloat) -> Self {
        self.sectionHeaderTopPadding = padding
        return self
    }
}

// MARK: - 链式方法
public extension UITableView {
    /// 滚动到最近选中的行
    /// - Parameters:
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToNearestSelectedRow(at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        self.scrollToNearestSelectedRow(at: position, animated: animated)
        return self
    }

    /// 设置 `contentOffset`
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_contentOffset(_ offset: CGPoint, animated: Bool = false) -> Self {
        self.setContentOffset(offset, animated: animated)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UITableView {
    /// 滚动到顶部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToTop(animated: Bool = false) -> Self {
        self.setContentOffset(.zero, animated: animated)
        return self
    }

    /// 滚动到底部(安全处理 `contentSize` 未更新情况)
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToBottom(animated: Bool = false) -> Self {
        let yOffset = max(0, self.contentSize.height - self.bounds.height)
        self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        return self
    }

    /// 滚动到指定 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 目标`IndexPath`
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollTo(_ indexPath: IndexPath, at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.row >= 0,
            indexPath.section < self.numberOfSections,
            indexPath.row < self.numberOfRows(inSection: indexPath.section)
        else { return self }
        self.scrollToRow(at: indexPath, at: position, animated: animated)
        return self
    }
}
