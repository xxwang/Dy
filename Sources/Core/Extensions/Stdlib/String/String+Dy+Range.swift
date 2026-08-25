import Foundation

// MARK: - 字符串范围（Range）与 NSRange 互转
public extension String {
    /// 返回字符串的完整字符范围（基于 `String.Index`）
    ///
    /// - Returns: `startIndex..<endIndex`
    var dy_fullRange: Range<String.Index> {
        self.startIndex ..< self.endIndex
    }

    /// 返回字符串的完整范围（基于 `NSRange`,常用于与 Foundation 或正则 API 交互）
    ///
    /// - Returns: 对应的 `NSRange`（基于 UTF-16 单元）
    var dy_fullNSRange: NSRange {
        NSRange(self.dy_fullRange, in: self)
    }

    /// 将 `NSRange` 安全转换为 `Range<String.Index>`
    ///
    /// - Parameter nsRange: 基于 UTF-16 的 NSRange
    /// - Returns: 若范围有效且完全位于字符串内,则返回对应的 `Range<String.Index>`;否则返回 `nil`
    /// - Note: 此方法是 Foundation `Range(_:in:)` 的安全封装
    func dy_range(from nsRange: NSRange) -> Range<String.Index>? {
        Range(nsRange, in: self)
    }

    /// 将 `Range<String.Index>` 转换为 `NSRange`
    ///
    /// - Parameter range: 基于 `String.Index` 的字符范围
    /// - Returns: 对应的 `NSRange`（基于 UTF-16 单元）
    /// - Note: 要求 `range` 必须是当前字符串的有效子范围
    func dy_nsRange(from range: Range<String.Index>) -> NSRange {
        NSRange(range, in: self)
    }

    /// 查找子字符串在当前字符串中的首次出现位置（基于 `String.Index`）
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 找到则返回范围,否则返回 `nil`
    func dy_subRange(of substring: String) -> Range<String.Index>? {
        self.range(of: substring)
    }

    /// 查找子字符串在当前字符串中的首次出现位置（基于 `NSRange`）
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 找到则返回 `NSRange`;否则返回 `NSRange(location: NSNotFound, length: 0)`（符合 Foundation 惯例）
    func dy_subNSRange(of substring: String) -> NSRange {
        guard let range = self.range(of: substring) else {
            return NSRange(location: NSNotFound, length: 0)
        }
        return NSRange(range, in: self)
    }

    /// 查找所有匹配子串的字符范围（支持自定义比较选项）
    ///
    /// - Parameters:
    ///   - substring: 要查找的子字符串
    ///   - options: 字符串比较选项（如 `.caseInsensitive`）,默认为空
    /// - Returns: 所有匹配位置的 `Range<String.Index>` 数组（按出现顺序）
    func dy_ranges(of substring: String, options: String.CompareOptions = []) -> [Range<String.Index>] {
        guard !substring.isEmpty else { return [] }
        var results: [Range<String.Index>] = []
        var searchStart = self.startIndex

        while searchStart < self.endIndex,
              let range = self.range(of: substring, options: options, range: searchStart ..< self.endIndex)
        {
            results.append(range)
            searchStart = range.upperBound
        }

        return results
    }

    /// 查找所有匹配子串的 `NSRange`（支持自定义比较选项）
    ///
    /// - Parameters:
    ///   - substring: 要查找的子字符串
    ///   - options: 字符串比较选项（如 `.caseInsensitive`）,默认为空
    /// - Returns: 所有匹配位置的 `NSRange` 数组（按出现顺序）
    func dy_nsRanges(of substring: String, options: String.CompareOptions = []) -> [NSRange] {
        self.dy_ranges(of: substring, options: options).map { self.dy_nsRange(from: $0) }
    }
}

// MARK: - 字符串填充（左/右对齐）
public extension String {
    /// 在字符串开头填充字符,直到达到指定长度（左对齐）
    ///
    /// - Parameters:
    ///   - toLength: 目标总长度
    ///   - with: 用于填充的字符串（默认为空格）
    /// - Returns: 填充后的字符串;若原长度 ≥ 目标长度或填充串为空,则返回原字符串
    func dy_padStart(toLength length: Int, with padding: String = " ") -> String {
        guard length > self.count, !padding.isEmpty else { return self }
        let needed = length - self.count
        let repeatCount = (needed + padding.count - 1) / padding.count
        let repeated = String(repeating: padding, count: repeatCount)
        return String(repeated.prefix(needed)) + self
    }

    /// 在字符串末尾填充字符,直到达到指定长度（右对齐）
    ///
    /// - Parameters:
    ///   - toLength: 目标总长度
    ///   - with: 用于填充的字符串（默认为空格）
    /// - Returns: 填充后的字符串;若长度 ≥ 目标长度或填充串为空,则返回原字符串
    func dy_padEnd(toLength length: Int, with padding: String = " ") -> String {
        guard length > self.count, !padding.isEmpty else { return self }
        let needed = length - self.count
        let repeatCount = (needed + padding.count - 1) / padding.count
        let repeated = String(repeating: padding, count: repeatCount)
        return self + String(repeated.prefix(needed))
    }
}

// MARK: - 子字符串位置查找扩展
public extension String {
    /// 返回子字符串首次出现的 UTF-16 索引位置
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 首次出现的起始索引（从 0 开始）,未找到返回 `-1`
    /// - Note: 基于 UTF-16 编码单位计算位置,与 JavaScript 行为一致
    func dy_positionFirst(of substring: String) -> Int {
        return self.dy_position(of: substring, backwards: false)
    }

