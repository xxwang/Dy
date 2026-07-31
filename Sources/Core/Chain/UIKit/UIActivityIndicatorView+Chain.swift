import UIKit

// MARK: - 链式属性
public extension DyWrapper where Base: UIActivityIndicatorView {
    /// 设置是否在暂停的时候隐藏
    /// - Parameter hidesWhenStopped: 是否在暂停的时候隐藏
    /// - Returns: `Self`
    @discardableResult
    func hidesWhenStopped(_ hidesWhenStopped: Bool) -> Self {
        base.hidesWhenStopped = hidesWhenStopped
        return self
    }

    /// 设置指示器样式
    /// - Parameter style: 指示器样式
    /// - Returns: `Self`
    @discardableResult
    func style(_ style: UIActivityIndicatorView.Style) -> Self {
        base.style = style
        return self
    }

    /// 设置指示器颜色
    /// - Parameter color: 指示器颜色
    /// - Returns: `Self`
    @discardableResult
    func color(_ color: UIColor) -> Self {
        base.color = color
        return self
    }
}
