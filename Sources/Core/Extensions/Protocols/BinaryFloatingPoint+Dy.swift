import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 将当前浮点数值转换为布尔值
    func dy_bool() -> Bool {
        self > 0
    }

    /// 将当前值转换为 `Int` 类型
    func dy_int() -> Int {
        Int(self)
    }

    /// 将当前值转换为 `Int64` 类型
    func dy_int64() -> Int64 {
        Int64(self)
    }

    /// 将当前值转换为 `UInt` 类型
    func dy_uInt() -> UInt {
        UInt(self)
    }

    /// 将当前值转换为 `UInt64` 类型
    func dy_uInt64() -> UInt64 {
        UInt64(self)
    }

    /// 将当前值转换为 `Float` 类型
    func dy_float() -> Float {
        Float(self)
    }

    /// 将当前值转换为 `Double` 类型
    func dy_double() -> Double {
        Double(self)
    }

    /// 将当前值转换为 `CGFloat` 类型
    func dy_cGFloat() -> CGFloat {
        CGFloat(self)
    }

    /// 将当前值包装为 `NSNumber` 对象
    func dy_nSNumber() -> NSNumber {
        NSNumber(value: self.dy_double())
    }

    /// 将当前值转换为 `NSDecimalNumber`
    func dy_nSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self.dy_string())
    }

    /// 将当前值转换为 `Decimal`
    func dy_decimal() -> Decimal {
        self.dy_nSDecimalNumber().decimalValue
    }

    /// 将当前值转换为字符串表示
    func dy_string() -> String {
        String(describing: self)
    }

    /// 将当前值转换为 `CGPoint`,`x` 和 `y` 坐标均使用该值
    func dy_cGPoint() -> CGPoint {
        let v = self.dy_cGFloat()
        return CGPoint(x: v, y: v)
    }

    /// 将当前值转换为 `CGSize`,`width` 和 `height` 均使用该值
    func dy_cGSize() -> CGSize {
        let v = self.dy_cGFloat()
        return CGSize(width: v, height: v)
    }
}

// MARK: - 角度与弧度转换
public extension BinaryFloatingPoint {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围通常为 `0` 到 `2π`,但支持任意输入)
    func dy_radians() -> Self {
        self * (.pi / 180)
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值
    func dy_degrees() -> Self {
        self * (180 / .pi)
    }
}

// MARK: - 基础数值操作
public extension BinaryFloatingPoint {
    /// 返回当前值的绝对值
    func dy_abs() -> Self {
        Swift.abs(self)
    }

    /// 对当前值向上取整(向正无穷方向)
    func dy_ceil() -> Self {
        Foundation.ceil(self)
    }

    /// 对当前值向下取整(向负无穷方向)
    func dy_floor() -> Self {
        Foundation.floor(self)
    }

    /// 将当前值四舍五入为最接近的整数,并转换为 `Int`
    /// - Returns: 四舍五入后的 `Int` 值
    func dy_roundToInt() -> Int {
        Foundation.lround(self.dy_double())
    }
}

// MARK: - 小数精度控制
public extension BinaryFloatingPoint {
    /// 截断小数部分,保留指定的小数位数(向零取整)
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 截断后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.dy_truncate(places: 2)) // 5.67
    ///
    ///     let negative: Double = -5.6789
    ///     print(negative.dy_truncate(places: 2)) // -5.67
    ///     ```
    func dy_truncate(places: Int) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded(.towardZero) / multiplier
    }

    /// 对当前值四舍五入到指定的小数位数
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 四舍五入后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.dy_round(places: 2)) // 5.68
    ///     ```
    func dy_round(places: Int) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded() / multiplier
    }

    /// 按指定舍入规则对当前值舍入到指定小数位数
    ///
    /// - Parameters:
    ///   - places: 要保留的小数位数(≥ 0)
    ///   - rule: 舍入规则,如 `.up`, `.down`, `.towardZero` 等
    /// - Returns: 舍入后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.671
    ///     print(value.dy_rounded(places: 2, rule: .down)) // 5.67
    ///     ```
    func dy_rounded(places: Int, rule: FloatingPointRoundingRule) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded(rule) / multiplier
    }
}
