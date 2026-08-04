import Foundation

extension Character: DyExtension {}

// MARK: - 构造方法
public extension Character {
    /// 使用 `ASCII` 码值`(0–127)`创建一个 `Character`
    ///
    /// - Parameter ascii: 有效的 `ASCII` 码值(`UInt8`)
    /// - Returns: 若在 0–127 范围内,返回对应字符;否则返回 `nil`
    init?(ascii: UInt8) {
        guard ascii <= 127 else { return nil }
        self = Character(UnicodeScalar(ascii))
    }

    /// 使用一个或多个 `Unicode` 码点(十六进制字符串)创建 `Character`
    ///
    /// 支持格式：
    /// - `"1F60A"`, `"U+1F60A"`, `"0x1F60A"`, `"\\u{1F60A}"`
    /// - 多个码点用于组合字符(如国旗、家庭 Emoji)
    ///
    /// - Parameter unicodeScalars: 一个或多个十六进制字符串表示的码点
    /// - Returns: 若能组成合法单字符,返回 `Character`;否则 `nil`
    ///
    /// - Examples:
    ///   ```swift
    ///   Character(unicodeScalars: "1F60A")                     // 😊
    ///   Character(unicodeScalars: "U+1F1FA", "1F1F8")          // 🇺🇸
    ///   ```
    init?(unicodeScalars: String...) {
        guard !unicodeScalars.isEmpty else { return nil }

        let cleanedCodes: [UInt32] = unicodeScalars.compactMap { str in
            var hex = str.trimmingCharacters(in: .whitespacesAndNewlines)

            // 移除常见前缀
            if hex.hasPrefix("U+") || hex.hasPrefix("u+") {
                hex = String(hex.dropFirst(2))
            } else if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
                hex = String(hex.dropFirst(2))
            } else if hex.hasPrefix("\\u{"), hex.hasSuffix("}") {
                let startIndex = hex.index(hex.startIndex, offsetBy: 3)
                let endIndex = hex.index(hex.endIndex, offsetBy: -1)
                hex = String(hex[startIndex ..< endIndex])
            }

            guard !hex.isEmpty, let code = UInt32(hex, radix: 16) else {
                return nil
            }
            return code
        }

        // 必须全部成功解析
        guard cleanedCodes.count == unicodeScalars.count else { return nil }

        // 转换所有码点为 UnicodeScalar
        let scalars = cleanedCodes.compactMap(UnicodeScalar.init)

        // 如果数量不一致,说明有无效码点
        guard scalars.count == cleanedCodes.count else {
            return nil
        }

        // 构造 String
        let scalarView = String.UnicodeScalarView(scalars)
        let string = String(scalarView)

        // 验证是否构成单个 Character(grapheme cluster)
        guard string.count == 1, let char = string.first else {
            return nil
        }

        self = char
    }
}

// MARK: - 类型转换
public extension DyWrapper where Base == Character {
    /// 将当前字符转换为`String`
    func toString() -> String {
        return String(base)
    }

    /// 返回当前字符的大写形式
    func toUppercase() -> Character {
        return base.uppercased().first ?? base
    }

    /// 返回当前字符的小写形式
    func toLowercase() -> Character {
        return base.lowercased().first ?? base
    }

    /// 尝试将当前字符转换为其对应的 ASCII 码值(`UInt8`)
    func toASCII() -> UInt8? {
        guard let scalar = base.unicodeScalars.first, scalar.isASCII else { return nil }
        return UInt8(scalar.value)
    }

    /// 返回当前字符的 `Swift` 风格 `Unicode` 转义序列(如 `\u{1F60A}`)
    func toUnicodeEscapeSequence() -> String {
        return base.unicodeScalars.map { "\\u{\(String($0.value, radix: 16, uppercase: true))}" }.joined()
    }
}

// MARK: - 内容判断
public extension DyWrapper where Base == Character {
    /// 判断当前字符是否为 `Emoji`(包括`简单Emoji `和`组合 Emoji`)
    var isEmoji: Bool {
        let scalars = base.unicodeScalars

        // 单标量：直接检查 isEmoji 属性
        if scalars.count == 1 {
            return scalars.first!.properties.isEmoji
        }

        // 多标量：必须以 Emoji 标量开头,并包含 VS-16、ZWJ 或区域指示符
        guard let first = scalars.first, first.properties.isEmoji else {
            return false
        }

        // 检查后续标量是否为有效 Emoji 组成部分
        return scalars.dropFirst().contains { scalar in
            let props = scalar.properties
            if props.isVariationSelector || props.isJoinControl {
                return true
            }
            // 区域指示符范围: U+1F1E6 to U+1F1FF
            let value = scalar.value
            return (0x1F1E6 ... 0x1F1FF).contains(value)
        }
    }
}

// MARK: - 字符生成
public extension DyWrapper where Base == Character {
    /// 生成一个随机 `ASCII` 字符
    ///
    /// - Parameter includeSpecialChars: 是否包含特殊符号(默认 `false`)
    /// - Returns: 一个随机 `Character`
    static func random(includeSpecialChars: Bool = false) -> Character {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let digits = "0123456789"
        let special = includeSpecialChars ? "!@#$%^&*()-_=+[]{}|;:'\",.<>?/" : ""
        let pool = letters + digits + special
        return pool.randomElement()!
    }
}
