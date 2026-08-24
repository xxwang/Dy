import Foundation

// MARK: - 整数判断
public extension NSDecimalNumber {
    /// 检查当前 `NSDecimalNumber` 是否表示一个数学意义上的整数(即小数部分为零)
    /// 支持负数、零、极大/极小值,且不会因浮点转换丢失精度
    ///
    /// - Returns: 如果值是整数(如 5, -3.0, 0),返回 `true`;否则返回 `false`(如 3.14, -2.5)
    ///
    /// - Example:
    ///   ```swift
    ///   NSDecimalNumber(string: "10").solo_isInteger       // true
    ///   NSDecimalNumber(string: "10.0").solo_isInteger     // true
    ///   NSDecimalNumber(string: "10.1").solo_isInteger     // false
    ///   NSDecimalNumber(value: -5).solo_isInteger          // true
    ///   NSDecimalNumber.notANumber.solo_isInteger          // false
    ///   ```
    var solo_isInteger: Bool {
        // 特殊值处理：NaN 或无穷大(虽然 NSDecimalNumber 通常不支持无穷,但防御性处理)
        if self == .notANumber {
            return false
        }

        // 创建一个舍入处理器：保留 0 位小数,向零舍入(.down 对正数是向下,对负数也是向零？其实更安全用 .plain + scale=0 比较)
        // 更可靠的方式：使用 .bankers 或 .plain,但关键是 scale = 0
        let handler = NSDecimalNumberHandler(
            roundingMode: .down, // 或 .plain,实际比较时只要一致即可
            scale: 0,
            raiseOnExactness: false,
            raiseOnOverflow: false,
            raiseOnUnderflow: false,
            raiseOnDivideByZero: false
        )

        // 将当前值舍入到整数(去掉所有小数位)
        let rounded = self.rounding(accordingToBehavior: handler)

        // 比较原值与舍入后的值是否完全相等
        return self.compare(rounded) == .orderedSame
    }

    /// 返回当前数值的绝对值
    var solo_absoluteValue: NSDecimalNumber {
        return self.compare(NSDecimalNumber.zero) == .orderedAscending ? self.multiplying(by: -1) : self
    }

    /// 返回当前数值的相反数(正变负,负变正)
    var solo_negated: NSDecimalNumber {
        return self.multiplying(by: -1)
    }
}
