import Foundation

extension Decimal: DyExtension {}

// MARK: - 数值判断
public extension DyWrapper where Base == Decimal {
    /// 判断当前值是否大于零
    ///
    /// - Returns: 如果值 > 0,返回 `true`;否则返回 `false`
    var isPositive: Bool {
        base > 0
    }

    /// 判断当前值是否小于零
    ///
    /// - Returns: 如果值 < 0,返回 `true`;否则返回 `false`
    var isNegative: Bool {
        base < 0
    }

    /// 判断当前值是否等于零
    ///
    /// - Returns: 如果值 == 0,返回 `true`;否则返回 `false`
    var isZero: Bool {
        base == 0
    }

    /// 检查当前数值是否为整数(即小数部分为零)
    ///
    /// - Returns: 如果值等于其向零取整结果,则返回 `true`
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(5).dy.isInteger        // true
    ///   Decimal("5.00")!.dy.isInteger  // true
    ///   Decimal("5.01")!.dy.isInteger  // false
    ///   ```
    var isInteger: Bool {
        var selfCopy = base
        var rounded = Decimal()
        NSDecimalRound(&rounded, &selfCopy, 0, .plain)
        return base == rounded
    }
}

// MARK: - 安全初始化与转换
public extension DyWrapper where Base == Decimal {
    /// 从可选字符串安全创建 `Decimal`,失败时返回默认值
    ///
    /// - Parameters:
    ///   - string: 可能为 `nil` 或无效格式的字符串
    ///   - defaultValue: 解析失败时返回的默认值(默认为 `0`)
    /// - Returns: 成功解析的 `Decimal`,或 `defaultValue`
    ///
    /// - Example:
    ///   ```swift
    ///   let valid = Decimal.dy.from("123.45")          // 123.45
    ///   let invalid = Decimal.dy.from("abc", default: 0) // 0
    ///   ```
    static func from(_ string: String?, default defaultValue: Decimal = 0) -> Decimal {
        guard let str = string,
              let decimal = Decimal(string: str)
        else {
            return defaultValue
        }
        return decimal
    }

    /// 尝试将当前 `Decimal` 精确转换为 `Int`
    ///
    /// - Returns: 如果值在 `Int` 范围内且无小数部分,返回对应的 `Int`;否则返回 `nil`
    ///
    /// - Note: 此方法保证`无精度损失`
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(42).dy.intValue         // Optional(42)
    ///   Decimal("42.0")!.dy.intValue    // Optional(42)
    ///   Decimal("42.1")!.dy.intValue    // nil
    ///   ```
    var intValue: Int? {
        // 先检查是否为整数
        guard self.isInteger else { return nil }

        // 转为 NSDecimalNumber 再转 Int(注意：可能溢出)
        let nsdn = NSDecimalNumber(decimal: base)
        let intVal = nsdn.intValue

        // 验证是否可逆(防止溢出)
        if NSDecimalNumber(value: intVal).decimalValue == base {
            return Int(intVal)
        }
        return nil
    }
}

// MARK: - 格式化
public extension DyWrapper where Base == Decimal {
    /// 将当前值格式化为本地化货币字符串
    ///
    /// - Parameters:
    ///   - locale: 本地化区域(默认为 `.current`)
    ///   - currencyCode: 可选的 ISO 货币代码(如 `"USD"`、`"CNY"`),若未指定则使用 `locale` 默认货币
    /// - Returns: 格式化后的货币字符串(如 `"$1,234.56"`)
    ///
    /// - Example:
    ///   ```swift
    ///   let amount = Decimal(1234.56)
    ///   print(amount.dy.asCurrency()) // "$1,234.56" (en_US)
    ///   print(amount.dy.asCurrency(currencyCode: "JPY")) // "¥1,235"
    ///   ```
    func asCurrency(locale: Locale = .current, currencyCode: String? = nil) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        if let code = currencyCode {
            formatter.currencyCode = code
        }
        return formatter.string(from: NSDecimalNumber(decimal: base)) ?? "\(base)"
    }

    /// 将当前值截断(非四舍五入)到指定小数位数
    ///
    /// - Parameter scale: 保留的小数位数(≥0)
    /// - Returns: 截断后的 `Decimal`
    ///
    /// - Note: 使用 `.plain` 舍入模式(向零取整)
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal("12.3456")!.dy.truncated(to: 2) // 12.34
    ///   Decimal("-12.999")!.dy.truncated(to: 1) // -12.9
    ///   ```
    func truncated(to scale: Int) -> Decimal {
        precondition(scale >= 0, "scale must be non-negative")
        var result = Decimal()
        var selfCopy = base
        NSDecimalRound(&result, &selfCopy, scale, .plain)
        return result
    }
}

