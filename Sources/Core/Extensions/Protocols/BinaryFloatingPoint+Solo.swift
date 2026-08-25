import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension BinaryFloatingPoint {
    /// 将当前浮点数值转换为布尔值
    func solo_bool() -> Bool {
        self > 0
    }

    /// 将当前值转换为 `Int` 类型
    func solo_int() -> Int {
        Int(self)
    }

    /// 将当前值转换为 `Int64` 类型
    func solo_int64() -> Int64 {
        Int64(self)
    }

    /// 将当前值转换为 `UInt` 类型
    func solo_uInt() -> UInt {
        UInt(self)
    }

    /// 将当前值转换为 `UInt64` 类型
    func solo_uInt64() -> UInt64 {
        UInt64(self)
    }

    /// 将当前值转换为 `Float` 类型
    func solo_float() -> Float {
        Float(self)
    }

    /// 将当前值转换为 `Double` 类型
    func solo_double() -> Double {
        Double(self)
    }

    /// 将当前值转换为 `CGFloat` 类型
    func solo_cGFloat() -> CGFloat {
        CGFloat(self)
    }

    /// 将当前值包装为 `NSNumber` 对象
    func solo_nSNumber() -> NSNumber {
        NSNumber(value: self.solo_double())
    }

    /// 将当前值转换为 `NSDecimalNumber`
    func solo_nSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self.solo_string())
    }

    /// 将当前值转换为 `Decimal`
    func solo_decimal() -> Decimal {
        self.solo_nSDecimalNumber().decimalValue
    }

    /// 将当前值转换为字符串表示
    func solo_string() -> String {
        String(describing: self)
    }

    /// 将当前值转换为 `CGPoint`,`x` 和 `y` 坐标均使用该值
    func solo_cGPoint() -> CGPoint {
        let v = self.solo_cGFloat()
        return CGPoint(x: v, y: v)
    }

    /// 将当前值转换为 `CGSize`,`width` 和 `height` 均使用该值
    func solo_cGSize() -> CGSize {
        let v = self.solo_cGFloat()
        return CGSize(width: v, height: v)
    }
}

// MARK: - 角度与弧度转换
public extension BinaryFloatingPoint {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围通常为 `0` 到 `2π`,但支持任意输入)
    func solo_radians() -> Self {
        self * (.pi / 180)
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值
    func solo_degrees() -> Self {
        self * (180 / .pi)
    }
}

// MARK: - 基础数值操作
public extension BinaryFloatingPoint {
    /// 返回当前值的绝对值
    func solo_abs() -> Self {
        Swift.abs(self)
    }

    /// 对当前值向上取整(向正无穷方向)
    func solo_ceil() -> Self {
        Foundation.ceil(self)
    }

    /// 对当前值向下取整(向负无穷方向)
    func solo_floor() -> Self {
        Foundation.floor(self)
    }

    /// 将当前值四舍五入为最接近的整数,并转换为 `Int`
    /// - Returns: 四舍五入后的 `Int` 值
    func solo_roundToInt() -> Int {
        Foundation.lround(self.solo_double())
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
    ///     print(value.solo_truncate(places: 2)) // 5.67
    ///
    ///     let negative: Double = -5.6789
    ///     print(negative.solo_truncate(places: 2)) // -5.67
    ///     ```
    func solo_truncate(places: Int) -> Self {
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
    ///     print(value.solo_round(places: 2)) // 5.68
    ///     ```
    func solo_round(places: Int) -> Self {
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
    ///     print(value.solo_rounded(places: 2, rule: .down)) // 5.67
    ///     ```
    func solo_rounded(places: Int, rule: FloatingPointRoundingRule) -> Self {
        guard places >= 0 else { return self }
        let multiplier = Self(pow(10, Double(places)))
        return (self * multiplier).rounded(rule) / multiplier
    }
}
