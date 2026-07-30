import Foundation
import CoreText
import CoreGraphics

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - String行处理
public extension String {
    /// 将字符串按系统换行符(\n, \r\n 等)分割为行数组
    ///
    /// - Returns: 每行内容组成的数组,不包含换行符
    ///
    /// - Example:
    ///   ```swift
    ///   "Hello\nWorld".dy_lines // ["Hello", "World"]
    ///   ```
    var dy_lines: [String] {
        var result: [String] = []
        self.enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }

    /// 根据指定最大宽度和字体,将字符串自动换行分割为多行
    ///
    /// - Parameters:
    ///   - maxWidth: 每行允许的最大宽度(单位：点)
    ///   - font: 用于文本测量的字体
    /// - Returns: 换行后的字符串数组
    ///
    /// - Note: 使用 Core Text 实现,支持复杂文本(如 emoji、混合语言)
    ///
    /// - Example:
    ///   ```swift
    ///   let text = "这是一个测试字符串"
    ///   let lines = text.dy_wrappedLines(maxWidth: 100, font: .systemFont(ofSize: 16))
    ///   ```
    func dy_wrappedLines(maxWidth: CGFloat, font: UIFont) -> [String] {
        guard !self.isEmpty, maxWidth > 0 else { return [] }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byCharWrapping // 或 .byWordWrapping,根据需求调整

        let attributedString = NSAttributedString(
            string: self,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
            ]
        )

        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: maxWidth, height: .greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedString.length), path, nil)

        guard let ctLines = CTFrameGetLines(frame) as? [CTLine] else { return [] }

        return ctLines.compactMap { line in
            let range = CTLineGetStringRange(line)
            let nsRange = NSRange(location: range.location, length: range.length)
            if nsRange.location + nsRange.length <= self.utf16.count {
                return (self as NSString).substring(with: nsRange)
            }
            return nil
        }
    }

    /// 将文本限制在指定宽度和最大行数内,并在末尾添加自定义后缀(如"...全文")
    ///
    /// - Parameters:
    ///   - maxWidth: 每行最大宽度
    ///   - font: 主文本字体
    ///   - maxLines: 允许的最大行数(≥1)
    ///   - suffix: 截断后缀文本(如 "..." 或 "...查看全文")
    ///   - suffixFont: 后缀字体(若为 nil,则使用主字体)
    /// - Returns: 截断并添加后缀后的行数组(长度 ≤ maxLines)
    ///
    /// - Example:
    ///   ```swift
    ///   let lines = longText.dy_truncatedLines(
    ///       maxWidth: 200,
    ///       font: .systemFont(ofSize: 14),
    ///       maxLines: 3,
    ///       suffix: "...查看全文"
    ///   )
    ///   ```
    func dy_truncatedLines(
        maxWidth: CGFloat,
        font: UIFont,
        maxLines: Int,
        suffix: String,
        suffixFont: UIFont? = nil
    ) -> [String] {
        guard !self.isEmpty, maxLines > 0, maxWidth > 0 else { return [] }

        let mainAttributes: [NSAttributedString.Key: Any] = [.font: font]
        let effectiveSuffixFont = suffixFont ?? font
        let suffixAttributes: [NSAttributedString.Key: Any] = [.font: effectiveSuffixFont]

        let mainAttributedString = NSAttributedString(string: self, attributes: mainAttributes)
        let typesetter = CTTypesetterCreateWithAttributedString(mainAttributedString)
        let totalLength = mainAttributedString.length

        // 预计算后缀宽度
        let suffixAttrString = NSAttributedString(string: suffix, attributes: suffixAttributes)
        let suffixLine = CTLineCreateWithAttributedString(suffixAttrString)
        var ascent: CGFloat = 0, descent: CGFloat = 0
        let suffixWidth = CTLineGetTypographicBounds(suffixLine, &ascent, &descent, nil)

        var lines: [String] = []
        var currentIndex = 0

        while currentIndex < totalLength, lines.count < maxLines {
            let isLastLine = (lines.count == maxLines - 1)
            let availableWidth = isLastLine ? max(0, maxWidth - CGFloat(suffixWidth)) : maxWidth

            let lineLength = CTTypesetterSuggestLineBreak(typesetter, currentIndex, Double(availableWidth))
            guard lineLength > 0 else { break }

            let lineRange = NSRange(location: currentIndex, length: lineLength)
            let lineSubstring = (self as NSString).substring(with: lineRange)

            if isLastLine {
                // 先尝试完整拼接
                let candidateAttr = NSMutableAttributedString(string: lineSubstring, attributes: mainAttributes)
                candidateAttr.append(suffixAttrString)
                let candidateWidth = CTLineGetTypographicBounds(
                    CTLineCreateWithAttributedString(candidateAttr),
                    nil, nil, nil
                )

                var finalLine: String
                if CGFloat(candidateWidth) <= maxWidth {
                    finalLine = lineSubstring + suffix
                } else {
                    // 逐步缩减主文本,直到 "主文本 + 后缀" 能放入 maxWidth
                    var tempMain = lineSubstring
                    while !tempMain.isEmpty {
                        let testAttr = NSMutableAttributedString(string: tempMain, attributes: mainAttributes)
                        testAttr.append(suffixAttrString)
                        let testWidth = CTLineGetTypographicBounds(
                            CTLineCreateWithAttributedString(testAttr),
                            nil, nil, nil
                        )

                        if CGFloat(testWidth) <= maxWidth {
                            break
                        }
                        tempMain = String(tempMain.dropLast())
                    }
                    finalLine = tempMain + suffix
                }
                lines.append(finalLine)
            } else {
                lines.append(lineSubstring)
            }

            currentIndex += lineLength
        }

        return lines
    }
}
