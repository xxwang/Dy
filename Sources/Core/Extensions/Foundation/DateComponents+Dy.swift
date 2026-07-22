import Foundation

// MARK: - 日期构建与转换
public extension DateComponents {
    /// 基于当前 `DateComponents` 生成 `Date` 对象
    /// - Parameter calendar: 日历,默认为 `.current`
    /// - Returns: 若组件有效,则返回对应的 `Date`;否则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let date = DateComponents().dy_toDate()
    ///   ```
    func dy_toDate(using calendar: Calendar = .current) -> Date? {
        return calendar.date(from: self)
    }
}

// MARK: - 链式设置
public extension DateComponents {
    /// 设置日历
    /// - Parameter calendar: 要设置的日历对象
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 要设置的时区对象
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置年份
    /// - Parameter year: 年份数值（例如 2025）
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_year(_ year: Int) -> Self {
        self.year = year
        return self
    }

    /// 设置月份
    /// - Parameter month: 月份数值，范围为 1 到 12（1 表示一月，12 表示十二月）
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_month(_ month: Int) -> Self {
        self.month = month
        return self
    }

    /// 设置天数
    /// - Parameter day: 天数值，范围通常为 1 到 31，具体取决于月份和日历
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_day(_ day: Int) -> Self {
        self.day = day
        return self
    }

    /// 设置小时
    /// - Parameter hour: 小时数值，采用 24 小时制，范围为 0 到 23
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_hour(_ hour: Int) -> Self {
        self.hour = hour
        return self
    }

    /// 设置分钟
    /// - Parameter minute: 分钟数值，范围为 0 到 59
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_minute(_ minute: Int) -> Self {
        self.minute = minute
        return self
    }

    /// 设置秒
    /// - Parameter second: 秒数值，范围为 0 到 59
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_second(_ second: Int) -> Self {
        self.second = second
        return self
    }

    /// 设置纳秒
    /// - Parameter nanosecond: 纳秒数值，范围为 0 到 999,999,999
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_nanosecond(_ nanosecond: Int) -> Self {
        self.nanosecond = nanosecond
        return self
    }

    /// 设置星期几
    /// - Parameter weekday: 星期几的数值，1 表示星期日，2 表示星期一，依此类推，7 表示星期六（具体行为受日历影响）
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_weekday(_ weekday: Int) -> Self {
        self.weekday = weekday
        return self
    }

    /// 设置当月第几个指定的星期几（需与 `weekday` 配合使用）
    /// - Parameter ordinal: 序数，例如 2 表示“第二个”，结合 `weekday(.monday)` 可表示“本月第二个星期一”
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_weekdayOrdinal(_ ordinal: Int) -> Self {
        self.weekdayOrdinal = ordinal
        return self
    }

    /// 设置季度
    /// - Parameter quarter: 季度数值，范围为 1 到 4（1 表示第一季度，4 表示第四季度）
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_quarter(_ quarter: Int) -> Self {
        self.quarter = quarter
        return self
    }

    /// 设置当前月中的第几周
    /// - Parameter week: 周序号，从 1 开始计数
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_weekOfMonth(_ week: Int) -> Self {
        self.weekOfMonth = week
        return self
    }

    /// 设置当前年中的第几周
    /// - Parameter week: 周序号，从 1 开始计数
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_weekOfYear(_ week: Int) -> Self {
        self.weekOfYear = week
        return self
    }

    /// 设置时代（Era）
    /// - Parameter era: 时代标识符，例如公历中公元为 1，公元前为 0 或负值（具体取决于日历）
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_era(_ era: Int) -> Self {
        self.era = era
        return self
    }
}
