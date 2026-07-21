import Foundation
import CommonCrypto
import CoreText
import CoreGraphics
import CryptoKit

#if canImport(UIKit)
    import UIKit

    public typealias DyFont = UIFont
#endif

#if canImport(AppKit)
    import AppKit

    public typealias DyFont = NSFont
#endif

#if canImport(CoreLocation)
    import CoreLocation
#endif

// MARK: - 下标
public extension String {
    /// 通过整数索引安全获取或设置单个字符
    ///
    /// - Parameter index: 从 0 开始的字符位置
    /// - Returns: 对应位置的字符子串（如 `"a"`）,若索引越界则返回 `nil`
    /// - Note: 设置时若新值为空或越界,则忽略操作
    /// - Example:
    ///   ```swift
    ///   var str = "Hello"
    ///   print(str[safe: 1]) // Optional("e")
    ///   str[safe: 0] = "J"
    ///   print(str)          // "Jello"
    ///   ```
    subscript(safe index: Int) -> String? {
        get {
            guard index >= 0, index < count else { return nil }
            let i = self.index(startIndex, offsetBy: index)
            return String(self[i])
        }
        set {
            guard let newValue, !newValue.isEmpty,
                  index >= 0, index < count else { return }
            let start = self.index(startIndex, offsetBy: index)
            let end = self.index(after: start)
            replaceSubrange(start ..< end, with: newValue)
        }
    }

    /// 通过整数范围安全获取或设置子字符串
    ///
    /// - Parameter range: 整数范围表达式（如 `0..<3`, `2...4`）
    /// - Returns: 对应子串,若范围越界则返回 `nil`
    /// - Note: 设置时会自动裁剪范围至 `[0, count]`,确保安全
    /// - Example:
    ///   ```swift
    ///   var str = "Hello"
    ///   print(str[range: 1..<4]) // Optional("ell")
    ///   str[range: 0..<5] = "Hi"
    ///   print(str)                   // "Hi"
    ///   ```
    subscript<R>(range: R) -> String? where R: RangeExpression, R.Bound == Int {
        get {
            let swiftRange = range.relative(to: 0 ..< Int.max)
            guard swiftRange.lowerBound >= 0,
                  swiftRange.upperBound <= self.count
            else {
                return nil
            }
            let start = index(startIndex, offsetBy: swiftRange.lowerBound)
            let end = index(startIndex, offsetBy: swiftRange.upperBound)
            return String(self[start ..< end])
        }
        set {
            guard let newValue else { return }

            var swiftRange = range.relative(to: 0 ..< Int.max)
            let lower = max(0, min(swiftRange.lowerBound, count))
            let upper = max(lower, min(swiftRange.upperBound, count))
            swiftRange = lower ..< upper

            let start = index(startIndex, offsetBy: lower)
            let end = index(startIndex, offsetBy: upper)
            replaceSubrange(start ..< end, with: newValue)
        }
    }

    /// 通过 `NSRange` 安全获取子字符串
    ///
    /// - Parameter nsRange: 基于 UTF-16 的 NSRange
    /// - Returns: 对应子串;若范围无效（如越界）,返回空 `Substring` 而非崩溃
    /// - Note: 此下标永不抛出异常,适合处理来自 Foundation 或正则匹配的 NSRange
    /// - Example:
    ///   ```swift
    ///   let str = "Hello"
    ///   let sub = str[range: NSRange(location: 1, length: 3)] // "ell"
    ///   ```
    subscript(range: NSRange) -> Substring {
        if let range = Range(range, in: self) {
            return self[range]
        } else {
            return Substring("")
        }
    }
}

