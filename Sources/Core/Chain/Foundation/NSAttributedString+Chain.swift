import Foundation

// MARK: - 方法
public extension DyWrapper where Base: NSAttributedString {
    /// 将当前不可变属性字符串转换为可变属性字符串
    func toMutable() -> DyWrapper<NSMutableAttributedString> {
        let matt = NSMutableAttributedString(attributedString: base)
        return DyWrapper<NSMutableAttributedString>(matt)
    }
}
