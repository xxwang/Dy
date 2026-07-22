import UIKit

// MARK: - 属性
public extension UITextField {
    /// 判断当前文本内容是否为空
    var dy_isEmpty: Bool {
        self.text == nil || self.text == ""
    }
}

// MARK: - 常用方法
public extension UITextField {
    /// 为输入框添加工具栏到 `inputAccessoryView`
    ///
    /// - Parameters:
    ///   - items: 工具栏中的按钮项数组
    ///   - height: 工具栏高度,默认为 `44`
    /// - Returns: 创建的 `UIToolbar` 实例
    ///
    /// - Example:
    ///   ```swift
    ///   let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
    ///   textField.dy_addToolbar(items: [doneButton])
    ///   ```
    @discardableResult
    func dy_addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.items = items
        toolbar.sizeToFit()

        // 强制设置高度(sizeToFit 可能忽略)
        let fixedHeight = NSLayoutConstraint(item: toolbar,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .notAnAttribute,
                                             multiplier: 1,
                                             constant: height)
        fixedHeight.isActive = true

        self.inputAccessoryView = toolbar
        return toolbar
    }

    /// 用于 `UITextFieldDelegate` 的输入限制方法
    ///
    /// 支持最大字符数限制和正则表达式过滤
    ///
    /// - Parameters:
    ///   - range: 当前编辑范围(由 delegate 方法传入)
    ///   - replacementText: 即将插入的文本
    ///   - maxCharacters: 允许的最大字符数
    ///   - regex: 可选的正则表达式,用于限制输入字符类型(如仅数字字母)
    /// - Returns: `true` 表示允许输入,`false` 表示拒绝
    ///
    /// - Example:
    ///   ```swift
    ///   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    ///       return textField.dy_inputRestrictions(
    ///           shouldChangeTextIn: range,
    ///           replacementText: string,
    ///           maxCharacters: 10,
    ///           regex: "^[a-zA-Z0-9]*$"
    ///       )
    ///   }
    ///   ```
    func dy_inputRestrictions(
        shouldChangeTextIn range: NSRange,
        replacementText text: String,
        maxCharacters: Int,
        regex: String? = nil
    ) -> Bool {
        // 删除操作：总是允许
        if text.isEmpty {
            return true
        }

        // 正则校验(仅校验新增字符)
        if let regexPattern = regex, !text.dy_isMatch(pattern: regexPattern) {
            return false
        }

        // 计算新文本
        let currentText = self.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return false }
        let newText = currentText.replacingCharacters(in: textRange, with: text)

        // 长度限制
        return newText.count <= maxCharacters
    }
}

// MARK: - 链式设置属性
public extension UITextField {
    /// 设置普通文本内容
    /// - Parameter text: 要显示的文本
    /// - Returns: `Self`
    @discardableResult
    func dy_text(_ text: String?) -> Self {
        self.text = text
        return self
    }

    /// 设置富文本内容
    /// - Parameter attributedText: 富文本对象
    /// - Returns: `Self`
    @discardableResult
    func dy_attributedText(_ attributedText: NSAttributedString?) -> Self {
        self.attributedText = attributedText
        return self
    }