// MARK: - 类型转换
public extension String {
    /// 将字符串转换为 `Bool`
    func dy_toBool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`,失败时返回 `0`
    func dy_toInt() -> Int {
        Int(self) ?? 0
    }

    /// 转换为 `Int64`,失败时返回 `0`
    func dy_toInt64() -> Int64 {
        Int64(self) ?? 0
    }

    /// 转换为 `UInt`,失败时返回 `0`
    func dy_toUInt() -> UInt {
        UInt(self) ?? 0
    }

    /// 转换为 `UInt64`,失败时返回 `0`
    func dy_toUInt64() -> UInt64 {
        UInt64(self) ?? 0
    }

    /// 转换为 `Float`,失败时返回 `0.0`
    func dy_toFloat() -> Float {
        Float(self) ?? 0
    }

    /// 转换为 `Double`,失败时返回 `0.0`
    func dy_toDouble() -> Double {
        Double(self) ?? 0
    }

    /// 转换为 `CGFloat`,失败时返回 `0.0`
    func dy_toCGFloat() -> CGFloat {
        CGFloat(Double(self) ?? 0)
    }

    /// 转换为 `NSNumber`
    func dy_toNSNumber() -> NSNumber {
        NSNumber(value: Double(self) ?? 0)
    }

    /// 转换为 `NSDecimalNumber`
    func dy_toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self)
    }

    /// 转换为 `Decimal`
    func dy_toDecimal() -> Decimal {
        return Decimal(string: self) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    func dy_toHexInt() -> Int {
        let clean = self.hasPrefix("#") ? String(self.dropFirst()) : self
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    func dy_toCharacter() -> Character? {
        guard let intValue = Int(self),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    func dy_toCharacters() -> [Character] {
        Array(self)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    func dy_toData() -> Data? {
        self.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    func dy_toURL() -> URL? {
        URL(string: self)
    }

    /// 尝试转换为 `URLRequest`
    func dy_toURLRequest() -> URLRequest? {
        guard let url = self.dy_toURL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    func dy_toNotificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 转换为 `NSString`（桥接）
    func dy_toNSString() -> NSString {
        self as NSString
    }

    /// 转换为 `NSAttributedString`
    func dy_toNSAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    func dy_toNSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    func dy_toHexColor() -> UIColor {
        UIColor(hex: self)
    }

    /// 从资源名加载 `UIImage`
    func dy_toImage() -> UIImage? {
        UIImage(named: self)
    }
}

// MARK: - Emoji检测与提取
public extension String {
    /// 判断字符串是否为单个视觉单元的 Emoji
    var dy_isSingleEmoji: Bool {
        return self.count == 1 && self.first?.dy_isEmoji == true
    }

    /// 判断字符串是否包含至少一个 Emoji 字符
    var dy_containsEmoji: Bool {
        return self.contains { $0.dy_isEmoji }
    }

    /// 判断字符串是否仅由`Emoji`字符组成（不含空格、标点等）
    var dy_containsOnlyEmoji: Bool {
        return !self.isEmpty && self.allSatisfy(\.dy_isEmoji)
    }

    /// 提取所有`Emoji`字符并拼接成新字符串
    var dy_emojiString: String {
        return self.dy_emojis.map(String.init).joined()
    }

    /// 提取所有`Emoji`字符数组
    var dy_emojis: [Character] {
        return self.filter(\.dy_isEmoji)
    }

    /// 提取所有 `Emoji` 的底层 `Unicode` 标量
    var dy_emojiScalars: [UnicodeScalar] {
        return self.dy_emojis.flatMap(\.unicodeScalars)
    }
}

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
    /// - Returns: 填充后的字符串;若原长度 ≥ 目标长度或填充串为空,则返回原字符串
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
        return self.position(of: substring, backwards: false)
    }

    /// 返回子字符串最后一次出现的 UTF-16 索引位置
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 最后一次出现的起始索引,未找到返回 `-1`
    func dy_positionLast(of substring: String) -> Int {
        return self.position(of: substring, backwards: true)
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

// MARK: - 字符提取、统计与分析
public extension String {
    /// 提取所有数字字符（Unicode 十进制数字）
    ///
    /// - Returns: 仅包含数字的字符串
    /// - Note: 使用 `Character.isNumber`,支持全角数字、罗马数字等（若需仅 0-9,请用 `CharacterSet.decimalDigits`）
    var dy_numerics: String {
        self.filter(\.isNumber)
    }

    /// 获取第一个字符（作为字符串）
    ///
    /// - Returns: 第一个字符的字符串形式;若为空串,返回 `nil`
    var dy_firstCharacter: String? {
        guard !self.isEmpty else { return nil }
        return String(self.first!)
    }

    /// 获取最后一个字符（作为字符串）
    ///
    /// - Returns: 最后一个字符的字符串形式;若为空串,返回 `nil`
    var dy_lastCharacter: String? {
        guard !self.isEmpty else { return nil }
        return String(self.last!)
    }

    /// 统计单词数量（以空白符和标点符号为分隔）
    ///
    /// - Returns: 非空单词的数量
    var dy_wordCount: Int {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return self.components(separatedBy: separators).count { !$0.isEmpty }
    }

    /// 统计数字字符个数
    ///
    /// - Returns: 满足 `isNumber` 的字符数量
    var dy_numericCount: Int {
        self.count(where: \.isNumber)
    }

    /// 计算“显示宽度”：英文/数字占 1,常见汉字占 2（适用于终端对齐）
    ///
    /// - Returns: 加权字符数
    /// - Limitation: 仅检测基本汉字范围 `U+4E00–U+9FFF`,不覆盖扩展汉字、日韩汉字等
    var dy_displayWidth: Int {
        self.reduce(0) { width, char in
            if let scalar = char.unicodeScalars.first,
               (0x4E00 ... 0x9FFF).contains(scalar.value)
            {
                return width + 2
            }
            return width + 1
        }
    }

    /// 统计子字符串出现次数
    ///
    /// - Parameters:
    ///   - substring: 要统计的子串
    ///   - caseSensitive: 是否区分大小写,默认为 `true`
    /// - Returns: 出现次数
    /// - Note: 使用 `components(separatedBy:)` 实现,简单高效
    func dy_countOccurrences(of substring: String, caseSensitive: Bool = true) -> Int {
        guard !substring.isEmpty else { return 0 }
        let source = caseSensitive ? self : self.lowercased()
        let target = caseSensitive ? substring : substring.lowercased()
        return source.components(separatedBy: target).count - 1
    }

    /// 查找出现频率最高的非空白字符
    ///
    /// - Returns: 最常见字符;若无有效字符（如全为空白）,返回 `nil`
    /// - Note: 空格、制表符、换行等均被过滤
    var dy_mostFrequentCharacter: Character? {
        let nonWhitespace = self.filter { !$0.isWhitespace }
        guard !nonWhitespace.isEmpty else { return nil }

        let frequency = nonWhitespace.reduce(into: [:]) { dict, char in
            dict[char, default: 0] += 1
        }
        return frequency.max(by: { $0.value < $1.value })?.key
    }

    /// 获取每个 Unicode 标量的数值（十进制）
    ///
    /// - Returns: `Int` 类型的 Unicode 码点数组
    var dy_unicodeScalarValues: [Int] {
        self.unicodeScalars.map { Int($0.value) }
    }

    /// 提取所有单词（以空白符和标点符号分割）
    ///
    /// - Returns: 非空单词数组
    var dy_words: [String] {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return self.components(separatedBy: separators).filter { !$0.isEmpty }
    }

    /// 将整数 UTF-16 索引安全转换为 `String.Index`
    ///
    /// - Parameter offset: UTF-16 索引（从 0 开始）
    /// - Returns: 对应的 `String.Index`;若越界,返回最近边界（`startIndex` 或 `endIndex`）
    /// - Note: 使用 `samePosition(in:)` 确保在复杂 Unicode 下仍安全
    func dy_index(at offset: Int) -> String.Index {
        if offset <= 0 {
            return self.startIndex
        } else if offset >= self.utf16.count {
            return self.endIndex
        } else {
            let utf16Index = self.utf16.index(self.utf16.startIndex, offsetBy: offset)
            return utf16Index.samePosition(in: self) ?? self.endIndex
        }
    }
}

// MARK: - Unicode编解码
public extension String {
    /// 将字符串编码为 `JavaScript/JSON` 兼容的 `\uXXXX` 转义格式
    ///
    /// - Returns: 所有字符转换为 UTF-16 单元的 `\uXXXX` 序列拼接结果
    var dy_unicodeEncoded: String {
        var result = ""
        for char in self {
            // 使用 UTF-16 单元确保与 JS/JSON 行为一致
            for unit in String(char).utf16 {
                result += "\\u" + String(format: "%04x", unit)
            }
        }
        return result
    }

    /// 将 `JavaScript/JSON` 风格的 `\uXXXX` 转义字符串解码为原始字符串
    ///
    /// - Returns: 解码后的字符串;无法识别的 `\uXXXX` 序列将被保留原样
    var dy_unicodeDecoded: String {
        // 先提取所有 \uXXXX 序列(不区分大小写)
        let pattern = #"\\u([0-9a-fA-F]{4})"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return self // 正则失败,原样返回
        }

        let nsString = self as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, range: fullRange)

        // 如果没有匹配项,直接返回
        if matches.isEmpty {
            return self
        }

        var result = ""
        var lastIndex = 0
        var pendingHighSurrogate: UInt16? = nil

        for match in matches {
            let matchRange = match.range // 整个 \uXXXX
            let hexRange = match.range(at: 1) // 仅 XXXX 部分

            // 添加匹配前的普通文本
            if matchRange.location > lastIndex {
                result += nsString.substring(with: NSRange(location: lastIndex, length: matchRange.location - lastIndex))
            }

            // 解析十六进制
            let hexStr = nsString.substring(with: hexRange)
            guard let codeUnit = UInt16(hexStr, radix: 16) else {
                // 无效十六进制,原样保留 \uXXXX
                result += nsString.substring(with: matchRange)
                lastIndex = matchRange.upperBound
                continue
            }

            // 处理 UTF-16 代理对
            if let high = pendingHighSurrogate {
                // 期待低代理
                if codeUnit >= 0xDC00, codeUnit <= 0xDFFF {
                    // 合并代理对
                    let highAdjusted = UInt32(high - 0xD800)
                    let lowAdjusted = UInt32(codeUnit - 0xDC00)
                    let scalarValue = (highAdjusted << 10) + lowAdjusted + 0x10000
                    if let scalar = UnicodeScalar(scalarValue) {
                        result += String(scalar)
                    } else {
                        // 合并失败,回退
                        result += "\\u" + String(format: "%04x", high)
                        result += "\\u" + String(format: "%04x", codeUnit)
                    }
                } else {
                    // 不是低代理,高代理单独输出(非法但容错)
                    result += "\\u" + String(format: "%04x", high)
                    // 当前 codeUnit 作为新起点处理
                    if codeUnit < 0xD800 || codeUnit > 0xDFFF {
                        if let scalar = UnicodeScalar(codeUnit) {
                            result += String(scalar)
                        } else {
                            result += "\\u" + String(format: "%04x", codeUnit)
                        }
                    } else if codeUnit >= 0xD800, codeUnit <= 0xDBFF {
                        // 又是一个高代理,更新 pending
                        pendingHighSurrogate = codeUnit
                    } else {
                        // 低代理单独出现(非法)
                        result += "\\u" + String(format: "%04x", codeUnit)
                    }
                }
                pendingHighSurrogate = nil
            } else if codeUnit >= 0xD800, codeUnit <= 0xDBFF {
                // 高代理：暂存,等待下一个
                pendingHighSurrogate = codeUnit
            } else if codeUnit >= 0xDC00, codeUnit <= 0xDFFF {
                // 低代理单独出现(非法),直接输出
                result += "\\u" + String(format: "%04x", codeUnit)
            } else {
                // 普通字符
                if let scalar = UnicodeScalar(codeUnit) {
                    result += String(scalar)
                } else {
                    result += "\\u" + String(format: "%04x", codeUnit)
                }
            }

            lastIndex = matchRange.upperBound
        }

        // 处理剩余未匹配文本
        if lastIndex < nsString.length {
            result += nsString.substring(from: lastIndex)
        }

        // 如果还有未配对的高代理,追加回去
        if let high = pendingHighSurrogate {
            result += "\\u" + String(format: "%04x", high)
        }

        return result
    }
}

// MARK: - Base64 编解码扩展
public extension String {
    /// 使用 Base64 字符串初始化 `String`
    ///
    /// - Parameter base64String: Base64 编码的字符串（可包含换行、空格等）
    /// - Returns: 成功解码并以 UTF-8 解析的字符串,或 `nil`
    /// - Note: 自动忽略非法字符（如空格、换行）,但`不自动补全 `=` 填充`
    /// - Example:
    ///   ```swift
    ///   let str = String(base64: "SGVsbG8g8J+MjQ==") // Optional("Hello 😊")
    ///   ```
    init?(base64 base64String: String) {
        guard let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
              let string = String(data: data, encoding: .utf8)
        else {
            return nil
        }
        self = string
    }

    /// 将字符串以 UTF-8 编码后进行 Base64 编码
    ///
    /// - Returns: Base64 编码字符串,或 `nil`（理论上 UTF-8 不会失败）
    var dy_base64Encoded: String? {
        self.dy_toData()?.base64EncodedString()
    }

    /// 尝试将字符串作为 Base64 进行解码（自动处理缺失的填充符 `=`）
    ///
    /// - Returns: 解码后的 UTF-8 字符串,或 `nil`
    var dy_base64Decoded: String? {
        // 第一次尝试：标准解码
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters),
           let str = String(data: data, encoding: .utf8)
        {
            return str
        }

        // 自动补全填充
        let remainder = count % 4
        if remainder != 0 {
            let padded = self + String(repeating: "=", count: 4 - remainder)
            if let data = Data(base64Encoded: padded, options: .ignoreUnknownCharacters),
               let str = String(data: data, encoding: .utf8)
            {
                return str
            }
        }
        return nil
    }
}

// MARK: - 安全哈希与摘要计算
public extension String {
    /// 哈希输出格式选项
    ///
    /// - Note: 16 位格式（`.lowercase16` / `.uppercase16`）**仅用于兼容旧系统**,因信息丢失严重,**不推荐用于新项目**
    enum DyHashFormat {
        case lowercase32 // < 32 位小写十六进制（标准）
        case uppercase32 // < 32 位大写十六进制
        case lowercase16 // < ⚠️ 截取中间 16 位小写（兼容旧系统）
        case uppercase16 // < ⚠️ 截取中间 16 位大写（兼容旧系统）
    }

