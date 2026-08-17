import Foundation

extension Locale: SoloExtension {}

// MARK: - 自定义
public extension SoloWrapper where Base == Locale {
    /// 判断是否使用`12`小时制
    var is12Hour: Bool {
        let formatter = DateFormatter()
        formatter.locale = base
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.dateFormat?.contains("a") == true
    }
}
