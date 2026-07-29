import UIKit
import Combine
import DyCore

open class DyTextView: UITextView {
    public var cancellables = Set<AnyCancellable>()

    /// 占位文本标签
    lazy var placeholderLabel: UILabel = UILabel.dy_label()
        .dy_numberOfLines(0)
        .dy_backgroundColor(.clear)
        .dy_textColor(.placeholderText)
        .dy_font(self.font ?? .systemFont(ofSize: 14))
        .dy_translatesAutoresizingMaskIntoConstraints(false)

    override open var font: UIFont? {
        didSet {
            placeholderLabel.font = font ?? .systemFont(ofSize: 14)
        }
    }

    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupUI()
        self.eventHandler()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
        self.eventHandler()
    }

    deinit {
        cancellables.removeAll()
    }
}

@objc extension DyTextView {
    /// 设置UI
    open func setupUI() {
        // 添加占位文本标签
        self.addSubview(placeholderLabel)

        // 获取总内边距(contentInset + textContainerInset)
        let totalTopInset = contentInset.top + textContainerInset.top
        let totalLeftInset = contentInset.left + textContainerInset.left
        let totalRightInset = contentInset.right + textContainerInset.right

        NSLayoutConstraint.activate([
            // 顶部对齐：textView 顶部 + 总上边距
            placeholderLabel.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: totalTopInset
            ),

            // 左侧对齐：textView 左侧 + 总左边距
            placeholderLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: totalLeftInset
            ),

            // 右侧不超过：textView 右侧 - 总右边距(防止超出)
            placeholderLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: self.trailingAnchor,
                constant: -totalRightInset
            ),

            // 高度自适应(由 label 内容决定)
            placeholderLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
        ])
    }

    /// 事件处理
    open func eventHandler() {
        // 精准监听自身文本变化：使用 KVO
        self.publisher(for: \.text, options: [.initial, .new])
            .sink { [weak self] _ in
                self?.updatePlaceholderVisibility()
            }
            .store(in: &self.cancellables)

        // 同时监听 attributedText(防止通过富文本清空内容)
        publisher(for: \.attributedText, options: [.initial, .new])
            .sink { [weak self] _ in
                self?.updatePlaceholderVisibility()
            }
            .store(in: &self.cancellables)
    }

    /// 根据内容决定是否隐藏占位文本
    open func updatePlaceholderVisibility() {
        // `text`/`attributedText` 为 nil 时按"空"处理,避免空白状态占位符被隐藏
        let isEmpty = (text?.isEmpty ?? true) && (attributedText?.string.isEmpty ?? true)
        placeholderLabel.isHidden = !isEmpty
    }
}

// MARK: - 链式语法
public extension DyTextView {
    /// 设置占位文字内容
    /// - Parameter text: 要设置的文字
    /// - Returns: `Self`
    @discardableResult
    func dy_placeholder(_ text: String?) -> Self {
        self.placeholderLabel.text = text
        self.updatePlaceholderVisibility()
        return self
    }

    /// 设置占位文字字体
    /// - Parameter font: 要设置的占位文字字体
    /// - Returns: `Self`
    @discardableResult
    func dy_placeholderFont(_ font: UIFont) -> Self {
        self.placeholderLabel.font = font
        return self
    }

    /// 设置占位文字颜色
    /// - Parameter color: 要设置的占位文字颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_placeholderColor(_ color: UIColor) -> Self {
        self.placeholderLabel.textColor = color
        return self
    }
}
