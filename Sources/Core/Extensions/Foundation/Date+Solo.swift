import Foundation

extension Date: SoloExtension {}

// MARK: - 共享对象
extension Date {
    /// 日历
    var calendar: Calendar {
        Calendar.current
    }

    /// 时区
    var timeZone: TimeZone {
        TimeZone.autoupdatingCurrent
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
            DateFormatter.solo.formatter(format: format)
        } else {
            DateFormatter.solo.iso8601()
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

// MARK: - 组件访问与设置
public extension SoloWrapper where Base == Date {
    /// 获取或设置当前日期的年份
    ///
    /// - 注意: 设置时若新值 ≤ 0,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.year = 2030  // 将年份设为 2030
    ///   print(date.solo.year)  // 输出：2030
    ///   ```
    var year: Int {
        get { base.calendar.component(.year, from: base) }
        set {
            guard newValue > 0 else { return }
            if let newDate = base.calendar.date(bySetting: .year, value: newValue, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期的月份(1 到 12)
    ///
    /// - 注意: 若设置值不在 1～12 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.month = 5  // 设置为五月
    ///   ```
    var month: Int {
        get { base.calendar.component(.month, from: base) }
        set {
            guard (1 ... 12).contains(newValue) else { return }
            if let newDate = base.calendar.date(bySetting: .month, value: newValue, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期在当月中的日(1 到该月最大天数)
    ///
    /// - 注意: 若设置值超出当前月份的有效范围(如 2 月设为 30 日),则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.day = 15  // 设置为当月 15 日
    ///   ```
    var day: Int {
        get { base.calendar.component(.day, from: base) }
        set {
            let dayRange = base.calendar.range(of: .day, in: .month, for: base) ?? (1 ..< 32)
            guard dayRange.contains(newValue) else { return }
            if let newDate = base.calendar.date(bySetting: .day, value: newValue, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期的小时(0 到 23,24 小时制)
    ///
    /// - 注意: 若设置值不在 0～23 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.hour = 14  // 设置为下午 2 点
    ///   ```
    var hour: Int {
        get { base.calendar.component(.hour, from: base) }
        set {
            guard (0 ... 23).contains(newValue) else { return }
            if let newDate = base.calendar.date(bySetting: .hour, value: newValue, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期的分钟(0 到 59)
    ///
    /// - 注意: 若设置值不在 0～59 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.minute = 30  // 设置为 30 分
    ///   ```
    var minute: Int {
        get { base.calendar.component(.minute, from: base) }
        set {
            guard (0 ... 59).contains(newValue) else { return }
            if let newDate = base.calendar.date(bySetting: .minute, value: newValue, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期的秒(0 到 59)
    ///
    /// - 注意: 若设置值不在 0～59 范围内,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.second = 45  // 设置为 45 秒
    ///   ```
    var second: Int {
        get { base.calendar.component(.second, from: base) }
        set {
            guard (0 ... 59).contains(newValue) else { return }
            if let newDate = base.calendar.date(bySetting: .second, value: newValue, of: base) {
                base = newDate
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
    ///   date.solo.millisecond = 500  // 设置为 500 毫秒
    ///   ```
    var millisecond: Int {
        get {
            let nanoseconds = base.calendar.component(.nanosecond, from: base)
            return nanoseconds / 1000000
        }
        set {
            let clampedValue = min(max(newValue, 0), 999)
            let nanoseconds = clampedValue * 1000000
            if let newDate = base.calendar.date(bySetting: .nanosecond, value: nanoseconds, of: base) {
                base = newDate
            }
        }
    }

    /// 获取或设置当前日期的纳秒(0 到 999,999,999)
    ///
    /// - 注意: 设置时会自动将值限制在有效范围内
    /// - Example:
    ///   ```swift
    ///   var date = Date()
    ///   date.solo.nanosecond = 123_456_789
    ///   ```
    var nanosecond: Int {
        get { base.calendar.component(.nanosecond, from: base) }
        set {
            let clampedValue = min(max(newValue, 0), 999999999)
            if let newDate = base.calendar.date(bySetting: .nanosecond, value: clampedValue, of: base) {
                base = newDate
            }
        }
    }
}

// MARK: - 格式化
public extension SoloWrapper where Base == Date {
    /// 将日期格式化为字符串
    /// - Parameters:
    ///   - format: 日期格式模板,默认为 `"yyyy-MM-dd HH:mm:ss"`
    ///   - locale: 指定地区
    ///   - timeZone: 指定时区,默认使用当前自动更新时区
    /// - Returns: 格式化后的字符串
    func toString(_ format: String = "yyyy-MM-dd HH:mm:ss",
                  locale: Locale = .current,
                  timeZone: TimeZone = .autoupdatingCurrent) -> String
    {
        let formatter = DateFormatter.solo.formatter(format: format, locale: locale, timeZone: timeZone)
        return formatter.string(from: base)
    }

    /// 将日期格式化为标准 ISO8601 字符串(UTC 时区)
    ///
    /// - Returns: 形如 `"2024-01-01T12:00:00.000Z"` 的字符串
    func toISO8601String() -> String {
        DateFormatter.solo.iso8601().string(from: base)
    }
}

// MARK: - 随机时间
public extension SoloWrapper where Base == Date {
    /// 在开区间 `(lower, upper)` 内生成随机日期
    static func random(in range: Range<Date>) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ..< upper)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 在闭区间 `[lower, upper]` 内生成随机日期
    static func random(in range: ClosedRange<Date>) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ... upper)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 使用自定义随机数生成器生成随机日期(开区间)
    static func random(
        in range: Range<Date>,
        using generator: inout some RandomNumberGenerator
    ) -> Date {
        let lower = range.lowerBound.timeIntervalSinceReferenceDate
        let upper = range.upperBound.timeIntervalSinceReferenceDate
        let randomInterval = TimeInterval.random(in: lower ..< upper, using: &generator)
        return Date(timeIntervalSinceReferenceDate: randomInterval)
    }

    /// 使用自定义随机数生成器生成随机日期(闭区间)
    static func random(
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
public extension SoloWrapper where Base == Date {
    /// 是否在未来(相对于调用时刻)
    /// - Returns: 若晚于当前时间,返回 `true`
    func isInFuture() -> Bool {
        base > Date()
    }

    /// 是否在过去(相对于调用时刻)
    /// - Returns: 若早于当前时间,返回 `true`
    func isInPast() -> Bool {
        base < Date()
    }

    /// 是否是今天
    /// - Returns: 若落在当前日历日,返回 `true`
    func isToday() -> Bool {
        base.calendar.isDateInToday(base)
    }

    /// 是否是昨天
    /// - Returns: 若落在昨天,返回 `true`
    func isYesterday() -> Bool {
        base.calendar.isDateInYesterday(base)
    }

    /// 是否是明天
    /// - Returns: 若落在明天,返回 `true`
    func isTomorrow() -> Bool {
        base.calendar.isDateInTomorrow(base)
    }

    /// 是否是周末
    /// - Returns: 若被系统日历视为周末(如周六/周日),返回 `true`
    /// - Note: 周末定义因地区而异
    func isWeekend() -> Bool {
        base.calendar.isDateInWeekend(base)
    }

    /// 是否是工作日(非周末)
    /// - Returns: 若不是周末,返回 `true`
    /// - Note: 不考虑法定节假日
    func isWorkday() -> Bool {
        !base.calendar.isDateInWeekend(base)
    }

    /// 是否在本周
    /// - Returns: 若与当前日期属于同一周(按 `.weekOfYear` 粒度),返回 `true`
    func isThisWeek() -> Bool {
        base.calendar.isDate(base, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 是否在本月
    /// - Returns: 若与当前日期属于同一月,返回 `true`
    func isThisMonth() -> Bool {
        base.calendar.isDate(base, equalTo: Date(), toGranularity: .month)
    }

    /// 是否在本年
    /// - Returns: 若与当前日期属于同年,返回 `true`
    func isThisYear() -> Bool {
        base.calendar.isDate(base, equalTo: Date(), toGranularity: .year)
    }

    /// 所在年份是否为闰年
    /// - Returns: 若年份满足闰年规则(能被4整除且不被100整除,或能被400整除),返回 `true`
    func isLeapYear() -> Bool {
        let year = Calendar.current.component(.year, from: base)
        return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)
    }

    /// 判断是否与另一日期处于同一天
    func isSameDay(as date: Date) -> Bool {
        base.calendar.isDate(base, inSameDayAs: date)
    }

    /// 判断是否在 `[startDate, endDate]` 区间内
    ///
    /// - Parameters:
    ///   - startDate: 起始日期
    ///   - endDate: 结束日期
    ///   - includeBounds: 是否包含边界(默认 `false`)
    func isBetween(_ startDate: Date, _ endDate: Date, includeBounds: Bool = false) -> Bool {
        if includeBounds {
            return base >= startDate && base <= endDate
        } else {
            return base > startDate && base < endDate
        }
    }

    /// 判断年、月、日是否完全相同
    func isSameYearMonthDay(as date: Date) -> Bool {
        let comps1 = base.calendar.dateComponents([.year, .month, .day], from: base)
        let comps2 = base.calendar.dateComponents([.year, .month, .day], from: date)
        return comps1 == comps2
    }

    /// 判断是否与当前时间在指定日历粒度上相等(如同年、同月)
    func isInCurrent(_ component: Calendar.Component) -> Bool {
        base.calendar.isDate(base, equalTo: Date(), toGranularity: component)
    }

    /// 判断与另一日期在指定组件上的绝对差值是否 ≤ 给定值
    func isWithin(_ value: Int, of component: Calendar.Component, comparedTo date: Date) -> Bool {
        guard let diff = self.componentDifference(to: date, in: component) else { return false }
        return Swift.abs(diff) <= value
    }
}

// MARK: - 时间戳(Timestamp)
public extension SoloWrapper where Base == Date {
    /// 获取当前时间的秒级 Unix 时间戳
    /// - Returns: 自 1970-01-01 UTC 起的秒数(整数)
    static func nowSecond() -> Int64 {
        Int64(Date().timeIntervalSince1970)
    }

    /// 返回当前日期的秒级 Unix 时间戳(UTC)
    /// - Returns: 秒级时间戳
    func secondsSince1970() -> TimeInterval {
        base.timeIntervalSince1970
    }

    /// 获取当前时间的毫秒级时间戳
    /// - Returns: 自 1970-01-01 UTC 起的毫秒数(四舍五入)
    static func nowMillisecond() -> Int64 {
        Int64(Darwin.round(Date().timeIntervalSince1970 * 1000))
    }

    /// 返回当前日期的毫秒级时间戳(UTC)
    /// - Returns: 毫秒级时间戳(四舍五入)
    func millisecondsSince1970() -> TimeInterval {
        base.timeIntervalSince1970 * 1000
    }

    /// 返回本地日历下的“伪秒级时间戳”(非标准,仅用于显示逻辑)
    /// - Returns: 假设当前时区为 UTC+0 时的时间戳
    /// - Warning: 此值`不是标准 Unix 时间戳`,不可用于网络传输
    func localSec() -> TimeInterval {
        let offset = TimeZone.current.secondsFromGMT(for: base)
        return base.timeIntervalSince1970 - offset.solo.toDouble()
    }

    /// 从时间戳字符串创建 `Date`
    /// - Parameter timestamp: 支持 10 位(秒)或 13 位(毫秒)字符串
    /// - Returns: 成功解析则返回 `Date`,否则返回 `nil`
    static func toDate(from timestamp: String) -> Date? {
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
    static func toString(from timestamp: String, format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        guard let date = self.toDate(from: timestamp) else { return "" }

        let formatter = DateFormatter.solo.formatter(format: format)
        return formatter.string(from: date)
    }
}

// MARK: - 常用方法
public extension SoloWrapper where Base == Date {
    /// 将当前日期`视为 UTC 时间`,并返回其在本地时区下的等效显示值
    ///
    /// - 注意：此方法会按当前时区偏移量调整绝对时间点(`timeIntervalSince1970`),并非仅调整显示
    ///   适用于将 API 返回的 UTC 字符串按本地时间展示(如 `"2024-01-01T08:00:00Z"` 显示为本地 16:00)
    /// - Returns: 本地时区下对应的日期对象(绝对时间点已偏移)
    func toLocal() -> Date {
        let offset = base.timeZone.secondsFromGMT(for: base)
        return base.addingTimeInterval(TimeInterval(offset))
    }

    /// 将当前日期`视为本地时间`,并返回其在 UTC 下的等效表示
    ///
    /// - 注意：此方法会按当前时区偏移量调整绝对时间点(`timeIntervalSince1970`)
    ///   适用于将用户选择的本地日历时间(如“今天 10:00”)转换为 UTC 存储
    /// - Returns: UTC 时区下对应的日期对象(绝对时间点已偏移)
    func toUTC() -> Date {
        let offset = base.timeZone.secondsFromGMT(for: base)
        return base.addingTimeInterval(-TimeInterval(offset))
    }

    /// 返回当前日期相对于现在的自然语言描述(中文)
    ///
    /// 支持“刚刚”、“3分钟前”、“明天”、“2个月后”等表达
    /// - Returns: 中文相对时间字符串
    func relativeString() -> String {
        let now = Date()
        let interval = now.timeIntervalSince(base)
        let isPast = interval > 0
        let absInterval = Swift.abs(interval)

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
        if self.isToday() {
            return "今天"
        }
        if self.isYesterday() {
            return "昨天"
        }
        if self.isTomorrow() {
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
    var weekday: Int {
        base.calendar.component(.weekday, from: base)
    }

    /// 获取中文星期名称(如“星期一”)
    var weekdayString: String {
        let weekdays = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let idx = self.weekday - 1
        guard idx >= 0, idx < weekdays.count else { return "" }
        return weekdays[idx]
    }

    /// 获取英文月份全称(如 "January")
    var monthString: String {
        self.toString("MMMM")
    }

    /// 获取本年第几周(ISO 周数,取决于日历配置)
    var weekOfYear: Int {
        base.calendar.component(.weekOfYear, from: base)
    }

    /// 获取本月第几周
    var weekOfMonth: Int {
        base.calendar.component(.weekOfMonth, from: base)
    }

    /// 获取当前日期所属的季度(1–4)
    var quarter: Int {
        (self.month - 1) / 3 + 1
    }

    /// 获取当前日期所属哪个年代
    var era: Int {
        return base.calendar.component(.era, from: base)
    }
}

// MARK: - 日期计算
public extension SoloWrapper where Base == Date {
    /// 返回昨天的日期
    func yesterday() -> Date? {
        base.calendar.date(byAdding: .day, value: -1, to: base)
    }

    /// 返回明天的日期
    func tomorrow() -> Date? {
        base.calendar.date(byAdding: .day, value: 1, to: base)
    }

    /// 返回指定天数偏移后的日期
    func adding(days: Int) -> Date? {
        base.calendar.date(byAdding: .day, value: days, to: base)
    }

    /// 返回最接近的 N 分钟整点(向上或向下取整,以更近为准)
    ///
    /// - Parameter minutes: 分钟间隔(必须 > 0),如 5、15、30
    /// - Returns: 对齐后的日期(秒和纳秒归零)
    func nearest(minutes: Int) -> Date? {
        guard minutes > 0 else { return nil }
        var comps = base.calendar.dateComponents([.year, .month, .day, .hour, .minute], from: base)
        guard let min = comps.minute else { return nil }
        let remainder = min % minutes
        let newMinute = remainder < minutes / 2 ? min - remainder : min + (minutes - remainder)
        comps.minute = newMinute
        comps.second = 0
        comps.nanosecond = 0
        return base.calendar.date(from: comps)
    }

    /// 最近的 5 分钟整点
    func nearest5Minutes() -> Date? {
        self.nearest(minutes: 5)
    }

    /// 最近的 10 分钟整点
    func nearest10Minutes() -> Date? {
        self.nearest(minutes: 10)
    }

    /// 最近的 15 分钟整点(一刻钟)
    func nearest15Minutes() -> Date? {
        self.nearest(minutes: 15)
    }

    /// 最近的 30 分钟整点
    func nearest30Minutes() -> Date? {
        self.nearest(minutes: 30)
    }

    /// 最近的整点小时(以 30 分钟为界：≤30 分 → 当前小时,>30 分 → 下一小时)
    func nearestHour() -> Date? {
        let min = self.minute
        let base = base.calendar.startOfDay(for: base)
        return min < 30 ? base : base.calendar.date(byAdding: .hour, value: 1, to: base)
    }

    /// 今天的起始时间(即当前日期,但通常配合其他方法使用)
    static var today: Date {
        Date()
    }

    /// 昨天
    static var yesterday: Date? {
        Date()
            .solo
            .yesterday()
    }

    /// 明天
    static var tomorrow: Date? {
        Date()
            .solo
            .tomorrow()
    }

    /// 前天
    static var dayBeforeYesterday: Date? {
        Date()
            .solo
            .adding(days: -2)
    }

    /// 后天
    static var dayAfterTomorrow: Date? {
        Date()
            .solo
            .adding(days: 2)
    }

    /// 获取指定年月的天数
    ///
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份(1–12)
    /// - Returns: 该月的总天数
    static func daysInMonth(year: Int, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) ? 29 : 28
        default: return 0
        }
    }

    /// 获取当前月份的天数
    static var currentMonthDays: Int {
        let now = Date()
        return self.daysInMonth(year: now.solo.year, month: now.solo.month)
    }

    /// 返回与另一日期相差的秒数(可正可负)
    func seconds(since date: Date) -> Double {
        base.timeIntervalSince(date)
    }

    /// 返回与另一日期相差的分钟数
    func minutes(since date: Date) -> Double {
        self.seconds(since: date) / 60
    }

    /// 返回与另一日期相差的小时数
    func hours(since date: Date) -> Double {
        self.seconds(since: date) / 3600
    }

    /// 返回与另一日期相差的天数
    func days(since date: Date) -> Double {
        self.seconds(since: date) / 86400
    }

    /// 返回两个日期在指定日历单位下的整数差值(如完整天数、月数等)
    ///
    /// - Parameters:
    ///   - date: 比较基准日期
    ///   - unit: 日历单位(如 `.day`, `.month`)
    /// - Returns: 差值(可能为 `nil`,如跨时区异常)
    func componentDifference(to date: Date, in unit: Calendar.Component) -> Int? {
        let components = base.calendar.dateComponents([unit], from: date, to: base)
        return components.value(for: unit)
    }
}

// MARK: - 常用方法
public extension SoloWrapper where Base == Date {
    /// 日期名称的显示样式
    ///
    /// - note: 此枚举用于统一控制月份和星期名称的格式,
    ///         对应常见的三种本地化形式：宽(完整)、缩写、窄(单字符)
    enum SoloDateNameStyle {
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
    func monthName(style: SoloDateNameStyle = .wide) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.calendar = base.calendar
        formatter.timeZone = base.timeZone

        // 提取当前月份(1 = January, ..., 12 = December)
        let month = base.calendar.component(.month, from: base)
        guard month >= 1, month <= 12 else { return "???" }
        let index = month - 1

        // 根据样式选择对应的符号数组
        let symbols: [String] = {
            switch style {
            case .narrow:
                // veryShortStandaloneMonthSymbols: 独立显示的极短形式(如 "J")
                return formatter.veryShortStandaloneMonthSymbols
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
    func dayName(style: SoloDateNameStyle = .wide) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.calendar = base.calendar
        formatter.timeZone = base.timeZone

        // weekday 组件：1=Sunday, 2=Monday, ..., 7=Saturday(由 calendar 决定)
        let weekday = base.calendar.component(.weekday, from: base)
        let index = weekday - 1

        // 根据样式选择对应的星期符号数组
        let symbols: [String] = {
            switch style {
            case .narrow:
                return formatter.veryShortStandaloneWeekdaySymbols
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
    func adding(_ component: Calendar.Component, value: Int) -> Date? {
        base.calendar.date(byAdding: component, value: value, to: base)
    }

    /// 将当前日期的指定组件设置为给定值(如将分钟设为 30)
    ///
    /// - Returns: 新日期,若值非法或无法设置则返回 `nil`
    func setting(_ component: Calendar.Component, to value: Int) -> Date? {
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
           let range = base.calendar.range(of: component, in: parent, for: base),
           !range.contains(value)
        {
            return nil // 提前失败
        }

        // 否则直接尝试设置(让系统判断)
        return base.calendar.date(bySetting: component, value: value, of: base)
    }

    /// 获取指定日历组件的起始时刻(如 `.day` → 00:00:00)
    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return base.calendar.startOfDay(for: base)
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

        let comps = base.calendar.dateComponents(neededComponents, from: base)
        return base.calendar.date(from: comps)
    }

    /// 获取指定日历组件的结束时刻(如 `.day` → 23:59:59)
    func end(of component: Calendar.Component) -> Date? {
        guard let next = self.adding(component, value: 1) else { return nil }
        guard let beginningOfNext = next.solo.beginning(of: component) else { return nil }
        return beginningOfNext.solo.adding(.second, value: -1)
    }
}
