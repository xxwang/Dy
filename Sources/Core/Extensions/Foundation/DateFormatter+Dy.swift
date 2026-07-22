import Foundation

// MARK: - 共享实例
public extension DateFormatter {
    /// `ISO 8601`格式的共享 `DateFormatter`（`UTC 时区` + `en_US_POSIX区域`）
    ///
    /// 格式：`yyyy-MM-dd'T'HH:mm:ssZ`
    /// 适用于网络 API、日志记录等需要确定性解析/格式化的场景
    ///
    /// ⚠️ 注意：此 `formatter` 是只读共享实例，`不可修改其属性`
    /// `DateFormatter` 本身非线程安全，但此静态常量通过 `let` 惰性初始化保证线程安全
    static let dy_iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // 强制UTC
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()

    /// 创建一个自定义配置的 `DateFormatter` 实例
    ///
    /// - Parameters:
    ///   - format: 日期格式字符串，默认为 `"yyyy-MM-dd HH:mm:ss"`
    ///   - locale: 区域设置，默认为 `.current`
    ///   - timeZone: 时区，默认为 `.current`（而非 `.autoupdatingCurrent`，避免隐式更新）
    /// - Returns: `DateFormatter` 实例
    static func dy_formatter(
        format: String = "yyyy-MM-dd HH:mm:ss",
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        formatter.timeZone = timeZone
        return formatter
    }
}

// MARK: - 构造方法
public extension DateFormatter {
    /// 创建自定义格式的 `DateFormatter`
    /// - Parameters:
    ///   - format: 日期格式字符串(如 `yyyy-MM-dd`)
    ///   - locale: 地区,默认为 `en_US_POSIX`(推荐用于解析)
    ///   - timeZone: 时区,默认为 `UTC`
    convenience init(
        format: String,
        locale: Locale = Locale(identifier: "en_US_POSIX"),
        timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!
    ) {
        self.init()
        self.dateFormat = format
        self.locale = locale
        self.timeZone = timeZone
    }
}

// MARK: - 链式设置
public extension DateFormatter {
    /// 设置日期格式字符串
    /// - Parameter dateFormat: 日期格式（如 `"yyyy-MM-dd HH:mm"`）
    /// - Returns: `Self`，支持链式调用
    @discardableResult
    func dy_dateFormat(_ dateFormat: String) -> Self {
        self.dateFormat = dateFormat
        return self
    }

    /// 设置地区（Locale）
    /// - Parameter locale: 地区对象（建议使用 `.init(identifier:)` 明确指定）
    /// - Returns: `Self`
    @discardableResult
    func dy_locale(_ locale: Locale) -> Self {
        self.locale = locale
        return self
    }

    /// 设置时区
    /// - Parameter timeZone: 时区对象（如 `.current`, `.utc`）
    /// - Returns: `Self`
    @discardableResult
    func dy_timeZone(_ timeZone: TimeZone) -> Self {
        self.timeZone = timeZone
        return self
    }

    /// 设置日期样式
    /// - Parameter style: 日期显示样式（`.none`, `.short`, `.medium`, `.long`, `.full`）
    /// - Returns: `Self`
    @discardableResult
    func dy_dateStyle(_ style: DateFormatter.Style) -> Self {
        self.dateStyle = style
        return self
    }

    /// 设置时间样式
    /// - Parameter style: 时间显示样式
    /// - Returns: `Self`
    @discardableResult
    func dy_timeStyle(_ style: DateFormatter.Style) -> Self {
        self.timeStyle = style
        return self
    }

    /// 设置是否启用宽松解析（lenient parsing）
    /// - Parameter isLenient: 是否宽松（默认 `false` 更安全）
    /// - Returns: `Self`
    @discardableResult
    func dy_isLenient(_ isLenient: Bool) -> Self {
        self.isLenient = isLenient
        return self
    }

    /// 设置默认日期（用于补全缺失字段，如只有时间时使用该日期）
    /// - Parameter date: 默认日期
    /// - Returns: `Self`
    @discardableResult
    func dy_defaultDate(_ date: Date?) -> Self {
        self.defaultDate = date
        return self
    }

    /// 启用相对日期格式（如“今天”、“昨天”）
    /// - Parameter enabled: 是否启用（仅在 `dateStyle`/`timeStyle` 使用时生效）
    /// - Returns: `Self`
    @discardableResult
    func dy_doesRelativeDateFormatting(_ enabled: Bool) -> Self {
        self.doesRelativeDateFormatting = enabled
        return self
    }

    /// 从模板设置本地化日期格式（自动适配 locale）
    /// - Parameter template: 日期组件模板（如 `"yyyyMMMdd"`）
    /// - Returns: `Self`
    @discardableResult
    func dy_localizedDateFormat(fromTemplate template: String) -> Self {
        self.setLocalizedDateFormatFromTemplate(template)
        return self
    }
}
