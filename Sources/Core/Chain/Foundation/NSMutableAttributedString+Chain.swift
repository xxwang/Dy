import Foundation

// MARK: - 链式设置属性(自定义)
public extension SoloWrapper where Base: NSMutableAttributedString {
    /// 在指定位置插入一个图片附件
    ///
    /// - Parameters:
    ///   - image: 要插入的图片对象若为 `nil`,则不执行任何操作
    ///   - bounds: 图片的显示区域(相对于文本基线)若为 `.zero`,将自动根据字体大小垂直居中对齐
    ///   - index: 插入位置(UTF-16 索引,默认为 0,即开头)
    /// - Returns: `Self`
    ///
    /// - Note: 图片会作为 `NSTextAttachment` 插入,适用于表情、图标等场景
    ///
    /// - Example:
    ///   ```swift
    ///   let attr = NSMutableAttributedString()
    ///       .solo
    ///       .string("点击 ")
    ///       .attachment(UIImage(systemName: "arrow.right"), at: 3)
    ///   ```
    @discardableResult
    func attachment(_ image: UIImage?, bounds: CGRect = .zero, at index: Int = 0) -> Self {
        guard let image else { return self }
        let attachment = NSTextAttachment()
        attachment.image = image

        if bounds != .zero {
            attachment.bounds = bounds
        } else {
            // 尝试从插入位置获取当前字体
            var fontSize: CGFloat = UIFont.systemFontSize // 默认字体大小
            if index < base.length {
                if let existingFont = base.attribute(.font, at: index, effectiveRange: nil) as? UIFont {
                    fontSize = existingFont.pointSize
                }
            } else if base.length > 0 {
                // 如果插入到末尾,取最后一个字符的字体
                if let existingFont = base.attribute(.font, at: base.length - 1, effectiveRange: nil) as? UIFont {
                    fontSize = existingFont.pointSize
                }
            }

            // 自动垂直对齐：通常图片底部略低于基线
            let yPosition = fontSize * -0.25
            attachment.bounds = CGRect(
                x: 0,
                y: yPosition,
                width: image.size.width,
                height: image.size.height
            )
        }
        let imageAttrStr = NSAttributedString(attachment: attachment)
        base.insert(imageAttrStr, at: index)

        return self
    }

    /// 设置指定范围内的字体
    ///
    /// - Parameters:
    ///   - font: 要应用的字体若为 `nil`,不执行操作
    ///   - for: 目标范围若未提供,默认为整个字符串
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont?, for range: NSRange? = nil) -> Self {
        guard let font else { return self }
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.font, value: font, range: range)
        return self
    }

    /// 设置字符间距(kerning),控制相邻字符之间的额外距离
    ///
    /// - Parameters:
    ///   - spacing: 间距值(单位：点)正值增大间距,负值减小
    ///   - for: 目标范围默认为整个字符串
    /// - Returns: `Self`
    ///
    /// - Note: 此属性作用于`所有字符之间`,包括中文、英文、Emoji 等
    ///         它对应 Core Text 的 `.kern` 属性
    @discardableResult
    func characterSpacing(_ spacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.kern, value: spacing, range: range)
        return self
    }

    /// 设置段落内行与行之间的额外间距(line spacing)
    ///
    /// - Parameters:
    ///   - lineSpacing: 行间距(单位：点)
    ///   - alignment: 段落对齐方式,默认为左对齐
    ///   - for: 目标范围默认为整个字符串
    /// - Returns: `Self`
    @discardableResult
    func lineSpacing(_ lineSpacing: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = alignment
        base.addAttribute(.paragraphStyle, value: style, range: range)
        return self
    }

    /// 设置`固定行高`(通过最小/最大行高强制统一高度)
    ///
    /// - Parameters:
    ///   - lineHeight: 期望的行高(单位：点)
    ///   - alignment: 段落对齐方式
    ///   - for: 目标范围
    /// - Returns: `Self`
    ///
    /// - Note: 实际渲染行高 = max(字体自然高度, lineHeight)
    ///         若需精确控制,请确保 `lineHeight` 大于等于字体高度
    @discardableResult
    func fixedLineHeight(_ lineHeight: CGFloat, alignment: NSTextAlignment = .left, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight
        style.maximumLineHeight = lineHeight
        style.alignment = alignment
        base.addAttribute(.paragraphStyle, value: style, range: range)
        return self
    }

    /// 设置段落后的额外间距(paragraph spacing)
    ///
    /// - Parameters:
    ///   - spacing: 段落间距(单位：点)
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func paragraphSpacing(_ spacing: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        let style = NSMutableParagraphStyle()
        style.paragraphSpacing = spacing
        base.addAttribute(.paragraphStyle, value: style, range: range)
        return self
    }

    /// 设置首行缩进(仅第一行缩进)
    ///
    /// - Parameter indent: 缩进宽度(单位：点)
    /// - Returns: `Self`
    @discardableResult
    func firstLineHeadIndent(_ indent: CGFloat) -> Self {
        let style = NSMutableParagraphStyle()
        style.firstLineHeadIndent = indent
        base.addAttribute(.paragraphStyle, value: style, range: base.solo.fullNSRange)
        return self
    }

    /// 设置文字前景色(即文字颜色)
    ///
    /// - Parameters:
    ///   - color: 文字颜色
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.foregroundColor, value: color, range: range)
        return self
    }

    /// 设置文字背景色(高亮背景)
    ///
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.backgroundColor, value: color, range: range)
        return self
    }

    /// 添加下划线
    ///
    /// - Parameters:
    ///   - color: 下划线颜色
    ///   - style: 下划线样式(如实线、虚线等),默认为 `.single`
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func underline(color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.underlineStyle, value: style.rawValue, range: range)
        base.addAttribute(.underlineColor, value: color, range: range)
        return self
    }

    /// 添加删除线(贯穿线)
    ///
    /// - Parameters:
    ///   - color: 删除线颜色
    ///   - style: 删除线样式,默认为 `.single`
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func strikethrough(color: UIColor, style: NSUnderlineStyle = .single, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.strikethroughStyle, value: style.rawValue, range: range)
        base.addAttribute(.strikethroughColor, value: color, range: range)
        return self
    }

    /// 设置文字倾斜(仿斜体效果)
    ///
    /// - Parameters:
    ///   - factor: 倾斜因子0 表示无倾斜,正值右倾,负值左倾
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func obliqueness(_ factor: Float = 0, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.obliqueness, value: factor, range: range)
        return self
    }

    /// 设置文字横向缩放(拉伸或压缩)
    ///
    /// - Parameters:
    ///   - factor: 缩放因子1.0 为原始宽度,>1 拉伸,<1 压缩
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func expansion(_ factor: Float = 1.0, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        base.addAttribute(.expansion, value: factor, range: range)
        return self
    }

    /// 添加文本阴影效果
    ///
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - offset: 阴影偏移量(x 向右,y 向下为正)
    ///   - radius: 阴影模糊半径(越大越模糊)
    ///   - for: 目标范围
    /// - Returns: `Self`
    ///
    /// - Example:
    ///   ```swift
    ///   .solo.textShadow(color: .black, offset: CGSize(width: 1, height: 1), radius: 2)
    ///   ```
    @discardableResult
    func textShadow(color: UIColor, offset: CGSize, radius: CGFloat, for range: NSRange? = nil) -> Self {
        let range = range ?? base.solo.fullNSRange
        let shadow = NSShadow()
        shadow.shadowColor = color
        shadow.shadowOffset = offset
        shadow.shadowBlurRadius = radius
        base.addAttribute(.shadow, value: shadow, range: range)
        return self
    }
}

