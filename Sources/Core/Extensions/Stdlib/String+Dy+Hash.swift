import Foundation
import CryptoKit

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
    /// - Warning: `.md5` 已被密码学界破解，仅用于非安全场景（如缓存 key）
    enum DyHashAlgorithm {
        case md5
        case sha256
        case sha512

        /// 对给定数据执行哈希运算
        func dy_hash(_ data: Data) -> [UInt8] {
            switch self {
            case .md5:
                let digest = Insecure.MD5.hash(data: data)
                return Array(digest)
            case .sha256:
                let digest = SHA256.hash(data: data)
                return Array(digest)
            case .sha512:
                let digest = SHA512.hash(data: data)
                return Array(digest)
            }
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
