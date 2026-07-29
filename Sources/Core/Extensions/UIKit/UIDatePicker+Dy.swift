import UIKit

// MARK: - 链式设置属性
public extension UIDatePicker {
    /// 设置时区
    /// - Parameter timeZone: 时区
    /// - Returns: `Self`
    @discardableResult
    func dy_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置日期选择器模式
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func dy_datePickerMode(_ mode: UIDatePicker.Mode) -> Self {
        self.datePickerMode = mode
        return self
    }

    /// 设置首选样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @available(iOS 13.4, *)
    @discardableResult
    func dy_preferredDatePickerStyle(_ style: UIDatePickerStyle) -> Self {
        self.preferredDatePickerStyle = style
        return self
    }

    /// 设置当前日期
    /// - Parameters:
    ///   - date: 日期
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_date(_ date: Date, animated: Bool = false) -> Self {
        if animated {
            self.setDate(date, animated: animated)
        } else {
            self.date = date
        }
        return self
    }

    /// 设置最小日期
    /// - Parameter date: 最小日期
    /// - Returns: `Self`
    @discardableResult
    func dy_minimumDate(_ date: Date?) -> Self {
        self.minimumDate = date
        return self
    }

    /// 设置最大日期
    /// - Parameter date: 最大日期
    /// - Returns: `Self`
    @discardableResult
    func dy_maximumDate(_ date: Date?) -> Self {
        self.maximumDate = date
        return self
    }

    /// 设置分钟间隔
    /// - Note: 必须为 1–30 之间且能整除 60 的整数,如 1, 5, 10, 15, 30
    /// - Parameter interval: 间隔时间
    /// - Returns: `Self`
    @discardableResult
    func dy_minuteInterval(_ interval: Int) -> Self {
        self.minuteInterval = interval
        return self
    }

    /// 设置区域
    /// - Parameter locale: 区域
    /// - Returns: `Self`
    @discardableResult
    func dy_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    /// 设置日历
    /// - Parameter calendar: 日历对象
    /// - Returns: `Self`
    @discardableResult
    func dy_calendar(_ calendar: Calendar) -> Self {
        self.calendar = calendar
        return self
    }

    /// 设置倒计时时长
    /// - Note: 仅在`.countDownTimer`模式下有效
    /// - Parameter duration: 时长
    /// - Returns: `Self`
    @discardableResult
    func dy_countDownDuration(_ duration: TimeInterval) -> Self {
        self.countDownDuration = duration
        return self
    }

    /// 是否将时间四舍五入到最接近的`minuteInterval`
    /// - Parameter rounds: 是否四舍五入
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_roundsToMinuteInterval(_ rounds: Bool) -> Self {
        self.roundsToMinuteInterval = rounds
        return self
    }
}
