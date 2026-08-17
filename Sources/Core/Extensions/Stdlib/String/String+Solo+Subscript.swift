import Foundation

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