    /// 返回子字符串最后一次出现的 UTF-16 索引位置
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 最后一次出现的起始索引,未找到返回 `-1`
    func dy_positionLast(of substring: String) -> Int {
        return self.dy_position(of: substring, backwards: true)
    }

    /// 私有辅助方法：统一实现前后向查找
    private func dy_position(of substring: String, backwards: Bool) -> Int {
        guard !substring.isEmpty else { return -1 }
        let options: String.CompareOptions = backwards ? .backwards : []
        if let range = self.range(of: substring, options: options) {
            return self.utf16.distance(from: self.startIndex, to: range.lowerBound)
        }
        return -1
    }
}

// MARK: - 基于 UTF-16 索引的安全截取
public extension String {
    /// 根据 `Range<Int>`（UTF-16 索引）安全截取子字符串
    ///
    /// - Parameter range: 前闭后开的整数范围
    /// - Returns: 截取结果;若范围无效、越界或无法映射到有效 `String.Index`,返回空字符串
    /// - Note: 自动处理组合字符、Emoji 等复杂 Unicode 情况
    func dy_slice(_ range: Range<Int>) -> String {
        guard !range.isEmpty,
              range.lowerBound >= 0,
              range.upperBound <= self.utf16.count
        else {
            return ""
        }

        let start = self.utf16.index(self.utf16.startIndex, offsetBy: range.lowerBound)
        let end = self.utf16.index(self.utf16.startIndex, offsetBy: range.upperBound)

        guard let stringStart = String.Index(start, within: self),
              let stringEnd = String.Index(end, within: self)
        else {
            return ""
        }

        return String(self[stringStart ..< stringEnd])
    }

    /// 从指定 UTF-16 索引截取到字符串末尾
    ///
    /// - Parameter from: 起始位置（UTF-16 索引）
    /// - Returns: 截取结果;若 `from` 越界,返回空字符串
    func dy_substring(from: Int) -> String {
        self.dy_slice(from ..< self.utf16.count)
    }

    /// 从开头截取到指定 UTF-16 索引（不包含）
    ///
    /// - Parameter to: 结束位置（UTF-16 索引）
    /// - Returns: 截取结果;若 `to` 越界,自动截断至末尾
    func dy_substring(to: Int) -> String {
        let end = min(max(0, to), self.utf16.count)
        return self.dy_slice(0 ..< end)
    }

    /// 从指定位置截取固定长度的子串
    ///
    /// - Parameters:
    ///   - from: 起始 UTF-16 索引
    ///   - length: 截取长度
    /// - Returns: 尽可能截取的有效子串;若 `length <= 0`,返回空字符串
    func dy_substring(from: Int, length: Int) -> String {
        guard length > 0 else { return "" }
        let start = max(0, from)
        let end = min(start + length, self.utf16.count)
        return self.dy_slice(start ..< end)
    }

    /// 在两个 UTF-16 索引之间截取子串（自动处理顺序颠倒）
    ///
    /// - Parameters:
    ///   - from: 起始索引
    ///   - to: 结束索引（不包含）
    /// - Returns: 有效范围内的子串
    func dy_substring(from: Int, to: Int) -> String {
        let start = max(0, min(from, to))
        let end = min(max(from, to), self.utf16.count)
        return self.dy_slice(start ..< end)
    }

    /// 获取指定 UTF-16 索引处的字符（作为字符串）
    ///
    /// - Parameter index: 位置索引
    /// - Returns: 对应字符的字符串;若索引无效,返回空字符串
    func dy_character(at index: Int) -> String {
        self.dy_substring(from: index, length: 1)
    }

    /// 截断字符串至指定 UTF-16 长度
    ///
    /// - Parameter length: 最大保留长度
    /// - Returns: 截断后的字符串;若未超长,返回原串
    func dy_truncate(length: Int) -> String {
        guard length < self.utf16.count else { return self }
        return self.dy_substring(to: length)
    }

    /// 截断字符串并在末尾追加尾部标记（如省略号）
    ///
    /// - Parameters:
    ///   - length: 最大保留长度（不含尾部标记）
    ///   - trailing: 尾部附加字符串,默认为 `"..."`
    /// - Returns: 截断并追加标记的字符串;若未超长,返回原串
    /// - Warning: 总长度 = `length + trailing.utf16.count`,可能超过 `length`
    func dy_truncate(length: Int, trailing: String = "...") -> String {
        guard length >= 0, self.utf16.count > length else { return self }
        let truncated = self.dy_substring(to: length)
        return truncated + trailing
    }

    /// 按固定 UTF-16 长度分段,并用分隔符连接
    ///
    /// - Parameters:
    ///   - segmentLength: 每段的 UTF-16 长度
    ///   - separator: 分隔符,默认为 `"-"`
    /// - Returns: 分段拼接后的字符串
    func dy_chunked(segmentLength: Int, separator: String = "-") -> String {
        guard segmentLength > 0 else { return self }

        var result: [String] = []
        var utf16Offset = 0
        let utf16View = self.utf16

        while utf16Offset < utf16View.count {
            let endOffset = min(utf16Offset + segmentLength, utf16View.count)

            guard let startIdx = String.Index(utf16View.index(utf16View.startIndex, offsetBy: utf16Offset), within: self),
                  let endIdx = String.Index(utf16View.index(utf16View.startIndex, offsetBy: endOffset), within: self)
            else {
                break
            }

            result.append(String(self[startIdx ..< endIdx]))
            utf16Offset = endOffset
        }

        return result.joined(separator: separator)
    }
}
