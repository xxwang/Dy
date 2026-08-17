import Foundation

// MARK: - URL 百分号编解码扩展
public extension SoloWrapper where Base == String {
    /// 对字符串进行 URL 百分号编码（适用于查询参数、路径片段等通用场景）
    ///
    /// - Returns: 编码后的字符串;若编码失败（理论上不会）,返回原字符串
    /// - Note: 使用 `.urlQueryAllowed` 字符集,保留字母、数字及 `-._～!*'()` 等安全字符
    /// - Example:
    ///   ```swift
    ///   "it's easy".solo.urlEncoded() // "it's%20easy"
    ///   "hello world!".solo.urlEncoded() // "hello%20world!"
    ///   ```
    func urlEncoded() -> String {
        base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? base
    }

    /// 对已 URL 编码的字符串进行解码
    ///
    /// - Returns: 解码后的字符串;若解码失败（如非法 `%` 序列）,返回原字符串
    /// - Example:
    ///   ```swift
    ///   "it's%20easy".solo.urlDecoded() // "it's easy"
    ///   ```
    func urlDecoded() -> String {
        base.removingPercentEncoding ?? base
    }
}

// MARK: - 随机与假文字符串生成扩展
public extension SoloWrapper where Base == String {
    /// 生成指定长度的随机字符串（包含大小写字母和数字）
    ///
    /// - Parameter length: 目标长度（必须 > 0）
    /// - Returns: 随机字符串;若 `length <= 0`,返回空字符串
    /// - Note: 使用 `String.randomElement()`,基于系统默认随机源（非加密安全）
    ///         如需密码学安全随机,请使用 `CryptoKit` 或 `SecRandomCopyBytes`
    /// - Example:
    ///   ```swift
    ///   String.solo.random(length: 8) // e.g. "aB3xK9Lm"
    ///   ```
    static func random(length: Int) -> String {
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
    ///   String.solo.loremIpsum(length: 20) // "Lorem ipsum dolor si"
    ///   ```
    static func loremIpsum(length: Int = 445) -> String {
        guard length > 0 else { return "" }

        let lorem = """
        Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        """
        return String(lorem.prefix(length))
    }
}
