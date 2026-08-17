import Foundation

// MARK: - 数字与金额格式化
public extension SoloWrapper where Base == String {
    /// 将数字字符串格式化为带千分位的形式(如 "1,234,567.89")
    ///
    /// - Parameters:
    ///   - maximumFractionDigits: 最大小数位数(默认 2)
    ///   - roundingMode: 舍入模式(默认 `.halfEven`)
    ///   - fallback: 格式化失败时的返回值(默认空字符串)
    /// - Returns: 格式化后的字符串
    func formattedAsThousands(
        maximumFractionDigits: Int = 2,
        roundingMode: NumberFormatter.RoundingMode = .halfEven,
        fallback: String = ""
    ) -> String {
        let number = NSDecimalNumber(string: base)
        if number == NSDecimalNumber.notANumber {
            return fallback
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.maximumFractionDigits = max(0, maximumFractionDigits)
        formatter.roundingMode = roundingMode

        return formatter.string(from: number) ?? fallback
    }

    /// 移除小数点后多余的零,以及末尾的小数点
    ///
    /// - Returns: 清理后的字符串
    func trimTrailingZeros() -> String {
        guard let _ = base.firstIndex(of: ".") else {
            return base
        }

        var result = base
        while result.last == "0" {
            result.removeLast()
        }
        if result.last == "." {
            result.removeLast()
        }
        return result.isEmpty ? "0" : result
    }

    /// 保留指定小数位数并按指定模式舍入
    ///
    /// - Parameters:
    ///   - places: 保留的小数位数(默认 0)
    ///   - mode: 舍入模式(默认 `.halfEven`)
    ///   - fallback: 失败时返回值(默认 "0")
    /// - Returns: 格式化后的字符串
    func rounded(toDecimalPlaces places: Int = 0, mode: NumberFormatter.RoundingMode = .halfEven, fallback: String = "0") -> String {
        let number = NSDecimalNumber(string: base)
        if number == NSDecimalNumber.notANumber {
            return fallback
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = max(0, places)
        formatter.maximumFractionDigits = max(0, places)
        formatter.roundingMode = mode

        return formatter.string(from: number) ?? fallback
    }
}
