import Foundation

extension Calendar: SoloExtension {}

// MARK: - 月份与年份操作
public extension SoloWrapper where Base == Calendar {
    /// 获取指定日期所在月份的总天数
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 该月的天数(如 28, 29, 30, 31);若无法计算则返回 0
    ///
    /// - Example:
    ///   ```swift
    ///   let days = Calendar.current.solo.daysInMonth(for: someDate)
    ///   print("当月有 \(days) 天")
    ///   ```
    func daysInMonth(for date: Date = Date()) -> Int {
        guard let range = base.range(of: .day, in: .month, for: date) else {
            return 0
        }
        return range.count
    }

    /// 获取指定年份和月份的第一天(00:00:00)
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份(1-12)
    /// - Returns: 该月第一天的 `Date`,失败时返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let start = Calendar.current.solo.startOfMonth(year: 2024, month: 12) {
    ///       print("2024年12月开始: \(start)")
    ///   }
    ///   ```
    func startOfMonth(year: Int, month: Int) -> Date? {
        let comps = DateComponents(calendar: base, year: year, month: month, day: 1)
        return base.date(from: comps)
    }

    /// 获取指定年份和月份的最后一天(23:59:59)
    /// - Parameters:
    ///   - year: 年份
    ///   - month: 月份(1-12)
    /// - Returns: 该月最后时刻的 `Date`,失败时返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let end = Calendar.current.solo.endOfMonth(year: 2024, month: 2) {
    ///       print("2024年2月结束: \(end)")
    ///   }
    ///   ```
    func endOfMonth(year: Int, month: Int) -> Date? {
        guard let start = self.startOfMonth(year: year, month: month),
              let next = base.date(byAdding: .month, value: 1, to: start)
        else {
            return nil
        }
        return next.addingTimeInterval(-1)
    }

    /// 判断指定日期所在年份是否为闰年
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: `true` 表示是闰年
    ///
    /// - Example:
    ///   ```swift
    ///   let isLeap = Calendar.current.solo.isLeapYear(for: Date())
    ///   print("今年是闰年吗？\(isLeap)")
    ///   ```
    func isLeapYear(for date: Date = Date()) -> Bool {
        let daysInYear = base.range(of: .day, in: .year, for: date)?.count ?? 0
        return daysInYear == 366
    }
}

// MARK: - 周相关操作
public extension SoloWrapper where Base == Calendar {
    /// 获取指定日期所在周的起始日(根据日历的 firstWeekday 设置,如周日或周一)
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 本周第一天的 `Date`,失败时返回 `nil`
    ///
    /// - Note: 在美国日历中通常是周日,在中国日历中通常是周一
    ///
    /// - Example:
    ///   ```swift
    ///   if let weekStart = Calendar.current.solo.startOfWeek() {
    ///       print("本周从: \(weekStart)")
    ///   }
    ///   ```
    func startOfWeek(for date: Date = Date()) -> Date? {
        let components = base.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return base.date(from: components)
    }

    /// 强制获取指定日期所在周的周一(忽略系统日历设置)
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 本周周一的 `Date`,失败时返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let monday = Calendar.current.solo.mondayOfWeek() {
    ///       print("本周一是: \(monday)")
    ///   }
    ///   ```
    func mondayOfWeek(for date: Date = Date()) -> Date? {
        var cal = base
        cal.firstWeekday = 2 // Monday
        let components = cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return cal.date(from: components)
    }

    /// 获取指定日期所在周的全部 7 天(从周日或周一开始,依日历而定)
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 包含 7 个 `Date` 的数组
    ///
    /// - Example:
    ///   ```swift
    ///   let weekDates = Calendar.current.solo.datesInWeek()
    ///   weekDates.forEach { print($0) }
    ///   ```
    func datesInWeek(for date: Date = Date()) -> [Date] {
        guard let start = self.startOfWeek(for: date) else { return [] }
        return (0 ..< 7).compactMap { offset in
            base.date(byAdding: .day, value: offset, to: start)
        }
    }
}

// MARK: - 日期比较与判断
public extension SoloWrapper where Base == Calendar {
    /// 判断两个日期是否是同一天(忽略时间部分)
    /// - Parameters:
    ///   - date1: 第一个日期
    ///   - date2: 第二个日期
    /// - Returns: `true` 表示是同一天
    ///
    /// - Example:
    ///   ```swift
    ///   let same = Calendar.current.solo.isSameDay(date1, date2)
    ///   ```
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        return base.isDate(date1, equalTo: date2, toGranularity: .day)
    }

