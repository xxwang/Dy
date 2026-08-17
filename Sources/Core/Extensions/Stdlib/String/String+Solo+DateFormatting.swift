import Foundation

// MARK: - 日期相关扩展
public extension SoloWrapper where Base == String {
    /// 将当前字符串解析为 `Date` 对象
    ///
    /// 使用 `en_US_POSIX` locale 和 UTC 时区,确保解析结果稳定
    ///
    /// - Parameter format: 日期格式,默认为 `"yyyy-MM-dd HH:mm:ss"`
    /// - Returns: 解析成功的 `Date?`,失败返回 `nil`
    func date(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        formatter.dateFormat = format
        return formatter.date(from: base)
    }
}
