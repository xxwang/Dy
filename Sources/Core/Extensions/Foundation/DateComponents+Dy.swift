import Foundation

// MARK: - 日期构建与转换
public extension DateComponents {
    /// 基于当前 `DateComponents` 生成 `Date` 对象
    /// - Parameter calendar: 日历,默认为 `.current`
    /// - Returns: 若组件有效,则返回对应的 `Date`;否则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let date = DateComponents().dy_date()
    ///   ```
    func dy_date(using calendar: Calendar = .current) -> Date? {
        return calendar.date(from: self)
    }
}
