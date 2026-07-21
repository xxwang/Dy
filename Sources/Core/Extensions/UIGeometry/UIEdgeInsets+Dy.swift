import UIKit

// MARK: - 属性
public extension UIEdgeInsets {
    /// 水平方向的总边距(`left` + `right`)
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     let horizontal = inset.dy_horizontal // 10
    var dy_horizontal: CGFloat {
        left + right
    }

    /// 垂直方向的总边距(`top` + `bottom`)
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     let vertical = inset.dy_vertical // 20
    var dy_vertical: CGFloat {
        top + bottom
    }
}

// MARK: - 构造方法
public extension UIEdgeInsets {
    /// 创建四个方向相等的 `UIEdgeInsets`
    ///
    /// - Parameter inset: 应用于 `top、left、bottom、right`的相同值
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(inset: 10)
    ///     // Result: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    /// 创建一个 `UIEdgeInsets`,其左右边距之和为 `horizontalTotal`,
    /// 上下边距之和为 `verticalTotal`,并平均分配到两侧
    ///
    /// - Parameters:
    ///   - horizontalTotal: 水平方向的`总边距(left + right)`
    ///   - verticalTotal: 垂直方向的`总边距(top + bottom)`
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(horizontalTotal: 20, verticalTotal: 40)
    ///     // Result: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    init(horizontalTotal: CGFloat, verticalTotal: CGFloat) {
        self.init(
            top: verticalTotal / 2,
            left: horizontalTotal / 2,
            bottom: verticalTotal / 2,
            right: horizontalTotal / 2
        )
    }
}

// MARK: - 链式修改：基于当前值生成新值
public extension UIEdgeInsets {
    /// 在当前边距基础上,向顶部增加指定偏移量
    @discardableResult
    func dy_insetBy(top: CGFloat) -> Self {
        UIEdgeInsets(top: self.top + top, left: self.left, bottom: self.bottom, right: self.right)
    }

    /// 在当前边距基础上,向左侧增加指定偏移量
    @discardableResult
    func dy_insetBy(left: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: self.left + left, bottom: self.bottom, right: self.right)
    }

    /// 在当前边距基础上,向底部增加指定偏移量
    @discardableResult
    func dy_insetBy(bottom: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom + bottom, right: self.right)
    }

    /// 在当前边距基础上,向右侧增加指定偏移量
    @discardableResult
    func dy_insetBy(right: CGFloat) -> Self {
        UIEdgeInsets(top: self.top, left: self.left, bottom: self.bottom, right: self.right + right)
    }

    /// 在当前边距基础上,向水平方向`总共`增加指定边距(均分到 left 和 right)
    ///
    /// - Parameter horizontal: 要增加的`水平总边距`(例如 20 → left+10, right+10)
    @discardableResult
    func dy_insetBy(horizontal: CGFloat) -> Self {
        UIEdgeInsets(
            top: self.top,
            left: self.left + horizontal / 2,
            bottom: self.bottom,
            right: self.right + horizontal / 2
        )
    }

    /// 在当前边距基础上,向垂直方向`总共`增加指定边距(均分到 top 和 bottom)
    ///
    /// - Parameter vertical: 要增加的`垂直总边距`(例如 30 → top+15, bottom+15)
    @discardableResult
    func dy_insetBy(vertical: CGFloat) -> Self {
        UIEdgeInsets(
            top: self.top + vertical / 2,
            left: self.left,
            bottom: self.bottom + vertical / 2,
            right: self.right
        )
    }
}

// MARK: - 运算符重载：支持加法与复合赋值
public extension UIEdgeInsets {
    /// 将两个 `UIEdgeInsets` 对应方向相加
    ///
    /// - Example:
    ///
    ///     let a = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     let b = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    ///     let c = a + b
    ///     c == top:12, left:7, bottom:7, right:7
    static func + (lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(
            top: lhs.top + rhs.top,
            left: lhs.left + rhs.left,
            bottom: lhs.bottom + rhs.bottom,
            right: lhs.right + rhs.right
        )
    }

    /// 将右侧的 `UIEdgeInsets` 累加到左侧(就地修改)
    ///
    /// - Example:
    ///
    ///     var a = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     a += UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    ///     a == top:12, left:7, bottom:7, right:7
    static func += (lhs: inout UIEdgeInsets, rhs: UIEdgeInsets) {
        lhs = lhs + rhs
    }
}
