import Foundation

// MARK: - Emoji检测与提取
public extension DyWrapper where Base == String {
    /// 判断字符串是否为单个视觉单元的 Emoji
    var isSingleEmoji: Bool {
        return base.count == 1 && base.first?.dy_isEmoji == true
    }

    /// 判断字符串是否包含至少一个 Emoji 字符
    var containsEmoji: Bool {
        return base.contains { $0.dy.isEmoji }
    }

    /// 判断字符串是否仅由`Emoji`字符组成（不含空格、标点等）
    var containsOnlyEmoji: Bool {
        return !base.isEmpty && base.allSatisfy(\.dy.isEmoji)
    }

    /// 提取所有`Emoji`字符并拼接成新字符串
    var emojiString: String {
        return self.emojis.map(String.init).joined()
    }

    /// 提取所有`Emoji`字符数组
    var emojis: [Character] {
        return base.filter(\.dy_isEmoji)
    }

    /// 提取所有 `Emoji` 的底层 `Unicode` 标量
    var emojiScalars: [UnicodeScalar] {
        return self.emojis.flatMap(\.unicodeScalars)
    }
}
