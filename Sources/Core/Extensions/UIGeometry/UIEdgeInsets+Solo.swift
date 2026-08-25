import UIKit

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

// MARK: - 属性
public extension UIEdgeInsets {
    /// 水平方向的总边距(`left` + `right`)
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     let horizontal = inset.solo_horizontal // 10
    var solo_horizontal: CGFloat {
        self.left + self.right
    }

    /// 垂直方向的总边距(`top` + `bottom`)
    ///
    /// - Example:
    ///
    ///     let inset = UIEdgeInsets(top: 10, left: 5, bottom: 5, right: 5)
    ///     let vertical = inset.solo_vertical // 20
    var solo_vertical: CGFloat {
        self.top + self.bottom
    }
}
