import Foundation

// MARK: - 类型转换
public extension DyWrapper where Base == NSRange {
    /// 将 `NSRange`(基于 UTF-16)安全转换为 Swift 原生的 `Range<String.Index>`
    ///
    /// - Parameter in: 要转换的字符串(必须与生成该 `NSRange` 的字符串相同)
    /// - Returns: 对应的 `Range<String.Index>`;若 `NSRange` 超出字符串范围、包含无效位置或长度为负,则返回 `nil`
    ///
    /// - Important:
    ///   `NSRange` 使用 UTF-16 编码单位(code units),而 Swift 的 `String` 使用 Unicode 字符(grapheme clusters)
    ///   因此,只有当 `NSRange` 来自 `NSString` 或 `NSRegularExpression` 等 Cocoa API 时,此转换才有意义
    ///
    /// - Example:
    ///   ```swift
    ///   let string = "Hello, 世界!"
    ///   let nsRange = NSRange(location: 7, length: 2) // 指向 "世界"
    ///   if let range = nsRange.dy.toRange(in: string) {
    ///       print(string[range]) // "世界"
    ///   }
    ///   ```
    ///
    /// - Note: 此方法已处理代理对(surrogate pairs)和组合字符等复杂 Unicode 情况
    ///
    func toRange(in string: String) -> Range<String.Index>? {
        // 提前排除无效输入
        guard base.location >= 0, base.length >= 0 else { return nil }

        let utf16 = string.utf16

        // 检查 location 是否超出字符串 UTF-16 范围
        guard base.location <= utf16.count else { return nil }

        // 计算 end = location + length,防止溢出
        let endLocation = base.location + base.length
        guard endLocation >= base.location, endLocation <= utf16.count else { return nil } // 溢出或越界

        // 获取 UTF-16 索引
        let from16 = utf16.index(utf16.startIndex, offsetBy: base.location)
        let to16 = utf16.index(from16, offsetBy: base.length)

        // 转换为 String.Index(可能失败,如落在代理对中间)
        guard let from = String.Index(from16, within: string),
              let to = String.Index(to16, within: string)
        else { return nil }

        return from ..< to
    }
}
