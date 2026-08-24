import Foundation

// MARK: - 字符串通用分割
public extension String {
    /// 按固定长度分割字符串
    ///
    /// - Parameter length: 每段的字符长度
    /// - Returns: 分割后的字符串数组
    ///
    /// - Example:
    ///   ```swift
    ///   "HelloWorld".solo_split(byLength: 5) // ["Hello", "World"]
    ///   ```
    func solo_split(byLength length: Int) -> [String] {
        guard length > 0 else { return [] }
        var result: [String] = []
        var startIndex = self.startIndex

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            result.append(String(self[startIndex ..< endIndex]))
            startIndex = endIndex
        }
        return result
    }

    /// 按指定分隔符分割字符串
    ///
    /// - Parameter separator: 分隔符字符串
    /// - Returns: 分割后的数组;若结果为 `[""]`(即空字符串输入),则返回空数组
    ///
    /// - Example:
    ///   ```swift
    ///   "a,b,c".solo_split(bySeparator: ",") // ["a", "b", "c"]
    ///   "".solo_split(bySeparator: ",")      // []
    ///   ```
    func solo_split(bySeparator separator: String) -> [String] {
        let components = self.components(separatedBy: separator)
        return components == [""] ? [] : components
    }
}

// MARK: - 字符串替换/删除
public extension String {
    // MARK: - 正则替换

    /// 使用正则表达式对象替换匹配内容
    /// - Parameters:
    ///   - regex: 已编译的正则表达式
    ///   - template: 替换模板字符串
    ///   - matchingOptions: 匹配时的行为选项
    ///   - range: 搜索范围(默认整个字符串)
    /// - Returns: 替换后的新字符串
    func solo_replacingRegexMatches(
        using regex: NSRegularExpression,
        withTemplate template: String,
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        in range: Range<String.Index>? = nil
    ) -> String {
        let nsRange = NSRange(range ?? self.startIndex ..< self.endIndex, in: self)
        return regex.stringByReplacingMatches(
            in: self,
            options: matchingOptions,
            range: nsRange,
            withTemplate: template
        )
    }

    /// 使用正则表达式模式字符串替换匹配内容
    /// - Parameters:
    ///   - pattern: 正则表达式模式
    ///   - template: 替换模板字符串
    ///   - regexOptions: 正则编译选项(如 .caseInsensitive)
    ///   - matchingOptions: 匹配行为选项
    /// - Returns: 替换后的字符串;若正则无效,返回原字符串
    func solo_replacingRegexMatches(
        using pattern: String,
        withTemplate template: String,
        regexOptions: NSRegularExpression.Options = [],
        matchingOptions: NSRegularExpression.MatchingOptions = []
    ) -> String {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: regexOptions) else {
            return self
        }
        return regex.stringByReplacingMatches(
            in: self,
            options: matchingOptions,
            range: NSRange(self.startIndex ..< self.endIndex, in: self),
            withTemplate: template
        )
    }

    // MARK: - 普通替换与清理

    /// 替换所有匹配的子串
    /// - Parameters:
    ///   - target: 被替换的子串
    ///   - replacement: 替换内容
    /// - Returns: 替换后的新字符串
    func solo_replacing(_ target: String, with replacement: String) -> String {
        return self.replacingOccurrences(of: target, with: replacement)
    }

    /// 隐藏指定字符位置范围的敏感信息(位置从 0 开始,按用户可见字符计数)
    /// - Parameters:
    ///   - range: 要隐藏的字符范围(左闭右开),例如 `3..<7`
    ///   - replacement: 用于遮蔽的字符串,默认为 `"**`"`
    /// - Returns: 遮蔽后的字符串;若范围无效,返回原字符串
    ///
    /// - Example:
    ///     `"13812345678".solo_hidingSensitiveContent(in: 3..<7)` → `"138**`5678"`
    func solo_hidingSensitiveContent(in range: Range<Int>, with replacement: String = "**`") -> String {
        let charCount = self.count
        let lower = max(0, min(range.lowerBound, charCount))
        let upper = max(lower, min(range.upperBound, charCount))
        guard lower < upper else { return self }

        let startIdx = self.index(self.startIndex, offsetBy: lower)
        let endIdx = self.index(startIdx, offsetBy: upper - lower)
        return self.replacingCharacters(in: startIdx ..< endIdx, with: replacement)
    }

    /// 移除所有出现在给定字符串中的字符
    /// - Parameter characters: 包含要移除字符的字符串
    /// - Returns: 移除指定字符后的新字符串
    ///
    /// - Example:
    ///     `"Hello World!".solo_removingCharacters(in: "lo!")` → `"He Wrd"`
    func solo_removingCharacters(in characters: String) -> String {
        let characterSet = Set(characters)
        return self.filter { !characterSet.contains($0) }
    }

    /// 移除字符串开头的指定前缀(如果存在)
    /// - Parameter prefix: 要移除的前缀
    /// - Returns: 移除前缀后的新字符串
    func solo_removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self[prefix.endIndex...])
    }

    /// 移除字符串末尾的指定后缀(如果存在)
    /// - Parameter suffix: 要移除的后缀
    /// - Returns: 移除后缀后的新字符串
    func solo_removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
