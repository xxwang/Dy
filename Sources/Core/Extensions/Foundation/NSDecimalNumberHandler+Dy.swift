import Foundation

// MARK: - 运算符枚举
public enum DyDecimalNumberHandlerOperator {
    case add // < 加法(`a + b`)
    case subtract // < 减法(`a - b`)
    case multiply // < 乘法(`a × b`)
    case divide // < 除法(`a ÷ b`)

    /// 对两个 `NSDecimalNumber` 执行指定的算术运算
    ///
    /// - Parameters:
    ///   - numberA: 被操作数(左操作数)
    ///   - numberB: 操作数(右操作数)
    ///   - behavior: 控制运算行为的策略对象(如舍入方式、是否抛出异常等)
    /// - Returns: 运算结果
    ///
    /// - Example:
    ///   ```swift
    ///   let handler = NSDecimalNumberHandler.default
    ///   let result = DecimalNumberHandlerOperator.multiply.calculate(
    ///       numberA: NSDecimalNumber(5),
    ///       numberB: NSDecimalNumber(3),
    ///       behavior: handler
    ///   )
    ///   print(result) // 输出: 15
    ///   ```
    func dy_calculate(
        numberA: NSDecimalNumber,
        numberB: NSDecimalNumber,
        behavior: NSDecimalNumberBehaviors
    ) -> NSDecimalNumber {
        switch self {
        case .add: return numberA.adding(numberB, withBehavior: behavior)
        case .subtract: return numberA.subtracting(numberB, withBehavior: behavior)
        case .multiply: return numberA.multiplying(by: numberB, withBehavior: behavior)
        case .divide: return numberA.dividing(by: numberB, withBehavior: behavior)
        }
    }
}

// MARK: - 计算

/// 为 `NSDecimalNumberHandler` 提供一系列高精度、类型安全的数值计算工具方法
///
/// 所有公共方法均使用泛型约束 `LosslessStringConvertible`,确保输入类型(如 `Int`, `Double`, `String` 等)
/// 能无损转换为字符串并正确解析为 `NSDecimalNumber`,避免因非法输入导致静默错误
public extension NSDecimalNumberHandler {
    /// 执行基本数值计算
    ///
    /// 支持任意符合 `LosslessStringConvertible` 协议的类型作为输入(如 `Int`, `Float`, `Double`, `String`, `NSDecimalNumber`)
    /// 自动创建 `NSDecimalNumberHandler` 实例以控制舍入、精度和异常行为
    ///
    /// - Parameters:
    ///   - operator: 要执行的运算类型(加、减、乘、除)
    ///   - valueA: 第一个操作数
    ///   - valueB: 第二个操作数
    ///   - roundingMode: 舍入模式,默认为 `.plain`(不进行舍入)
    ///   - scale: 保留的小数位数,默认为 `2`
    ///   - exact: 若为 `true`,当运算无法精确表示时抛出异常
    ///   - overflow: 若为 `true`,发生溢出时抛出异常
    ///   - underflow: 若为 `true`,发生下溢时抛出异常
    ///   - divideByZero: 若为 `true`,除零时抛出异常
    /// - Returns: 计算结果(`NSDecimalNumber` 类型)
    ///
    /// - Example:
    ///   ```swift
    ///   let result = NSDecimalNumberHandler.dy_calculate(
    ///       operator: .add,
    ///       valueA: 10.5,
    ///       valueB: "2.3",
    ///       roundingMode: .bankers,
    ///       scale: 2
    ///   )
    ///   print(result) // 输出: 12.80
    ///   ```
    static func dy_calculate(
        operator: DyDecimalNumberHandlerOperator,
        valueA: some LosslessStringConvertible,
        valueB: some LosslessStringConvertible,
        roundingMode: NSDecimalNumber.RoundingMode = .plain,
        scale: Int16 = 2,
        exact: Bool = false,
        overflow: Bool = false,
        underflow: Bool = false,
        divideByZero: Bool = false
    ) -> NSDecimalNumber {
        let numberA = NSDecimalNumber(string: String(valueA))
        let numberB = NSDecimalNumber(string: String(valueB))
        let handler = NSDecimalNumberHandler(
            roundingMode: roundingMode,
            scale: scale,
            raiseOnExactness: exact,
            raiseOnOverflow: overflow,
            raiseOnUnderflow: underflow,
            raiseOnDivideByZero: divideByZero
        )
        return `operator`.dy_calculate(numberA: numberA, numberB: numberB, behavior: handler)
    }
}

