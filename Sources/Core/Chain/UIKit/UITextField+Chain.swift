import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UITextField {
    /// 设置普通文本内容
    /// - Parameter text: 要显示的文本
    /// - Returns: `Self`
    @discardableResult
    func text(_ text: String?) -> Self {
        base.text = text
        return self
    }

    /// 设置富文本内容
    /// - Parameter attributedText: 富文本对象
    /// - Returns: `Self`
    @discardableResult
    func attributedText(_ attributedText: NSAttributedString?) -> Self {
        base.attributedText = attributedText
        return self
    }

    /// 设置占位符文本
    /// - Parameter placeholder: 占位符字符串
    /// - Returns: `Self`
    @discardableResult
    func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }

    /// 设置富文本占位符
    /// - Parameter attributedPlaceholder: 富文本占位符
    /// - Returns: `Self`
    @discardableResult
    func attributedPlaceholder(_ attributedPlaceholder: NSAttributedString?) -> Self {
        base.attributedPlaceholder = attributedPlaceholder
        return self
    }

    /// 设置文本对齐方式
    /// - Parameter alignment: 对齐模式(左、中、右等)
    /// - Returns: `Self`
    @discardableResult
    func textAlignment(_ alignment: NSTextAlignment) -> Self {
        base.textAlignment = alignment
        return self
    }

    /// 设置文本颜色
    /// - Parameter color: 文本颜色
    /// - Returns: `Self`
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        base.textColor = color
        return self
    }

    /// 设置字体
    /// - Parameter font: 字体对象
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        base.font = font
        return self
    }

    /// 设置是否根据宽度自动调整字体大小
    /// - Parameter enabled: 是否启用自动缩放
    /// - Returns: `Self`
    @discardableResult
    func adjustsFontSizeToFitWidth(_ enabled: Bool) -> Self {
        base.adjustsFontSizeToFitWidth = enabled
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITextFieldDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置键盘类型
    /// - Parameter type: 键盘样式(如数字、邮箱等)
    /// - Returns: `Self`
    @discardableResult
    func keyboardType(_ type: UIKeyboardType) -> Self {
        base.keyboardType = type
        return self
    }

    /// 设置 Return 键类型
    /// - Parameter type: Return 键样式(如完成、搜索等)
    /// - Returns: `Self`
    @discardableResult
    func returnKeyType(_ type: UIReturnKeyType) -> Self {
        base.returnKeyType = type
        return self
    }

    /// 启用或禁用密码模式(安全文本输入)
    /// - Parameter enabled: 是否启用安全输入
    /// - Returns: `Self`
    @discardableResult
    func secureTextEntry(_ enabled: Bool) -> Self {
        base.isSecureTextEntry = enabled
        return self
    }

    /// 设置左侧视图显示模式
    /// - Parameter mode: 显示模式(从不、编辑时、始终等)
    /// - Returns: `Self`
    @discardableResult
    func leftViewMode(_ mode: UITextField.ViewMode) -> Self {
        base.leftViewMode = mode
        return self
    }

    /// 设置右侧视图显示模式
    /// - Parameter mode: 显示模式
    /// - Returns: `Self`
    @discardableResult
    func rightViewMode(_ mode: UITextField.ViewMode) -> Self {
        base.rightViewMode = mode
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

    /// 快速设置工具栏为输入辅助视图
    /// - Parameter toolbar: 工具栏实例
    /// - Returns: `Self`
    @discardableResult
    func toolbar(_ toolbar: UIToolbar) -> Self {
        base.inputAccessoryView = toolbar
        return self
    }

    /// 设置清除按钮显示模式
    /// - Parameter mode: 清除按钮模式
    /// - Returns: `Self`
    @discardableResult
    func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        base.clearButtonMode = mode
        return self
    }

    /// 设置是否自动启用 Return 键
    /// - Parameter enabled: 是否自动启用
    /// - Returns: `Self`
    @discardableResult
    func enablesReturnKeyAutomatically(_ enabled: Bool) -> Self {
        base.enablesReturnKeyAutomatically = enabled
        return self
    }

    /// 设置边框样式
    /// - Parameter style: 边框样式,如 `.roundedRect`
    /// - Returns: `Self`
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        base.borderStyle = style
        return self
    }

    /// 设置是否在开始编辑时清空文本
    /// - Parameter clears: 是否清空
    /// - Returns: `Self`
    @discardableResult
    func clearsOnBeginEditing(_ clears: Bool) -> Self {
        base.clearsOnBeginEditing = clears
        return self
    }

    /// 设置最小字体大小
    /// - Parameter size: 最小字号
    /// - Returns: `Self`
    @discardableResult
    func minimumFontSize(_ size: CGFloat) -> Self {
        base.minimumFontSize = size
        return self
    }

    /// 设置背景图片
    /// - Parameter image: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func background(_ image: UIImage?) -> Self {
        base.background = image
        return self
    }

    /// 设置禁用状态背景图片
    /// - Parameter image: 禁用背景图片
    /// - Returns: `Self`
    @discardableResult
    func disabledBackground(_ image: UIImage?) -> Self {
        base.disabledBackground = image
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension DyWrapper where Base: UITextField {
    /// 清空文本和富文本内容
    /// - Returns: `Self`
    @discardableResult
    func clear() -> Self {
        base.text = nil
        base.attributedText = nil
        return self
    }

    /// 添加左侧内边距(通过 `leftView` 实现)
    /// - Parameter padding: 左侧空白宽度
    /// - Returns: `Self`
    @discardableResult
    func leftPadding(_ padding: CGFloat) -> Self {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        base.leftView = spacer
        base.leftViewMode = .always
        NSLayoutConstraint.activate([
            spacer.widthAnchor.constraint(equalToConstant: padding),
        ])
        return self
    }

    /// 添加右侧内边距(通过 `rightView` 实现)
    /// - Parameter padding: 右侧空白宽度
    /// - Returns: `Self`
    @discardableResult
    func rightPadding(_ padding: CGFloat) -> Self {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        base.rightView = spacer
        base.rightViewMode = .always
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
    func leftView(_ view: UIView?, containerSize: CGSize = CGSize(width: 40, height: 40)) -> Self {
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
        base.leftView = container
        base.leftViewMode = .always
        return self
    }

    /// 设置右侧自定义视图
    /// - Parameters:
    ///   - view: 要显示的视图
    ///   - containerSize: 容器尺寸
    /// - Returns: `Self`
    @discardableResult
    func rightView(_ view: UIView?, containerSize: CGSize = CGSize(width: 40, height: 40)) -> Self {
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
        base.rightView = container
        base.rightViewMode = .always
        return self
    }
}