// MARK: - 数学运算
public extension DyWrapper where Base == Decimal {
    /// 计算当前值的整数次幂(仅支持非负指数)
    ///
    /// - Parameter exponent: 幂指数(必须 ≥ 0)
    /// - Returns: `self^exponent`,若 `exponent < 0` 则返回 `nil`
    ///
    /// - Note: 使用快速幂算法,保持高精度
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(2).dy.power(10) // 1024
    ///   Decimal("1.5")!.dy.power(3) // 3.375
    ///   ```
    func power(_ exponent: Int) -> Decimal? {
        guard exponent >= 0 else { return nil }
        if exponent == 0 {
            return 1
        }
        if exponent == 1 {
            return base
        }

        var result = Decimal(1)
        var base = base
        var exp = exponent

        while exp > 0 {
            if exp & 1 == 1 {
                result *= base
            }
            base *= base
            exp >>= 1
        }
        return result
    }

    /// 计算当前值占 `total` 的百分比(结果为 0～100)
    ///
    /// - Parameter total: 总量(分母)
    /// - Returns: 百分比值(如 25 表示 25%),若 `total == 0` 则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(25).dy.percentageRate(of: 200) // 12.5
    ///   ```
    func percentageRate(of total: Decimal) -> Decimal? {
        guard !total.isZero else { return nil }
        return (base / total) * 100
    }

    /// 计算 `percentage`% 对应的数值(例如 15 表示 15%)
    ///
    /// - Parameter percentage: 百分比数值(如 15 表示 15%)
    /// - Returns: `percentage%` of `self`
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(100).dy.percentage(15) // 15.0
    ///   ```
    func percentage(_ percentage: Decimal) -> Decimal {
        return (percentage * base) / 100
    }

    /// 安全除法：除数为零时返回 `nil`
    ///
    /// - Parameter divisor: 除数
    /// - Returns: 商,若 `divisor == 0` 则返回 `nil`
    func divided(by divisor: Decimal) -> Decimal? {
        guard !divisor.isZero else { return nil }
        return base / divisor
    }

    /// 计算余数(模运算),符合数学定义：`dividend = divisor × quotient + remainder`
    ///
    /// - Parameter divisor: 除数(必须非零)
    /// - Returns: 余数(符号与被除数相同),若 `divisor == 0` 则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(10.5).dy.remainder(dividingBy: 3) // 1.5
    ///   Decimal(-10).dy.remainder(dividingBy: 3)  // -1
    ///   Decimal("0.3")!.dy.remainder(dividingBy: Decimal("0.1")!) // 0.0
    ///   ```
    func remainder(dividingBy divisor: Decimal) -> Decimal? {
        guard !divisor.isZero else { return nil }

        let division = base / divisor
        var divisionCopy = division
        var quotient = Decimal()
        NSDecimalRound(&quotient, &divisionCopy, 0, .plain) // 向零取整

        return base - divisor * quotient
    }
}

// MARK: - 边界控制
public extension DyWrapper where Base == Decimal {
    /// 将值限制在指定闭区间内
    ///
    /// - Parameter limits: 有效范围(如 `0...100`)
    /// - Returns: 若值在范围内则返回自身,否则返回最近的边界值
    ///
    /// - Example:
    ///   ```swift
    ///   Decimal(-5).dy.clamped(to: 0...100) // 0
    ///   Decimal(150).dy.clamped(to: 0...100) // 100
    ///   ```
    func clamped(to limits: ClosedRange<Decimal>) -> Decimal {
        if base < limits.lowerBound {
            return limits.lowerBound
        }
        if base > limits.upperBound {
            return limits.upperBound
        }
        return base
    }
}