// MARK: - 实用工具方法
public extension NSDecimalNumberHandler {
    /// 判断两个数是否可以整除(即 `valueA ÷ valueB` 的结果为整数)
    ///
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 若能整除返回 `true`,否则 `false`;若除数为零,返回 `false`
    ///
    /// - Example:
    ///   ```swift
    ///   let divisible = NSDecimalNumberHandler.dy_isDivisible(valueA: 10, valueB: 2)
    ///   print(divisible) // true
    ///   ```
    static func dy_isDivisible(
        valueA: some LosslessStringConvertible,
        valueB: some LosslessStringConvertible
    ) -> Bool {
        let divisor = NSDecimalNumber(string: String(valueB))
        if divisor == .zero {
            return false
        }
        let result = dy_calculate(operator: .divide, valueA: valueA, valueB: valueB, roundingMode: .down, scale: 10)
        return result.dy_isInteger
    }

    /// 执行向下取整的整数除法(即“地板除”)
    ///
    /// - Parameters:
    ///   - valueA: 被除数
    ///   - valueB: 除数
    /// - Returns: 整除结果(向下取整后的整数);若除数为零,返回 `0`
    ///
    /// - Example:
    ///   ```swift
    ///   let quotient = NSDecimalNumberHandler.dy_intFloor(valueA: 10, valueB: 3)
    ///   print(quotient) // 3
    ///   ```
    static func dy_intFloor(
        valueA: some LosslessStringConvertible,
        valueB: some LosslessStringConvertible
    ) -> Int {
        let divisor = NSDecimalNumber(string: String(valueB))
        guard divisor != .zero else { return 0 }
        let result = dy_calculate(operator: .divide, valueA: valueA, valueB: valueB, roundingMode: .down, scale: 0)
        return result.intValue
    }

    /// 计算某个数值的百分比
    ///
    /// - Parameters:
    ///   - value: 基础值
    ///   - percentage: 百分比数值(例如传入 `10` 表示 10%)
    /// - Returns: `value × percentage ÷ 100`
    ///
    /// - Example:
    ///   ```swift
    ///   let tax = NSDecimalNumberHandler.dy_calculatePercentage(value: 200, percentage: 15)
    ///   print(tax) // 30
    ///   ```
    static func dy_calculatePercentage(
        value: some LosslessStringConvertible,
        percentage: some LosslessStringConvertible
    ) -> NSDecimalNumber {
        let product = dy_calculate(operator: .multiply, valueA: value, valueB: percentage)
        return product.dividing(by: NSDecimalNumber(100))
    }

