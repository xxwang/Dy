import Foundation

// MARK: - 链式设置
public extension SoloWrapper where Base == Date {
    /// 设置日期的年份
    ///
    /// - Parameter year: 目标年份(必须为正整数,例如 `2024`)
    /// - Returns: 更新后的 `Date` 实例若指定年份无效(如 ≤ 0)或无法生成有效日期,则返回原日期
    /// - Note: 使用日历的 `date(bySetting:value:of:)` 方法进行安全设置,不会因跨月/跨年导致日期偏移
    @discardableResult
    func year(_ year: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .year, value: year, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的月份
    ///
    /// - Parameter month: 目标月份,取值范围为 `1`(一月)到 `12`(十二月)
    /// - Returns: 更新后的 `Date` 实例若 `month` 超出有效范围或导致无效日期(如 2 月 30 日),则返回原日期
    /// - Note: 自动处理不同月份的天数差异(例如将 1 月 31 日设为 2 月,会调整为 2 月最后一天)
    @discardableResult
    func month(_ month: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .month, value: month, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期在当月中的日
    ///
    /// - Parameter day: 目标日,取值范围通常为 `1` 到 `31`,具体取决于当前月份和年份
    /// - Returns: 更新后的 `Date` 实例若 `day` 超出该月有效天数(如 2 月设为 30 日),则返回原日期
    /// - Note: 支持闰年等日历规则,由系统日历自动校验有效性
    @discardableResult
    func day(_ day: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .day, value: day, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的小时(24 小时制)
    ///
    /// - Parameter hour: 目标小时,取值范围为 `0`(午夜)到 `23`(晚上 11 点)
    /// - Returns: 更新后的 `Date` 实例若 `hour` 不在 `[0, 23]` 范围内,则返回原日期
    @discardableResult
    func hour(_ hour: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .hour, value: hour, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的分钟
    ///
    /// - Parameter minute: 目标分钟,取值范围为 `0` 到 `59`
    /// - Returns: 更新后的 `Date` 实例若 `minute` 不在有效范围内,则返回原日期
    @discardableResult
    func minute(_ minute: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .minute, value: minute, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的秒
    ///
    /// - Parameter second: 目标秒,取值范围为 `0` 到 `59`
    /// - Returns: 更新后的 `Date` 实例若 `second` 不在有效范围内,则返回原日期
    @discardableResult
    func second(_ second: Int) -> Self {
        if let newDate = base.calendar.date(bySetting: .second, value: second, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的毫秒
    ///
    /// - Parameter millisecond: 目标毫秒,取值范围为 `0` 到 `999`
    /// - Returns: 更新后的 `Date` 实例若 `millisecond` 超出有效范围,则返回原日期
    /// - Note: 内部通过纳秒实现(1 毫秒 = 1,000,000 纳秒)设置时会覆盖原有的纳秒部分
    @discardableResult
    func millisecond(_ millisecond: Int) -> Self {
        guard millisecond >= 0, millisecond <= 999 else { return self }
        let nanoseconds = millisecond * 1000000
        if let newDate = base.calendar.date(bySetting: .nanosecond, value: nanoseconds, of: base) {
            base = newDate
        }
        return self
    }

    /// 设置日期的纳秒
    ///
    /// - Parameter nanosecond: 目标纳秒,取值范围为 `0` 到 `999,999,999`
    /// - Returns: 更新后的 `Date` 实例若 `nanosecond` 超出有效范围,则返回原日期
    /// - Note: 纳秒是 `Date` 支持的最高精度时间单位
    @discardableResult
    func nanosecond(_ nanosecond: Int) -> Self {
        guard nanosecond >= 0, nanosecond < 1000000000 else { return self }
        if let newDate = base.calendar.date(bySetting: .nanosecond, value: nanosecond, of: base) {
            base = newDate
        }
        return self
    }
}
