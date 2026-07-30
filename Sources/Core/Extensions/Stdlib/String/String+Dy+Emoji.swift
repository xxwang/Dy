import Foundation

// MARK: - Emoji检测与提取
public extension String {
    /// 判断字符串是否为单个视觉单元的 Emoji
    var dy_isSingleEmoji: Bool {
        return self.count == 1 && self.first?.dy_isEmoji == true
    }

    /// 判断字符串是否包含至少一个 Emoji 字符
    var dy_containsEmoji: Bool {
        return self.contains { $0.dy_isEmoji }
    }

    /// 判断字符串是否仅由`Emoji`字符组成（不含空格、标点等）
    var dy_containsOnlyEmoji: Bool {
        return !self.isEmpty && self.allSatisfy(\.dy_isEmoji)
    }

    /// 提取所有`Emoji`字符并拼接成新字符串
    var dy_emojiString: String {
        return self.dy_emojis.map(String.init).joined()
    }

    /// 提取所有`Emoji`字符数组
    var dy_emojis: [Character] {
        return self.filter(\.dy_isEmoji)
    }

    /// 提取所有 `Emoji` 的底层 `Unicode` 标量
    var dy_emojiScalars: [UnicodeScalar] {
        return self.dy_emojis.flatMap(\.unicodeScalars)
    }
}
