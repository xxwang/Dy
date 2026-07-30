import UIKit

// MARK: - 链式属性
public extension UIActivityIndicatorView {
    /// 设置是否在暂停的时候隐藏
    /// - Parameter hidesWhenStopped: 是否在暂停的时候隐藏
    /// - Returns: `Self`
    @discardableResult
    func dy_hidesWhenStopped(_ hidesWhenStopped: Bool) -> Self {
        self.hidesWhenStopped = hidesWhenStopped
        return self
    }

    /// 设置指示器样式
    /// - Parameter style: 指示器样式
    /// - Returns: `Self`
    @discardableResult
    func dy_style(_ style: Style) -> Self {
        self.style = style
        return self
    }

    /// 设置指示器颜色
    /// - Parameter color: 指示器颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_color(_ color: UIColor) -> Self {
        self.color = color
        return self
    }
}
