import Foundation

/// 缓存的 ISO 8601 formatter（避免重复创建昂贵的 DateFormatter 实例）
private let _cachedISO8601Formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}()

// MARK: - 构造方法
public extension DateFormatter {
    /// 创建自定义格式的 `DateFormatter`
    /// - Parameters:
    ///   - format: 日期格式字符串(如 `yyyy-MM-dd`)
    ///   - locale: 地区,默认为 `en_US_POSIX`(推荐用于解析)
    ///   - timeZone: 时区,默认为 `UTC`
    convenience init(
        format: String,
        locale: Locale = Locale(identifier: "en_US_POSIX"),
        timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!
    ) {
        self.init()
        self.dateFormat = format
        self.locale = locale
        self.timeZone = timeZone
    }
}

// MARK: - 共享实例
public extension DyWrapper where Base: DateFormatter {
    /// `ISO 8601`格式的 `DateFormatter`（`UTC 时区` + `en_US_POSIX区域`）
    ///
    /// 格式：`yyyy-MM-dd'T'HH:mm:ssZ`
    static func iso8601() -> DateFormatter {
        _cachedISO8601Formatter
    }

    /// 创建一个自定义配置的 `DateFormatter` 实例
    ///
    /// - Parameters:
    ///   - format: 日期格式字符串，默认为 `"yyyy-MM-dd HH:mm:ss"`
    ///   - locale: 区域设置，默认为 `.current`
    ///   - timeZone: 时区，默认为 `.current`（而非 `.autoupdatingCurrent`，避免隐式更新）
    /// - Returns: `DateFormatter` 实例
    static func formatter(
        format: String = "yyyy-MM-dd HH:mm:ss",
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter
    }
}
