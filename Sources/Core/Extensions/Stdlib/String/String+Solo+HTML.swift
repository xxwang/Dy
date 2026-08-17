import Foundation

// MARK: - HTML 与链接处理
public extension SoloWrapper where Base == String {
    /// 从简单的 `<a>` 标签中提取链接和文本内容
    /// - 返回值: `(link: String, text: String)` 元组;若匹配失败,返回 `nil`
    /// - 注意: 仅支持单个 `<a>` 标签,且属性顺序固定
    ///
    /// - Example:
    ///     `"<a href=\"https://example.com\">Click</a>".solo.linkAndText` → `("https://example.com", "Click")`
    ///
    var linkAndText: (link: String, text: String)? {
        let pattern = #"href\s*=\s*["']([^"']+)["'][^>]*>([^<]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
              let match = regex.firstMatch(in: base, range: NSRange(base.startIndex..., in: base))
        else {
            return nil
        }

        let linkRange = match.range(at: 1)
        let textRange = match.range(at: 2)

        guard let link = Range(linkRange, in: base),
              let text = Range(textRange, in: base)
        else {
            return nil
        }

        return (String(base[link]), String(base[text]))
    }

    /// 提取字符串中所有 URL、@提及、#话题 的 `NSRange`
    /// - 返回值: 匹配范围数组;若正则失败,返回 `nil`
    /// - 支持: http/https 链接、@用户名(含中文)、#话题#
    ///
    /// - Example:
    ///     `"看 https://a.com 和 @张三 #热点#"` → 三个 NSRange
    ///
    var linkRanges: [NSRange]? {
        let patterns = [
            ##"https?://[^\s<>"{}|\\^`\[\]]+"##, // URL
            ##"@\p{Han}*[a-zA-Z0-9_\p{Han}]+"##, // @提及
            ##"#[^#\s]+#"##, // #话题#
        ]

        var allRanges: [NSRange] = []

        for pattern in patterns {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                continue
            }
            let matches = regex.matches(in: base, range: NSRange(base.startIndex..., in: base))
            allRanges.append(contentsOf: matches.map(\.range))
        }

        return allRanges.isEmpty ? nil : allRanges
    }
}
