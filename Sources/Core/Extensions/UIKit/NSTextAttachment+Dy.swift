import UIKit

// MARK: - 链式设置属性
public extension NSTextAttachment {
    /// 设置附件的图片
    /// - Parameter image: 要显示的图片(可为 `nil`)
    /// - Returns: `Self`
    @discardableResult
    func dy_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置附件的显示边界(位置和尺寸)
    /// 注意：`bounds.origin` 会影响附件在文本行中的垂直/水平偏移
    /// - Parameter bounds: 附件的矩形区域
    /// - Returns: `Self`
    @discardableResult
    func dy_bounds(_ bounds: CGRect) -> Self {
        self.bounds = bounds
        return self
    }
}
