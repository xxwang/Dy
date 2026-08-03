import Foundation

// MARK: - 命名与格式转换
public extension DyWrapper where Base == String {
    /// 转换为驼峰命名法(首单词小写,其余首字母大写)
    /// - 返回值: 驼峰格式字符串
    ///
    /// - Example:
    ///     `"some variable name".dy.camelCase` → `"someVariableName"`
    ///
    var camelCase: String {
        let words = self.words
        guard !words.isEmpty else { return "" }
        let first = words[0].lowercased()
        let rest = words.dropFirst().map(\.capitalized).joined()
        return first + rest
    }

    /// 将汉字转为拼音(可选择是否保留声调)
    /// - 参数 withTone: 是否保留声调符号,默认 `false`
    /// - 返回值: 拼音字符串(空格分隔);若无可转换字符,返回原串
    ///
    /// - Example:
    ///     `"汉字".dy.pinyin(withTone: false)` → `"han zi"`
    ///
    func pinyin(withTone: Bool = false) -> String {
        let mutable = NSMutableString(string: base) as CFMutableString
        // 转为拉丁字母(带声调)
        CFStringTransform(mutable, nil, kCFStringTransformMandarinLatin, false)
        // 去声调
        if !withTone {
            CFStringTransform(mutable, nil, kCFStringTransformStripDiacritics, false)
        }
        return mutable as String
    }

    /// 提取每个汉字的拼音首字母
    /// - 参数 uppercase: 是否转为大写,默认 `true`
    /// - 返回值: 首字母字符串;非汉字部分会被忽略
    ///
    /// - Example:
    ///     `"爱国".dy.pinyinInitials()` → `"AG"`
    ///
    func pinyinInitials(uppercase: Bool = true) -> String {
        let pinyin = self.pinyin(withTone: false)
        let initials = pinyin
            .components(separatedBy: .whitespaces)
            .compactMap { word in
                word.first.flatMap { String($0).uppercased().first }
            }
        let result = String(initials)
        return uppercase ? result : result.lowercased()
    }

    /// 返回本地化字符串(调用 `NSLocalizedString`)
    /// - 参数 comment: 供翻译人员参考的注释
    /// - 返回值: 本地化后的字符串
    ///
    /// - Example:
    ///     `"Hello".dy.localized(comment: "Greeting")`
    ///
    func localized(comment: String = "") -> String {
        NSLocalizedString(base, comment: comment)
    }

    /// 转换为 URL 友好的 slug 格式(小写、短横线分隔)
    /// - 返回值: 清理后的 slug 字符串
    ///
    /// - Example:
    ///     `"Swift is amazing!".dy.slug()` → `"swift-is-amazing"`
    ///
    func slug() -> String {
        // 转小写并去除重音
        let normalized = base.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale.current)
        // 替换空白符为短横线
        let dashed = normalized.replacingOccurrences(of: "\\s+", with: "-", options: .regularExpression)
        // 仅保留字母、数字、短横线
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-"))
        let filtered = dashed.filter { String($0).rangeOfCharacter(from: allowed) != nil }
        // 去除首尾短横线,并压缩连续短横线
        return filtered
            .trimmingCharacters(in: .init(charactersIn: "-"))
            .replacingOccurrences(of: "-+", with: "-", options: .regularExpression)
    }
}

// MARK: - 空白符处理
public extension DyWrapper where Base == String {
    /// 移除首尾的空白符和换行符
    func trim() -> String {
        base.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 仅移除首尾空白符(不含换行)
    func trimWhitespaces() -> String {
        base.trimmingCharacters(in: .whitespaces)
    }

    /// 仅移除首尾换行符
    func trimNewlines() -> String {
        base.trimmingCharacters(in: .newlines)
    }

    /// 移除所有空格
    func removeSpaces() -> String {
        base.replacingOccurrences(of: " ", with: "")
    }

    /// 移除所有换行符
    func removeNewlines() -> String {
        base.replacingOccurrences(of: "\n", with: "")
    }

    /// 移除所有空白符和换行符
    func removeAllWhitespace() -> String {
        base.components(separatedBy: .whitespacesAndNewlines).joined()
    }
}
