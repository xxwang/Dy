import CoreGraphics
import Foundation

extension Float: DyExtension {}
extension Double: DyExtension {}
extension CGFloat: DyExtension {}

// MARK: - 类型转换
public extension DyWrapper where Base: BinaryFloatingPoint {
    /// 将当前浮点数值转换为布尔值
    func toBool() -> Bool {
        base > 0
    }

    /// 将当前值转换为 `Int` 类型
    func toInt() -> Int {
        Int(base)
    }

    /// 将当前值转换为 `Int64` 类型
    func toInt64() -> Int64 {
        Int64(base)
    }

    /// 将当前值转换为 `UInt` 类型
    func toUInt() -> UInt {
        UInt(base)
    }

    /// 将当前值转换为 `UInt64` 类型
    func toUInt64() -> UInt64 {
        UInt64(base)
    }

    /// 将当前值转换为 `Float` 类型
    func toFloat() -> Float {
        Float(base)
    }

    /// 将当前值转换为 `Double` 类型
    func toDouble() -> Double {
        Double(base)
    }

    /// 将当前值转换为 `CGFloat` 类型
    func toCGFloat() -> CGFloat {
        CGFloat(base)
    }

    /// 将当前值包装为 `NSNumber` 对象
    func toNSNumber() -> NSNumber {
        NSNumber(value: Double(base))
    }

    /// 将当前值转换为 `NSDecimalNumber`
    func toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(value: Double(base))
    }

    /// 将当前值转换为 `Decimal`
    func toDecimal() -> Decimal {
        Decimal(Double(base))
    }

    /// 将当前值转换为字符串表示
    func toString() -> String {
        String(describing: base)
    }

    /// 将当前值转换为 `CGPoint`,`x` 和 `y` 坐标均使用该值
    func toCGPoint() -> CGPoint {
        let v = self.toCGFloat()
        return CGPoint(x: v, y: v)
    }

    /// 将当前值转换为 `CGSize`,`width` 和 `height` 均使用该值
    func toCGSize() -> CGSize {
        let v = self.toCGFloat()
        return CGSize(width: v, height: v)
    }
}

// MARK: - 角度与弧度转换
public extension DyWrapper where Base: BinaryFloatingPoint {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围通常为 `0` 到 `2π`,但支持任意输入)
    func toRadians() -> Base {
        base * (.pi / 180)
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值
    func toDegrees() -> Base {
        base * (180 / .pi)
    }
}

// MARK: - 基础数值操作
public extension DyWrapper where Base: BinaryFloatingPoint {
    /// 返回当前值的绝对值
    func abs() -> Base {
        Swift.abs(base)
    }

    /// 对当前值向上取整(向正无穷方向)
    func ceil() -> Base {
        Foundation.ceil(base)
    }

    /// 对当前值向下取整(向负无穷方向)
    func floor() -> Base {
        Foundation.floor(base)
    }

    /// 将当前值四舍五入为最接近的整数,并转换为 `Int`
    /// - Returns: 四舍五入后的 `Int` 值
    func roundToInt() -> Int {
        Foundation.lround(Double(base))
    }
}

// MARK: - 小数精度控制
public extension DyWrapper where Base: BinaryFloatingPoint {
    /// 截断小数部分,保留指定的小数位数(向零取整)
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 截断后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.dy.truncate(places: 2)) // 5.67
    ///
    ///     let negative: Double = -5.6789
    ///     print(negative.dy.truncate(places: 2)) // -5.67
    ///     ```
    func truncate(places: Int) -> Base {
        guard places >= 0 else { return base }
        let multiplier = Base(pow(10, Double(places)))
        return (base * multiplier).rounded(.towardZero) / multiplier
    }

    /// 对当前值四舍五入到指定的小数位数
    ///
    /// - Parameter places: 要保留的小数位数,必须 ≥ 0若为负数,返回原值
    /// - Returns: 四舍五入后的值
    ///
    /// - Example:
    ///   ```swift
    ///     let value: Double = 5.6789
    ///     print(value.dy.round(places: 2)) // 5.68
    ///     ```
    func round(places: Int) -> Base {
        guard places >= 0 else { return base }
        let multiplier = Base(pow(10, Double(places)))
        return (base * multiplier).rounded() / multiplier
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
    ///     print(value.dy.rounded(places: 2, rule: .down)) // 5.67
    ///     ```
    func rounded(places: Int, rule: FloatingPointRoundingRule) -> Base {
        guard places >= 0 else { return base }
        let multiplier = Base(pow(10, Double(places)))
        return (base * multiplier).rounded(rule) / multiplier
    }
}