    /// 支持的加密哈希算法
    ///
    /// - Warning:
    ///   - `.md5` 已被密码学界视为**不安全**,仅用于遗留系统兼容
    ///   - 推荐使用 `.sha256`（通用）或 `.sha512`（高安全需求）
    enum DyHashAlgorithm {
        case md5 // < ❌ 已破解,仅兼容
        case sha256 // < ✅ 推荐
        case sha512 // < ✅ 更高安全级别

        /// 返回对应算法的摘要字节长度
        var digestLength: Int {
            switch self {
            case .md5: return Int(CC_MD5_DIGEST_LENGTH)
            case .sha256: return Int(CC_SHA256_DIGEST_LENGTH)
            case .sha512: return Int(CC_SHA512_DIGEST_LENGTH)
            }
        }

        /// 对给定数据执行哈希运算
        ///
        /// - Parameter data: 输入数据
        /// - Returns: 哈希摘要的字节数组
        func dy_hash(_ data: Data) -> [UInt8] {
            var digest = [UInt8](repeating: 0, count: digestLength)
            data.withUnsafeBytes { buffer in
                guard let baseAddress = buffer.baseAddress else { return }
                switch self {
                case .md5:
                    _ = CC_MD5(baseAddress, CC_LONG(data.count), &digest)
                case .sha256:
                    _ = CC_SHA256(baseAddress, CC_LONG(data.count), &digest)
                case .sha512:
                    _ = CC_SHA512(baseAddress, CC_LONG(data.count), &digest)
                }
            }
            return digest
        }
    }

    /// 计算字符串的安全哈希值
    ///
    /// - Parameters:
    ///   - format: 输出格式,默认为 `.lowercase32`
    ///   - algorithm: 哈希算法,默认为 `.sha256`
    /// - Returns: 哈希字符串;若输入为空字符串,则返回 `nil`
    /// - Security: 使用 UTF-8 编码进行哈希,确保跨平台一致性
    /// - Example:
    ///   ```swift
    ///   "hello".dy_hash()                     // "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824"
    ///   "hello".dy_hash(.uppercase32, .sha512) // 大写 SHA-512 摘要
    ///   ```
    func dy_hash(
        _ format: DyHashFormat = .lowercase32,
        algorithm: DyHashAlgorithm = .sha256
    ) -> String? {
        guard !isEmpty else { return nil }

        let digest = algorithm.dy_hash(Data(utf8))
        let hex = digest.map { String(format: "%02x", $0) }.joined()
        let upperHex = digest.map { String(format: "%02X", $0) }.joined()

        switch format {
        case .lowercase32:
            return hex
        case .uppercase32:
            return upperHex
        case .lowercase16:
            // ⚠️ 兼容模式：截取中间 16 字符（即 8～24）
            guard hex.count >= 16 else { return hex } // 防御性编程
            let start = hex.index(hex.startIndex, offsetBy: 8)
            let end = hex.index(start, offsetBy: 16)
            return String(hex[start ..< end])
        case .uppercase16:
            guard upperHex.count >= 16 else { return upperHex }
            let start = upperHex.index(upperHex.startIndex, offsetBy: 8)
            let end = upperHex.index(start, offsetBy: 16)
            return String(upperHex[start ..< end])
        }
    }

    /// ⚠️【已弃用】计算 MD5 哈希值（仅用于遗留系统兼容）
    ///
    /// - Important: **MD5 已被证明存在碰撞漏洞,绝对不可用于密码存储、数字签名等安全敏感场景**
    /// - Migration: 请改用 `hash(algorithm: .sha256)`
    /// - Returns: MD5 哈希字符串（按指定格式）,空输入返回 `nil`
    @available(*, deprecated, message: "MD5 is cryptographically broken. Use hash(algorithm: .sha256) instead.")
    func dy_md5(_ format: DyHashFormat = .lowercase32) -> String? {
        return self.dy_hash(format, algorithm: .md5)
    }
}

// MARK: - URL 百分号编解码扩展
public extension String {
    /// 对字符串进行 URL 百分号编码（适用于查询参数、路径片段等通用场景）
    ///
    /// - Returns: 编码后的字符串;若编码失败（理论上不会）,返回原字符串
    /// - Note: 使用 `.urlQueryAllowed` 字符集,保留字母、数字及 `-._～!*'()` 等安全字符
    /// - Example:
    ///   ```swift
    ///   "it's easy".dy_urlEncoded() // "it's%20easy"
    ///   "hello world!".dy_urlEncoded() // "hello%20world!"
    ///   ```
    func dy_urlEncoded() -> String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }

    /// 对已 URL 编码的字符串进行解码
    ///
    /// - Returns: 解码后的字符串;若解码失败（如非法 `%` 序列）,返回原字符串
    /// - Example:
    ///   ```swift
    ///   "it's%20easy".dy_urlDecoded() // "it's easy"
    ///   ```
    func dy_urlDecoded() -> String {
        removingPercentEncoding ?? self
    }
}

// MARK: - 随机与假文字符串生成扩展
public extension String {
    /// 生成指定长度的随机字符串（包含大小写字母和数字）
    ///
    /// - Parameter length: 目标长度（必须 > 0）
    /// - Returns: 随机字符串;若 `length <= 0`,返回空字符串
    /// - Note: 使用 `String.randomElement()`,基于系统默认随机源（非加密安全）
    ///         如需密码学安全随机,请使用 `CryptoKit` 或 `SecRandomCopyBytes`
    /// - Example:
    ///   ```swift
    ///   String.dy_random(length: 8) // e.g. "aB3xK9Lm"
    ///   ```
    static func dy_random(length: Int) -> String {
        guard length > 0 else { return "" }
        let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0 ..< length).compactMap { _ in charset.randomElement() })
    }

    /// 生成指定长度的 Lorem Ipsum 假文（英文经典段落）
    ///
    /// - Parameter length: 目标字符数,默认为 445（经典段落长度）
    /// - Returns: 截取后的假文字符串;若 `length <= 0`,返回空字符串
    /// - Note: 内容为标准 Lorem Ipsum 段落,不含敏感信息
    /// - Example:
    ///   ```swift
    ///   String.dy_loremIpsum(length: 20) // "Lorem ipsum dolor si"
    ///   ```
    static func dy_loremIpsum(length: Int = 445) -> String {
        guard length > 0 else { return "" }

        let lorem = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        return String(lorem.prefix(length))
    }
}

// MARK: - HTML 与链接处理
public extension String {
    /// 从简单的 `<a>` 标签中提取链接和文本内容
    /// - 返回值: `(link: String, text: String)` 元组;若匹配失败,返回 `nil`
    /// - 注意: 仅支持单个 `<a>` 标签,且属性顺序固定
    ///
    /// - Example:
    ///     `"<a href=\"https://example.com\">Click</a>".dy_linkAndText` → `("https://example.com", "Click")`
    ///
    var dy_linkAndText: (link: String, text: String)? {
        let pattern = #"href\s*=\s*["']([^"']+)["'][^>]*>([^<]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]),
              let match = regex.firstMatch(in: self, range: NSRange(self.startIndex..., in: self))
        else {
            return nil
        }

        let linkRange = match.range(at: 1)
        let textRange = match.range(at: 2)

        guard let link = Range(linkRange, in: self),
              let text = Range(textRange, in: self)
        else {
            return nil
        }

        return (String(self[link]), String(self[text]))
    }

    /// 提取字符串中所有 URL、@提及、#话题 的 `NSRange`
    /// - 返回值: 匹配范围数组;若正则失败,返回 `nil`
    /// - 支持: http/https 链接、@用户名(含中文)、#话题#
    ///
    /// - Example:
    ///     `"看 https://a.com 和 @张三 #热点#"` → 三个 NSRange
    ///
    var dy_linkRanges: [NSRange]? {
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
            let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            allRanges.append(contentsOf: matches.map(\.range))
        }

        return allRanges.isEmpty ? nil : allRanges
    }
}

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

    /// 将汉字转换为拼音(可选是否保留声调)
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

    /// 将文本限制在指定宽度和最大行数内,并在末尾添加自定义后缀(如“...全文”)
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

