import Foundation

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
        let range = NSRange(location: 0, length: self.utf16.count)
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
              let match = regex.firstMatch(in: self, range: NSRange(location: 0, length: self.utf16.count))
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
        let range = NSRange(location: 0, length: self.utf16.count)
        return regex.matches(in: self, options: [], range: range).map(\.range)
    }
}
