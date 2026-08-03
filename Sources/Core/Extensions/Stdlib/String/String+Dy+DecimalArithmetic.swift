import Foundation

// MARK: - 高精度四则运算(基于 NSDecimalNumber)
public extension DyWrapper where Base == String {
    /// 加法：`self + other`
    func add(_ other: String?) -> String {
        return self.performOperation(other) { $0.adding($1) }
    }

    /// 减法：`self - other`
    func subtract(_ other: String?) -> String {
        return self.performOperation(other) { $0.subtracting($1) }
    }

    /// 乘法：`self * other`
    func multiply(_ other: String?) -> String {
        return self.performOperation(other) { $0.multiplying(by: $1) }
    }

    /// 除法：`self / other`,若 `other` 为 nil、空或 0,则返回 `self`
    func divide(_ other: String?) -> String {
        guard let other, !other.isEmpty else { return base }
        let divisor = NSDecimalNumber(string: other)
        if divisor == .zero {
            return base
        }
        return self.performOperation(other) { $0.dividing(by: $1) }
    }
}

// MARK: 私有辅助工具
public extension DyWrapper where Base == String {
    private func performOperation(_ other: String?, _ operation: DyFunc2<NSDecimalNumber, NSDecimalNumber, NSDecimalNumber>) -> String {
        let left = self.toNSDecimalNumber()
        let right = (other ?? "").dy.toNSDecimalNumber()
        let result = operation(left, right)
        return result.stringValue
    }
}
