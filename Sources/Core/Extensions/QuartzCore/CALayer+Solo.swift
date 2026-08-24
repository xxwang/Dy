import QuartzCore
import UIKit

// MARK: - 方法
public extension CALayer {
    /// 将图层内容转为颜色 (`UIColor`)
    /// - Returns: 返回转换的颜色,如果失败则返回`nil`
    func solo_uIColor() -> UIColor? {
        if let image = self.solo_uIImage() {
            return UIColor(patternImage: image)
        }
        return nil
    }

    /// 将`CALayer`转换为`UIImage?`
    /// - Parameters:
    ///   - scale: 缩放比例,默认值为当前屏幕的scale,通常与设备的屏幕密度相匹配
    /// - Returns: 返回转换后的`UIImage`,如果失败则返回`nil`
    func solo_uIImage(scale: CGFloat = SoloScreen.screenScale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: ctx)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
