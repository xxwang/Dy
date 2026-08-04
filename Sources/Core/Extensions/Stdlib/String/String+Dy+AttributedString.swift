import UIKit
import os.log

// MARK: - 属性字符串相关
public extension DyWrapper where Base == String {
    /// 将 HTML 源码转换为属性字符串
    /// - Parameters:
    ///   - font: 全局字体(会覆盖 HTML 中的所有字体样式,包括 <b>, <i> 等)
    ///   - lineSpacing: 全局行间距
    /// - Returns: 转换后的属性字符串;失败时返回纯文本(带指定样式)
    ///
    /// - 注意: 此实现会丢失 HTML 的原始文本样式(如粗体、斜体),仅保留结构(换行等)
    ///
    func htmlToAttributedString(
        font: UIFont? = .systemFont(ofSize: 12),
        lineSpacing: CGFloat? = 10
    ) -> NSMutableAttributedString {
        // 预处理：将 \n 替换为 <br/> 以保留换行
        let processedHTML = base.replacingOccurrences(of: "\n", with: "<br/>")
        // 包裹在 <span> 中避免解析异常
        let fullHTML = "<span>\(processedHTML)</span>"

        guard let data = fullHTML.data(using: .utf8) else {
            return self.fallbackAttributedString(font: font, lineSpacing: lineSpacing)
        }

        do {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue,
            ]

            let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)

            // 删除尾部自动添加的换行符(HTML 解析器常会多加一个 \n)
            if attributedString.length > 0, attributedString.string.last == "\n" {
                attributedString.deleteCharacters(in: NSRange(location: attributedString.length - 1, length: 1))
            }

            // 应用全局字体(覆盖所有文本)
            if let font {
                attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
            }

            // 应用全局行间距
            if let lineSpacing {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineSpacing
                attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            }

            return attributedString
        } catch {
            os_log(.error, "HTML to Attributed String failed: %{public}@", String(describing: error))
            return self.fallbackAttributedString(font: font, lineSpacing: lineSpacing)
        }
    }

    /// 高亮显示关键字
    func highlightKeyword(
        keyword: String,
        highlightColor: UIColor,
        normalColor: UIColor,
        options: NSRegularExpression.Options = []
    ) -> NSMutableAttributedString {
        guard !keyword.isEmpty else {
            let attr = NSMutableAttributedString(string: base)
            attr.addAttribute(.foregroundColor, value: normalColor, range: NSRange(location: 0, length: attr.length))
            return attr
        }

        let attributedString = NSMutableAttributedString(string: base)
        attributedString.addAttribute(.foregroundColor, value: normalColor, range: NSRange(location: 0, length: attributedString.length))

        do {
            let escapedKeyword = NSRegularExpression.escapedPattern(for: keyword)
            let regex = try NSRegularExpression(pattern: escapedKeyword, options: options)
            let nsRange = NSRange(location: 0, length: base.utf16.count)
            let matches = regex.matches(in: base, options: [], range: nsRange)

            // 从后往前高亮,避免 range 偏移
            for match in matches.reversed() {
                attributedString.addAttribute(.foregroundColor, value: highlightColor, range: match.range)
            }
        } catch {
            os_log(.error, "Highlight keyword regex error: %{public}@", String(describing: error))
        }

        return attributedString
    }

    // MARK: - 私有辅助方法
    private func fallbackAttributedString(font: UIFont?, lineSpacing: CGFloat?) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: base)
        if let font {
            attr.addAttribute(.font, value: font, range: NSRange(location: 0, length: attr.length))
        }
        if let lineSpacing {
            let style = NSMutableParagraphStyle()
            style.lineSpacing = lineSpacing
            attr.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attr.length))
        }
        return attr
    }
}
