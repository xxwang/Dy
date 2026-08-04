import UIKit
import os.log

// MARK: - 链式设置属性
public extension DyWrapper where Base: UITextView {
    /// 设置是否可编辑
    /// - Parameter isEditable: 是否可以编辑
    /// - Returns: `Self`
    @discardableResult
    func isEditable(_ isEditable: Bool) -> Self {
        base.isEditable = isEditable
        return self
    }

    /// 清空文本内容
    /// - Returns: `Self`
    @discardableResult
    func clear() -> Self {
        base.text = ""
        base.attributedText = NSAttributedString()
        return self
    }

    /// 设置纯文本内容
    /// - Parameter text: 要设置的内容
    /// - Returns: `Self`
    @discardableResult
    func text(_ text: String) -> Self {
        base.text = text
        return self
    }

    /// 设置富文本内容
    /// - Parameter attributedText: 要设置的富文本内容
    /// - Returns: `Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 设置文本对齐方式
    /// - Parameter alignment: 要设置的对齐方式
    /// - Returns: `Self`
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 要设置的颜色
    /// - Returns: `Self`
    @discardableResult
    func textColor(_ color: UIColor) -> Self {
        base.textColor = color
        return self
    }

    /// 设置字体
    /// - Parameter font: 要设置的字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.font = font
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 要设置的代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITextViewDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter type: 要设置的键盘类型
    /// - Returns: `Self`
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        base.keyboardType = type
        return self
    }

    /// 设置`Return`键类型
    /// - Parameter type: 要设置的类型
    /// - Returns: `Self`
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        base.returnKeyType = type
        return self
    }

    /// 是否自动启用/禁用 `Return`键(基于内容是否为空)
    /// - Parameter enabled: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func enablesReturnKeyAutomatically(_ enabled: Bool) -> Self {
        base.enablesReturnKeyAutomatically = enabled
        return self
    }

    /// 设置文本容器外边距
    /// - Parameter inset: 外边距
    /// - Returns: `Self`
    @discardableResult
    func textContainerInset(_ inset: UIEdgeInsets) -> Self {
        base.textContainerInset = inset
        return self
    }

    /// 设置行片段左右内边距(通常设为 0 以贴边)
    /// - Parameter padding: 内边距
    /// - Returns: `Self`
    @discardableResult
    func lineFragmentPadding(_ padding: CGFloat) -> Self {
        base.textContainer.lineFragmentPadding = padding
        return self
    }

    /// 设置是否可选择文本
    /// - Parameter selectable: 是否可选择
    /// - Returns: `Self`
    @discardableResult
    func isSelectable(_ selectable: Bool) -> Self {
        base.isSelectable = selectable
        return self
    }

    /// 设置数据检测类型(自动识别电话、链接等)
    /// - Parameter types: 检测类型,如 `.link` / `.phoneNumber`
    /// - Returns: `Self`
    @discardableResult
    func dataDetectorTypes(_ types: UIDataDetectorTypes) -> Self {
        base.dataDetectorTypes = types
        return self
    }

    /// 设置是否允许编辑文本属性(加粗/斜体等)
    /// - Parameter allows: 是否允许
    /// - Returns: `Self`
    @discardableResult
    func allowsEditingTextAttributes(_ allows: Bool) -> Self {
        base.allowsEditingTextAttributes = allows
        return self
    }

    /// 设置链接文本属性(颜色、下划线等)
    /// - Parameter attributes: 链接属性字典
    /// - Returns: `Self`
    @discardableResult
    func linkTextAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        base.linkTextAttributes = attributes
        return self
    }

    /// 设置输入辅助视图(如工具栏)
    /// - Parameter accessoryView: 辅助视图
    /// - Returns: `Self`
    @discardableResult
    func inputAccessoryView(_ accessoryView: UIView?) -> Self {
        base.inputAccessoryView = accessoryView
        return self
    }

    /// 设置自定义输入视图(替代系统键盘)
    /// - Parameter inputView: 自定义输入视图
    /// - Returns: `Self`
    @discardableResult
    func inputView(_ inputView: UIView?) -> Self {
        base.inputView = inputView
        return self
    }

    /// 设置当前输入属性(字体、颜色等)
    /// - Parameter attributes: 属性字典
    /// - Returns: `Self`
    @discardableResult
    func typingAttributes(_ attributes: [NSAttributedString.Key: Any]) -> Self {
        base.typingAttributes = attributes
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension DyWrapper where Base: UITextView {
    /// 滚动到顶部
    /// - Returns: `Self`
    @discardableResult
    func scrollToTop() -> Self {
        if !base.text.isEmpty {
            let range = NSRange(location: 0, length: 1)
            base.scrollRangeToVisible(range)
        }
        return self
    }

    /// 滚动到底部
    /// - Returns: `Self`
    @discardableResult
    func scrollToBottom() -> Self {
        if !base.text.isEmpty {
            let end = base.text.count - 1
            let range = NSRange(location: max(0, end), length: 1)
            base.scrollRangeToVisible(range)
        }
        return self
    }

    /// 自动调整视图大小以适应内容(常用于动态高度`TextView`)
    /// - Returns: `Self`
    @discardableResult
    func wrapToContent() -> Self {
        base.contentInset = .zero
        base.scrollIndicatorInsets = .zero
        base.contentOffset = .zero
        base.textContainerInset = .zero
        base.textContainer.lineFragmentPadding = 0
        base.sizeToFit()
        return self
    }
}
