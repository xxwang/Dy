import Foundation

// MARK: - 从数值类型格式化
public extension NumberFormatter {
    /// 将 `Decimal` 格式化为本地化字符串(`推荐用于高精度场景`)
    ///
    /// - Parameters:
    ///   - value: 要格式化的 `Decimal` 值
    ///   - style: 数字样式(如 `.decimal`, `.currency`),默认为 `.decimal`
    /// - Returns: 格式化后的字符串
    ///
    /// - Note: 使用 `Decimal` 可避免 `Float`/`Double` 的二进制浮点误差
    static func dy_format(_ value: Decimal, style: Style = .decimal) -> String {
        let number = NSDecimalNumber(decimal: value)
        return localizedString(from: number, number: style)
    }

    /// 将 `Double` 格式化为本地化字符串(`注意精度损失风险`)
    ///
    /// - Parameters:
    ///   - value: 要格式化的 `Double` 值
    ///   - style: 数字样式,默认为 `.decimal`
    /// - Returns: 格式化后的字符串
    static func dy_format(_ value: Double, style: Style = .decimal) -> String {
        return localizedString(from: NSNumber(value: value), number: style)
    }

    /// 将 `Float` 格式化为本地化字符串(`注意精度损失风险`)
    ///
    /// - Parameters:
    ///   - value: 要格式化的 `Float` 值
    ///   - style: 数字样式,默认为 `.decimal`
    /// - Returns: 格式化后的字符串
    static func dy_format(_ value: Float, style: Style = .decimal) -> String {
        return localizedString(from: NSNumber(value: value), number: style)
    }
}

// MARK: - 从字符串解析并重新格式化
public extension NumberFormatter {
    /// 将字符串数值解析后,用指定样式重新格式化
    ///
    /// - Parameters:
    ///   - string: 源字符串(如 `"12345.67"`)
    ///   - style: 目标格式样式,默认为 `.decimal`
    /// - Returns: 格式化后的字符串;若无法解析则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let result = NumberFormatter.dy_reformat("12345.6", style: .currency)
    ///   // 可能返回 "$12,345.60"(取决于 locale)
    ///   ```
    static func dy_reformat(_ string: String, style: Style = .decimal) -> String? {
        let parser = NumberFormatter()
        parser.numberStyle = .decimal // 使用宽松解析
        guard let number = parser.number(from: string) else { return nil }

        return localizedString(from: number, number: style)
    }
}

// MARK: - 高级自定义格式化(通用入口)
public extension NumberFormatter {
    /// 使用自定义配置的 `NumberFormatter` 格式化字符串数值
    ///
    /// - Parameters:
    ///   - string: 源字符串数值
    ///   - configure: 用于配置 `NumberFormatter` 的闭包
    /// - Returns: 格式化结果;若解析或格式化失败则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let result = NumberFormatter.dy_customFormat("1234567") { formatter in
    ///       formatter.numberStyle = .decimal
    ///       formatter.groupingSeparator = " "
    ///       formatter.groupingSize = 3
    ///       formatter.minimumFractionDigits = 2
    ///   }
    ///   // 返回 "1 234 567.00"
    ///   ```
    static func dy_customFormat(_ string: String, configure: (inout NumberFormatter) -> Void) -> String? {
        // 第一步：解析字符串为 NSNumber
        let parser = NumberFormatter()
        parser.numberStyle = .decimal
        guard let number = parser.number(from: string) else { return nil }

        // 第二步：应用自定义配置并格式化
        var formatter = NumberFormatter()
        configure(&formatter)
        return formatter.string(from: number)
    }
}

// MARK: - 快捷方法
public extension NumberFormatter {
    /// 为字符串数值添加千位分隔符
    ///
    /// - Parameters:
    ///   - string: 源字符串
    ///   - separator: 分隔符(如 `","`, `" "`)
    ///   - groupingSize: 每组位数(通常为 3)
    /// - Returns: 格式化后的字符串;失败返回 `nil`
    static func dy_withGroupingSeparator(_ string: String, separator: String = ",", groupingSize: Int = 3) -> String? {
        return dy_customFormat(string) { formatter in
            formatter.numberStyle = .decimal
            formatter.usesGroupingSeparator = true
            formatter.groupingSeparator = separator
            formatter.groupingSize = groupingSize
        }
    }

    /// 为字符串数值设置固定宽度并填充
    ///
    /// - Parameters:
    ///   - string: 源字符串
    ///   - width: 总宽度
    ///   - padding: 填充字符(如 `"0"`)
    ///   - position: 填充位置(默认在前缀前)
    /// - Returns: 格式化后的字符串;失败返回 `nil`
    static func dy_padded(_ string: String, width: Int, padding: String = "0", position: PadPosition = .beforePrefix) -> String? {
        return dy_customFormat(string) { formatter in
            formatter.formatWidth = width
            formatter.paddingCharacter = padding
            formatter.paddingPosition = position
        }
    }

    /// 设置整数和小数位数限制
    ///
    /// - Parameters:
    ///   - string: 源字符串
    ///   - minInteger: 最小整数位数
    ///   - maxInteger: 最大整数位数
    ///   - minFraction: 最小小数位数
    ///   - maxFraction: 最大小数位数
    /// - Returns: 格式化后的字符串;失败返回 `nil`
    static func dy_digitLimits(
        _ string: String,
        minInteger: Int? = nil,
        maxInteger: Int? = nil,
        minFraction: Int? = nil,
        maxFraction: Int? = nil
    ) -> String? {
        return dy_customFormat(string) { formatter in
            if let min = minInteger {
                formatter.minimumIntegerDigits = min
            }
            if let max = maxInteger {
                formatter.maximumIntegerDigits = max
            }
            if let min = minFraction {
                formatter.minimumFractionDigits = min
            }
            if let max = maxFraction {
                formatter.maximumFractionDigits = max
            }
        }
    }

    /// 添加前缀和后缀
    ///
    /// - Parameters:
    ///   - string: 源字符串
    ///   - prefix: 正数前缀(如 `"$"`)
    ///   - suffix: 正数后缀(如 `" USD"`)
    /// - Returns: 格式化后的字符串;失败返回 `nil`
    static func dy_withAffixes(_ string: String, prefix: String = "", suffix: String = "") -> String? {
        return dy_customFormat(string) { formatter in
            formatter.positivePrefix = prefix
            formatter.positiveSuffix = suffix
        }
    }

    /// 使用自定义正数格式模板(如 `"###,###.00"`)
    ///
    /// - Parameters:
    ///   - string: 源字符串
    ///   - format: 格式模板
    /// - Returns: 格式化后的字符串;失败返回 `nil`
    static func dy_withPositiveFormat(_ string: String, format: String) -> String? {
        return dy_customFormat(string) { formatter in
            formatter.positiveFormat = format
        }
    }
}
