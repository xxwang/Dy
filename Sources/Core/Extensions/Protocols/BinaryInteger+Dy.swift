import CoreGraphics
import Foundation

// MARK: - 类型转换
public extension DyWrapper where Base: BinaryInteger {
    /// 转换为 `Bool`
    func toBool() -> Bool {
        base > 0
    }

    /// 转换为`Int`
    func toInt() -> Int {
        Int(base)
    }

    /// 转换为`Int64`
    func toInt64() -> Int64 {
        Int64(base)
    }

    /// 转换为`UInt`
    func toUInt() -> UInt {
        UInt(base)
    }

    /// 转换为`UInt64`
    func toUInt64() -> UInt64 {
        UInt64(base)
    }

    /// 转换为`Float`
    func toFloat() -> Float {
        Float(base)
    }

    /// 转换为`Double`
    func toDouble() -> Double {
        Double(base)
    }

    /// 转换为`CGFloat`
    func toCGFloat() -> CGFloat {
        CGFloat(base)
    }

    /// 转换为 `NSNumber`
    func toNSNumber() -> NSNumber {
        NSNumber(value: Double(base))
    }

    /// 转换为 `NSDecimalNumber`(通过 `Double` 中转,注意精度损失)
    func toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(value: Double(base))
    }

    /// 转换为 `Decimal`(经字符串中转,避免 `Decimal(Double(self))` 对大整数(>2^53)的精度丢失)
    func toDecimal() -> Decimal {
        Decimal(string: String(base)) ?? .zero
    }

    /// 转换为十进制字符串表示
    func toString() -> String {
        String(base)
    }

    /// 尝试将当前值解释为 `Unicode` 码点,并返回对应的 `Character`
    ///
    /// - Returns: 有效的 `Character`,若码点无效则返回 `nil`
    func toCharacter() -> Character? {
        guard let scalar = UnicodeScalar(Int(base)) else { return nil }
        return Character(scalar)
    }

    /// 创建一个 `CGPoint`,`x` 和 `y`坐标均设为当前值(转换为 `Double`)
    func toCGPoint() -> CGPoint {
        CGPoint(x: CGFloat(base), y: CGFloat(base))
    }

    /// 创建一个 `CGSize`,宽高均设为当前值(转换为 `CGFloat`)
    func toCGSize() -> CGSize {
        CGSize(width: CGFloat(base), height: CGFloat(base))
    }
}

// MARK: - 角度与弧度转换
public extension DyWrapper where Base: BinaryInteger {
    /// 将角度(单位：度)转换为弧度
    ///
    /// - Returns: 对应的弧度值(范围：0 到 2π)
    ///
    /// - Example:
    ///   ```swift
    ///     let radians = 180.dy.toRadians() // ≈ π
    ///     ```
    func toRadians() -> Double {
        Double(base) * .pi / 180.0
    }

    /// 将弧度转换为角度(单位：度)
    ///
    /// - Returns: 对应的角度值(范围：0 到 360)
    ///
    /// - Example:
    ///   ```swift
    ///     let degrees = Int.pi.dy.toDegrees() // ≈ 180.0
    ///     ```
    func toDegrees() -> Double {
        Double(base) * 180.0 / .pi
    }
}

// MARK: - 数值属性与操作
public extension DyWrapper where Base: BinaryInteger {
    /// 判断是否为奇数
    var isOdd: Bool {
        base & 1 == 1
    }

    /// 判断是否为偶数
    var isEven: Bool {
        base & 1 == 0
    }

    /// 格式化为人类可读的存储单位(如 KB, MB, GB)
    ///
    /// - Returns: 格式化字符串,如 `"1.50 MB"`
    ///
    /// - Example:
    ///   ```swift
    ///     let size = (1_572_864 as Int).dy.storageUnit() // "1.50 MB"
    ///     ```
    func storageUnit() -> String {
        let units = ["bytes", "KB", "MB", "GB", "TB", "PB"]
        var value = Double(base)
        var index = 0
        while value >= 1024, index < units.count - 1 {
            value /= 1024
            index += 1
        }
        if index == 0 {
            return "\(Int(value)) \(units[index])"
        } else {
            return String(format: "%.2f %@", value, units[index])
        }
    }

    /// 转换为罗马数字(仅支持正整数)
    ///
    /// - Returns: 罗马数字字符串,若 ≤ 0 则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///     let roman = 1987.dy.toRomanNumeral() // "MCMLXXXVII"
    ///     ```
    func toRomanNumeral() -> String? {
        guard base > 0 else { return nil }
        let values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1]
        let numerals = ["M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"]

        var result = ""
        var remaining = Int(base)
        for (value, numeral) in zip(values, numerals) {
            while remaining >= value {
                result += numeral
                remaining -= value
            }
        }
        return result
    }
}

// MARK: - 时间
public extension DyWrapper where Base: BinaryInteger {
    /// 将整数解释为时间戳,并创建 `Date` 对象
    ///
    /// - Parameters:
    ///   - isUnix: 若为 `true`,表示秒级 Unix 时间戳;若为 `false`,表示毫秒级
    /// - Returns: 对应的 `Date`
    ///
    /// - Example:
    ///   ```swift
    ///     let date = 1_609_459_200.dy.date() // 2021-01-01 UTC
    ///     let dateMs = 1_609_459_200_000.dy.date(isUnix: false) // 同上
    ///     ```
    func date(isUnix: Bool = true) -> Date {
        let interval = isUnix ? Double(base) : Double(base) / 1000.0
        return Date(timeIntervalSince1970: interval)
    }

    /// 将秒数格式化为播放时间字符串(如 "01:01:01")
    ///
    /// - Parameter component: 可选,指定只显示到某一级(如 `.minute` → "61:01")
    /// - Returns: 格式化的时间字符串
    ///
    /// - Example:
    ///   ```swift
    ///     let full = 3661.dy.durationString() // "01:01:01"
    ///     let minSec = 3661.dy.durationString(component: .minute) // "61:01"
    ///     ```
    func durationString(component: Calendar.Component? = nil) -> String {
        guard base > 0 else { return "00:00" }

        let totalSeconds = Int(base)
        let seconds = totalSeconds % 60

        if component == .second {
            return String(format: "%02d", seconds)
        }

        let totalMinutes = totalSeconds / 60
        let minutes = totalMinutes % 60

        if component == .minute {
            return String(format: "%02d:%02d", totalMinutes, seconds)
        }

        let hours = totalMinutes / 60
        if component == .hour || hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
}

// MARK: - 区间
public extension DyWrapper where Base: BinaryInteger {
    /// 创建从 `from` 到 `self` 的半开区间(左闭右开)
    ///
    /// - Parameter from: 起始值(包含)
    /// - Returns: `CountableRange<Int>`
    ///
    /// - Example:
    ///   ```swift
    ///     let range = 10.dy.range(from: 5) // 5..<10
    ///     ```
    func range(from: some BinaryInteger) -> CountableRange<Int> {
        Int(from) ..< Int(base)
    }

    /// 创建从 `self` 到 `to` 的半开区间(左闭右开)
    ///
    /// - Parameter to: 结束值(不包含)
    /// - Returns: `CountableRange<Int>`
    ///
    /// - Example:
    ///   ```swift
    ///     let range = 5.dy.range(to: 10) // 5..<10
    ///     ```
    func range(to: some BinaryInteger) -> CountableRange<Int> {
        Int(base) ..< Int(to)
    }
}