// MARK: - 字符串通用分割
public extension String {
    /// 按固定长度分割字符串
    ///
    /// - Parameter length: 每段的字符长度
    /// - Returns: 分割后的字符串数组
    ///
    /// - Example:
    ///   ```swift
    ///   "HelloWorld".dy_split(byLength: 5) // ["Hello", "World"]
    ///   ```
    func dy_split(byLength length: Int) -> [String] {
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
    ///   "a,b,c".dy_split(bySeparator: ",") // ["a", "b", "c"]
    ///   "".dy_split(bySeparator: ",")      // []
    ///   ```
    func dy_split(bySeparator separator: String) -> [String] {
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
    func dy_replacingRegexMatches(
        using regex: NSRegularExpression,
        withTemplate template: String,
        matchingOptions: NSRegularExpression.MatchingOptions = [],
        in range: Range<String.Index>? = nil
    ) -> String {
        let nsRange = NSRange(range ?? startIndex ..< endIndex, in: self)
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
    func dy_replacingRegexMatches(
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
            range: NSRange(startIndex ..< endIndex, in: self),
            withTemplate: template
        )
    }

    // MARK: - 普通替换与清理

    /// 替换所有匹配的子串
    /// - Parameters:
    ///   - target: 被替换的子串
    ///   - replacement: 替换内容
    /// - Returns: 替换后的新字符串
    func dy_replacing(_ target: String, with replacement: String) -> String {
        return replacingOccurrences(of: target, with: replacement)
    }

    /// 隐藏指定字符位置范围的敏感信息(位置从 0 开始,按用户可见字符计数)
    /// - Parameters:
    ///   - range: 要隐藏的字符范围(左闭右开),例如 `3..<7`
    ///   - replacement: 用于遮蔽的字符串,默认为 `"**`"`
    /// - Returns: 遮蔽后的字符串;若范围无效,返回原字符串
    ///
    /// - Example:
    ///     `"13812345678".dy_hidingSensitiveContent(in: 3..<7)` → `"138**`5678"`
    func dy_hidingSensitiveContent(in range: Range<Int>, with replacement: String = "**`") -> String {
        let charCount = self.count
        let lower = max(0, min(range.lowerBound, charCount))
        let upper = max(lower, min(range.upperBound, charCount))
        guard lower < upper else { return self }

        let startIdx = index(startIndex, offsetBy: lower)
        let endIdx = index(startIdx, offsetBy: upper - lower)
        return replacingCharacters(in: startIdx ..< endIdx, with: replacement)
    }

    /// 移除所有出现在给定字符串中的字符
    /// - Parameter characters: 包含要移除字符的字符串
    /// - Returns: 移除指定字符后的新字符串
    ///
    /// - Example:
    ///     `"Hello World!".dy_removingCharacters(in: "lo!")` → `"He Wrd"`
    func dy_removingCharacters(in characters: String) -> String {
        let characterSet = Set(characters)
        return filter { !characterSet.contains($0) }
    }

    /// 移除字符串开头的指定前缀(如果存在)
    /// - Parameter prefix: 要移除的前缀
    /// - Returns: 移除前缀后的新字符串
    func dy_removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(self[prefix.endIndex...])
    }

    /// 移除字符串末尾的指定后缀(如果存在)
    /// - Parameter suffix: 要移除的后缀
    /// - Returns: 移除后缀后的新字符串
    func dy_removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(self[..<suffix.startIndex])
    }
}

// MARK: - 字符串操作
public extension String {
    /// 首字母大写,其余保持不变
    /// - 返回值: 首字母大写后的字符串;若为空,返回 `nil`
    ///
    /// - Example:
    ///     `"hello world".dy_capitalizeFirst()` → `"Hello world"`
    ///
    func dy_capitalizeFirst() -> String? {
        guard !isEmpty else { return nil }
        return String(first!).uppercased() + dropFirst()
    }

    /// 返回反转后的字符串(非 mutating)
    /// - 返回值: 反转结果
    ///
    /// - Example:
    ///     `"Hello".dy_reverse()` → `"olleH"`
    ///
    func dy_reverse() -> String {
        String(reversed())
    }

    /// 在字符串前添加前缀(若尚未包含)
    /// - 参数 prefix: 要添加的前缀
    /// - 返回值: 添加后的字符串
    ///
    /// - Example:
    ///     `"www.apple.com".dy_withPrefix("https://")` → `"https://www.apple.com"`
    ///
    func dy_withPrefix(_ prefix: String) -> String {
        hasPrefix(prefix) ? self : prefix + self
    }

    /// 在字符串后添加后缀(若尚未包含)
    /// - 参数 suffix: 要添加的后缀
    /// - 返回值: 添加后的字符串
    ///
    /// - Example:
    ///     `"www.apple".dy_withSuffix(".com")` → `"www.apple.com"`
    ///
    func dy_withSuffix(_ suffix: String) -> String {
        hasSuffix(suffix) ? self : self + suffix
    }

    /// 在指定 UTF-16 位置插入字符串
    /// - 参数 content: 要插入的内容
    /// - 参数 at: 插入位置(从 0 开始)
    /// - 返回值: 新字符串;若位置越界,插入到末尾
    ///
    /// - Example:
    ///     `"HelloWorld!".dy_insert(" ", at: 5)` → `"Hello World!"`
    ///
    func dy_insert(_ content: String, at position: Int) -> String {
        let safePos = max(0, min(position, utf16.count))
        let idx = utf16.index(utf16.startIndex, offsetBy: safePos)
        guard let stringIdx = String.Index(idx, within: self) else {
            return self + content // fallback
        }
        return String(self[..<stringIdx]) + content + String(self[stringIdx...])
    }

    /// 重复当前字符串指定次数
    /// - 参数 times: 重复次数(≥0)
    /// - 返回值: 重复后的字符串;若 `times ≤ 0`,返回空串
    ///
    /// - Example:
    ///     `"abc".dy_repeated(3)` → `"abcabcabc"`
    ///
    func dy_repeated(_ times: Int) -> String {
        guard times > 0 else { return "" }
        return String(repeating: self, count: times)
    }

    /// 获取与另一字符串的最长公共后缀
    /// - 参数 other: 比较对象
    /// - 返回值: 公共后缀字符串
    ///
    /// - Example:
    ///     `"apple".dy_commonSuffix(with: "maple")` → `"ple"`
    ///
    func dy_commonSuffix(with other: String) -> String {
        let common = zip(reversed(), other.reversed())
            .prefix(while: { pair in pair.0 == pair.1 })
            .map(\.0)
        return String(common.reversed())
    }
}

// MARK: - 字符判断(高效、无正则)
public extension String {
    // MARK: - 基础字符检测

    /// 是否包含任意字母
    var dy_hasLetters: Bool {
        rangeOfCharacter(from: .letters) != nil
    }

    /// 是否只包含字母(无数字、符号等)
    var dy_isAlphabetic: Bool {
        !isEmpty && allSatisfy(\.isLetter)
    }

    /// 是否包含任意数字
    var dy_hasDigits: Bool {
        rangeOfCharacter(from: .decimalDigits) != nil
    }

    /// 是否只包含数字(0-9)
    var dy_isDigits: Bool {
        !isEmpty && allSatisfy(\.isNumber)
    }

    /// 是否同时包含字母和数字
    var dy_hasAlphanumeric: Bool {
        self.dy_hasLetters && self.dy_hasDigits
    }

    /// 是否只包含字母或数字(即：字母数字混合,无符号)
    var dy_isAlphanumeric: Bool {
        !isEmpty && allSatisfy { $0.isLetter || $0.isNumber }
    }

    /// 是否只包含空格或换行符
    var dy_isWhitespace: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 是否所有字符唯一(无重复)
    var dy_hasUniqueCharacters: Bool {
        Set(self).count == count
    }

    /// 是否包含中文字符(支持扩展汉字)
    var dy_containsChinese: Bool {
        self.unicodeScalars.contains { scalar in
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF) ||
                (v >= 0x20000 && v <= 0x2A6DF) ||
                (v >= 0x2A700 && v <= 0x2B73F) ||
                (v >= 0x2B740 && v <= 0x2B81F)
        }
    }

    /// 是否只包含中文字符
    var dy_isChinese: Bool {
        !isEmpty && allSatisfy { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF)
        }
    }

    // MARK: - 连续数字检测

    /// 是否包含连续 ≥2 位的数字
    var dy_hasContinuousDigits: Bool {
        var count = 0
        for c in self {
            if c.isNumber {
                count += 1
                if count >= 2 {
                    return true
                }
            } else {
                count = 0
            }
        }
        return false
    }
}

// MARK: - 回文 & 拼写
public extension String {
    /// 是否为回文(忽略大小写,仅比较字母)
    var dy_isPalindrome: Bool {
        let letters = filter(\.isLetter).lowercased()
        return letters == String(letters.reversed())
    }

    /// 是否拼写正确(仅 iOS/macOS)
    var dy_isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: self,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelled.location == NSNotFound
    }
}

// MARK: - 通用格式验证
public extension String {
    /// 是否为有效中国手机号(11 位,1[3-9] 开头)
    var dy_isValidPhoneNumber: Bool {
        dy_isMatch(pattern: "^1[3-9]\\d{9}$")
    }