    /// 判断指定日期是否是今天
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示是今天
    func isToday(_ date: Date) -> Bool {
        return base.isDateInToday(date)
    }

    /// 判断指定日期是否是昨天
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示是昨天
    func isYesterday(_ date: Date) -> Bool {
        return base.isDateInYesterday(date)
    }

    /// 判断指定日期是否是明天
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示是明天
    func isTomorrow(_ date: Date) -> Bool {
        return base.isDateInTomorrow(date)
    }

    /// 判断指定日期是否在本周内
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示在本周
    func isThisWeek(_ date: Date) -> Bool {
        return base.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// 判断指定日期是否在本月内
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示在本月
    func isThisMonth(_ date: Date) -> Bool {
        return base.isDate(date, equalTo: Date(), toGranularity: .month)
    }

    /// 判断指定日期是否在今年内
    /// - Parameter date: 要判断的日期
    /// - Returns: `true` 表示在今年
    func isThisYear(_ date: Date) -> Bool {
        return base.isDate(date, equalTo: Date(), toGranularity: .year)
    }
}

// MARK: - 序数与范围
public extension SoloWrapper where Base == Calendar {
    /// 获取指定日期在当月中的第几周
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 周序号(1 表示第一周)
    ///
    /// - Example:
    ///   ```swift
    ///   let week = Calendar.current.solo.weekOfMonth()
    ///   print("今天是本月第 \(week) 周")
    ///   ```
    func weekOfMonth(for date: Date = Date()) -> Int {
        return base.component(.weekOfMonth, from: date)
    }

    /// 获取某月第 N 周的起止日期(时间范围)
    /// - Parameters:
    ///   - week: 周序号(1 起)
    ///   - year: 年份
    ///   - month: 月份(1-12)
    /// - Returns: 元组 `(start, end)`,`end` 精确到 23:59:59;失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let range = Calendar.current.solo.rangeOfWeek(2, inMonth: 2024, 12) {
    ///       print("第2周: \(range.start) ～ \(range.end)")
    ///   }
    ///   ```
    func rangeOfWeek(_ week: Int, inMonth year: Int, _ month: Int) -> (start: Date, end: Date)? {
        guard let firstDay = DateComponents(calendar: base, year: year, month: month, day: 1).date,
              let weekStart = base.date(byAdding: .weekOfMonth, value: week - 1, to: firstDay)
        else {
            return nil
        }
        guard let weekEndBase = base.date(byAdding: .day, value: 6, to: weekStart) else {
            return (weekStart, weekStart)
        }
        let weekEnd = weekEndBase.addingTimeInterval(86399) // 23:59:59
        return (weekStart, weekEnd)
    }
}

// MARK: - 迭代与生成
public extension SoloWrapper where Base == Calendar {
    /// 生成从指定日期开始的连续 N 天(包含起始日)
    /// - Parameters:
    ///   - date: 起始日期,默认为当前时间
    ///   - count: 天数(必须 > 0)
    /// - Returns: `Date` 数组
    ///
    /// - Example:
    ///   ```swift
    ///   let next7Days = Calendar.current.solo.nextDays(count: 7)
    ///   ```
    func nextDays(from date: Date = Date(), count: Int) -> [Date] {
        guard count > 0 else { return [] }
        return (0 ..< count).compactMap { offset in
            base.date(byAdding: .day, value: offset, to: date)
        }
    }

    /// 生成指定日期之前的连续 N 天(按时间升序排列)
    /// - Parameters:
    ///   - date: 结束日期,默认为当前时间
    ///   - count: 天数(必须 > 0)
    /// - Returns: `Date` 数组(最早日期在前)
    ///
    /// - Example:
    ///   ```swift
    ///   let last7Days = Calendar.current.solo.previousDays(count: 7)
    ///   ```
    func previousDays(from date: Date = Date(), count: Int) -> [Date] {
        guard count > 0 else { return [] }
        return (0 ..< count).compactMap { offset in
            base.date(byAdding: .day, value: -offset, to: date)
        }.reversed()
    }

