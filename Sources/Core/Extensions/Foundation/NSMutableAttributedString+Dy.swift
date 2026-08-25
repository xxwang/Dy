import UIKit

// MARK: - 类型转换
public extension NSMutableAttributedString {
    /// 将当前可变属性字符串以不可变形式返回(恒等转换)
    ///
    /// 此属性主要用于链式调用后传递给仅接受 `NSAttributedString` 的 API(如 `UILabel.attributedText`)
    func dy_nSAttributedString() -> NSAttributedString {
        return self
    }
}
