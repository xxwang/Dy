import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UITableView {
    /// 设置 `delegate`
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITableViewDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置 `dataSource`
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UITableViewDataSource) -> Self {
        base.dataSource = dataSource
        return self
    }

    /// 链式注册 `Cell`(纯代码)
    /// - Parameter cellType: `UITableViewCell`子类
    /// - Returns: `Self`
    @discardableResult
    func register(_ cellType: (some UITableViewCell).Type) -> Self {
        base.register(withCellClass: cellType)
        return self
    }

    /// 设置行高(若使用自动布局,请设为 `UITableView.automaticDimension`)
    /// - Parameter height: 行高
    /// - Returns: `Self`
    @discardableResult
    func rowHeight(_ height: CGFloat) -> Self {
        base.rowHeight = height
        return self
    }

    /// 设置段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func sectionHeaderHeight(_ height: CGFloat) -> Self {
        base.sectionHeaderHeight = height
        return self
    }

    /// 设置段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func sectionFooterHeight(_ height: CGFloat) -> Self {
        base.sectionFooterHeight = height
        return self
    }

    /// 设置预估行高(提升滚动性能)
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedRowHeight(_ height: CGFloat) -> Self {
        base.estimatedRowHeight = height
        return self
    }

    /// 设置预估段头高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionHeaderHeight(_ height: CGFloat) -> Self {
        base.estimatedSectionHeaderHeight = height
        return self
    }

    /// 设置预估段尾高度
    /// - Parameter height: 高度
    /// - Returns: `Self`
    @discardableResult
    func estimatedSectionFooterHeight(_ height: CGFloat) -> Self {
        base.estimatedSectionFooterHeight = height
        return self
    }

    /// 设置键盘交互模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        base.keyboardDismissMode = mode
        return self
    }

    /// 是否让 `Cell` 的 `layoutMargins` 跟随` readable width`(影响 iOS 8+ 的左右留白)
    /// - Parameter enabled: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func cellLayoutMarginsFollowReadableWidth(_ enabled: Bool) -> Self {
        base.cellLayoutMarginsFollowReadableWidth = enabled
        return self
    }

    /// 设置分割线样式
    /// - Parameter style: 分割线样式
    /// - Returns: `Self`
    @discardableResult
    func separatorStyle(_ style: UITableViewCell.SeparatorStyle = .none) -> Self {
        base.separatorStyle = style
        return self
    }

    /// 设置表格头部视图(`tableHeaderView`)
    /// - Parameter view: 列表头部视图
    /// - Returns: `Self`
    @discardableResult
    func tableHeaderView(_ view: UIView?) -> Self {
        base.tableHeaderView = view
        return self
    }

    /// 设置表格尾部视图(`tableFooterView`)
    /// - Parameter view: 列表尾部视图
    /// - Returns: `Self`
    @discardableResult
    func tableFooterView(_ view: UIView?) -> Self {
        base.tableFooterView = view
        return self
    }

    /// 移除表格头部视图
    /// - Returns: `Self`
    @discardableResult
    func removeTableHeaderView() -> Self {
        base.tableHeaderView = nil
        return self
    }

    /// 移除表格尾部视图
    /// - Returns: `Self`
    @discardableResult
    func removeTableFooterView() -> Self {
        base.tableFooterView = nil
        return self
    }

    /// 设置内容内边距调整行为
    /// - Parameter behavior: 行为
    /// - Returns: `Self`
    @discardableResult
    func contentInsetAdjustmentBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        base.contentInsetAdjustmentBehavior = behavior
        return self
    }

    /// 设置段头顶部额外间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func sectionHeaderTopPadding(_ padding: CGFloat) -> Self {
        base.sectionHeaderTopPadding = padding
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UITableView {
    /// 滚动到最近选中的行
    /// - Parameters:
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToNearestSelectedRow(at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        base.scrollToNearestSelectedRow(at: position, animated: animated)
        return self
    }

    /// 设置 `contentOffset`
    /// - Parameters:
    ///   - offset: 偏移量
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func contentOffset(_ offset: CGPoint, animated: Bool = false) -> Self {
        base.setContentOffset(offset, animated: animated)
        return self
    }
}

// MARK: - 方法(自定义)
@MainActor
public extension DyWrapper where Base: UITableView {
    /// 滚动到顶部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToTop(animated: Bool = false) -> Self {
        base.setContentOffset(.zero, animated: animated)
        return self
    }

    /// 滚动到底部(安全处理 `contentSize` 未更新情况)
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToBottom(animated: Bool = false) -> Self {
        let yOffset = max(0, base.contentSize.height - base.bounds.height)
        base.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        return self
    }

    /// 滚动到指定 `IndexPath`
    /// - Parameters:
    ///   - indexPath: 目标`IndexPath`
    ///   - position: 位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollTo(_ indexPath: IndexPath, at position: UITableView.ScrollPosition = .middle, animated: Bool = true) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.row >= 0,
            indexPath.section < base.numberOfSections,
            indexPath.row < base.numberOfRows(inSection: indexPath.section)
        else { return self }
        base.scrollToRow(at: indexPath, at: position, animated: animated)
        return self
    }
}
