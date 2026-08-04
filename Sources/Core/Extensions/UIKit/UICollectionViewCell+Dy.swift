import UIKit

// MARK: - 常用方法
public extension DyWrapper where Base: UICollectionViewCell {
    /// 获取当前`Cell`所属的 `UICollectionView`(通过向上遍历`superview`)
    var collectionView: UICollectionView? {
        for view in sequence(first: base.superview, next: { $0?.superview }) {
            if let collectionView = view as? UICollectionView {
                return collectionView
            }
        }
        return nil
    }

    /// 获取当前`Cell` 在 `UICollectionView` 中的 `IndexPath`
    var indexPath: IndexPath? {
        self.collectionView?.indexPath(for: base)
    }
}
