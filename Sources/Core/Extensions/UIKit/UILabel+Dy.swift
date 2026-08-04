import UIKit

// MARK: - 构造方法
public extension UILabel {
    /// 使用纯文本创建 UILabel
    /// - Parameter text: 显示的文本(可为 nil)
    ///
    /// - Example:
    ///   ```swift
    ///   let label = UILabel(text: "Hello")
    ///   ```
    convenience init(text: String?) {
        self.init()
        self.text = text
    }

    /// 使用文本和动态字体样式创建 UILabel(支持系统字体缩放)
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - style: 字体样式(如 `.body`, `.headline`),自动适配用户字体偏好
    ///
    /// - Example:
    ///   ```swift
    ///   let label = UILabel(text: "标题", style: .headline)
    ///   ```
    convenience init(text: String, style: UIFont.TextStyle) {
        self.init()
        self.font = .preferredFont(forTextStyle: style)
        self.text = text
        self.adjustsFontForContentSizeCategory = true
    }
}

// MARK: - 属性
public extension DyWrapper where Base: UILabel {
    /// 获取 `UILabel` 在当前约束下实际使用的字体大小(考虑 `adjustsFontSizeToFitWidth`)
    ///
    /// - 注意: 此属性应在布局完成后(如 `layoutSubviews` 后)调用,否则 `bounds` 可能为零
    /// - 原理: 通过比较文本所需宽度与 label 可用宽度,结合 `minimumScaleFactor` 计算缩放比例
    ///
    /// - Example:
    ///   ```swift
    ///   label.adjustsFontSizeToFitWidth = true
    ///   label.minimumScaleFactor = 0.5
    ///   print("实际字号: \(label.dy.actualFontSize)")
    ///   ```
    var actualFontSize: CGFloat {
        // 快速返回：未启用自动缩放、无文本、无字体或容器宽度无效
        guard base.adjustsFontSizeToFitWidth,
              let text = base.text,
              !text.isEmpty,
              base.bounds.width > 0,
              let font = base.font
        else {
            return base.font?.pointSize ?? 0
        }

        // 计算原始文本在当前字体下的单行宽度
        let originalWidth = (text as NSString).boundingRect(
            with: CGSize(width: .greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        ).width

        // 若原始宽度未超出容器,使用原始字号
        guard originalWidth > base.bounds.width else {
            return font.pointSize
        }

        // 计算缩放比例,并受 minimumScaleFactor 限制
        let scale = base.bounds.width / originalWidth
        let clampedScale = max(base.minimumScaleFactor, scale)
        return font.pointSize * clampedScale
    }

    /// 根据当前文本、字体、宽度和行数限制,计算内容所需的高度
    ///
    /// - 注意: 此方法考虑了 `numberOfLines`、`lineBreakMode`、`attributedText/text` 优先级
    /// - 推荐在 label 布局完成后调用(确保 `bounds.width` 有效)
    ///
    /// - Example:
    ///   ```swift
    ///   label.frame.size.width = 200
    ///   label.numberOfLines = 0
    ///   print("所需高度: \(label.dy.requiredHeight)")
    ///   ```
    var requiredHeight: CGFloat {
        guard base.bounds.width > 0 else { return 0 }

        let textToUse = base.attributedText ?? (base.text.map { NSAttributedString(string: $0) })
        guard let text = textToUse, text.length > 0 else { return 0 }

        let constraintBox = CGSize(width: base.bounds.width, height: .greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        var boundingRect = base.text?.boundingRect(
            with: constraintBox,
            options: options,
            context: nil
        ) ?? .zero

        // 如果 numberOfLines > 0,限制最大行数
        if base.numberOfLines > 0 {
            let lineHeight = base.font.lineHeight
            let maxHeight = CGFloat(base.numberOfLines) * lineHeight
            if boundingRect.height > maxHeight {
                boundingRect.size.height = maxHeight.dy.ceil()
            }
        }

        return boundingRect.height.dy.ceil()
    }

    /// 将 `UILabel` 的文本按当前宽度和字体拆分为多行字符串数组
    ///
    /// - 注意: 依赖外部扩展 `String.splitIntoLines1(forWidth:usingFont:)`
    /// - 若该扩展不存在,此属性将返回空数组
    ///
    /// - Example:
    ///   ```swift
    ///   label.frame.size.width = 100
    ///   print("所有行: \(label.dy.allTextLines)")
    ///   ```
    var allTextLines: [String] {
        guard let text = base.text,
              let font = base.font,
              base.bounds.width > 0
        else {
            return []
        }
        return text.dy.wrappedLines(maxWidth: base.bounds.width, font: font)
    }

    /// 获取第一行显示的文本内容(若存在)
    ///
    /// - Returns: 第一行字符串,若无内容则返回 `nil`
    var firstLine: String? {
        self.allTextLines.first
    }

    /// 判断当前文本是否因空间不足而被截断(省略号或隐藏)
    ///
    /// - 注意: 使用 Core Text 精确检测,适用于单行/多行、任意 `lineBreakMode`
    /// - 性能开销中等,避免在 `cellForRow` 或动画中高频调用
    var isTextTruncated: Bool {
        // 边界检查
        guard let text = base.text,
              !text.isEmpty,
              let font = base.font,
              base.bounds.width > 0,
              base.bounds.height > 0
        else {
            return false
        }

        // 构建富文本(优先使用 attributedText)
        let displayText = base.attributedText ?? NSAttributedString(string: text, attributes: [.font: font])

        // 创建 framesetter
        let framesetter = CTFramesetterCreateWithAttributedString(displayText as CFAttributedString)

        // 创建限制路径(宽高由 label bounds 决定)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: base.bounds.width, height: base.bounds.height), transform: nil)

        // 创建 frame(注意：range 设为 (0, 0) 表示使用全部文本)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        // 获取可见范围：直接调用,无额外参数
        let visibleRange = CTFrameGetVisibleStringRange(frame)

        // 如果可见字符数 < 总字符数,则被截断
        return visibleRange.length < displayText.length
    }
}

// MARK: - UILabel 内容尺寸计算
public extension DyWrapper where Base: UILabel {
    /// 根据当前文本内容(普通或富文本)和指定最大宽度,计算所需尺寸
    ///
    /// - Parameter maxWidth: 最大允许宽度,默认为 `.greatestFiniteMagnitude`
    /// - Returns: 内容实际占用的 `CGSize`
    ///
    /// - 注意:
    ///   - 若 `text` 和 `attributedText` 均为空,返回 `.zero`
    ///   - 自动考虑 `numberOfLines` 和 `lineBreakMode`
    ///
    /// - Example:
    ///   ```swift
    ///   label.text = "Hello World"
    ///   let size = label.dy.size(maxWidth: 200)
    ///   ```
    func size(maxWidth: CGFloat = .greatestFiniteMagnitude) -> CGSize {
        return if base.attributedText != nil {
            base.attributedText?.dy.size(maxWidth: maxWidth) ?? .zero
        } else {
            base.text?.dy.size(maxWidth: maxWidth, font: base.font) ?? .zero
        }
    }

    /// 根据内容计算`CGSize`
    /// - Parameter maxWidth: 最大宽度
    /// - Returns: `CGSize`
    func sizeThatFits(maxWidth: CGFloat) -> CGSize {
        return base.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
    }
}

// MARK: - UILabel 富文本内容设置
public extension DyWrapper where Base: UILabel {
    /// 设置图文混排内容(支持在指定位置插入多张图片)
    ///
    /// - Parameters:
    ///   - text: 基础文本
    ///   - images: 要插入的图片数组(按顺序插入)
    ///   - insertPosition: 插入起始位置(字符索引),默认为 0(开头)
    ///   - scale: 图片缩放比例(基于字体高度),默认为 1.0
    ///   - spacing: 图片与文字之间的额外水平间距(单位：点),默认为 5
    ///   - useOriginalSize: 是否忽略缩放,使用图片原始尺寸(默认 `false`)
    ///
    /// - Returns: 生成的 `NSMutableAttributedString`
    ///
    /// - 注意:
    ///   - 若 `insertPosition` 超出文本长度,图片将追加到末尾
    ///   - 图片垂直居中对齐于文字基线
    ///
    /// - Example:
    ///   ```swift
    ///   let label = UILabel()
    ///   label.font = .systemFont(ofSize: 16)
    ///   label.dy.blend(
    ///       "Swift & UIKit",
    ///       images: [UIImage(systemName: "swift")],
    ///       insertPosition: 5,
    ///       scale: 1.2,
    ///       spacing: 4
    ///   )
    ///   ```
    @discardableResult
    func blend(
        _ text: String? = nil,
        images: [UIImage?] = [],
        insertPosition: Int = 0,
        scale: CGFloat = 1.0,
        spacing: CGFloat = 5,
        useOriginalSize: Bool = false
    ) -> NSMutableAttributedString {
        guard let font = base.font else {
            assertionFailure("UILabel.font is nil")
            let result = NSMutableAttributedString(string: text ?? "")
            base.attributedText = result
            return result
        }

        let baseText = text ?? ""
        let actualInsertPos = min(max(0, insertPosition), baseText.count)

        let attributedString = NSMutableAttributedString()

        // 插入前缀文本
        let prefix = String(baseText.prefix(actualInsertPos))
        attributedString.append(NSAttributedString(string: prefix))

        // 插入每张图片(带可选间距)
        for image in images {
            guard let image else { continue }

            let attachment = NSTextAttachment()
            let lineHeight = font.lineHeight

            let (width, height): (CGFloat, CGFloat)
            if useOriginalSize {
                width = image.size.width
                height = image.size.height
            } else {
                height = font.pointSize * scale
                width = image.size.width * (height / image.size.height)
            }

            // 垂直居中：y = (lineHeight - imageHeight) / 2 - font.descender
            // 更精确做法：对齐 baseline,但简单居中已满足多数场景
            let y = (lineHeight - height) / 2.0
            attachment.bounds = CGRect(x: 0, y: y, width: width, height: height)
            attachment.image = image

            attributedString.append(NSAttributedString(attachment: attachment))

            // 添加图片后间距(用空格 + kern 实现更可控)
            if spacing > 0 {
                let spaceAttr = [NSAttributedString.Key.kern: spacing]
                attributedString.append(NSAttributedString(string: " ", attributes: spaceAttr))
            }
        }

        // 插入后缀文本
        let suffix = String(baseText.dropFirst(actualInsertPos))
        attributedString.append(NSAttributedString(string: suffix))

        base.attributedText = attributedString
        return attributedString
    }

    /// 设置带行间距和字间距的纯文本(自动转为富文本)
    ///
    /// - Parameters:
    ///   - text: 显示的文本
    ///   - lineSpacing: 行间距(单位：点)
    ///   - wordSpacing: 字间距(单位：点),默认为 0
    ///
    /// - Returns: 生成的 `NSMutableAttributedString`
    ///
    /// - Example:
    ///   ```swift
    ///   label.dy.textWithSpacing("多行\n文本", lineSpacing: 8, wordSpacing: 2)
    ///   ```
    @discardableResult
    func textWithSpacing(
        _ text: String,
        lineSpacing: CGFloat,
        wordSpacing: CGFloat = 0
    ) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = base.textAlignment

        let attributes: [NSAttributedString.Key: Any] = [
            .font: base.font ?? UIFont.systemFont(ofSize: 14),
            .paragraphStyle: paragraphStyle,
            .kern: wordSpacing,
        ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        base.attributedText = attributedString
        return attributedString
    }

    /// 将当前文本按渲染结果拆分为实际显示的每一行字符串
    ///
    /// - Parameters:
    ///   - maxWidth: 最大宽度(若为 `nil`,使用 `bounds.width`)
    ///   - lineSpacing: 行间距(影响换行,但不改变返回的字符串内容)
    ///   - wordSpacing: 字间距(同上)
    ///
    /// - Returns: 每一行的字符串数组(按 Core Text 渲染结果)
    ///
    /// - 注意:
    ///   - 此方法反映`真实渲染分行`,比简单按 `\n` 拆分更准确
    ///   - 性能开销中等,避免高频调用
    ///
    /// - Example:
    ///   ```swift
    ///   label.text = "This is a long sentence that wraps."
    ///   label.frame.size.width = 100
    ///   print(label.dy.renderedLines())
    ///   ```
    func renderedLines(
        maxWidth: CGFloat? = nil,
        lineSpacing: CGFloat = 0,
        wordSpacing: CGFloat = 0
    ) -> [String] {
        guard let text = base.text, !text.isEmpty, let font = base.font else { return [] }

        let width = maxWidth ?? max(1, base.bounds.width) // 防止 width <= 0

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing

        let attributed = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle,
                .kern: wordSpacing,
            ]
        )

        let framesetter = CTFramesetterCreateWithAttributedString(attributed as CFAttributedString)
        let path = CGPath(rect: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)

        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return [] }

        return lines.compactMap { line in
            let range = CTLineGetStringRange(line)
            guard range.location + range.length <= text.utf16.count else { return nil }
            // 注意：Core Text 使用 UTF-16 单位,需谨慎转换
            let start = text.utf16.index(text.utf16.startIndex, offsetBy: range.location)
            let end = text.utf16.index(start, offsetBy: range.length)
            return String(text.utf16[start ..< end])
        }
    }
}
