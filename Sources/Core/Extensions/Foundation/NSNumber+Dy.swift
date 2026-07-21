import Foundation

// MARK: - 格式化
public extension NSNumber {
    /// 格式化为十进制数字字符串(支持千分位、小数位控制)
    /// - Parameters:
    ///   - groupingSeparator: 千位分隔符(通常为 "," 或 "."),默认取当前 locale
    ///   - roundingMode: 舍入模式,默认 `.halfEven`
    ///   - minimumFractionDigits: 最小小数位数,默认 0
    ///   - maximumFractionDigits: 最大小数位数,默认 0
    ///   - usesGroupingSeparator: 是否启用千分位分隔,默认 true
    /// - Returns: 格式化后的字符串
    func dy_decimal(
        groupingSeparator: String? = nil,
        roundingMode: NumberFormatter.RoundingMode = .halfEven,
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 0,
        usesGroupingSeparator: Bool = true
    ) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.roundingMode = roundingMode
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        formatter.usesGroupingSeparator = usesGroupingSeparator

        if let separator = groupingSeparator {
            formatter.groupingSeparator = separator
        }

        return formatter.string(from: self)
    }

    /// 格式化为货币字符串
    /// - Parameters:
    ///   - locale: 地区,默认 `.current`
    ///   - showCurrencySymbol: 是否显示货币符号,默认 true
    /// - Returns: 货币格式字符串(如 "$1,234.56")
    func dy_currency(
        locale: Locale = .current,
        showCurrencySymbol: Bool = true
    ) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        if !showCurrencySymbol {
            formatter.currencySymbol = ""
        }
        return formatter.string(from: self)
    }

    /// 格式化为百分比字符串(自动 ×100)
    /// - Parameters:
    ///   - minimumFractionDigits: 最小小数位数,默认 0
    ///   - maximumFractionDigits: 最大小数位数,默认 0
    /// - Returns: 百分比字符串(如 "12.35%")
    func dy_percent(
        minimumFractionDigits: Int = 0,
        maximumFractionDigits: Int = 0
    ) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: self)
    }

    /// 格式化为科学计数法(如 "1.234E5")
    func dy_scientific() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        return formatter.string(from: self)
    }

    /// 格式化为固定小数位的十进制数
    /// - Parameter decimalPlaces: 小数位数
    /// - Returns: 字符串(如 "12345.679")
    func dy_fixed(_ decimalPlaces: Int) -> String? {
        return decimal(
            minimumFractionDigits: decimalPlaces,
            maximumFractionDigits: decimalPlaces
        )
    }
}
