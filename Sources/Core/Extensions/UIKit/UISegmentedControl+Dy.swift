import UIKit

// MARK: - 属性
public extension UISegmentedControl {
    /// 获取或设置所有分段的图片
    var dy_images: [UIImage] {
        get {
            return (0 ..< self.numberOfSegments).compactMap { self.imageForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, image) in newValue.enumerated() {
                self.insertSegment(with: image.withRenderingMode(.alwaysOriginal), at: index, animated: false)
            }
        }
    }

    /// 获取或设置所有分段的标题
    var dy_titles: [String] {
        get {
            return (0 ..< self.numberOfSegments).compactMap { self.titleForSegment(at: $0) }
        }
        set {
            self.removeAllSegments()
            for (index, title) in newValue.enumerated() {
                self.insertSegment(withTitle: title, at: index, animated: false)
            }
        }
    }
}
