import UIKit

// MARK: - 链式修改：基于当前值生成新值
public extension SoloWrapper where Base == UIEdgeInsets {
    /// 在当前边距基础上,向顶部增加指定偏移量
    @discardableResult
    func insetBy(top: CGFloat) -> Self {
        base = UIEdgeInsets(top: base.top + top, left: base.left, bottom: base.bottom, right: base.right)
        return self
    }

    /// 在当前边距基础上,向左侧增加指定偏移量
    @discardableResult
    func insetBy(left: CGFloat) -> Self {
        base = UIEdgeInsets(top: base.top, left: base.left + left, bottom: base.bottom, right: base.right)
        return self
    }

    /// 在当前边距基础上,向底部增加指定偏移量
    @discardableResult
    func insetBy(bottom: CGFloat) -> Self {
        base = UIEdgeInsets(top: base.top, left: base.left, bottom: base.bottom + bottom, right: base.right)
        return self
    }

    /// 在当前边距基础上,向右侧增加指定偏移量
    @discardableResult
    func insetBy(right: CGFloat) -> Self {
        base = UIEdgeInsets(top: base.top, left: base.left, bottom: base.bottom, right: base.right + right)
        return self
    }

    /// 在当前边距基础上,向水平方向`总共`增加指定边距(均分到 left 和 right)
    ///
    /// - Parameter horizontal: 要增加的`水平总边距`(例如 20 → left+10, right+10)
    @discardableResult
    func insetBy(horizontal: CGFloat) -> Self {
        base = UIEdgeInsets(
            top: base.top,
            left: base.left + horizontal / 2,
            bottom: base.bottom,
            right: base.right + horizontal / 2
        )
        return self
    }

    /// 在当前边距基础上,向垂直方向`总共`增加指定边距(均分到 top 和 bottom)
    ///
    /// - Parameter vertical: 要增加的`垂直总边距`(例如 30 → top+15, bottom+15)
    @discardableResult
    func insetBy(vertical: CGFloat) -> Self {
        base = UIEdgeInsets(
            top: base.top + vertical / 2,
            left: base.left,
            bottom: base.bottom + vertical / 2,
            right: base.right
        )
        return self
    }
}
