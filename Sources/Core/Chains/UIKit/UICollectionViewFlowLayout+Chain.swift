import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UICollectionViewFlowLayout {
    /// 设置`滚动方向上`相邻行(或列)之间的最小间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func minimumLineSpacing(_ spacing: CGFloat) -> Self {
        base.minimumLineSpacing = spacing
        return self
    }

    /// 设置同一`行`(或`列`)内相邻 `item` 之间的最小间距
    /// - Parameter spacing: 间距
    /// - Returns: `Self`
    @discardableResult
    func minimumInteritemSpacing(_ spacing: CGFloat) -> Self {
        base.minimumInteritemSpacing = spacing
        return self
    }

    /// 设置每个 `item` 的固定大小
    /// - Parameter size: `item` 尺寸若需自动计算高度,请使用 `.automaticSize` 并配合 `estimatedItemSize`
    /// - Returns: `Self`
    @discardableResult
    func itemSize(_ size: CGSize) -> Self {
        base.itemSize = size
        return self
    }

    /// 设置 `item` 的预估尺寸(用于自动尺寸计算)
    /// - Note：仅当 `itemSize` 为 `.automaticSize` 时生效
    /// - Parameter size: 预估尺寸
    /// - Returns: `Self`
    @discardableResult
    func estimatedItemSize(_ size: CGSize) -> Self {
        base.estimatedItemSize = size
        return self
    }

    /// 设置滚动方向
    /// - Parameter scrollDirection: 滚动方向(`.vertical` 或 `.horizontal`)
    /// - Returns: `Self`
    @discardableResult
    func scrollDirection(_ scrollDirection: UICollectionView.ScrollDirection) -> Self {
        base.scrollDirection = scrollDirection
        return self
    }

    /// 设置 `section header` 的参考尺寸
    /// - Parameter size: `header` 尺寸(设为 `.zero` 可隐藏)
    /// - Returns: `Self`
    @discardableResult
    func headerReferenceSize(_ size: CGSize) -> Self {
        base.headerReferenceSize = size
        return self
    }

    /// 设置 `section footer `的参考尺寸
    /// - Parameter size: `footer` 尺寸(设为 `.zero` 可隐藏)
    /// - Returns: `Self`
    @discardableResult
    func footerReferenceSize(_ size: CGSize) -> Self {
        base.footerReferenceSize = size
        return self
    }

    /// 设置 `section` 的内边距
    /// - Parameter sectionInset: 内边距(`top`, `left`, `bottom`, `right`)
    /// - Returns: `Self`
    @discardableResult
    func sectionInset(_ sectionInset: UIEdgeInsets) -> Self {
        base.sectionInset = sectionInset
        return self
    }

    /// 设置 `sectionInset` 的参考系
    /// - Parameter reference: 参考系(如 `.fromSafeArea`, `.fromContentInsets` 等)
    /// - Returns: `Self`
    @discardableResult
    func sectionInsetReference(_ reference: UICollectionViewFlowLayout.SectionInsetReference) -> Self {
        base.sectionInsetReference = reference
        return self
    }

    /// 设置 `section header`是否在滚动时悬停于可见区域顶部
    /// - Parameter pinned: 是否悬停(默认 `false`)
    /// - Returns: `Self`
    @discardableResult
    func sectionHeadersPinToVisibleBounds(_ pinned: Bool) -> Self {
        base.sectionHeadersPinToVisibleBounds = pinned
        return self
    }

    /// 设置 `section footer `是否在滚动时悬停于可见区域底部
    /// - Parameter pinned: 是否悬停(默认 `false`)
    /// - Returns: `Self`
    @discardableResult
    func sectionFootersPinToVisibleBounds(_ pinned: Bool) -> Self {
        base.sectionFootersPinToVisibleBounds = pinned
        return self
    }
}
