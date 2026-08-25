import Foundation

// MARK: - 高精度四则运算(基于 NSDecimalNumber)
public extension String {
    /// 加法：`self + other`
    func dy_add(_ other: String?) -> String {
        return self.dy_performOperation(other) { $0.adding($1) }
    }

    /// 减法：`self - other`
    func dy_subtract(_ other: String?) -> String {
        return self.dy_performOperation(other) { $0.subtracting($1) }
    }

    /// 乘法：`self * other`
    func dy_multiply(_ other: String?) -> String {
        return self.dy_performOperation(other) { $0.multiplying(by: $1) }
    }

    /// 除法：`self / other`,若 `other` 为 nil、空或 0,则返回 `self`
    func dy_divide(_ other: String?) -> String {
        guard let other, !other.isEmpty else { return self }
        let divisor = NSDecimalNumber(string: other)
        if divisor == .zero {
            return self
        }
        return self.dy_performOperation(other) { $0.dividing(by: $1) }
    }
}

// MARK: 私有辅助工具
public extension String {
    private func dy_performOperation(_ other: String?, _ operation: DyFunc2<NSDecimalNumber, NSDecimalNumber, NSDecimalNumber>) -> String {
        let left = self.dy_nSDecimalNumber()
        let right = (other ?? "").dy_nSDecimalNumber()
        let result = operation(left, right)
        return result.stringValue
    }
}