    /// 将数值向下取整到最接近的指定倍数
    ///
    /// - Parameters:
    ///   - value: 需要取整的数值
    ///   - multiple: 取整的基准倍数(必须非零)
    /// - Returns: 向下取整后的结果;若 `multiple` 为零,返回原值
    ///
    /// - Example:
    ///   ```swift
    ///   let price = NSDecimalNumberHandler.dy_floorToNearest(value: 7.5, multiple: 2)
    ///   print(price) // 6
    ///   ```
    static func dy_floorToNearest(
        value: some LosslessStringConvertible,
        multiple: some LosslessStringConvertible
    ) -> NSDecimalNumber {
        let number = NSDecimalNumber(string: String(value))
        let factor = NSDecimalNumber(string: String(multiple))
        guard factor != .zero else { return number }
        let handler = NSDecimalNumberHandler(roundingMode: .down, scale: 0, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        return number.dividing(by: factor, withBehavior: handler).multiplying(by: factor)
    }

    /// 将数值限制在指定的上下界范围内(钳位函数)
    ///
    /// - Parameters:
    ///   - value: 待限制的数值
    ///   - lowerBound: 最小允许值
    ///   - upperBound: 最大允许值
    /// - Returns: 若 `value < lowerBound` 返回 `lowerBound`;
    ///           若 `value > upperBound` 返回 `upperBound`;
    ///           否则返回 `value`
    ///
    /// - Example:
    ///   ```swift
    ///   let clamped = NSDecimalNumberHandler.dy_clamp(value: 25, lowerBound: 10, upperBound: 20)
    ///   print(clamped) // 20
    ///   ```
    static func dy_clamp(
        value: some LosslessStringConvertible,
        lowerBound: some LosslessStringConvertible,
        upperBound: some LosslessStringConvertible
    ) -> NSDecimalNumber {
        let number = NSDecimalNumber(string: String(value))
        let minVal = NSDecimalNumber(string: String(lowerBound))
        let maxVal = NSDecimalNumber(string: String(upperBound))
        if number.compare(minVal) == .orderedAscending {
            return minVal
        }
        if number.compare(maxVal) == .orderedDescending {
            return maxVal
        }
        return number
    }

    /// 获取数值的绝对值(正数形式)
    ///
    /// - Parameter value: 输入数值
    /// - Returns: 其绝对值
    ///
    /// - Example:
    ///   ```swift
    ///   let pos = NSDecimalNumberHandler.dy_positive(-42)
    ///   print(pos) // 42
    ///   ```
    static func dy_positive(_ value: some LosslessStringConvertible) -> NSDecimalNumber {
        let number = NSDecimalNumber(string: String(value))
        return number.dy_absoluteValue
    }

    /// 获取数值的相反数(符号取反)
    ///
    /// - Parameter value: 输入数值
    /// - Returns: 其相反数(正变负,负变正)
    ///
    /// - Example:
    ///   ```swift
    ///   let neg = NSDecimalNumberHandler.dy_negative(5)
    ///   print(neg) // -5
    ///   ```
    static func dy_negative(_ value: some LosslessStringConvertible) -> NSDecimalNumber {
        let number = NSDecimalNumber(string: String(value))
        return number.dy_negated
    }

    /// 计算数值数组的总和
    ///
    /// - Parameter values: 数值数组
    /// - Returns: 所有元素的累加和
    ///
    /// - Example:
    ///   ```swift
    ///   let total = NSDecimalNumberHandler.dy_sum(of: [1, 2.5, "3"])
    ///   print(total) // 6.5
    ///   ```
    static func dy_sum(of values: [some LosslessStringConvertible]) -> NSDecimalNumber {
        return values.reduce(.zero) { acc, val in
            acc.adding(NSDecimalNumber(string: String(val)))
        }
    }

    /// 计算数值数组的累积乘积
    ///
    /// - Parameter values: 数值数组
    /// - Returns: 所有元素的累乘积
    ///
    /// - Example:
    ///   ```swift
    ///   let product = NSDecimalNumberHandler.dy_product(of: [2, 3, 4])
    ///   print(product) // 24
    ///   ```
    static func dy_product(of values: [some LosslessStringConvertible]) -> NSDecimalNumber {
        return values.reduce(.one) { acc, val in
            acc.multiplying(by: NSDecimalNumber(string: String(val)))
        }
    }

    /// 按比例将总值分解为多个部分
    ///
    /// - Parameters:
    ///   - total: 总值
    ///   - ratios: 比例数组(可为小数或百分比,只要相对比例正确即可)
    /// - Returns: 按比例分配后的数值数组;若比例总和为零,返回全零数组
    ///
    /// - Example:
    ///   ```swift
    ///   let parts = NSDecimalNumberHandler.dy_splitByRatios(total: 100, ratios: [1, 2, 3])
    ///   // 相当于按 1:2:3 分配 → [16.66..., 33.33..., 50]
    ///   ```
    static func dy_splitByRatios(
        total: some LosslessStringConvertible,
        ratios: [some LosslessStringConvertible]
    ) -> [NSDecimalNumber] {
        let totalNum = NSDecimalNumber(string: String(total))
        let ratioSum = dy_sum(of: ratios)
        guard ratioSum != .zero else { return Array(repeating: .zero, count: ratios.count) }
        return ratios.map { ratio in
            let r = NSDecimalNumber(string: String(ratio))
            return totalNum.multiplying(by: r).dividing(by: ratioSum)
        }
    }

    /// 生成指定范围内的随机高精度数值
    ///
    /// - Parameters:
    ///   - min: 最小值(包含)
    ///   - max: 最大值(不包含)
    /// - Returns: `[min, max)` 区间内的随机 `NSDecimalNumber`
    /// - Note: 内部使用 `Double.random(in:)`,因此`精度受限于 `Double`(约15位有效数字)`,
    ///         不适用于需要完整 `NSDecimalNumber` 精度的场景(如金融级随机金额)
    ///
    /// - Example:
    ///   ```swift
    ///   let randomPrice = NSDecimalNumberHandler.dy_random(min: 10, max: 20)
    ///   print(randomPrice) // 如: 14.728...
    ///   ```
    static func dy_random(
        min: some LosslessStringConvertible,
        max: some LosslessStringConvertible
    ) -> NSDecimalNumber {
        let minValue = NSDecimalNumber(string: String(min))
        let maxValue = NSDecimalNumber(string: String(max))
        let range = maxValue.subtracting(minValue)
        let randomDouble = Double.random(in: 0 ..< 1)
        return range.multiplying(by: NSDecimalNumber(value: randomDouble)).adding(minValue)
    }
}