    /// 是否为有效邮箱(宽松版)
    var dy_isValidEmail: Bool {
        dy_isMatch(pattern: #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)
    }

    /// 是否为有效 URL(任意协议)
    var dy_isValidURL: Bool {
        URL(string: self) != nil
    }

    /// 是否为带协议的 URL(如 http://, https://)
    var dy_isValidSchemedURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 是否为 HTTPS URL
    var dy_isValidHttpsURL: Bool {
        URL(string: self)?.scheme == "https"
    }

    /// 是否为 HTTP URL
    var dy_isValidHttpURL: Bool {
        URL(string: self)?.scheme == "http"
    }

    /// 是否为文件 URL
    var dy_isValidFileURL: Bool {
        URL(string: self)?.isFileURL == true
    }
}

// MARK: - 自定义规则
public extension String {
    /// 是否符合字母数字+下划线,长度在 [min, max]
    func dy_isValidAlphanumeric(minLen: Int, maxLen: Int) -> Bool {
        guard count >= minLen, count <= maxLen else { return false }
        return allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    /// 是否为有效昵称(中英文、数字、下划线)
    var dy_isValidNickname: Bool {
        dy_isMatch(pattern: #"^[\u{4e00}-\u{9fff}a-zA-Z0-9_]+$"#)
    }

    /// 是否为有效用户名(中英文,1-20 字符)
    var dy_isValidUsername: Bool {
        count >= 1 && count <= 20 && allSatisfy { $0.isLetter || ($0.unicodeScalars.first?.value ?? 0) >= 0x4E00 }
    }

    /// 是否为有效密码
    /// - `complex = false`: 至少包含字母+数字,≥6 位
    /// - `complex = true`: 必须包含大小写字母+数字+特殊符号,≥8 位
    func dy_isValidPassword(complex: Bool = false) -> Bool {
        if complex {
            return dy_isMatch(pattern: #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{}|;:'",.<>/?]).{8,}$"#)
        } else {
            return count >= 6 && dy_hasLetters && dy_hasDigits
        }
    }
}

// MARK: - 数字格式
public extension String {
    /// 是否为整数(支持负号)
    var dy_isInteger: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanInt() != nil && scanner.isAtEnd
    }

    /// 是否为浮点数(支持科学计数法)
    var dy_isFloat: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanFloat() != nil && scanner.isAtEnd
    }
}

// MARK: - 身份证(简化版)
public extension String {
    /// 是否符合身份证基本格式(15/18 位)
    var dy_isBasicIDNumber: Bool {
        dy_isMatch(pattern: #"^(\d{15}|\d{17}[\dXx])$"#)
    }

    /// 是否为严格有效的 18 位身份证(含校验码)
    var dy_isStrictIDNumber: Bool {
        guard count == 18, dy_isBasicIDNumber else { return false }

        let weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let checkCodes = "10X98765432"

        var sum = 0
        for i in 0 ..< 17 {
            guard let digit = Int(self.dy_character(at: i)) else { return false }
            sum += digit * weights[i]
        }

        let expected = String(checkCodes[checkCodes.index(checkCodes.startIndex, offsetBy: sum % 11)])
        let actual = String(self[self.index(self.startIndex, offsetBy: 17)])
        return expected.uppercased() == actual.uppercased()
    }
}

// MARK: - 子串匹配
public extension String {
    /// 是否包含子串(可选大小写敏感)
    func dy_contains(_ substring: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return contains(substring)
        }
        return localizedCaseInsensitiveContains(substring)
    }

    /// 是否以某前缀开头(可选大小写敏感)
    func dy_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return hasPrefix(prefix)
        }
        return lowercased().hasPrefix(prefix.lowercased())
    }

    /// 是否以某后缀结尾(可选大小写敏感)
    func dy_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return hasSuffix(suffix)
        }
        return lowercased().hasSuffix(suffix.lowercased())
    }
}

// MARK: - 正则匹配操作符
/// 自定义正则匹配操作符 `=~`
/// 优先级：高于加法,低于乘法
infix operator =~: RegPrecedence
precedencegroup RegPrecedence {
    associativity: none
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
}

public extension String {
    /// 正则匹配操作符：检查字符串是否包含匹配正则表达式的内容
    /// - Parameters:
    ///   - lhs: 要匹配的字符串
    ///   - rhs: 正则表达式模式
    /// - Returns: 是否存在匹配
    ///
    /// - Example:
    ///   ```swift
    ///   "123abc" =～ "\\d+"  // true
    ///   "abc" =～ "^\\d+$"   // false
    ///   ```
    static func =~ (lhs: String, rhs: String) -> Bool {
        lhs.dy_isMatch(pattern: rhs)
    }
}

// MARK: - 正则扩展
public extension String {
    /// 将字符串中的正则元字符转义为字面量
    /// - Returns: 转义后的安全正则字符串
    ///
    /// - Example:
    ///   ```swift
    ///   "hello ^$ there".dy_regexEscaped() // "hello \\^\\$ there"
    ///   ```
    func dy_regexEscaped() -> String {
        NSRegularExpression.escapedPattern(for: self)
    }

    /// 检查字符串是否`包含`匹配指定正则表达式的内容
    /// - Parameters:
    ///   - pattern: 正则表达式模式
    ///   - options: 匹配选项(如 `.caseInsensitive`),默认为空
    /// - Returns: 若存在匹配则返回 `true`,否则 `false`;若正则无效,返回 `false`
    ///
    /// - Note: 此方法使用 `NSRegularExpression`,性能优于 `NSPredicate`
    ///
    /// - Example:
    ///   ```swift
    ///   "123abc".dy_isMatch(pattern: "\\d+")                          // true
    ///   "example@example.com".dy_isMatch(pattern: "^[\\w.-]+@")       // true
    ///   "invalid-email".dy_isMatch(pattern: "invalid[", options: [])  // false(无效正则)
    ///   ```
    func dy_isMatch(pattern: String, options: NSRegularExpression.Options = []) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return false // 无效正则视为不匹配(安全策略)
        }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }

    /// 获取正则表达式的`所有捕获组内容`
    /// - Parameters:
    ///   - pattern: 正则表达式模式(需包含捕获组 `(...)`)
    ///   - options: 正则选项(如 `.caseInsensitive`)
    /// - Returns: 第一个匹配的捕获组数组(不含完整匹配),若无匹配或正则无效则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   "abc123xyz".dy_captures(pattern: "(\\d+)")               // ["123"]
    ///   "John Doe, age 30".dy_captures(pattern: "(\\w+) (\\w+), age (\\d+)") // ["John", "Doe", "30"]
    ///   ```
    func dy_captures(pattern: String, options: NSRegularExpression.Options = []) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options),
              let match = regex.firstMatch(in: self, range: NSRange(location: 0, length: utf16.count))
        else {
            return nil
        }
        // 跳过第 0 个(完整匹配),从 1 开始取捕获组
        return (1 ..< match.numberOfRanges).compactMap { index in
            Range(match.range(at: index), in: self).map { String(self[$0]) }
        }
    }

    /// 获取字符串中`所有匹配项的 NSRange`
    /// - Parameters:
    ///   - pattern: 正则表达式模式
    ///   - options: 正则选项
    /// - Returns: 所有匹配的 `NSRange` 数组(按出现顺序),正则无效时返回空数组
    ///
    /// - Example:
    ///   ```swift
    ///   "a1b2c3".dy_matchRanges(pattern: "\\d") // [NSRange(1,1), NSRange(3,1), NSRange(5,1)]
    ///   ```
    func dy_matchRanges(pattern: String, options: NSRegularExpression.Options = []) -> [NSRange] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: options) else {
            return []
        }
        let range = NSRange(location: 0, length: utf16.count)
        return regex.matches(in: self, options: [], range: range).map(\.range)
    }
}

// MARK: - 字符串尺寸计算
public extension String {
    /// 计算普通字符串在指定宽度和字体下的实际尺寸
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度,默认为 `.greatestFiniteMagnitude`
    ///   - font: 使用的字体(iOS: `UIFont`, macOS: `NSFont`)
    ///   - usesLineFragmentOrigin: 是否使用段落布局模式(默认 `true`)
    ///   - ceilResult: 是否对结果向上取整(默认 `true`,便于 UI 布局)
    /// - Returns: 字符串占用的尺寸(`CGSize`)
    ///
    /// - Example:
    ///   ```swift
    ///   let size = "Hello".dy_size(maxWidth: 200, font: .systemFont(ofSize: 16))
    ///   ```
    func dy_size(
        maxWidth: CGFloat = .greatestFiniteMagnitude,
        font: DyFont,
        usesLineFragmentOrigin: Bool = true,
        ceilResult: Bool = true
    ) -> CGSize {
        let options: NSStringDrawingOptions = usesLineFragmentOrigin
            ? [.usesLineFragmentOrigin, .usesFontLeading]
            : [.usesFontLeading]

        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(
            with: constraint,
            options: options,
            attributes: [.font: font],
            context: nil
        )
        let size = rect.size
        return ceilResult ? CGSize(width: ceil(size.width), height: ceil(size.height)) : size
    }

