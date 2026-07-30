import Foundation
import CoreGraphics

// MARK: - 字符串尺寸计算
public extension String {
    /// 计算普通字符串在指定宽度和字体下的实际尺寸
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度,默认为 `.greatestFiniteMagnitude`
    ///   - font: 使用的字体(iOS: `UIFont`, macOS: `NSFont`)
    ///   - usesLineFragmentOrigin: 是否使用段落布局模式(默认 `true`)
    ///   - ceilResult: 是否对结果向上取整(默认 `true`,便于 UI 布局)
    /// - Returns: 字符串占用的尺寸(`CGSize`)
    ///
    /// - Example:
    ///   ```swift
    ///   let size = "Hello".dy_size(maxWidth: 200, font: .systemFont(ofSize: 16))
    ///   ```
    func dy_size(
        maxWidth: CGFloat = .greatestFiniteMagnitude,
        font: DyFont,
        usesLineFragmentOrigin: Bool = true,
        ceilResult: Bool = true
    ) -> CGSize {
        let options: NSStringDrawingOptions = usesLineFragmentOrigin
            ? [.usesLineFragmentOrigin, .usesFontLeading]
            : [.usesFontLeading]

        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(
            with: constraint,
            options: options,
            attributes: [.font: font],
            context: nil
        )
        let size = rect.size
        return ceilResult ? CGSize(width: ceil(size.width), height: ceil(size.height)) : size
    }

    /// 使用富文本属性计算字符串尺寸(支持行间距、字间距等)
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度,默认为 `.greatestFiniteMagnitude`
    ///   - font: 字体
    ///   - lineSpacing: 行间距(默认 0)
    ///   - paragraphSpacing: 段落间距(默认 0)
    ///   - wordSpacing: 字符间距(即 kerning,默认 0)
    ///   - alignment: 文本对齐方式(默认 `.left`)
    ///   - lineBreakMode: 换行模式(默认 `.byWordWrapping`)
    ///   - ceilResult: 是否对结果向上取整(默认 `true`)
    /// - Returns: 富文本渲染后的尺寸
    ///
    /// - Example:
    ///   ```swift
    ///   let size = "Multi-line text".dy_sizeWithAttributes(
    ///       maxWidth: 150,
    ///       font: .systemFont(ofSize: 14),
    ///       lineSpacing: 4,
    ///       wordSpacing: 0.5
    ///   )
    ///   ```
    func dy_sizeWithAttributes(
        maxWidth: CGFloat = .greatestFiniteMagnitude,
        font: DyFont,
        lineSpacing: CGFloat = 0,
        paragraphSpacing: CGFloat = 0,
        wordSpacing: CGFloat = 0,
        alignment: NSTextAlignment = .left,
        lineBreakMode: NSLineBreakMode = .byWordWrapping,
        ceilResult: Bool = true
    ) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.alignment = alignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: wordSpacing,
            .paragraphStyle: paragraphStyle,
        ]

        let attributedString = NSAttributedString(string: self, attributes: attributes)
        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)

        let rect = attributedString.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        let size = rect.size
        return ceilResult ? CGSize(width: ceil(size.width), height: ceil(size.height)) : size
    }
}
