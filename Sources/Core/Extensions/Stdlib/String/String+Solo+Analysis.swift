import Foundation

// MARK: - 字符提取、统计与分析
public extension String {
    /// 提取所有数字字符（Unicode 十进制数字）
    ///
    /// - Returns: 仅包含数字的字符串
    /// - Note: 使用 `Character.isNumber`,支持全角数字、罗马数字等（若需仅 0-9,请用 `CharacterSet.decimalDigits`）
    var solo_numerics: String {
        self.filter(\.isNumber)
    }

    /// 获取第一个字符（作为字符串）
    ///
    /// - Returns: 第一个字符的字符串形式;若为空串,返回 `nil`
    var solo_firstCharacter: String? {
        self.first.map { String($0) }
    }

    /// 获取最后一个字符（作为字符串）
    ///
    /// - Returns: 最后一个字符的字符串形式;若为空串,返回 `nil`
    var solo_lastCharacter: String? {
        self.last.map { String($0) }
    }

    /// 统计单词数量（以空白符和标点符号为分隔）
    ///
    /// - Returns: 非空单词的数量
    var solo_wordCount: Int {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return self.components(separatedBy: separators).count { !$0.isEmpty }
    }

    /// 统计数字字符个数
    ///
    /// - Returns: 满足 `isNumber` 的字符数量
    var solo_numericCount: Int {
        self.count(where: \.isNumber)
    }

    /// 计算"显示宽度"：英文/数字占 1,常见汉字占 2（适用于终端对齐）
    ///
    /// - Returns: 加权字符数
    /// - Limitation: 仅检测基本汉字范围 `U+4E00–U+9FFF`,不覆盖扩展汉字、日韩汉字等
    var solo_displayWidth: Int {
        self.reduce(0) { width, char in
            if let scalar = char.unicodeScalars.first,
               (0x4E00 ... 0x9FFF).contains(scalar.value)
            {
                return width + 2
            }
            return width + 1
        }
    }

    /// 统计子字符串出现次数
    ///
    /// - Parameters:
    ///   - substring: 要统计的子串
    ///   - caseSensitive: 是否区分大小写,默认为 `true`
    /// - Returns: 出现次数
    /// - Note: 使用 `components(separatedBy:)` 实现,简单高效
    func solo_countOccurrences(of substring: String, caseSensitive: Bool = true) -> Int {
        guard !substring.isEmpty else { return 0 }
        let source = caseSensitive ? self : self.lowercased()
        let target = caseSensitive ? substring : substring.lowercased()
        return source.components(separatedBy: target).count - 1
    }

    /// 查找出现频率最高的非空白字符
    ///
    /// - Returns: 最常见字符;若无有效字符（如全为空白）,返回 `nil`
    /// - Note: 空格、制表符、换行等均被过滤
    var solo_mostFrequentCharacter: Character? {
        let nonWhitespace = self.filter { !$0.isWhitespace }
        guard !nonWhitespace.isEmpty else { return nil }

        let frequency = nonWhitespace.reduce(into: [:]) { dict, char in
            dict[char, default: 0] += 1
        }
        return frequency.max(by: { $0.value < $1.value })?.key
    }

    /// 获取每个 Unicode 标量的数值（十进制）
    ///
    /// - Returns: `Int` 类型的 Unicode 码点数组
    var solo_unicodeScalarValues: [Int] {
        self.unicodeScalars.map { Int($0.value) }
    }

    /// 提取所有单词（以空白符和标点符号分割）
    ///
    /// - Returns: 非空单词数组
    var solo_words: [String] {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        return self.components(separatedBy: separators).filter { !$0.isEmpty }
    }

    /// 将整数 UTF-16 索引安全转换为 `String.Index`
    ///
    /// - Parameter offset: UTF-16 索引（从 0 开始）
    /// - Returns: 对应的 `String.Index`;若越界,返回最近边界（`startIndex` 或 `endIndex`）
    /// - Note: 使用 `samePosition(in:)` 确保在复杂 Unicode 下仍安全
    func solo_index(at offset: Int) -> String.Index {
        if offset <= 0 {
            return self.startIndex
        } else if offset >= self.utf16.count {
            return self.endIndex
        } else {
            let utf16Index = self.utf16.index(self.utf16.startIndex, offsetBy: offset)
            return utf16Index.samePosition(in: self) ?? self.endIndex
        }
    }
}

