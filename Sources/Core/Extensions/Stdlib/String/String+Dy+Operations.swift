import Foundation

#if canImport(UIKit)
    import UIKit
#endif

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

    /// 返回反转��的字符串(非 mutating)
    /// - 返回值: 反转结果
    ///
    /// - Example:
    ///     `"Hello".dy_reverse()` → `"olleH"`
    ///
    func dy_reverse() -> String {
        String(reversed())
    }

    /// 在字符串前添加前缀(若尚未包��)
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