    /// 使用富文本属性计算字符串尺寸(支持行间距、字间距等)
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度,默认为 `.greatestFiniteMagnitude`
    ///   - font: 字体
    ///   - lineSpacing: 行间距(默认 0)
    ///   - paragraphSpacing: 段落间距(默认 0)
    ///   - wordSpacing: 字符间距(即 kerning,默认 0)
    ///   - alignment: 文本对齐方式(默认 `.left`)
    ///   - lineBreakMode: 换行模式(默认 `.byWordWrapping`)
    ///   - ceilResult: 是否对结果向上取整(默认 `true`)
    /// - Returns: 富文本渲染后的尺寸
    ///
    /// - Example:
    ///   ```swift
    ///   let size = "Multi-line text".dy_sizeWithAttributes(
    ///       maxWidth: 150,
    ///       font: .systemFont(ofSize: 14),
    ///       lineSpacing: 4,
    ///       wordSpacing: 0.5
    ///   )
    ///   ```
    func dy_sizeWithAttributes(
        maxWidth: CGFloat = .greatestFiniteMagnitude,
        font: DyFont,
        lineSpacing: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        wordSpacing: CGFloat = 0,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        ceilResult: Bool = true
    ) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: wordSpacing,
            .paragraphStyle: paragraphStyle,
        ]

        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let rect = attributedString.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        let size = rect.size
        return ceilResult ? CGSize(width: ceil(size.width), height: ceil(size.height)) : size
    }
}

// MARK: - 剪贴板
public extension String {
    /// 将字符串复制到系统剪贴板
    ///
    /// - Note: 在 iOS 上使用 `UIPasteboard`,在 macOS 上使用 `NSPasteboard`
    func dy_copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(self, forType: .string)
        #endif
    }
}

// MARK: - 地理位置(地址转坐标)
#if canImport(CoreLocation)
    public extension String {
        /// 对当前地址字符串执行地理编码(反向：地址 → 坐标)
        ///
        /// - Important: 此方法应在主线程调用,因为 `CLGeocoder` 的回调总是在主线程执行
        /// - Parameter completion: 完成回调,返回 `[CLPlacemark]?` 和 `Error?`
        ///
        /// - Example:
        ///   ```swift
        ///   "1600 Amphitheatre Parkway, Mountain View, CA".dy_geocode { placemarks, error in
        ///       if let coordinate = placemarks?.first?.location?.coordinate {
        ///           print("纬度: \(coordinate.latitude), 经度: \(coordinate.longitude)")
        ///       }
        ///   }
        ///   ```
        func dy_geocode(completion: @escaping (CLGeocodeCompletionHandler)) {
            CLGeocoder().geocodeAddressString(self) { placemarks, error in
                DispatchQueue.main.async {
                    completion(placemarks, error)
                }
            }
        }
    }
#endif

// MARK: - 类型与实例反射
public extension String {
    /// 通过类名字符串获取对应的类类型
    ///
    /// - Parameters:
    ///   - bundle: 指定 Bundle,默认为 `.main`
    /// - Returns: 对应的 `AnyClass?`,若未找到则返回 `nil`
    ///
    /// - Note: 自动拼接 Bundle 的模块名(如 `MyApp.MyClass`),并替换空格和连字符为下划线
    ///
    /// - Example:
    ///   ```swift
    ///   if let type = "MyViewController".dy_classFromName() {
    ///       let instance = type.init()
    ///   }
    ///   ```
    func dy_classFromName(in bundle: Bundle = .main) -> AnyClass? {
        guard let bundleName = bundle.bundleIdentifier ?? bundle.infoDictionary?["CFBundleExecutable"] as? String else {
            return nil
        }
        // 清理模块名中的非法字符(Swift 模块名不允许空格或连字符)
        let cleanModuleName = bundleName
            .replacingOccurrences(of: " ", with: "_")
            .replacingOccurrences(of: "-", with: "_")
        let fullClassName = "\(cleanModuleName).\(self)"
        return NSClassFromString(fullClassName)
    }

    /// 通过类名字符串创建该类的实例(要求类继承自 `NSObject` 并有无参 `init()`)
    ///
    /// - Returns: 实例对象,若类不存在或无法初始化则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let viewController = "MyViewController".dy_instanceFromClass() as? UIViewController
    ///   ```
    func dy_instanceFromClass() -> NSObject? {
        guard let cls = self.dy_classFromName(),
              let nsObjectCls = cls as? NSObject.Type
        else {
            return nil
        }
        return nsObjectCls.init()
    }

    /// 从类型描述字符串中提取简单类名(去除模块名和泛型)
    ///
    /// - Example:
    ///   - `"MyApp.UserManager<Database>"` → `"UserManager"`
    ///   - `"Foundation.NSArray"` → `"NSArray"`
    ///   - `"Int"` → `"Int"`
    func dy_simpleClassName() -> String {
        // 先处理泛型：截断 `<...>` 部分
        let base = (firstIndex(of: "<") ?? endIndex) == endIndex ? self : String(self[..<firstIndex(of: "<")!])
        // 再取最后一个 '.' 之后的部分
        if let lastDot = base.lastIndex(of: ".") {
            return String(base[index(after: lastDot)...])
        }
        return base
    }
}

// MARK: - 文件系统操作
public extension String {
    /// 删除指定路径的文件或目录
    ///
    /// - Returns: 成功删除或路径不存在时返回 `true`;删除失败返回 `false`
    ///
    /// - Note: 若路径不存在,视为“已删除”,返回 `true`
    func dy_deleteFileOrDirectory() -> Bool {
        guard FileManager.default.fileExists(atPath: self) else { return true }
        do {
            try FileManager.default.removeItem(atPath: self)
            return true
        } catch {
            #if DEBUG
                print("⚠️ 删除失败 [\(self)]: \(error.localizedDescription)")
            #endif
            return false
        }
    }

    /// 创建多级目录(确保父目录存在)
    ///
    /// - Parameter basePath: 基础路径,默认为当前用户主目录(`NSHomeDirectory()`)
    /// - Returns: 是否成功创建目录(若已存在也返回 `true`)
    ///
    /// - Example:
    ///   ```swift
    ///   "Documents/MyApp/Cache".dy_createDirectories()
    ///   ```
    func dy_createDirectories(in basePath: String = NSHomeDirectory()) -> Bool {
        let fullPath: String = if self.starts(with: "/") || self.starts(with: "～") {
            // 绝对路径或用户路径,直接使用
            self.replacingOccurrences(of: "～", with: NSHomeDirectory())
        } else {
            // 相对路径,拼接到 basePath
            (basePath as NSString).appendingPathComponent(self)
        }

        // 如果路径以 "/" 结尾,视为目录;否则取其父目录
        let directoryPath: String = if fullPath.hasSuffix("/") {
            fullPath
        } else {
            (fullPath as NSString).deletingLastPathComponent
        }

        // 确保目录存在
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(
                    atPath: directoryPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                return true
            } catch {
                #if DEBUG
                    print("⚠️ 创建目录失败 [\(directoryPath)]: \(error.localizedDescription)")
                #endif
                return false
            }
        }
        return true
    }
}

