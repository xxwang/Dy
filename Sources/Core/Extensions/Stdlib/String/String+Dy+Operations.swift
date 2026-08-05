import Foundation

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 字符串操作
public extension DyWrapper where Base == String {
    /// 首字母大写,其余保持不变
    /// - 返回值: 首字母大写后的字符串;若为空,返回 `nil`
    ///
    /// - Example:
    ///     `"hello world".dy.capitalizeFirst()` → `"Hello world"`
    ///
    func capitalizeFirst() -> String? {
        guard let first = base.first else { return nil }
        return String(first).uppercased() + base.dropFirst()
    }

    /// 返回反转的字符串(非 mutating)
    /// - 返回值: 反转结果
    ///
    /// - Example:
    ///     `"Hello".dy.reverse()` → `"olleH"`
    ///
    func reverse() -> String {
        String(base.reversed())
    }

    /// 在字符串前添加前缀(若尚未包含)
    /// - 参数 prefix: 要添加的前缀
    /// - 返回值: 添加后的字符串
    ///
    /// - Example:
    ///     `"www.apple.com".dy.withPrefix("https://")` → `"https://www.apple.com"`
    ///
    func withPrefix(_ prefix: String) -> String {
        base.hasPrefix(prefix) ? base : prefix + base
    }

    /// 在字符串后添加后缀(若尚未包含)
    /// - 参数 suffix: 要添加的后缀
    /// - 返回值: 添加后的字符串
    ///
    /// - Example:
    ///     `"www.apple".dy.withSuffix(".com")` → `"www.apple.com"`
    ///
    func withSuffix(_ suffix: String) -> String {
        base.hasSuffix(suffix) ? base : base + suffix
    }

    /// 在指定 UTF-16 位置插入字符串
    /// - 参数 content: 要插入的内容
    /// - 参数 at: 插入位置(从 0 开始)
    /// - 返回值: 新字符串;若位置越界,插入到末尾
    ///
    /// - Example:
    ///     `"HelloWorld!".dy.insert(" ", at: 5)` → `"Hello World!"`
    ///
    func insert(_ content: String, at position: Int) -> String {
        let safePos = max(0, min(position, base.utf16.count))
        let idx = base.utf16.index(base.utf16.startIndex, offsetBy: safePos)
        guard let stringIdx = String.Index(idx, within: base) else {
            return base + content // fallback
        }
        return String(base[..<stringIdx]) + content + String(base[stringIdx...])
    }

    /// 重复当前字符串指定次数
    /// - 参数 times: 重复次数(≥0)
    /// - 返回值: 重复后的字符串;若 `times ≤ 0`,返回空串
    ///
    /// - Example:
    ///     `"abc".dy.repeated(3)` → `"abcabcabc"`
    ///
    func repeated(_ times: Int) -> String {
        guard times > 0 else { return "" }
        return String(repeating: base, count: times)
    }

    /// 获取与另一字符串的最长公共后缀
    /// - 参数 other: 比较对象
    /// - 返回值: 公共后缀字符串
    ///
    /// - Example:
    ///     `"apple".dy.commonSuffix(with: "maple")` → `"ple"`
    ///
    func commonSuffix(with other: String) -> String {
        let common = zip(base.reversed(), other.reversed())
            .prefix(while: { pair in pair.0 == pair.1 })
            .map(\.0)
        return String(common.reversed())
    }
}

// MARK: - 字符判断(高效、无正则)
public extension DyWrapper where Base == String {
    // MARK: - 基础字符检测

    /// 是否包含任意字母
    var hasLetters: Bool {
        base.rangeOfCharacter(from: .letters) != nil
    }

    /// 是否只包含字母(无数字、符号等)
    var isAlphabetic: Bool {
        !base.isEmpty && base.allSatisfy(\.isLetter)
    }

    /// 是否包含任意数字
    var hasDigits: Bool {
        base.rangeOfCharacter(from: .decimalDigits) != nil
    }

    /// 是否只包含数字(0-9)
    var isDigits: Bool {
        !base.isEmpty && base.allSatisfy(\.isNumber)
    }

    /// 是否同时包含字母和数字
    var hasAlphanumeric: Bool {
        self.hasLetters && self.hasDigits
    }

    /// 是否只包含字母或数字(即：字母数字混合,无符号)
    var isAlphanumeric: Bool {
        !base.isEmpty && base.allSatisfy { $0.isLetter || $0.isNumber }
    }

    /// 是否只包含空格或换行符
    var isWhitespace: Bool {
        base.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// 是否所有字符唯一(无重复)
    var hasUniqueCharacters: Bool {
        Set(base).count == base.count
    }

    /// 是否包含中文字符(支持扩展汉字)
    var containsChinese: Bool {
        base.unicodeScalars.contains { scalar in
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF) ||
                (v >= 0x20000 && v <= 0x2A6DF) ||
                (v >= 0x2A700 && v <= 0x2B73F) ||
                (v >= 0x2B740 && v <= 0x2B81F)
        }
    }

    /// 是否只包含中文字符
    var isChinese: Bool {
        !base.isEmpty && base.allSatisfy { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            let v = scalar.value
            return (v >= 0x4E00 && v <= 0x9FFF) ||
                (v >= 0x3400 && v <= 0x4DBF)
        }
    }

    // MARK: - 连续数字检测

    /// 是否包含连续 ≥2 位的数字
    var hasContinuousDigits: Bool {
        var count = 0
        for c in base {
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
public extension DyWrapper where Base == String {
    /// 是否为回文(忽略大小写,仅比较字母)
    var isPalindrome: Bool {
        let letters = base.filter(\.isLetter).lowercased()
        return letters == String(letters.reversed())
    }

    /// 是否拼写正确(仅 iOS/macOS)
    var isSpelledCorrectly: Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: base.utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: base,
            range: range,
            startingAt: 0,
            wrap: false,
            language: Locale.preferredLanguages.first ?? "en"
        )
        return misspelled.location == NSNotFound
    }
}
