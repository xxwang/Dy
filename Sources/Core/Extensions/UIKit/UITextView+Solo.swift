import UIKit
import os.log

// MARK: - 常用方法
public extension UITextView {
    /// 限制输入字符数,并可选通过正则表达式过滤输入内容,支持中英文、表情符号(以 Unicode 字符计数)
    ///
    /// - Note: 此方法应在 `textView(_:shouldChangeTextIn:replacementText:)` 中调用
    ///
    /// - Parameters:
    ///   - range: 将被替换的文本范围(基于 `NSRange`)
    ///   - text: 新输入的文本(可能为空字符串,表示删除)
    ///   - maxCharacters: 允许的最大字符数(按 `String.count` 计算)
    ///   - regexPattern: 可选的正则表达式,用于限制允许输入的字符类型(如仅字母数字)若为 `nil`,不限制
    /// - Returns: `true` 表示允许变更,`false` 表示拒绝
    ///
    /// -   Example:
    ///
    ///   ```swift
    ///   func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    ///       return textView.solo_inputRestrictions(in: range, newText: text, maxLength: 100)
    ///   }
    ///   ```
    func solo_inputRestrictions(
        in range: NSRange,
        newText text: String,
        maxLength maxCharacters: Int,
        regexPattern: String? = nil
    ) -> Bool {
        // 删除操作(text 为空)总是允许
        guard !text.isEmpty else { return true }

        // 获取当前文本,安全处理 nil
        let currentText = self.text ?? ""

        // 用户使用中文拼音输入法时(如九宫格),`markedTextRange != nil` 表示正在输入中,此时不应截断
        if self.markedTextRange != nil {
            // 在高亮状态下,只做正则校验(不截断,避免打断输入)
            if let pattern = regexPattern, !text.solo_isMatch(pattern: pattern) {
                return false
            }
            // 不在此处判断长度,因为高亮文本尚未确认
            return true
        }

        // 非高亮状态：先校验正则
        if let pattern = regexPattern, !text.solo_isMatch(pattern: pattern) {
            return false
        }

        // 计算新文本总长度(注意：range.length 是要删除的字符数)
        let newTextLength = text.count
        let deleteLength = range.length
        let finalLength = currentText.count - deleteLength + newTextLength

        // 如果超出最大长度,尝试截断
        if finalLength > maxCharacters {
            // 构造最终文本
            let nsCurrent = currentText as NSString
            let before = nsCurrent.substring(to: range.location)
            let after = nsCurrent.substring(from: NSMaxRange(range))
            var fullText = before + text + after

            // 截断至最大长度
            if fullText.count > maxCharacters {
                fullText = String(fullText.prefix(maxCharacters))
            }

            // 更新文本并禁止原生插入
            self.text = fullText
            // 移动光标到末尾(可选增强体验)
            if let newPosition = self.position(from: self.beginningOfDocument, offset: fullText.utf16.count) {
                self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
            }
            return false
        }
        return true
    }

    /// 添加带可选超链接的文本
    ///
    /// - Note: 若 `linkURL` 无效或为空,将作为普通文本追加
    ///
    /// - Parameters:
    ///   - text: 要追加的文本
    ///   - font: 文本字体(默认使用当前 `font`)
    ///   - linkURL: 可选的 `URL` 字符串,若提供则整段文本变为可点击链接
    func solo_addLinkText(
        _ text: String,
        font: UIFont? = nil,
        linkURL: String? = nil
    ) {
        let effectiveFont = font ?? self.font ?? UIFont.preferredFont(forTextStyle: .body)
        let attributes: [NSAttributedString.Key: Any] = [.font: effectiveFont]
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)

        if let urlString = linkURL, !urlString.isEmpty,
           let url = URL(string: urlString)
        {
            attributedString.addAttribute(.link, value: url, range: NSRange(text.startIndex..., in: text))
        }

        let current = (self.attributedText ?? NSAttributedString()).mutableCopy() as? NSMutableAttributedString
            ?? NSMutableAttributedString()

        current.append(attributedString)
        self.attributedText = current
    }

    /// 自动识别并转换 `@用户名` 和 `#话题#` 为可点击链接
    ///
    /// - Note: 调用此方法会覆盖当前 `attributedText`
    /// - 规则:
    ///   - `@hangge` → 链接格式: `mention://hangge`
    ///   - `#iOS开发#` → 链接格式: `hashtag://iOS开发`
    ///
    /// - 忽略已存在于 URL 中的内容(如 `http://example.com/@user` 不会被转换)
    /// - 仅匹配由字母、数字、下划线组成的用户名或话题名
    func solo_convertMentionsAndHashtags() {
        guard let plainText = self.text, !plainText.isEmpty else {
            return
        }

        let attributed = NSMutableAttributedString(string: plainText)
        let nsString = plainText as NSString
        let length = nsString.length

        // 正则匹配 @用户名 和 #话题#
        let mentionPattern = "@([a-zA-Z0-9_\\u4e00-\\u9fff]+)" // 支持中文用户名
        let hashtagPattern = "#([a-zA-Z0-9_\\u4e00-\\u9fff]+)#" // #xxx# 格式

        for (pattern, scheme) in [(mentionPattern, "mention"), (hashtagPattern, "hashtag")] {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let matches = regex.matches(in: plainText, options: [], range: NSRange(location: 0, length: length))

                // 从后往前添加属性,避免 range 偏移
                for match in matches.reversed() {
                    let keywordRange = match.range(at: 1) // 捕获组
                    let fullRange = match.range(at: 0) // 完整匹配(含@ 或#)

                    guard keywordRange.location != NSNotFound,
                          let keyword = nsString.substring(with: keywordRange).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    else {
                        continue
                    }

                    let url = URL(string: "\(scheme)://\(keyword)")!
                    attributed.addAttribute(.link, value: url, range: fullRange)
                }
            } catch {
                os_log(.error, "Regex error in convertMentionsAndHashtags: %{public}@", String(describing: error))
            }
        }
        self.attributedText = attributed
    }
}
