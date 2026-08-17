import Foundation

// MARK: - 链式设置
public extension SoloWrapper where Base: DateFormatter {
    /// 设置日期格式字符串
    /// - Parameter dateFormat: 日期格式（如 `"yyyy-MM-dd HH:mm"`）
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func dateFormat(_ dateFormat: String) -> Self {
        base.dateFormat = dateFormat
        return self
    }

    /// 设置地区（Locale）
    /// - Parameter locale: 地区对象（建议使用 `.init(identifier:)` 明确指定）
    /// - Returns: `Self`
    @discardableResult
    func locale(_ locale: Locale) -> Self {
        base.locale = locale
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区对象（如 `.current`, `.utc`）
    /// - Returns: `Self`
    @discardableResult
    func timeZone(_ timeZone: TimeZone) -> Self {
        base.timeZone = timeZone
        return self
    }

    /// 设置日期样式
    /// - Parameter style: 日期显示样式（`.none`, `.short`, `.medium`, `.long`, `.full`）
    /// - Returns: `Self`
    @discardableResult
    func dateStyle(_ style: DateFormatter.Style) -> Self {
        base.dateStyle = style
        return self
    }

    /// 设置时间样式
    /// - Parameter style: 时间显示样式
    /// - Returns: `Self`
    @discardableResult
    func timeStyle(_ style: DateFormatter.Style) -> Self {
        base.timeStyle = style
        return self
    }

    /// 设置是否启用宽松解析（lenient parsing）
    /// - Parameter isLenient: 是否宽松（默认 `false` 更安全）
    /// - Returns: `Self`
    @discardableResult
    func isLenient(_ isLenient: Bool) -> Self {
        base.isLenient = isLenient
        return self
    }

    /// 设置默认日期（用于补全缺失字段，如只有时间时使用该日期）
    /// - Parameter date: 默认日期
    /// - Returns: `Self`
    @discardableResult
    func defaultDate(_ date: Date?) -> Self {
        base.defaultDate = date
        return self
    }

    /// 启用相对日期格式（如“今天”、“昨天”）
    /// - Parameter enabled: 是否启用（仅在 `dateStyle`/`timeStyle` 使用时生效）
    /// - Returns: `Self`
    @discardableResult
    func doesRelativeDateFormatting(_ enabled: Bool) -> Self {
        base.doesRelativeDateFormatting = enabled
        return self
    }

    /// 从模板设置本地化日期格式（自动适配 locale）
    /// - Parameter template: 日期组件模板（如 `"yyyyMMMdd"`）
    /// - Returns: `Self`
    @discardableResult
    func localizedDateFormat(fromTemplate template: String) -> Self {
        base.setLocalizedDateFormatFromTemplate(template)
        return self
    }
}