// MARK: - Unicode编解码
public extension String {
    /// 将字符串编码为 `JavaScript/JSON` 兼容的 `\uXXXX` 转义格式
    ///
    /// - Returns: 所有字符转换为 UTF-16 单元的 `\uXXXX` 序列拼接结果
    var solo_unicodeEncoded: String {
        var result = ""
        for char in self {
            // 使用 UTF-16 单元确保与 JS/JSON 行为一致
            for unit in String(char).utf16 {
                result += "\\u" + String(format: "%04x", unit)
            }
        }
        return result
    }

    /// 将 `JavaScript/JSON` 风格的 `\uXXXX` 转义字符串解码为原始字符串
    ///
    /// - Returns: 解码后的字符串;无法识别的 `\uXXXX` 序列将被保留原样
    var solo_unicodeDecoded: String {
        // 先提取所有 \uXXXX 序列(不区分大小写)
        let pattern = #"\\u([0-9a-fA-F]{4})"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return self // 正则失败,原样返回
        }

        let nsString = self as NSString
        let fullRange = NSRange(location: 0, length: nsString.length)
        let matches = regex.matches(in: self, range: fullRange)

        // 如果没有匹配项,直接返回
        if matches.isEmpty {
            return self
        }

        var result = ""
        var lastIndex = 0
        var pendingHighSurrogate: UInt16? = nil

        for match in matches {
            let matchRange = match.range // 整个 \uXXXX
            let hexRange = match.range(at: 1) // 仅 XXXX 部分

            // 添加匹配前的普通文本
            if matchRange.location > lastIndex {
                result += nsString.substring(with: NSRange(location: lastIndex, length: matchRange.location - lastIndex))
            }

            // 解析十六进制
            let hexStr = nsString.substring(with: hexRange)
            guard let codeUnit = UInt16(hexStr, radix: 16) else {
                // 无效十六进制,原样保留 \uXXXX
                result += nsString.substring(with: matchRange)
                lastIndex = matchRange.upperBound
                continue
            }

            // 处理 UTF-16 代理对
            if let high = pendingHighSurrogate {
                // 期待低代理
                if codeUnit >= 0xDC00, codeUnit <= 0xDFFF {
                    // 合并代理对
                    let highAdjusted = UInt32(high - 0xD800)
                    let lowAdjusted = UInt32(codeUnit - 0xDC00)
                    let scalarValue = (highAdjusted << 10) + lowAdjusted + 0x10000
                    if let scalar = UnicodeScalar(scalarValue) {
                        result += String(scalar)
                    } else {
                        // 合并失败,回退
                        result += "\\u" + String(format: "%04x", high)
                        result += "\\u" + String(format: "%04x", codeUnit)
                    }
                } else {
                    // 不是低代理,高代理单独输出(非法但容错)
                    result += "\\u" + String(format: "%04x", high)
                    // 当前 codeUnit 作为新起点处理
                    if codeUnit < 0xD800 || codeUnit > 0xDFFF {
                        if let scalar = UnicodeScalar(codeUnit) {
                            result += String(scalar)
                        } else {
                            result += "\\u" + String(format: "%04x", codeUnit)
                        }
                    } else if codeUnit >= 0xD800, codeUnit <= 0xDBFF {
                        // 又是一个高代理,更新 pending
                        pendingHighSurrogate = codeUnit
                    } else {
                        // 低代理单独出现(非法)
                        result += "\\u" + String(format: "%04x", codeUnit)
                    }
                }
                pendingHighSurrogate = nil
            } else if codeUnit >= 0xD800, codeUnit <= 0xDBFF {
                // 高代理：暂存,等待下一个
                pendingHighSurrogate = codeUnit
            } else if codeUnit >= 0xDC00, codeUnit <= 0xDFFF {
                // 低代理单独出现(非法),直接输出
                result += "\\u" + String(format: "%04x", codeUnit)
            } else {
                // 普通字符
                if let scalar = UnicodeScalar(codeUnit) {
                    result += String(scalar)
                } else {
                    result += "\\u" + String(format: "%04x", codeUnit)
                }
            }

            lastIndex = matchRange.upperBound
        }

        // 处理剩余未匹配文本
        if lastIndex < nsString.length {
            result += nsString.substring(from: lastIndex)
        }

        // 如果还有未配对的高代理,追加回去
        if let high = pendingHighSurrogate {
            result += "\\u" + String(format: "%04x", high)
        }

        return result
    }
}
