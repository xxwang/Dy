import Foundation

// MARK: - 自定义
public extension Locale {
    /// 判断是否使用`12`小时制
    var dy_is12Hour: Bool {
        let formatter = DateFormatter()
        formatter.locale = self
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.dateFormat?.contains("a") == true
    }
}
