import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: NSMutableParagraphStyle {
    /// 设置文本对齐方式
    ///
    /// - Parameter alignment: 对齐方式(如 `.left`, `.center`, `.right`)
    /// - Returns: `Self`
    @discardableResult
    func alignment(_ alignment: NSTextAlignment) -> Self {
        base.alignment = alignment
        return self
    }

    /// 设置文本换行模式
    ///
    /// - Parameter lineBreakMode: 换行方式(如 `.byWordWrapping`, `.byTruncatingTail`)
    /// - Returns: `Self`
    @discardableResult
    func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> Self {
        base.lineBreakMode = lineBreakMode
        return self
    }

    /// 设置行间距(行与行之间的额外空间)
    ///
    /// - Parameter lineSpacing: 行间距(单位：点),应 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat) -> Self {
        base.lineSpacing = max(0, lineSpacing)
        return self
    }

    /// 设置段落间距(当前段落与下一段落之间的距离)
    ///
    /// - Parameter paragraphSpacing: 段落间距(单位：点),应 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func paragraphSpacing(_ paragraphSpacing: CGFloat) -> Self {
        base.paragraphSpacing = max(0, paragraphSpacing)
        return self
    }

    /// 设置连字符使用倾向(0.0 = 从不,1.0 = 尽可能)
    ///
    /// - Parameter hyphenationFactor: 连字符系数,范围 [0.0, 1.0]
    /// - Returns: `Self`
    @discardableResult
    func hyphenationFactor(_ hyphenationFactor: Float) -> Self {
        base.hyphenationFactor = min(max(hyphenationFactor, 0.0), 1.0)
        return self
    }

    /// 设置首行缩进
    ///
    /// - Parameter firstLineHeadIndent: 缩进值(单位：点),可为负数
    /// - Returns: `Self`
    @discardableResult
    func firstLineHeadIndent(_ firstLineHeadIndent: CGFloat) -> Self {
        base.firstLineHeadIndent = firstLineHeadIndent
        return self
    }

    /// 设置段落前间距(段落上方的额外空间)
    ///
    /// - Parameter paragraphSpacingBefore: 间距值(单位：点),应 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func paragraphSpacingBefore(_ paragraphSpacingBefore: CGFloat) -> Self {
        base.paragraphSpacingBefore = max(0, paragraphSpacingBefore)
        return self
    }

    /// 设置段落左侧缩进(正文起始位置偏移)
    ///
    /// - Parameter headIndent: 缩进值(单位：点),应 ≥ 0
    /// - Returns: `Self`
    ///
    /// - Example:
    ///   ```swift
    ///   let style = NSMutableParagraphStyle().solo.headIndent(10.0)
    ///   ```
    @discardableResult
    func headIndent(_ headIndent: CGFloat) -> Self {
        base.headIndent = max(0, headIndent)
        return self
    }

    /// 设置段落右侧缩进(正文结束位置偏移)
    ///
    /// - Parameter tailIndent: 缩进值(单位：点),通常 ≤ 0 表示向左缩进
    /// - Returns: `Self`
    @discardableResult
    func tailIndent(_ tailIndent: CGFloat) -> Self {
        base.tailIndent = tailIndent
        return self
    }

    /// 设置行高倍数(基于字体大小的乘数)
    ///
    /// - Parameter lineHeightMultiple: 倍数(如 1.5 表示 1.5 倍行高),应 > 0
    /// - Returns: `Self`
    @discardableResult
    func lineHeightMultiple(_ lineHeightMultiple: CGFloat) -> Self {
        base.lineHeightMultiple = max(0.01, lineHeightMultiple)
        return self
    }

    /// 设置最小行高(防止行高过小)
    ///
    /// - Parameter minimumLineHeight: 最小行高(单位：点),应 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func minimumLineHeight(_ minimumLineHeight: CGFloat) -> Self {
        base.minimumLineHeight = max(0, minimumLineHeight)
        return self
    }

    /// 设置最大行高(防止行高过大)
    ///
    /// - Parameter maximumLineHeight: 最大行高(单位：点),应 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func maximumLineHeight(_ maximumLineHeight: CGFloat) -> Self {
        base.maximumLineHeight = max(0, maximumLineHeight)
        return self
    }
}
