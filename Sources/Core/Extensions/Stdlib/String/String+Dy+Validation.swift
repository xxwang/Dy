import Foundation

// MARK: - 通用格式验证
public extension String {
    /// 是否为有效中国手机号(11 位,1[3-9] 开头)
    var dy_isValidPhoneNumber: Bool {
        dy_isMatch(pattern: "^1[3-9]\\d{9}$")
    }

    /// 是否为有效邮箱(宽松版)
    var dy_isValidEmail: Bool {
        dy_isMatch(pattern: #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#)
    }

    /// 是否为有效 URL(任意协议)
    var dy_isValidURL: Bool {
        URL(string: self) != nil
    }

    /// 是否为带协议的 URL(如 http://, https://)
    var dy_isValidSchemedURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }

    /// 是否为 HTTPS URL
    var dy_isValidHttpsURL: Bool {
        URL(string: self)?.scheme == "https"
    }

    /// 是否为 HTTP URL
    var dy_isValidHttpURL: Bool {
        URL(string: self)?.scheme == "http"
    }

    /// 是否为文件 URL
    var dy_isValidFileURL: Bool {
        URL(string: self)?.isFileURL == true
    }
}

// MARK: - 自定义规则
public extension String {
    /// 是否符合字母数字+下划线,长度在 [min, max]
    func dy_isValidAlphanumeric(minLen: Int, maxLen: Int) -> Bool {
        guard self.count >= minLen, self.count <= maxLen else { return false }
        return self.allSatisfy { $0.isLetter || $0.isNumber || $0 == "_" }
    }

    /// 是否为有效昵称(中英文、数字、下划线)
    var dy_isValidNickname: Bool {
        dy_isMatch(pattern: #"^[\u{4e00}-\u{9fff}a-zA-Z0-9_]+$"#)
    }

    /// 是否为有效用户名(中英文,1-20 字符)
    var dy_isValidUsername: Bool {
        self.count >= 1 && self.count <= 20 && self.allSatisfy { $0.isLetter || ($0.unicodeScalars.first?.value ?? 0) >= 0x4E00 }
    }

    /// 是否为有效密码
    /// - `complex = false`: 至少包含字母+数字,≥6 位
    /// - `complex = true`: 必须包含大小写字母+数字+特殊符号,≥8 位
    func dy_isValidPassword(complex: Bool = false) -> Bool {
        if complex {
            return dy_isMatch(pattern: #"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+\-=\[\]{}|;:'",.<>/?]).{8,}$"#)
        } else {
            return self.count >= 6 && self.dy_hasLetters && self.dy_hasDigits
        }
    }
}

// MARK: - 数字格式
public extension String {
    /// 是否为整数(支持负号)
    var dy_isInteger: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanInt() != nil && scanner.isAtEnd
    }

    /// 是否为浮点数(支持科学计数法)
    var dy_isFloat: Bool {
        let scanner = Scanner(string: self)
        return scanner.scanFloat() != nil && scanner.isAtEnd
    }
}

// MARK: - 身份证(简化版)
public extension String {
    /// 是否符合身份证基本格式(15/18 位)
    var dy_isBasicIDNumber: Bool {
        dy_isMatch(pattern: #"^(\d{15}|\d{17}[\dXx])$"#)
    }

    /// 是否为严格有效的 18 位身份证(含校验码)
    var dy_isStrictIDNumber: Bool {
        guard self.count == 18, dy_isBasicIDNumber else { return false }

        let weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2]
        let checkCodes = "10X98765432"

        var sum = 0
        for i in 0 ..< 17 {
            guard let digit = Int(self.dy_character(at: i)) else { return false }
            sum += digit * weights[i]
        }

        let expected = String(checkCodes[checkCodes.index(checkCodes.startIndex, offsetBy: sum % 11)])
        let actual = String(self[self.index(self.startIndex, offsetBy: 17)])
        return expected.uppercased() == actual.uppercased()
    }
}

// MARK: - 子串匹配
public extension String {
    /// 是否包含子串(可选大小写敏感)
    func dy_contains(_ substring: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return contains(substring)
        }
        return self.localizedCaseInsensitiveContains(substring)
    }

    /// 是否以某前缀开头(可选大小写敏感)
    func dy_starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.hasPrefix(prefix)
        }
        return self.lowercased().hasPrefix(prefix.lowercased())
    }

    /// 是否以某后缀结尾(可选大小写敏感)
    func dy_ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if caseSensitive {
            return self.hasSuffix(suffix)
        }
        return self.lowercased().hasSuffix(suffix.lowercased())
    }
}