// MARK: - 日期相关扩展
public extension String {
    /// 将当前字符串解析为 `Date` 对象
    ///
    /// 使用 `en_US_POSIX` locale 和 UTC 时区,确保解析结果稳定
    ///
    /// - Parameter format: 日期格式,默认为 `"yyyy-MM-dd HH:mm:ss"`
    /// - Returns: 解析成功的 `Date?`,失败返回 `nil`
    func dy_date(format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}

// MARK: - 数字与金额格式化
public extension String {
    /// 将数字字符串格式化为带千分位的形式(如 "1,234,567.89")
    ///
    /// - Parameters:
    ///   - maximumFractionDigits: 最大小数位数(默认 2)
    ///   - roundingMode: 舍入模式(默认 `.halfEven`)
    ///   - fallback: 格式化失败时的返回值(默认空字符串)
    /// - Returns: 格式化后的字符串
    func dy_formattedAsThousands(
        maximumFractionDigits: Int = 2,
        roundingMode: NumberFormatter.RoundingMode = .halfEven,
        fallback: String = ""
    ) -> String {
        let number = NSDecimalNumber(string: self)
        if number == NSDecimalNumber.notANumber {
            return fallback
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.maximumFractionDigits = max(0, maximumFractionDigits)
        formatter.roundingMode = roundingMode

        return formatter.string(from: number) ?? fallback
    }

    /// 移除小数点后多余的零,以及末尾的小数点
    ///
    /// - Returns: 清理后的字符串
    func dy_trimTrailingZeros() -> String {
        guard let _ = firstIndex(of: ".") else {
            return self
        }

        var result = self
        while result.last == "0" {
            result.removeLast()
        }
        if result.last == "." {
            result.removeLast()
        }
        return result.isEmpty ? "0" : result
    }

    /// 保留指定小数位数并按指定模式舍入
    ///
    /// - Parameters:
    ///   - places: 保留的小数位数(默认 0)
    ///   - mode: 舍入模式(默认 `.halfEven`)
    ///   - fallback: 失败时返回值(默认 "0")
    /// - Returns: 格式化后的字符串
    func dy_rounded(toDecimalPlaces places: Int = 0, mode: NumberFormatter.RoundingMode = .halfEven, fallback: String = "0") -> String {
        let number = NSDecimalNumber(string: self)
        if number == NSDecimalNumber.notANumber {
            return fallback
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.usesGroupingSeparator = false
        formatter.minimumFractionDigits = max(0, places)
        formatter.maximumFractionDigits = max(0, places)
        formatter.roundingMode = mode

        return formatter.string(from: number) ?? fallback
    }
}

// MARK: - 高精度四则运算(基于 NSDecimalNumber)
public extension String {
    /// 加法：`self + other`
    func dy_add(_ other: String?) -> String {
        return performOperation(other) { $0.adding($1) }
    }

    /// 减法：`self - other`
    func dy_subtract(_ other: String?) -> String {
        return performOperation(other) { $0.subtracting($1) }
    }

    /// 乘法：`self * other`
    func dy_multiply(_ other: String?) -> String {
        return performOperation(other) { $0.multiplying(by: $1) }
    }

    /// 除法：`self / other`,若 `other` 为 nil、空或 0,则返回 `self`
    func dy_divide(_ other: String?) -> String {
        guard let other, !other.isEmpty else { return self }
        let divisor = NSDecimalNumber(string: other)
        if divisor == .zero {
            return self
        }
        return performOperation(other) { $0.dividing(by: $1) }
    }
}

// MARK: - URL 操作扩展
public extension String {
    /// 将字符串转义为 POSIX shell 安全的单引号形式
    /// 规则：用单引号包裹,内部单引号用 '\'' 转义
    var dy_shellEscaped: String {
        // 替换每个 ' 为 '\''
        let escaped = self.replacingOccurrences(of: "'", with: "'\\''")
        return "'\(escaped)'"
    }

    /// 从字符串中提取所有有效的 URL 链接
    ///
    /// 使用系统 `NSDataDetector` 自动识别文本中的超链接(包括 http/https 等)
    /// 返回 `URL` 对象数组,保留原始编码信息,便于后续安全操作
    ///
    /// - Returns: 所有匹配到的 `URL` 对象数组;若无匹配,返回空数组 `[]`
    ///
    /// - Example:
    ///   ```swift
    ///   let text = "Visit https://apple.com or mailto:support@example.com"
    ///   let urls = text.dy_urls
    ///   print(urls.map { $0.absoluteString }) // ["https://apple.com", "mailto:support@example.com"]
    ///   ```
    var dy_urls: [URL] {
        // NSDataDetector 是轻量级的,每次创建开销小,且线程安全
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return [] // 极罕见情况,返回空数组比崩溃更安全
        }

        let range = NSRange(location: 0, length: utf16.count)
        let matches = detector.matches(in: self, options: [], range: range)

        return matches.compactMap { result in
            result.url // 自动过滤 nil
        }
    }

    /// 解析当前字符串作为 URL 的查询参数(query string),返回每个键对应的所有值
    ///
    /// - 自动对 percent-encoded 的键和值进行解码(如 `%20` → 空格)
    /// - 支持重复键(如 `?tag=a&tag=b` → `["tag": ["a", "b"]]`)
    /// - 若字符串不是有效 URL 或无查询参数,返回空字典
    ///
    /// - Returns: `[String: [String]]`,每个键对应一个字符串数组(至少包含一个元素)
    ///
    /// - Example:
    ///   ```swift
    ///   let url = "https://example.com?name=John%20Doe&hobby=reading&hobby=coding"
    ///   let params = url.dy_queryParameters
    ///   print(params["name"] ?? [])      // ["John Doe"]
    ///   print(params["hobby"] ?? [])     // ["reading", "coding"]
    ///   ```
    var dy_queryParameters: [String: [String]] {
        guard let components = URLComponents(string: self),
              let queryItems = components.queryItems,
              !queryItems.isEmpty
        else {
            return [:]
        }

        var parameters: [String: [String]] = [:]

        for item in queryItems {
            // 自动解码 percent-encoded 字符串
            let key = item.name.removingPercentEncoding ?? item.name
            let value = item.value?.removingPercentEncoding ?? ""

            if var existing = parameters[key] {
                existing.append(value)
                parameters[key] = existing
            } else {
                parameters[key] = [value]
            }
        }

        return parameters
    }

    /// 解析查询参数,仅保留每个键的第一个值(忽略重复键)
    ///
    /// - 适用于大多数简单场景(如表单提交)
    /// - 同样会自动解码 percent-encoded 内容
    ///
    /// - Returns: `[String: String]`,每个键对应第一个出现的值
    ///
    /// - Example:
    ///   ```swift
    ///   let url = "https://example.com?name=Alice&name=Bob"
    ///   let firstParams = url.dy_firstQueryParameters
    ///   print(firstParams["name"] ?? "") // "Alice"
    ///   ```
    var dy_firstQueryParameters: [String: String] {
        let multiParams = dy_queryParameters
        var singleParams: [String: String] = [:]
        for (key, values) in multiParams {
            singleParams[key] = values.first ?? ""
        }
        return singleParams
    }
}

// MARK: - 文件路径基础操作(基于 NSString 的 POSIX 路径处理)
/// 提供与 `NSString` 路径 API 对应的 Swift 风格扩展
/// 这些方法适用于标准 POSIX 路径(如 "/a/b/c.txt"),不适用于 URL 字符串
public extension String {
    /// 返回路径的最后一个组件
    ///
    /// - Example:
    ///   ```swift
    ///   "/user/docs/file.txt".dy_lastPathComponent // "file.txt"
    ///   "/".dy_lastPathComponent                     // "/"
    ///   ```
    var dy_lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    /// 返回路径的扩展名(不含前导点)
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy_pathExtension     // "txt"
    ///   "/file.tar.gz".dy_pathExtension  // "gz"
    ///   "/file".dy_pathExtension         // ""
    ///   ```
    var dy_pathExtension: String {
        (self as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c".dy_deletingLastPathComponent // "/a/b"
    ///   "/a".dy_deletingLastPathComponent     // "/"
    ///   ```
    var dy_deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展名后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy_deletingPathExtension // "/file"
    ///   "/file".dy_deletingPathExtension     // "/file"
    ///   ```
    var dy_deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }

    /// 返回路径的所有组件数组(包含根目录 "/")
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c.txt".dy_pathComponents // ["/", "a", "b", "c.txt"]
    ///   ```
    var dy_pathComponents: [String] {
        (self as NSString).pathComponents
    }

    /// 在当前路径后追加一个路径组件,自动处理路径分隔符
    ///
    /// - Parameter component: 要追加的路径组件(不应以 `/` 开头)
    /// - Returns: 拼接后的新路径字符串
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b".dy_appendingPathComponent("c.txt") // "/a/b/c.txt"
    ///   ```
    func dy_appendingPathComponent(_ component: String) -> String {
        (self as NSString).appendingPathComponent(component)
    }

    /// 为当前路径添加扩展名(自动添加前导点)
    ///
    /// - Parameter ext: 扩展名(不应包含点)
    /// - Returns: 添加扩展名后的新路径;若原路径为空或为绝对根路径,则可能返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   "file".dy_appendingPathExtension("txt") // "file.txt"
    ///   ```
    func dy_appendingPathExtension(_ ext: String) -> String? {
        (self as NSString).appendingPathExtension(ext)
    }

    /// 返回将 `～` 展开为用户主目录后的路径字符串
    var dy_expandingTildeInPath: String {
        (self as NSString).expandingTildeInPath
    }
}

// MARK: - 沙盒路径解析：返回完整路径字符串(String)
/// 这些方法将当前字符串视为`相对于指定沙盒目录的子路径`,
/// 并解析为完整的文件系统路径(String)
///
/// ⚠️ 重要：
/// - `输入必须是相对路径`,例如 `"data.txt"` 或 `"subdir/config.json"`
/// - `不要传入包含目录前缀的路径`(如 `"Documents/data.txt"`),
///   否则会导致路径重复(如 `.../Documents/Documents/data.txt`)
/// - 这些是`方法`而非属性,因为结果依赖运行时环境(沙盒目录位置)
public extension String {
    /// 将当前字符串作为相对路径,解析为 Documents 目录下的绝对路径
    ///
    /// - Returns: 完整的文件系统路径字符串
    /// - Throws: 不会抛出错误,但若无法获取 Documents 目录会触发断言失败(仅调试模式)
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "user_data.json".dy_pathInDocuments()
    ///   // → "/var/mobile/Containers/Data/Application/.../Documents/user_data.json"
    ///   ```
    func dy_pathInDocuments() -> String {
        DyPath.shared.path(inDocuments: self)
    }

    /// 将当前字符串作为相对路径,解析为 Caches 目录下的绝对路径
    ///
    /// - Caches 目录用于存放可再生的缓存数据,系统可能在存储空间不足时清除
    func dy_pathInCaches() -> String {
        DyPath.shared.path(inCaches: self)
    }

    /// 将当前字符串作为相对路径,解析为临时目录(tmp)下的绝对路径
    ///
    /// - 临时目录用于短期存储,应用重启后内容可能被清除
    func dy_pathInTemporaryDirectory() -> String {
        DyPath.shared.path(inTemp: self)
    }

