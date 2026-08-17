import QuartzCore
import UIKit

// MARK: - 方法
public extension SoloWrapper where Base: CALayer {
    /// 将图层内容转为颜色 (`UIColor`)
    /// - Returns: 返回转换的颜色,如果失败则返回`nil`
    func toUIColor() -> UIColor? {
        if let image = self.toUIImage() {
            return UIColor(patternImage: image)
        }
        return nil
    }

    /// 将`CALayer`转换为`UIImage?`
    /// - Parameters:
    ///   - scale: 缩放比例,默认值为当前屏幕的scale,通常与设备的屏幕密度相匹配
    /// - Returns: 返回转换后的`UIImage`,如果失败则返回`nil`
    func toUIImage(scale: CGFloat = SoloScreen.screenScale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(base.bounds.size, base.isOpaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        base.render(in: ctx)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
