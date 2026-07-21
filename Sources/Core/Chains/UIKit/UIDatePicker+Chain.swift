import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone: 时间
    /// - Returns: `Self`
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        base.timeZone = timeZone
        return self
    }

    /// 设置日期选择器模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func datePickerMode(_ mode: UIDatePicker.Mode) -> Self {
        base.datePickerMode = mode
        return self
    }

    /// 设置首选样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func preferredDatePickerStyle(_ style: UIDatePickerStyle) -> Self {
        base.preferredDatePickerStyle = style
        return self
    }

    /// 设置当前日期
    /// - Parameters:
    ///   - date: 日期
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func date(_ date: Date, animated: Bool = false) -> Self {
        if animated {
            base.setDate(date, animated: animated)
        } else {
            base.date = date
        }
        return self
    }

    /// 设置最小日期
    /// - Parameter date: 最小日期
    /// - Returns: `Self`
    @discardableResult
    func minimumDate(_ date: Date?) -> Self {
        base.minimumDate = date
        return self
    }

    /// 设置最大日期
    /// - Parameter date: 最大日期
    /// - Returns: `Self`
    @discardableResult
    func maximumDate(_ date: Date?) -> Self {
        base.maximumDate = date
        return self
    }

    /// 设置分钟间隔
    /// - Note: 必须为 1–30 之间且能整除 60 的整数,如 1, 5, 10, 15, 30
    /// - Parameter interval: 间隔时间
    /// - Returns: `Self`
    @discardableResult
    func minuteInterval(_ interval: Int) -> Self {
        base.minuteInterval = interval
        return self
    }

    /// 设置区域
    /// - Parameter locale: 区域
    /// - Returns: `Self`
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        base.locale = locale
        return self
    }

    /// 设置日历
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    @discardableResult
    func calendar(_ calendar: Calendar) -> Self {
        base.calendar = calendar
        return self
    }

    /// 设置倒计时时长
    /// - Note: 仅在`.countDownTimer`模式下有效
    /// - Parameter duration: 时长
    /// - Returns: `Self`
    @discardableResult
    func countDownDuration(_ duration: TimeInterval) -> Self {
        base.countDownDuration = duration
        return self
    }

    /// 是否将时间四舍五入到最接近的`minuteInterval`
    /// - Parameter rounds: 是否四舍五入
    /// - Returns: `Self`
    @discardableResult
    func roundsToMinuteInterval(_ rounds: Bool) -> Self {
        base.roundsToMinuteInterval = rounds
        return self
    }
}