// MARK: - 链式添加属性(基于文本匹配/范围/正则表达式)
public extension SoloWrapper where Base: NSMutableAttributedString {
    /// 为所有`精确匹配` `target` 的子串添加属性
    ///
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - toOccurrencesOf: 目标子串(支持任意 `StringProtocol` 类型,如 `Substring`)
    /// - Returns: `Self`
    ///
    /// - Note: 匹配区分大小写,且会转义正则特殊字符以确保字面匹配
    ///
    /// - Example:
    ///   ```swift
    ///   .solo.addAttributes([.foregroundColor: UIColor.red], toOccurrencesOf: "World")
    ///   ```
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], toOccurrencesOf target: some StringProtocol) -> Self {
        // 使用 \Q...\E 转义目标字符串中的正则元字符,实现字面匹配
        let pattern = "\\Q\(target)\\E"
        return self.addAttributes(attributes, toRangesMatching: pattern)
    }

    /// 使用正则表达式匹配文本,并为所有匹配项添加属性
    ///
    /// - Parameters:
    ///   - attributes: 要添加的属性字典
    ///   - toRangesMatching: 正则表达式模式
    ///   - options: 正则选项(如 `.caseInsensitive`)
    /// - Returns: `Self`
    ///
    /// - Throws: 若正则表达式无效,将忽略并返回原字符串(不抛出异常)
    ///
    /// - Example:
    ///   ```swift
    ///   .solo.addAttributes([.foregroundColor: .blue], toRangesMatching: "\\d+") // 高亮所有数字
    ///   ```
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], toRangesMatching pattern: String, options: NSRegularExpression.Options = []) -> Self {
        guard !pattern.isEmpty,
              let regex = try? NSRegularExpression(pattern: pattern, options: options),
              base.length > 0 else { return self }

        let matches = regex.matches(in: base.string, options: [], range: base.solo.fullNSRange)
        for match in matches {
            self.addAttributes(attributes, for: match.range)
        }
        return self
    }

    /// 为指定 `NSRange` 添加多个属性(安全版本)
    ///
    /// - Parameters:
    ///   - attributes: 属性字典
    ///   - for: 目标范围
    /// - Returns: `Self`
    @discardableResult
    func addAttributes(_ attributes: [NSAttributedString.Key: Any], for range: NSRange) -> Self {
        let isValidRange = range.location >= 0 && range.length >= 0 && range.location + range.length <= base.length
        if isValidRange {
            base.addAttributes(attributes, range: range)
        }
        return self
    }

    /// 安全地添加单个属性,自动忽略无效范围
    func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {
        let isValidRange = range.location >= 0 && range.length >= 0 && range.location + range.length <= base.length
        if isValidRange {
            base.addAttribute(name, value: value, range: range)
        }
    }
}

// MARK: - 方法
public extension SoloWrapper where Base: NSMutableAttributedString {
    /// 设置基础纯文本内容
    ///
    /// - Parameter string: 新的字符串内容
    /// - Returns: `Self`
    @discardableResult
    func string(_ string: String) -> Self {
        base.setAttributedString(string.solo_nSAttributedString())
        return self
    }

    /// 替换当前内容为指定的不可变属性字符串
    ///
    /// - Parameter attributedString: 新的属性字符串
    /// - Returns: `Self`
    @discardableResult
    func attributedString(_ attributedString: NSAttributedString) -> Self {
        base.setAttributedString(attributedString)
        return self
    }

    /// 在当前字符串末尾追加另一个属性字符串
    ///
    /// - Parameter attributedString: 要追加的属性字符串
    /// - Returns: `Self`
    @discardableResult
    func append(_ attributedString: NSAttributedString) -> Self {
        base.append(attributedString)
        return self
    }
}
