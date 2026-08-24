import Foundation

// MARK: - 方法
public extension NSRegularExpression {
    /// 为每个匹配项执行闭包
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 匹配选项,默认为空
    ///   - range: 搜索范围(使用 `String.Index`)
    ///   - block: 对每个匹配项执行的闭包
    ///            若在闭包中将 `stop` 设为 `true`,将在当前匹配后停止枚举(与原生行为一致)
    ///
    /// - Example:
    ///
    ///     let regex = try! NSRegularExpression(pattern: "\\d+")
    ///     let text = "abc 123 def 456"
    ///     regex.solo_enumerateMatches(in: text, range: text.startIndex..<text.endIndex) { result, _, stop in
    ///         if let match = result {
    ///             print("Match: \(text[Range(match.range, in: text)!])")
    ///             stop = true // 只处理第一个匹配
    ///         }
    ///     }
    ///
    func solo_enumerateMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        using block: (_ result: NSTextCheckingResult?, _ flags: NSRegularExpression.MatchingFlags, _ stop: inout Bool) -> Void
    ) {
        self.enumerateMatches(in: string, options: options, range: NSRange(range, in: string)) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop {
                stop.pointee = true
            }
        }
    }

    /// 返回所有匹配项
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 匹配选项
    ///   - range: 搜索范围
    /// - Returns: 所有匹配的 `NSTextCheckingResult` 数组
    ///
    func solo_matches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> [NSTextCheckingResult] {
        return self.matches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 返回匹配项的数量
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 匹配选项
    ///   - range: 搜索范围
    /// - Returns: 匹配数量
    ///
    func solo_numberOfMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> Int {
        return self.numberOfMatches(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 返回第一个匹配项
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 匹配选项
    ///   - range: 搜索范围
    /// - Returns: 第一个匹配结果,若无则返回 `nil`
    ///
    func solo_firstMatch(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> NSTextCheckingResult? {
        return self.firstMatch(in: string, options: options, range: NSRange(range, in: string))
    }

    /// 返回第一个匹配项的字符串范围
    ///
    /// - Parameters:
    ///   - string: 要搜索的字符串
    ///   - options: 匹配选项
    ///   - range: 搜索范围
    /// - Returns: 第一个匹配的 `Range<String.Index>`,若无匹配则返回 `nil`
    ///
    func solo_firstMatchRange(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> Range<String.Index>? {
        let nsRange = self.rangeOfFirstMatch(in: string, options: options, range: NSRange(range, in: string))
        return Range(nsRange, in: string)
    }

    /// 返回替换所有匹配项后的新字符串(不修改原字符串)
    ///
    /// - Parameters:
    ///   - string: 原始字符串
    ///   - options: 匹配选项
    ///   - range: 替换范围
    ///   - template: 替换模板(支持 `$1`, `$2` 等捕获组)
    /// - Returns: 替换后的新字符串
    ///
    /// - Example:
    ///
    ///     let replaced = regex.solo_replacingMatches(in: "a1b2", range: ..., with: "X")
    ///
    func solo_replacingMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        with template: String
    ) -> String {
        return self.stringByReplacingMatches(
            in: string,
            options: options,
            range: NSRange(range, in: string),
            withTemplate: template
        )
    }

    /// 就地替换匹配项(直接修改传入的字符串)
    ///
    /// - Parameters:
    ///   - string: 被修改的字符串(`inout`)
    ///   - options: 匹配选项
    ///   - range: 替换范围
    ///   - template: 替换模板
    /// - Returns: 被替换的匹配项数量
    ///
    /// - Example:
    ///
    ///     var text = "a1b2"
    ///     let count = regex.solo_replaceMatches(in: &text, range: ..., with: "X")
    ///
    @discardableResult
    func solo_replaceMatches(
        in string: inout String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        with template: String
    ) -> Int {
        let mutableString = NSMutableString(string: string)
        let count = self.replaceMatches(
            in: mutableString,
            options: options,
            range: NSRange(range, in: string),
            withTemplate: template
        )
        string = String(mutableString)
        return count
    }
}
