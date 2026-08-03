import Foundation

extension Measurement: DyExtension {}

// MARK: - 方法
public extension DyWrapper where Base == Measurement<UnitAngle> {
    /// 创建一个以`角度(degrees)` 为单位的角度测量值
    ///
    /// 角度是平面几何中最常用的角单位,一圈为 360°
    ///
    /// - Parameter value: 角度数值(例如 `90.0` 表示直角)
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.degrees(45.0)
    ///   print(angle) // 45.0 degrees
    ///   ```
    static func degrees(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .degrees)
    }

    /// 创建一个以`弧度(radians)` 为单位的角度测量值
    ///
    /// 弧度是数学和物理中的标准角单位,一圈为 `2π` 弧度
    ///
    /// - Parameter value: 弧度数值(例如 `Double.pi / 2` 表示直角)
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.radians(Double.pi)
    ///   print(angle) // 3.141592653589793 radians
    ///   ```
    static func radians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .radians)
    }

    /// 创建一个以`弧分(arc minutes)` 为单位的角度测量值
    ///
    /// 1 度 = 60 弧分,常用于天文学和地理坐标
    ///
    /// - Parameter value: 弧分数值
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.arcMinutes(30.0)
    ///   print(angle) // 30.0 arc minutes
    ///   ```
    static func arcMinutes(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcMinutes)
    }

    /// 创建一个以`弧秒(arc seconds)` 为单位的角度测量值
    ///
    /// 1 弧分 = 60 弧秒,即 1 度 = 3600 弧秒,用于高精度角度表示
    ///
    /// - Parameter value: 弧秒数值
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.arcSeconds(1800.0)
    ///   print(angle) // 1800.0 arc seconds (等于 0.5 度)
    ///   ```
    static func arcSeconds(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .arcSeconds)
    }

    /// 创建一个以`梯度(gradians)` 为单位的角度测量值
    ///
    /// 梯度又称“百分度”,一圈为 400 梯度,常见于部分工程领域
    ///
    /// - Parameter value: 梯度数值
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.gradians(100.0)
    ///   print(angle) // 100.0 gradians (等于 90 度)
    ///   ```
    static func gradians(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .gradians)
    }

    /// 创建一个以`转数(revolutions)` 为单位的角度测量值
    ///
    /// 1 转 = 360 度 = `2π` 弧度,适用于描述旋转圈数
    ///
    /// - Parameter value: 转数(可为小数,如 `0.5` 表示半圈)
    /// - Returns: 对应的 `Measurement<UnitAngle>`
    ///
    /// - Example:
    ///   ```swift
    ///   let angle = Measurement<UnitAngle>.dy.revolutions(2.5)
    ///   print(angle) // 2.5 revolutions (等于 900 度)
    ///   ```
    static func revolutions(_ value: Double) -> Measurement<UnitAngle> {
        return Measurement(value: value, unit: .revolutions)
    }
}
