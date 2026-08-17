import UIKit

// MARK: - 常用方法
public extension SoloWrapper where Base: UINavigationItem {
    /// 将 `titleView` 设置为指定图片的 `UIImageView`
    /// - Note: 此操作会覆盖当前的 `titleView`
    ///
    /// - Parameters:
    ///   - image: 要显示的图片
    ///   - size: 图片视图的尺寸
    func titleView(with image: UIImage, size: CGSize = CGSize(width: 100, height: 30)) {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: size))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.clipsToBounds = true
        base.titleView = imageView
    }
}
