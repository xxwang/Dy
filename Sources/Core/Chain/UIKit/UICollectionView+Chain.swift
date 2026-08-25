import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: UICollectionView {
    /// 设置 `delegate`
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UICollectionViewDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置 `dataSource`
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        base.dataSource = dataSource
        return self
    }
}

// MARK: - 方法
public extension SoloWrapper where Base: UICollectionView {
    /// 注册 `Cell` 类(纯代码方式),支持链式调用
    /// - Parameter cell: `UICollectionViewCell` 的子类类型
    /// - Returns: `Self`
    @discardableResult
    func register(_ cell: (some UICollectionViewCell).Type) -> Self {
        base.register(cell, forCellWithReuseIdentifier: cell.solo_identifier)
        return self
    }

    /// 使用 `Nib` 注册 `UICollectionViewCell`
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - cellType: `Cell` 类型
    @discardableResult
    func register(nib: UINib?, forCellWithClass cellType: (some UICollectionViewCell).Type) -> Self {
        base.register(nib, forCellWithReuseIdentifier: cellType.solo_identifier)
        return self
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名需与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认为当前类)
    @discardableResult
    func register(nibWithCellClass cellType: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) -> Self {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.solo_identifier, bundle: bundle)
        base.register(nib, forCellWithReuseIdentifier: cellType.solo_identifier)
        return self
    }

    /// 使用类名注册补充视图(如 `Header`)
    /// - Parameters:
    ///   - kind: 视图种类(如 `UICollectionView.elementKindSectionHeader`)
    ///   - viewType: 视图类型
    @discardableResult
    func register(supplementaryViewOfKind kind: String, withClass viewType: (some UICollectionReusableView).Type) -> Self {
        base.register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.solo_identifier)
        return self
    }

    /// 使用 `Nib` 注册补充视图
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - kind: 视图种类
    ///   - viewType: 视图类型
    func register(
        nib: UINib?,
        forSupplementaryViewOfKind kind: String,
        withClass viewType: (some UICollectionReusableView).Type
    ) -> Self {
        base.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.solo_identifier)
        return self
    }

    /// 设置 `CollectionView` 布局,支持动画和完成回调
    /// - Parameters:
    ///   - layout: 布局对象
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func collectionViewLayout(
        _ layout: UICollectionViewLayout,
        animated: Bool = true,
        completion: SoloAction1<Bool>? = nil
    ) -> Self {
        base.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 滚动使指定区域可见
    /// - Parameters:
    ///   - rect: 可视区域
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        base.scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 设置 `contentOffset`
    /// - Parameters:
    ///   - offset: 目标偏移量,默认为 .zero
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func contentOffset(_ offset: CGPoint = .zero, animated: Bool = true) -> Self {
        base.setContentOffset(offset, animated: animated)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension SoloWrapper where Base: UICollectionView {
    /// 滚动到指定 `Item`
    /// - Parameters:
    ///   - indexPath: `Item`索引
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToItem(
        _ indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition = .top,
        animated: Bool = true
    ) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.item >= 0,
            indexPath.section < base.numberOfSections,
            indexPath.item < base.numberOfItems(inSection: indexPath.section)
        else {
            return self
        }
        base.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToTop(animated: Bool = true) -> Self {
        base.setContentOffset(.zero, animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToBottom(animated: Bool = true) -> Self {
        let yOffset = max(0, base.contentSize.height - base.bounds.height)
        base.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        return self
    }
}
