import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UISegmentedControl {
    /// 获取或设置所有分段的图片
    var images: [UIImage] {
        get {
            return (0 ..< base.numberOfSegments).compactMap { base.imageForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                base.insertSegment(with: image.withRenderingMode(.alwaysOriginal), at: index, animated: false)
            }
        }
    }

    /// 获取或设置所有分段的标题
    var titles: [String] {
        get {
            return (0 ..< base.numberOfSegments).compactMap { base.titleForSegment(at: $0) }
        }
        set {
            base.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                base.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}
