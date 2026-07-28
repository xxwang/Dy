import Foundation

// MARK: - 共享对象
extension Date {
    /// 日历
    var dy_calendar: Calendar {
        Calendar.current
    }

    /// 时区
    var dy_timeZone: TimeZone {
        TimeZone.autoupdatingCurrent
    }
}

// MARK: - 组件访问与设置
public extension Date {
    /// 获取或设置当前日期的年份
    ///
    /// - 注意: 设置时若新值 ≤ 0,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.year = 2030  // 将年份设为 2030
    ///   print(date.dy_year)  // 输出：2030
    ///   ```
    var dy_year: Int {
        get { dy_calendar.component(.year, from: self) }
        set {
            guard newValue > 0 else { return }
            if let newDate = dy_calendar.date(bySetting: .year, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的月份(1 到 12)
    ///
    /// - 注意: 若设置值不在 1～12 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_month = 5  // 设置为五月
    ///   ```
    var dy_month: Int {
        get { dy_calendar.component(.month, from: self) }
        set {
            guard (1 ... 12).contains(newValue) else { return }
            if let newDate = dy_calendar.date(bySetting: .month, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期在当月中的日(1 到该月最大天数)
    ///
    /// - 注意: 若设置值超出当前月份的有效范围(如 2 月设为 30 日),则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_day = 15  // 设置为当月 15 日
    ///   ```
    var dy_day: Int {
        get { dy_calendar.component(.day, from: self) }
        set {
            let dayRange = dy_calendar.range(of: .day, in: .month, for: self) ?? (1 ..< 32)
            guard dayRange.contains(newValue) else { return }
            if let newDate = dy_calendar.date(bySetting: .day, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的小时(0 到 23,24 小时制)
    ///
    /// - 注意: 若设置值不在 0～23 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_hour = 14  // 设置为下午 2 点
    ///   ```
    var dy_hour: Int {
        get { dy_calendar.component(.hour, from: self) }
        set {
            guard (0 ... 23).contains(newValue) else { return }
            if let newDate = dy_calendar.date(bySetting: .hour, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的分钟(0 到 59)
    ///
    /// - 注意: 若设置值不在 0～59 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_minute = 30  // 设置为 30 分
    ///   ```
    var dy_minute: Int {
        get { dy_calendar.component(.minute, from: self) }
        set {
            guard (0 ... 59).contains(newValue) else { return }
            if let newDate = dy_calendar.date(bySetting: .minute, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的秒(0 到 59)
    ///
    /// - 注意: 若设置值不在 0～59 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_second = 45  // 设置为 45 秒
    ///   ```
    var dy_second: Int {
        get { dy_calendar.component(.second, from: self) }
        set {
            guard (0 ... 59).contains(newValue) else { return }
            if let newDate = dy_calendar.date(bySetting: .second, value: newValue, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的毫秒(0 到 999)
    ///
    /// - 注意: 实际存储单位为纳秒,毫秒通过除以 1,000,000 转换
    /// - 设置时会自动将值限制在 [0, 999] 范围内
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_millisecond = 500  // 设置为 500 毫秒
    ///   ```
    var dy_millisecond: Int {
        get {
            let nanoseconds = dy_calendar.component(.nanosecond, from: self)
            return nanoseconds / 1000000
        }
        set {
            let clampedValue = min(max(newValue, 0), 999)
            let nanoseconds = clampedValue * 1000000
            if let newDate = dy_calendar.date(bySetting: .nanosecond, value: nanoseconds, of: self) {
                self = newDate
            }
        }
    }

    /// 获取或设置当前日期的纳秒(0 到 999,999,999)
    ///
    /// - 注意: 设置时会自动将值限制在有效范围内
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.dy_nanosecond = 123_456_789
    ///   ```
    var dy_nanosecond: Int {
        get { dy_calendar.component(.nanosecond, from: self) }
        set {
            let clampedValue = min(max(newValue, 0), 999999999)
            if let newDate = dy_calendar.date(bySetting: .nanosecond, value: clampedValue, of: self) {
                self = newDate
            }
        }
    }
}

// MARK: - 构造方法
public extension Date {
    /// 使用指定的日历和日期组件创建 `Date` 实例
    ///
    /// - Parameters:
    ///   - calendar: 用于解析组件的日历,默认为 `.current`
    ///   - components: 包含年、月、日等信息的 `DateComponents`
    /// - Returns: 若能成功解析为有效日期,则返回 `Date`;否则返回 `nil`
    init?(calendar: Calendar? = .current, components: DateComponents) {
        guard let cal = calendar,
              let date = cal.date(from: components) else { return nil }
        self = date
    }

    /// 从日期字符串创建 `Date` 实例
    ///
    /// - Parameters:
    ///   - string: 日期字符串(如 `"2025-01-01T12:00:00.000Z"`)
    ///   - dateFormat: 日期格式若为 `nil`,则使用 ISO 8601 标准格式
    /// - Returns: 若字符串能被成功解析,则返回 `Date`;否则返回 `nil`
    init?(string: String, dateFormat: String? = nil) {
        let formatter: DateFormatter = if let format = dateFormat {
            .dy_formatter(format: format)
        } else {
            .dy_iso8601
        }
        guard let date = formatter.date(from: string) else { return nil }
        self = date
    }

    /// 从时间戳创建 `Date` 实例
    ///
    /// - Parameters:
    ///   - timestamp: 时间戳数值
    ///   - isUnix: 是否为 Unix 时间戳(以秒为单位)若为 `false`,则视为毫秒时间戳
    /// - Returns: 对应的 `Date` 实例
    init(timestamp: TimeInterval, isUnix: Bool = true) {
        let interval = isUnix ? timestamp : timestamp / 1000.0
        self.init(timeIntervalSince1970: interval)
    }
}

// MARK: - 格式化
public extension Date {
    /// 将日期格式化为字符串
    /// - Parameters:
    ///   - format: 日期格式模板,默认为 `"yyyy-MM-dd HH:mm:ss"`
    ///   - locale: 指定地区
    ///   - timeZone: 指定时区,默认使用当前自动更新时区
    /// - Returns: 格式化后的字符串
    func dy_toString(_ format: String = "yyyy-MM-dd HH:mm:ss",
                     locale: Locale = .current,
                     timeZone: TimeZone = .autoupdatingCurrent) -> String
    {
        let formatter = DateFormatter.dy_formatter(format: format, locale: locale, timeZone: timeZone)
        return formatter.string(from: self)
    }

    /// 将日期格式化为标准 ISO8601 字符串(UTC 时区)
    ///
    /// - Returns: 形如 `"2024-01-01T12:00:00.000Z"` 的字符串
    func dy_toISO8601String() -> String {
        DateFormatter.dy_iso8601.string(from: self)
    }
}

// MARK: - 随机时间
public extension Date {
    /// 在开区间 `(lower, upper)` 内生成随机日期
    static func dy_random(in range: Range<Date>) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ..< upper)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 在闭区间 `[lower, upper]` 内生成随机日期
    static func dy_random(in range: ClosedRange<Date>) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ... upper)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 使用自定义随机数生成器生成随机日期(开区间)
    static func dy_random(
        in range: Range<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ..< upper, using: &generator)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 使用自定义随机数生成器生成随机日期(闭区间)
    static func dy_random(
        in range: ClosedRange<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ... upper, using: &generator)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }
}

// MARK: - 日期判断
public extension Date {
    /// 是否在未来(相对于调用时刻)
    /// - Returns: 若晚于当前时间,返回 `true`
    func dy_isInFuture() -> Bool {
        self > Date()
    }

    /// 是否在过去(相对于调用时刻)
    /// - Returns: 若早于当前时间,返回 `true`
    func dy_isInPast() -> Bool {
        self < Date()
    }

    /// 是否是今天
    /// - Returns: 若落在当前日历日,返回 `true`
    func dy_isToday() -> Bool {
        dy_calendar.isDateInToday(self)
    }

    /// 是否是昨天
    /// - Returns: 若落在昨天,返回 `true`
    func dy_isYesterday() -> Bool {
        dy_calendar.isDateInYesterday(self)
    }

    /// 是否是明天
    /// - Returns: 若落在明天,返回 `true`
    func dy_isTomorrow() -> Bool {
        dy_calendar.isDateInTomorrow(self)
    }

    /// 是否是周末
    /// - Returns: 若被系统日历视为周末(如周六/周日),返回 `true`
    /// - Note: 周末定义因地区而异
    func dy_isWeekend() -> Bool {
        dy_calendar.isDateInWeekend(self)
    }

    /// 是否是工作日(非周末)
    /// - Returns: 若不是周末,返回 `true`
    /// - Note: 不考虑法定节假日
    func dy_isWorkday() -> Bool {
        !dy_calendar.isDateInWeekend(self)
    }

    /// 是否在本周
    /// - Returns: 若与当前日期属于同一周(按 `.weekOfYear` 粒度),返回 `true`
    func dy_isThisWeek() -> Bool {
        dy_calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 是否在本月
    /// - Returns: 若与当前日期属于同一月,返回 `true`
    func dy_isThisMonth() -> Bool {
        dy_calendar.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// 是否在本年
    /// - Returns: 若与当前日期属于同年,返回 `true`
    func dy_isThisYear() -> Bool {
        dy_calendar.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// 所在年份是否为闰年
    /// - Returns: 若年份满足闰年规则(能被4整除且不被100整除,或能被400整除),返回 `true`
    func dy_isLeapYear() -> Bool {
        let year = Calendar.current.component(.year, from: self)
        return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
    }

    /// 判断是否与另一日期处于同一天
    func dy_isSameDay(as date: Date) -> Bool {
        dy_calendar.isDate(self, inSameDayAs: date)
    }

    /// 判断是否在 `[startDate, endDate]` 区间内
    ///
    /// - Parameters:
    ///   - startDate: 起始日期
    ///   - endDate: 结束日期
    ///   - includeBounds: 是否包含边界(默认 `false`)
    func dy_isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return self >= startDate && self <= endDate
        } else {
            return self > startDate && self < endDate
        }
    }

    /// 判断年、月、日是否完全相同
    func dy_isSameYearMonthDay(as date: Date) -> Bool {
        let comps1 = dy_calendar.dateComponents([.year, .month, .day], from: self)
        let comps2 = dy_calendar.dateComponents([.year, .month, .day], from: date)
        return comps1 == comps2
    }

    /// 判断是否与当前时间在指定日历粒度上相等(如同年、同月)
    func dy_isInCurrent(_ component: Calendar.Component) -> Bool {
        dy_calendar.isDate(self, equalTo: Date(), toGranularity: component)
    }

    /// 判断与另一日期在指定组件上的绝对差值是否 ≤ 给定值
    func dy_isWithin(_ value: Int, of component: Calendar.Component, comparedTo date: Date) -> Bool {
        guard let diff = dy_componentDifference(to: date, in: component) else { return false }
        return abs(diff) <= value
    }
}

// MARK: - 时间戳(Timestamp)
public extension Date {
    /// 获取当前时间的秒级 Unix 时间戳
    /// - Returns: 自 1970-01-01 UTC 起的秒数(整数)
    static func dy_nowSecond() -> Int64 {
        Int64(Date().timeIntervalSince1970)
    }

    /// 返回当前日期的秒级 Unix 时间戳(UTC)
    /// - Returns: 秒级时间戳
    func dy_secondsSince1970() -> TimeInterval {
        timeIntervalSince1970
    }

    /// 获取当前时间的毫秒级时间戳
    /// - Returns: 自 1970-01-01 UTC 起的毫秒数(四舍五入)
    static func dy_nowMillisecond() -> Int64 {
        Int64(round(Date().timeIntervalSince1970 * 1000))
    }

    /// 返回当前日期的毫秒级时间戳(UTC)
    /// - Returns: 毫秒级时间戳(四舍五入)
    func dy_millisecondsSince1970() -> TimeInterval {
        timeIntervalSince1970 * 1000
    }

    /// 返回本地日历下的“伪秒级时间戳”(非标准,仅用于显示逻辑)
    /// - Returns: 假设当前时区为 UTC+0 时的时间戳
    /// - Warning: 此值`不是标准 Unix 时间戳`,不可用于网络传输
    func dy_localSec() -> TimeInterval {
        let offset = TimeZone.current.secondsFromGMT(for: self)
        return timeIntervalSince1970 - offset.dy_toDouble()
    }

    /// 从时间戳字符串创建 `Date`
    /// - Parameter timestamp: 支持 10 位(秒)或 13 位(毫秒)字符串
    /// - Returns: 成功解析则返回 `Date`,否则返回 `nil`
    static func dy_toDate(from timestamp: String) -> Date? {
        guard let value = Int64(timestamp) else { return nil }
        let interval: TimeInterval
        if timestamp.count == 10 {
            interval = TimeInterval(value)
        } else if timestamp.count == 13 {
            interval = TimeInterval(value) / 1000.0
        } else {
            return nil
        }
        return Date(timeIntervalSince1970: interval)
    }

    /// 将时间戳字符串转为格式化日期字符串
    /// - Parameters:
    ///   - timestamp: 时间戳字符串(10 或 13 位)
    ///   - format: 日期格式,默认 `"yyyy-MM-dd HH:mm:ss"`
    /// - Returns: 格式化后的字符串;若时间戳无效,返回空字符串
    static func dy_toString(from timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        guard let date = self.dy_toDate(from: timestamp) else { return "" }

        let formatter = DateFormatter.dy_iso8601
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

// MARK: - 常用方法
public extension Date {
    /// 将当前日期`视为 UTC 时间`,并返回其在本地时区下的等效显示值
    ///
    /// - 注意：此方法会按当前时区偏移量调整绝对时间点(`timeIntervalSince1970`),并非仅调整显示
    ///   适用于将 API 返回的 UTC 字符串按本地时间展示(如 `"2024-01-01T08:00:00Z"` 显示为本地 16:00)
    /// - Returns: 本地时区下对应的日期对象(绝对时间点已偏移)
    func dy_asLocal() -> Date {
        let offset = dy_timeZone.secondsFromGMT(for: self)
        return addingTimeInterval(TimeInterval(offset))
    }

    /// 将当前日期`视为本地时间`,并返回其在 UTC 下的等效表示
    ///
    /// - 注意：此方法会按当前时区偏移量调整绝对时间点(`timeIntervalSince1970`)
    ///   适用于将用户选择的本地日历时间(如“今天 10:00”)转换为 UTC 存储
    /// - Returns: UTC 时区下对应的日期对象(绝对时间点已偏移)
    func dy_asUTC() -> Date {
        let offset = dy_timeZone.secondsFromGMT(for: self)
        return addingTimeInterval(-TimeInterval(offset))
    }

    /// 返回当前日期相对于现在的自然语言描述(中文)
    ///
    /// 支持“刚刚”、“3分钟前”、“明天”、“2个月后”等表达
    /// - Returns: 中文相对时间字符串
    func dy_relativeString() -> String {
        let now = Date()
        let interval = now.timeIntervalSince(self)
        let isPast = interval > 0
        let absInterval = abs(interval)

        if absInterval < 60 {
            return isPast ? "刚刚" : "马上"
        }
        if absInterval < 3600 {
            let minutes = Int(absInterval / 60)
            return isPast ? "\(minutes)分钟前" : "\(minutes)分钟后"
        }
        if absInterval < 86400 {
            let hours = Int(absInterval / 3600)
            return isPast ? "\(hours)小时前" : "\(hours)小时后"
        }

        // 精确判断“昨天/今天/明天”
        if dy_isToday() {
            return "今天"
        }
        if dy_isYesterday() {
            return "昨天"
        }
        if dy_isTomorrow() {
            return "明天"
        }

        if absInterval < 2592000 { // < 30天
            let days = Int(absInterval / 86400)
            return isPast ? "\(days)天前" : "\(days)天后"
        }
        if absInterval < 31536000 { // < 1年
            let months = Int(absInterval / 2592000)
            return isPast ? "\(months)个月前" : "\(months)个月后"
        }

        let years = Int(absInterval / 31536000)
        return isPast ? "\(years)年前" : "\(years)年后"
    }

    /// 获取星期几(1=星期日, 2=星期一, ..., 7=星期六)
    var dy_weekday: Int {
        dy_calendar.component(.weekday, from: self)
    }

    /// 获取中文星期名称(如“星期一”)
    var dy_weekdayString: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let idx = dy_weekday - 1
        guard idx >= 0, idx < weekdays.count else { return "" }
        return weekdays[idx]
    }

    /// 获取英文月份全称(如 "January")
    var dy_monthString: String {
        self.dy_toString("MMMM")
    }

    /// 获取本年第几周(ISO 周数,取决于日历配置)
    var dy_weekOfYear: Int {
        dy_calendar.component(.weekOfYear, from: self)
    }

    /// 获取本月第几周
    var dy_weekOfMonth: Int {
        dy_calendar.component(.weekOfMonth, from: self)
    }

    /// 获取当前日期所属的季度(1–4)
    var dy_quarter: Int {
        (dy_month - 1) / 3 + 1
    }

    /// 获取当前日期所属哪个年代
    var dy_era: Int {
        return dy_calendar.component(.era, from: self)
    }
}

// MARK: - 日期计算
public extension Date {
    /// 返回昨天的日期
    func dy_yesterday() -> Date? {
        dy_calendar.date(byAdding: .day, value: -1, to: self)
    }

    /// 返回明天的日期
    func dy_tomorrow() -> Date? {
        dy_calendar.date(byAdding: .day, value: 1, to: self)
    }

    /// 返回指定天数偏移后的日期
    func dy_adding(days: Int) -> Date? {
        dy_calendar.date(byAdding: .day, value: days, to: self)
    }

    /// 返回最接近的 N 分钟整点(向上或向下取整,以更近为准)
    ///
    /// - Parameter minutes: 分钟间隔(必须 > 0),如 5、15、30
    /// - Returns: 对齐后的日期(秒和纳秒归零)
    func dy_nearest(minutes: Int) -> Date? {
        guard minutes > 0 else { return nil }
        var comps = dy_calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        guard let min = comps.minute else { return nil }
        let remainder = min % minutes
        let newMinute = remainder < minutes / 2 ? min - remainder : min + (minutes - remainder)
        comps.minute = newMinute
        comps.second = 0
        comps.nanosecond = 0
        return dy_calendar.date(from: comps)
    }

    /// 最近的 5 分钟整点
    func dy_nearest5Minutes() -> Date? {
        dy_nearest(minutes: 5)
    }

    /// 最近的 10 分钟整点
    func dy_nearest10Minutes() -> Date? {
        dy_nearest(minutes: 10)
    }

    /// 最近的 15 分钟整点(一刻钟)
    func dy_nearest15Minutes() -> Date? {
        dy_nearest(minutes: 15)
    }

    /// 最近的 30 分钟整点
    func dy_nearest30Minutes() -> Date? {
        dy_nearest(minutes: 30)
    }

    /// 最近的整点小时(以 30 分钟为界：≤30 分 → 当前小时,>30 分 → 下一小时)
    func dy_nearestHour() -> Date? {
        let min = dy_minute
        let base = dy_calendar.startOfDay(for: self)
        return min < 30 ? base : dy_calendar.date(byAdding: .hour, value: 1, to: base)
    }

    /// 今天的起始时间(即当前日期,但通常配合其他方法使用)
    static var dy_today: Date {
        Date()
    }

    /// 昨天
    static var dy_yesterday: Date? {
        Date().dy_yesterday()
    }

    /// 明天
    static var dy_tomorrow: Date? {
        Date().dy_tomorrow()
    }

    /// 前天
    static var dy_dayBeforeYesterday: Date? {
        Date().dy_adding(days: -2)
    }

    /// 后天
    static var dy_dayAfterTomorrow: Date? {
        Date().dy_adding(days: 2)
    }

    /// 获取指定年月的天数
    ///
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份(1–12)
    /// - Returns: 该月的总天数
    static func dy_daysInMonth(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) ? 29 : 28
        default: return 0
        }
    }

    /// 获取当前月份的天数
    static var dy_currentMonthDays: Int {
        let now = Date()
        return dy_daysInMonth(year: now.dy_year, month: now.dy_month)
    }

    /// 返回与另一日期相差的秒数(可正可负)
    func dy_seconds(since date: Date) -> Double {
        timeIntervalSince(date)
    }

    /// 返回与另一日期相差的分钟数
    func dy_minutes(since date: Date) -> Double {
        dy_seconds(since: date) / 60
    }

    /// 返回与另一日期相差的小时数
    func dy_hours(since date: Date) -> Double {
        dy_seconds(since: date) / 3600
    }

    /// 返回与另一日期相差的天数
    func dy_days(since date: Date) -> Double {
        dy_seconds(since: date) / 86400
    }

    /// 返回两个日期在指定日历单位下的整数差值(如完整天数、月数等)
    ///
    /// - Parameters:
    ///   - date: 比较基准日期
    ///   - unit: 日历单位(如 `.day`, `.month`)
    /// - Returns: 差值(可能为 `nil`,如跨时区异常)
    func dy_componentDifference(to date: Date, in unit: Calendar.Component) -> Int? {
        let components = dy_calendar.dateComponents([unit], from: date, to: self)
        return components.value(for: unit)
    }
}

// MARK: - 常用方法
public extension Date {
    /// 日期名称的显示样式
    ///
    /// - note: 此枚举用于统一控制月份和星期名称的格式,
    ///         对应常见的三种本地化形式：宽(完整)、缩写、窄(单字符)
    enum DyDateNameStyle {
        case narrow // 窄形式,如 "J"(January)、"T"(Thursday),通常为单个字符(iOS 13+ 支持)
        case abbreviated // 缩写形式,如 "Jan"、"Thu"
        case wide // 宽形式(完整名称),如 "January"、"Thursday"
    }

    /// 获取当前日期的本地化月份名称
    ///
    /// - Parameter style: 名称显示样式,默认为 `.wide`(完整名称)
    /// - Returns: 对应样式的月份名称字符串(如 "January"、"Jan" 或 "J")
    /// - Note:
    ///   - 使用 `standalone` 形式的符号(如 `veryShortStandaloneMonthSymbols`),
    ///     因为这些名称是独立显示的(例如在日历或选择器中),而非嵌入句子
    ///   - 在 iOS 13 之前,系统不提供 `veryShort...` 符号,窄样式会回退到缩写形式
    func dy_monthName(style: DyDateNameStyle = .wide) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.calendar = dy_calendar
        formatter.timeZone = dy_timeZone

        // 提取当前月份(1 = January, ..., 12 = December)
        let month = dy_calendar.component(.month, from: self)
        guard month >= 1, month <= 12 else { return "???" }
        let index = month - 1

        // 根据样式选择对应的符号数组
        let symbols: [String] = {
            switch style {
            case .narrow:
                // veryShortStandaloneMonthSymbols: 独立显示的极短形式(如 "J")
                if #available(iOS 13.0, macOS 10.15, *) {
                    return formatter.veryShortStandaloneMonthSymbols
                } else {
                    // 旧系统无此属性,回退到缩写
                    return formatter.shortMonthSymbols
                }
            case .abbreviated:
                // shortMonthSymbols: 如 "Jan", "Feb"
                return formatter.shortMonthSymbols
            case .wide:
                // monthSymbols: 如 "January", "February"
                return formatter.monthSymbols
            }
        }()

        // 安全访问数组,防止越界
        return index < symbols.count ? symbols[index] : "?"
    }

    /// 获取当前日期的本地化星期名称
    ///
    /// - Parameter style: 名称显示样式,默认为 `.wide`(完整名称)
    /// - Returns: 对应样式的星期名称字符串(如 "Thursday"、"Thu" 或 "T")
    /// - Note:
    ///   - 星期索引以 `星期日为起始(0)`,符合 `DateFormatter` 的符号数组顺序
    ///   - 同样优先使用 `standalone` 形式的窄符号(iOS 13+)
    ///   - 若需“周一作为一周开始”的逻辑,请勿在此处理——名称数组顺序由 locale 决定,
    ///     而非业务逻辑
    func dy_dayName(style: DyDateNameStyle = .wide) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.calendar = dy_calendar
        formatter.timeZone = dy_timeZone

        // weekday 组件：1=Sunday, 2=Monday, ..., 7=Saturday(由 calendar 决定)
        let weekday = dy_calendar.component(.weekday, from: self)
        let index = weekday - 1

        // 根据样式选择对应的星期符号数组
        let symbols: [String] = {
            switch style {
            case .narrow:
                if #available(iOS 13.0, macOS 10.15, *) {
                    return formatter.veryShortStandaloneWeekdaySymbols
                } else {
                    return formatter.shortWeekdaySymbols
                }
            case .abbreviated:
                return formatter.shortWeekdaySymbols // 如 "Sun", "Mon"
            case .wide:
                return formatter.weekdaySymbols // 如 "Sunday", "Monday"
            }
        }()

        return index < symbols.count ? symbols[index] : "?"
    }

    /// 在当前日期上增加指定日历组件的值
    ///
    /// - Returns: 新日期,若无法计算则返回 `nil`
    func dy_adding(_ component: Calendar.Component, value: Int) -> Date? {
        dy_calendar.date(byAdding: component, value: value, to: self)
    }

    /// 将当前日期的指定组件设置为给定值(如将分钟设为 30)
    ///
    /// - Returns: 新日期,若值非法或无法设置则返回 `nil`
    func dy_setting(_ component: Calendar.Component, to value: Int) -> Date? {
        let parent: Calendar.Component? = {
            switch component {
            case .second: return .minute
            case .minute: return .hour
            case .hour: return .day
            case .day: return .month
            case .month: return .year
            case .year: return .era
            default: return nil // 如 .weekday 不适合此操作
            }
        }()

        // 如果有父单位,校验范围
        if let parent,
           let range = dy_calendar.range(of: component, in: parent, for: self),
           !range.contains(value)
        {
            return nil // 提前失败
        }

        // 否则直接尝试设置(让系统判断)
        return dy_calendar.date(bySetting: component, value: value, of: self)
    }

    /// 获取指定日历组件的起始时刻(如 `.day` → 00:00:00)
    func dy_beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return dy_calendar.startOfDay(for: self)
        }

        var neededComponents: Set<Calendar.Component> = []
        switch component {
        case .second: neededComponents = [.year, .month, .day, .hour, .minute, .second]
        case .minute: neededComponents = [.year, .month, .day, .hour, .minute]
        case .hour: neededComponents = [.year, .month, .day, .hour]
        case .weekOfMonth, .weekOfYear: neededComponents = [.yearForWeekOfYear, .weekOfYear]
        case .month: neededComponents = [.year, .month]
        case .year: neededComponents = [.year]
        default: return nil
        }

        let comps = dy_calendar.dateComponents(neededComponents, from: self)
        return dy_calendar.date(from: comps)
    }

    /// 获取指定日历组件的结束时刻(如 `.day` → 23:59:59)
    func dy_end(of component: Calendar.Component) -> Date? {
        guard let next = dy_adding(component, value: 1) else { return nil }
        guard let beginningOfNext = next.dy_beginning(of: component) else { return nil }
        return beginningOfNext.dy_adding(.second, value: -1)
    }
}

// MARK: - 链式设置
public extension Date {
    /// 设置日期的年份
    ///
    /// - Parameter year: 目标年份(必须为正整数,例如 `2024`)
    /// - Returns: 更新后的 `Date` 实例若指定年份无效(如 ≤ 0)或无法生成有效日期,则返回原日期
    /// - Note: 使用日历的 `date(bySetting:value:of:)` 方法进行安全设置,不会因跨月/跨年导致日期偏移
    @discardableResult
    mutating func dy_year(_ year: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .year, value: year, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的月份
    ///
    /// - Parameter month: 目标月份,取值范围为 `1`(一月)到 `12`(十二月)
    /// - Returns: 更新后的 `Date` 实例若 `month` 超出有效范围或导致无效日期(如 2 月 30 日),则返回原日期
    /// - Note: 自动处理不同月份的天数差异(例如将 1 月 31 日设为 2 月,会调整为 2 月最后一天)
    @discardableResult
    mutating func dy_month(_ month: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .month, value: month, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期在当月中的日
    ///
    /// - Parameter day: 目标日,取值范围通常为 `1` 到 `31`,具体取决于当前月份和年份
    /// - Returns: 更新后的 `Date` 实例若 `day` 超出该月有效天数(如 2 月设为 30 日),则返回原日期
    /// - Note: 支持闰年等日历规则,由系统日历自动校验有效性
    @discardableResult
    mutating func dy_day(_ day: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .day, value: day, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的小时(24 小时制)
    ///
    /// - Parameter hour: 目标小时,取值范围为 `0`(午夜)到 `23`(晚上 11 点)
    /// - Returns: 更新后的 `Date` 实例若 `hour` 不在 `[0, 23]` 范围内,则返回原日期
    @discardableResult
    mutating func dy_hour(_ hour: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .hour, value: hour, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的分钟
    ///
    /// - Parameter minute: 目标分钟,取值范围为 `0` 到 `59`
    /// - Returns: 更新后的 `Date` 实例若 `minute` 不在有效范围内,则返回原日期
    @discardableResult
    mutating func dy_minute(_ minute: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .minute, value: minute, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的秒
    ///
    /// - Parameter second: 目标秒,取值范围为 `0` 到 `59`
    /// - Returns: 更新后的 `Date` 实例若 `second` 不在有效范围内,则返回原日期
    @discardableResult
    mutating func dy_second(_ second: Int) -> Self {
        if let newDate = self.dy_calendar.date(bySetting: .second, value: second, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的毫秒
    ///
    /// - Parameter millisecond: 目标毫秒,取值范围为 `0` 到 `999`
    /// - Returns: 更新后的 `Date` 实例若 `millisecond` 超出有效范围,则返回原日期
    /// - Note: 内部通过纳秒实现(1 毫秒 = 1,000,000 纳秒)设置时会覆盖原有的纳秒部分
    @discardableResult
    mutating func dy_millisecond(_ millisecond: Int) -> Self {
        guard millisecond >= 0, millisecond <= 999 else { return self }
        let nanoseconds = millisecond * 1000000
        if let newDate = self.dy_calendar.date(bySetting: .nanosecond, value: nanoseconds, of: self) {
            self = newDate
        }
        return self
    }

    /// 设置日期的纳秒
    ///
    /// - Parameter nanosecond: 目标纳秒,取值范围为 `0` 到 `999,999,999`
    /// - Returns: 更新后的 `Date` 实例若 `nanosecond` 超出有效范围,则返回原日期
    /// - Note: 纳秒是 `Date` 支持的最高精度时间单位
    @discardableResult
    mutating func dy_nanosecond(_ nanosecond: Int) -> Self {
        guard nanosecond >= 0, nanosecond < 1000000000 else { return self }
        if let newDate = self.dy_calendar.date(bySetting: .nanosecond, value: nanosecond, of: self) {
            self = newDate
        }
        return self
    }
}
