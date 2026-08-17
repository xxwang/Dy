import Foundation

// MARK: - 运算符
public extension String {
    /// 重载 `~=` 运算符,使字符串能通过正则表达式字符串进行匹配
    /// - Parameters:
    ///   - lhs: 被匹配的字符串
    ///   - rhs: 正则表达式字符串
    /// - Returns: 是否匹配(若正则无效,返回 false)
    ///
    /// - Example:
    ///     `"hello world" ~= "hello"`      // true
    ///     `"hello world" ~= "^world"`     // false
    ///     `"hello world" ~= "["`          // false(非法正则)
    ///
    static func ~= (lhs: String, rhs: String) -> Bool {
        return lhs.range(of: rhs, options: .regularExpression) != nil
    }

    /// 重载 `~=` 运算符,使字符串能通过 `NSRegularExpression` 对象进行匹配
    /// - Parameters:
    ///   - lhs: 被匹配的字符串
    ///   - rhs: 预编译的正则表达式对象
    /// - Returns: 是否存在匹配
    ///
    /// - Example:
    /// ```swift
    ///      let regex = try! NSRegularExpression(pattern: "world$")
    ///     `"hello world" ~= regex`        // true
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
