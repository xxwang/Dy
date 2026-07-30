import Foundation

// MARK: - 命名与格式转换
public extension String {
    /// 转换为驼峰命名法(首单词小写,其余首字母大写)
    /// - 返回值: 驼峰格式字符串
    ///
    /// - Example:
    ///     `"some variable name".dy_camelCase` → `"someVariableName"`
    ///
    var dy_camelCase: String {
        let words = self.dy_words
        guard !words.isEmpty else { return "" }
        let first = words[0].lowercased()
        let rest = words.dropFirst().map(\.capitalized).joined()
        return first + rest
    }

    /// 将汉字转��为拼音(可选���否保留声调)
    /// - 参数 withTone: 是否保留声调符号,默认 `false`
    /// - 返回值: 拼音字符串(空格分隔);若无可转换字符,返回原串
    ///
    /// - Example:
    ///     `"汉字".dy_pinyin(withTone: false)` → `"han zi"`
    ///
    func dy_pinyin(withTone: Bool = false) -> String {
        let mutable = NSMutableString(string: self) as CFMutableString
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
    ///     `"爱国".dy_pinyinInitials()` → `"AG"`
    ///
    func dy_pinyinInitials(uppercase: Bool = true) -> String {
        let pinyin = self.dy_pinyin(withTone: false)
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
    ///     `"Hello".dy_localized(comment: "Greeting")`
    ///
    func dy_localized(comment: String = "") -> String {
        NSLocalizedString(self, comment: comment)
    }

    /// 转换为 URL 友好的 slug 格式(小写、短横线分隔)
    /// - 返回值: 清理后的 slug 字符串
    ///
    /// - Example:
    ///     `"Swift is amazing!".dy_slug()` → `"swift-is-amazing"`
    ///
    func dy_slug() -> String {
        // 转小写并去除重音
        let normalized = folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale.current)
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
public extension String {
    /// 移除首尾的空白符和换行符
    func dy_trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// 仅移除首尾空白符(不含换行)
    func dy_trimWhitespaces() -> String {
        trimmingCharacters(in: .whitespaces)
    }

    /// 仅移除首尾换行符
    func dy_trimNewlines() -> String {
        trimmingCharacters(in: .newlines)
    }

    /// 移除所有空格
    func dy_removeSpaces() -> String {
        replacingOccurrences(of: " ", with: "")
    }

    /// 移除所有换行符
    func dy_removeNewlines() -> String {
        replacingOccurrences(of: "\n", with: "")
    }

    /// 移除所有空白符和换行符
    func dy_removeAllWhitespace() -> String {
        components(separatedBy: .whitespacesAndNewlines).joined()
    }
}