    /// 生成从当前月开始的未来 12 个月的年月对
    /// - Parameter from: 起始日期,默认为当前时间
    /// - Returns: 数组,每个元素为 `(year, month)`
    ///
    /// - Example:
    ///   ```swift
    ///   let months = Calendar.current.solo.next12Months()
    ///   months.forEach { print("\($0.year)-\($0.month)") }
    ///   ```
    func next12Months(from date: Date = Date()) -> [(year: Int, month: Int)] {
        return (0 ..< 12).compactMap { offset in
            guard let future = base.date(byAdding: .month, value: offset, to: date),
                  let comp = base.dateComponents([.year, .month], from: future).date
            else {
                return nil
            }
            let c = base.dateComponents([.year, .month], from: comp)
            guard let year = c.year, let month = c.month else {
                return nil
            }
            return (year, month)
        }
    }
}

// MARK: - 高级计算
public extension SoloWrapper where Base == Calendar {
    /// 计算从出生日期到参考日期的年龄(整年)
    /// - Parameters:
    ///   - birthDate: 出生日期
    ///   - referenceDate: 参考日期,默认为当前时间
    /// - Returns: 年龄(整数)
    ///
    /// - Example:
    ///   ```swift
    ///   let age = Calendar.current.solo.age(from: birthday)
    ///   ```
    func age(from birthDate: Date, at referenceDate: Date = Date()) -> Int {
        return base.dateComponents([.year], from: birthDate, to: referenceDate).year ?? 0
    }

    /// 获取指定日期所在季度的起止日期
    /// - Parameter date: 目标日期,默认为当前时间
    /// - Returns: 元组 `(start, end)`,`end` 精确到 23:59:59;失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let q = Calendar.current.solo.quarterRange() {
    ///       print("本季度: \(q.start) ～ \(q.end)")
    ///   }
    ///   ```
    func quarterRange(for date: Date = Date()) -> (start: Date, end: Date)? {
        let month = base.component(.month, from: date)
        let quarter = ((month - 1) / 3) + 1
        let startMonth = (quarter - 1) * 3 + 1
        let year = base.component(.year, from: date)

        guard let start = DateComponents(calendar: base, year: year, month: startMonth, day: 1).date,
              let nextQuarter = base.date(byAdding: .month, value: 3, to: start)
        else {
            return nil
        }
        let end = nextQuarter.addingTimeInterval(-1)
        return (start, end)
    }
}

// MARK: - 工具方法
public extension SoloWrapper where Base == Calendar {
    /// 安全获取多个日期组件(语法糖,减少样板代码)
    /// - Parameters:
    ///   - components: 要获取的组件集合
    ///   - date: 目标日期
    /// - Returns: `DateComponents` 对象
    ///
    /// - Example:
    ///   ```swift
    ///   let comps = Calendar.current.solo.components([.year, .month], from: Date())
    ///   ```
    func components(_ components: Set<Calendar.Component>, from date: Date) -> DateComponents {
        return base.dateComponents(components, from: date)
    }

    /// 获取指定日期是星期几(1=星期日,2=星期一,..., 7=星期六)
    func weekday(for date: Date = Date()) -> Int {
        return base.component(.weekday, from: date)
    }

    /// 获取指定日期所在月的第一天(00:00:00)
    func startOfMonth(for date: Date = Date()) -> Date? {
        return base.date(from: base.dateComponents([.year, .month], from: date))
    }

    /// 获取指定日期所在月的最后一天(23:59:59)
    func endOfMonth(for date: Date = Date()) -> Date? {
        guard let startOfMonth = self.startOfMonth(for: date),
              let startOfNextMonth = base.date(byAdding: .month, value: 1, to: startOfMonth)
        else {
            return nil
        }
        return startOfNextMonth.addingTimeInterval(-1)
    }

    /// 计算两个日期之间的天数差(endDate - startDate)
    /// - Returns: 正数表示 endDate 在 startDate 之后,负数表示之前
    func daysBetween(startDate: Date, endDate: Date) -> Int {
        return base.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }

    /// 获取上一个月的同一天(自动调整无效日期)
    func previousMonth(for date: Date = Date()) -> Date? {
        return base.date(byAdding: .month, value: -1, to: date)
    }

    /// 获取下一个月的同一天(自动调整无效日期)
    func nextMonth(for date: Date = Date()) -> Date? {
        return base.date(byAdding: .month, value: 1, to: date)
    }
}