    /// 设置占位符文本
    /// - Parameter placeholder: 占位符字符串
    /// - Returns: `Self`
    @discardableResult
    func dy_placeholder(_ placeholder: String?) -> Self {
        self.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder: 富文本占位符
    /// - Returns: `Self`
    @discardableResult
    func dy_attributedPlaceholder(_ attributedPlaceholder: NSAttributedString?) -> Self {
        self.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐模式(左、中、右等)
    /// - Returns: `Self`
    @discardableResult
    func dy_textAlignment(_ alignment: NSTextAlignment) -> Self {
        self.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文本颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_textColor(_ color: UIColor?) -> Self {
        self.textColor = color
        return self
    }

    /// 设置字体
    /// - Parameter font: 字体对象
    /// - Returns: `Self`
    @discardableResult
    func dy_font(_ font: UIFont?) -> Self {
        self.font = font
        return self
    }

    /// 设置是否根据宽度自动调整字体大小
    /// - Parameter enabled: 是否启用自动缩放
    /// - Returns: `Self`
    @discardableResult
    func dy_adjustsFontSizeToFitWidth(_ enabled: Bool) -> Self {
        self.adjustsFontSizeToFitWidth = enabled
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UITextFieldDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter type: 键盘样式(如数字、邮箱等)
    /// - Returns: `Self`
    @discardableResult
    func dy_keyboardType(_ type: UIKeyboardType) -> Self {
        self.keyboardType = type
        return self
    }

    /// 设置 Return 键类型
    /// - Parameter type: Return 键样式(如完成、搜索等)
    /// - Returns: `Self`
    @discardableResult
    func dy_returnKeyType(_ type: UIReturnKeyType) -> Self {
        self.returnKeyType = type
        return self
    }

    /// 启用或禁用密码模式(安全文本输入)
    /// - Parameter enabled: 是否启用安全输入
    /// - Returns: `Self`
    @discardableResult
    func dy_secureTextEntry(_ enabled: Bool) -> Self {
        self.isSecureTextEntry = enabled
        return self
    }

    /// 设置左侧视图显示模式
    /// - Parameter mode: 显示模式(从不、编辑时、始终等)
    /// - Returns: `Self`
    @discardableResult
    func dy_leftViewMode(_ mode: UITextField.ViewMode) -> Self {
        self.leftViewMode = mode
        return self
    }

    /// 设置右侧视图显示模式
    /// - Parameter mode: 显示模式
    /// - Returns: `Self`
    @discardableResult
    func dy_rightViewMode(_ mode: UITextField.ViewMode) -> Self {
        self.rightViewMode = mode
        return self
    }

    /// 设置输入辅助视图(如工具栏)
    /// - Parameter accessoryView: 辅助视图
    /// - Returns: `Self`
    @discardableResult
    func dy_inputAccessoryView(_ accessoryView: UIView?) -> Self {
        self.inputAccessoryView = accessoryView
        return self
    }

    /// 设置自定义输入视图(替代系统键盘)
    /// - Parameter inputView: 自定义输入视图
    /// - Returns: `Self`
    @discardableResult
    func dy_inputView(_ inputView: UIView?) -> Self {
        self.inputView = inputView
        return self
    }

    /// 快速设置工具栏为输入辅助视图
    /// - Parameter toolbar: 工具栏实例
    /// - Returns: `Self`
    @discardableResult
    func dy_toolbar(_ toolbar: UIToolbar) -> Self {
        self.inputAccessoryView = toolbar
        return self
    }

    /// 设置清除按钮显示模式
    /// - Parameter mode: 清除按钮模式
    /// - Returns: `Self`
    @discardableResult
    func dy_clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        self.clearButtonMode = mode
        return self
    }

    /// 设置是否自动启用 Return 键
    /// - Parameter enabled: 是否自动启用
    /// - Returns: `Self`
    @discardableResult
    func dy_enablesReturnKeyAutomatically(_ enabled: Bool) -> Self {
        self.enablesReturnKeyAutomatically = enabled
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UITextField {
    /// 清空文本和富文本内容
    /// - Returns: `Self`
    func dy_clear() -> Self {
        self.text = nil
        self.attributedText = nil
        return self
    }

    /// 添加左侧内边距(通过 `leftView` 实现)
    /// - Parameter padding: 左侧空白宽度
    /// - Returns: `Self`
    @discardableResult
    func dy_leftPadding(_ padding: CGFloat) -> Self {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        self.leftView = spacer
        self.leftViewMode = .always
        NSLayoutConstraint.activate([
            spacer.widthAnchor.constraint(equalToConstant: padding),
        ])
        return self
    }

    /// 添加右侧内边距(通过 `rightView` 实现)
    /// - Parameter padding: 右侧空白宽度
    /// - Returns: `Self`
    @discardableResult
    func dy_rightPadding(_ padding: CGFloat) -> Self {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        self.rightView = spacer
        self.rightViewMode = .always
        NSLayoutConstraint.activate([
            spacer.widthAnchor.constraint(equalToConstant: padding),
        ])
        return self
    }

    /// 设置左侧自定义视图
    /// - Parameters:
    ///   - view: 要显示的视图
    ///   - containerSize: 容器尺寸(建议宽高一致)
    /// - Returns: `Self`
    @discardableResult
    func dy_leftView(_ view: UIView?, containerSize: CGSize = CGSize(width: 40, height: 40)) -> Self {
        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        container.translatesAutoresizingMaskIntoConstraints = false
        if let view {
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(view)
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ])
        }
        self.leftView = container
        self.leftViewMode = .always
        return self
    }

    /// 设置右侧自定义视图
    /// - Parameters:
    ///   - view: 要显示的视图
    ///   - containerSize: 容器尺寸
    /// - Returns: `Self`
    @discardableResult
    func dy_rightView(_ view: UIView?, containerSize: CGSize = CGSize(width: 40, height: 40)) -> Self {
        let container = UIView(frame: CGRect(origin: .zero, size: containerSize))
        container.translatesAutoresizingMaskIntoConstraints = false
        if let view {
            view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(view)
            NSLayoutConstraint.activate([
                view.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                view.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            ])
        }
        self.rightView = container
        self.rightViewMode = .always
        return self
    }
}
