import Foundation
import CryptoKit

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
}

// MARK: - Base64 编解码扩展
public extension SoloWrapper where Base == String {
    /// 将字符串以 UTF-8 编码后进行 Base64 编码
    ///
    /// - Returns: Base64 编码字符串,或 `nil`（理论上 UTF-8 不会失败）
    var base64Encoded: String? {
        self.toData()?.base64EncodedString()
    }

    /// 尝试将字符串作为 Base64 进行解码（自动处理缺失的填充符 `=`）
    ///
    /// - Returns: 解码后的 UTF-8 字符串,或 `nil`
    var base64Decoded: String? {
        // 第一次尝试：标准解码
        if let data = Data(base64Encoded: base, options: .ignoreUnknownCharacters),
           let str = String(data: data, encoding: .utf8)
        {
            return str
        }

        // 自动补全填充
        let remainder = base.count % 4
        if remainder != 0 {
            let padded = base + String(repeating: "=", count: 4 - remainder)
            if let data = Data(base64Encoded: padded, options: .ignoreUnknownCharacters),
               let str = String(data: data, encoding: .utf8)
            {
                return str
            }
        }
        return nil
    }
}