    /// 将当前字符串作为相对路径,解析为 Application Support 目录下的绝对路径
    ///
    /// - Application Support 目录用于存放应用支持文件,`会被 iCloud 备份`
    /// - 首次使用时建议确保父目录存在(可通过 `FileManager` 创建)
    func dy_pathInApplicationSupport() -> String {
        DyPath.shared.path(inApplicationSupport: self)
    }
}

// MARK: - 沙盒路径解析：返回 URL
/// 返回对应沙盒目录中文件的 `URL`Apple 推荐使用 `URL` 而非 `String` 表示文件路径,
/// 因其能正确处理 Unicode、特殊字符、编码等问题
///
/// 这些是`计算属性`,因为 `URL` 构建过程稳定且无副作用(仅依赖当前字符串和系统目录)
public extension String {
    /// Documents 目录中对应文件的 URL
    func dy_urlInDocuments() -> URL {
        DyPath.shared.url(inDocuments: self)
    }

    /// Caches 目录中对应文件的 URL
    func dy_urlInCaches() -> URL {
        DyPath.shared.url(inCaches: self)
    }

    /// 临时目录(tmp)中对应文件的 URL
    func dy_urlInTemporary() -> URL {
        DyPath.shared.url(inTemp: self)
    }

    /// Application Support 目录中对应文件的 URL
    func dy_urlInApplicationSupport() -> URL {
        DyPath.shared.url(inApplicationSupport: self)
    }
}

// MARK: - 属性字符串相关
public extension String {
    /// 将 HTML 源码转换为属性字符串
    /// - Parameters:
    ///   - font: 全局字体(会覆盖 HTML 中的所有字体样式,包括 <b>, <i> 等)
    ///   - lineSpacing: 全局行间距
    /// - Returns: 转换后的属性字符串;失败时返回纯文本(带指定样式)
    ///
    /// - 注意: 此实现会丢失 HTML 的原始文本样式(如粗体、斜体),仅保留结构(换行等)
    ///
    func dy_htmlToAttributedString(
        font: UIFont? = .systemFont(ofSize: 12),
        lineSpacing: CGFloat? = 10
    ) -> NSMutableAttributedString {
        // 预处理：将 \n 替换为 <br/> 以保留换行
        let processedHTML = self.replacingOccurrences(of: "\n", with: "<br/>")
        // 包裹在 <span> 中避免解析异常
        let fullHTML = "<span>\(processedHTML)</span>"

        guard let data = fullHTML.data(using: .utf8) else {
            return fallbackAttributedString(font: font, lineSpacing: lineSpacing)
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
            print("HTML to Attributed String failed: \(error)")
            return fallbackAttributedString(font: font, lineSpacing: lineSpacing)
        }
    }

    /// 高亮显示关键字
    func dy_highlightKeyword(
        keyword: String,
        highlightColor: UIColor,
        normalColor: UIColor,
        options: NSRegularExpression.Options = []
    ) -> NSMutableAttributedString {
        guard !keyword.isEmpty else {
            let attr = NSMutableAttributedString(string: self)
            attr.addAttribute(.foregroundColor, value: normalColor, range: NSRange(location: 0, length: attr.length))
            return attr
        }

        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttribute(.foregroundColor, value: normalColor, range: NSRange(location: 0, length: attributedString.length))

        do {
            let escapedKeyword = NSRegularExpression.escapedPattern(for: keyword)
            let regex = try NSRegularExpression(pattern: escapedKeyword, options: options)
            let nsRange = NSRange(location: 0, length: self.utf16.count)
            let matches = regex.matches(in: self, options: [], range: nsRange)

            // 从后往前高亮,避免 range 偏移
            for match in matches.reversed() {
                attributedString.addAttribute(.foregroundColor, value: highlightColor, range: match.range)
            }
        } catch {
            print("Highlight keyword regex error: \(error)")
        }

        return attributedString
    }
}

// MARK: - HTML Entity Encoding
public extension String {
    /// 返回当前字符串的 HTML 数字字符引用编码形式(格式：&#xHHHH;)
    /// 每个 Unicode 标量被转换为小写十六进制,至少 4 位,不足补零
    ///
    /// - Example:
    ///   ```swift
    ///   "Hello <world> & \"everyone\"".dy_htmlEncoded()
    ///   // → "&#x0048;&#x0065;&#x006c;&#x006c;&#x006f;&#x0020;&#x003c;&#x0077;&#x006f;&#x0072;&#x006c;&#x0064;&#x003e;&#x0020;&#x0026;&#x0020;&#x0022;&#x0065;&#x0076;&#x0065;&#x0072;&#x0079;&#x006f;&#x006e;&#x0065;&#x0022;"
    ///   ```
    func dy_htmlEncoded() -> String {
        unicodeScalars.map { scalar in
            let hex = String(scalar.value, radix: 16, uppercase: false)
            let paddedHex = String(repeating: "0", count: max(0, 4 - hex.count)) + hex
            return "&#x\(paddedHex);"
        }.joined()
    }

    /// 尝试将字符串中的 HTML 数字字符引用(如 `&#x0041;` 或 `&#65;`)解码为原始字符
    /// - 支持十六进制(`&#x...;`,不区分大小写)和十进制(`&#...;`)
    /// - 不支持命名实体(如 `&lt;`, `&amp;`)
    /// - 无效或超出 Unicode 范围的引用会被忽略(不插入字符)
    ///
    /// - Returns: 解码后的字符串;如果输入不含有效引用或结果为空,返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   "&#x0048;&#x0065;&#x006c;&#x006c;&#x006f;".dy_htmlDecoded()
    ///   // → Optional("Hello")
    ///   ```
    func dy_htmlDecoded() -> String? {
        // 匹配 &#x[hex]; (十六进制)和 &#[dec]; (十进制),不区分大小写
        let pattern = "(?i)&#(?:x([0-9a-f]+)|([0-9]+));"
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return nil
        }

        let nsString = self as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, options: [], range: fullRange)

        guard !matches.isEmpty else {
            return nil // 无匹配项,提前返回
        }

        var result = ""
        var currentIndex = 0

        for match in matches {
            let entityRange = match.range(at: 0)
            // 添加实体前的普通文本
            if entityRange.location > currentIndex {
                let plainRange = NSRange(location: currentIndex, length: entityRange.location - currentIndex)
                result += nsString.substring(with: plainRange)
            }

            // 解析数值
            var codePoint: UInt32?
            if let hexRange = Range(match.range(at: 1), in: self), !hexRange.isEmpty {
                let hexStr = String(self[hexRange])
                codePoint = UInt32(hexStr, radix: 16)
            } else if let decRange = Range(match.range(at: 2), in: self), !decRange.isEmpty {
                let decStr = String(self[decRange])
                codePoint = UInt32(decStr)
            }

            // 验证并追加有效字符
            if let cp = codePoint, let scalar = Unicode.Scalar(cp) {
                result += String(scalar)
            }
            // 注意：无效引用被静默跳过(可按需改为保留原文本)

            currentIndex = entityRange.upperBound
        }

        // 添加末尾剩余文本
        if currentIndex < nsString.length {
            let tailRange = NSRange(location: currentIndex, length: nsString.length - currentIndex)
            result += nsString.substring(with: tailRange)
        }

        return result.isEmpty ? nil : result
    }
}

// MARK: - 运算符
public extension String {
    /// 重载 `～= ` 运算符,使字符串能通过正则表达式字符串进行匹配
    /// - Parameters:
    ///   - lhs: 被匹配的字符串
    ///   - rhs: 正则表达式字符串
    /// - Returns: 是否匹配(若正则无效,返回 false)
    ///
    /// - Example:
    ///     `"hello world" ～= "hello"`      // true
    ///     `"hello world" ～= "^world"`     // false
    ///     `"hello world" ～= "["`          // false(非法正则)
    ///
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `~= ` 运算符,使字符串能通过 `NSRegularExpression` 对象进行匹配
    /// - Parameters:
    ///   - lhs: 被匹配的字符串
    ///   - rhs: 预编译的正则表达式对象
    /// - Returns: 是否存在匹配
    ///
    /// - Example:
    /// ```swift
    ///      let regex = try! NSRegularExpression(pattern: "world$")
    ///     `"hello world" ～= regex`        // true
    /// ```
    static func ~= (lhs: String, rhs: NSRegularExpression) -> Bool {
        let nsRange = NSRange(lhs.startIndex..., in: lhs)
        return rhs.firstMatch(in: lhs, options: [], range: nsRange) != nil
    }

    /// 重复字符串：`"bar" * 3` → `"barbarbar"`
    /// - Parameters:
    ///   - lhs: 要重复的字符串
    ///   - rhs: 重复次数(≤0 时返回空字符串)
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }

    /// 重复字符串：`3 * "bar"` → `"barbarbar"`
    /// - Parameters:
    ///   - lhs: 重复次数(≤0 时返回空字符串)
    ///   - rhs: 要重复的字符串
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
}

// MARK: - JSON
public extension String {
    /// 将字符串解析为 JSON 并格式化输出(美化缩进)
    /// - Note: 同时将 JSON 中的转义斜杠 `\/` 替换为 `/`
    /// - Returns: `成功`:格式化后的JSON字符串 `失败`:返回原字符串
    func dy_format() -> String {
        guard let data = self.dy_toData() else { return self }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]
            )
            return String(data: prettyData, encoding: .utf8)?
                .replacingOccurrences(of: "\\/", with: "/") ?? self
        } catch {
            return self
        }
    }
}
