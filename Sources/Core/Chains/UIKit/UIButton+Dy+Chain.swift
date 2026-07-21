import UIKit

// MARK: - 属性(UIButton.Configuration)
public extension DyWrapper where Base: UIButton {
    /// 设置按钮的 `UIButton.Configuration`
    /// - Parameter configuration: 按钮的新配置对象
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func configuration(_ configuration: UIButton.Configuration?) -> Self {
        base.configuration = configuration
        return self
    }

    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func titleC(_ title: String) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.title = title
        base.configuration = configuration
        return self
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func attributedTitleC(_ attributedTitle: AttributedString?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.attributedTitle = attributedTitle
        base.configuration = configuration
        return self
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func subtitle(_ subtitle: String) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.subtitle = subtitle
        base.configuration = configuration
        return self
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.attributedSubtitle = attributedSubtitle
        base.configuration = configuration
        return self
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func imageC(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePlacement = placement
        base.configuration = configuration
        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func backgroundImageC(_ backgroundImage: UIImage?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.background.image = backgroundImage
        base.configuration = configuration
        return self
    }

    /// 添加一个`UIAction`
    /// - Parameters:
    ///   - action: `UIAction`中实际执行的闭包代码
    ///   - controlEvents: 事件类型
    /// - Returns: `Self`
    @available(iOS 14.0, *)
    @discardableResult
    func addAction(_ action: @escaping (UIAction) -> Void, for controlEvents: UIControl.Event = .touchUpInside) -> Self {
        let action = UIAction { a in
            action(a)
        }
        base.removeAction(action, for: controlEvents)
        base.addAction(action, for: controlEvents)
        return self
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func isLoading(_ loading: Bool) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.showsActivityIndicator = loading
        base.configuration = configuration
        base.isUserInteractionEnabled = !loading
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.imagePadding = padding
        base.configuration = configuration
        return self
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func titlePadding(_ padding: CGFloat) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.titlePadding = padding
        base.configuration = configuration
        return self
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func baseBackgroundColor(_ color: UIColor?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.baseBackgroundColor = color
        base.configuration = configuration
        return self
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func baseForegroundColor(_ color: UIColor?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.baseForegroundColor = color
        base.configuration = configuration
        return self
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.imagePlacement = imagePlacement
        base.configuration = configuration
        return self
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.contentInsets = contentInsets
        base.configuration = configuration
        return self
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.cornerStyle = cornerStyle
        base.configuration = configuration
        return self
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.background.strokeColor = strokeColor
        base.configuration = configuration
        return self
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        var configuration = base.configuration ?? UIButton.Configuration.plain()
        configuration.background.strokeWidth = strokeWidth
        base.configuration = configuration
        return self
    }
}

// MARK: - 方法
public extension DyWrapper where Base: UIButton {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String, for state: UIControl.State = .normal) -> Self {
        base.setTitle(title, for: state)
        return self
    }

    /// 设置按钮在指定状态下的富文本标题
    /// - Parameters:
    ///   - attributedTitle: 富文本对象,可为 `nil` 清除标题
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func attributedTitle(_ attributedTitle: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        base.setAttributedTitle(attributedTitle, for: state)
        return self
    }

    /// 设置按钮在指定状态下的标题颜色
    /// - Parameters:
    ///   - color: 标题颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        base.setTitleColor(color, for: state)
        return self
    }

    /// 设置按钮标题的字体
    /// - Parameter font: 要应用的字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.titleLabel?.font = font
        return self
    }

    /// 设置按钮在指定状态下的前景图片
    /// - Parameters:
    ///   - image: 图片对象,可为 `nil` 清除图片
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的背景图片
    /// - Parameters:
    ///   - image: 背景图片,可为 `nil` 清除背景
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的纯色背景(通过生成纯色图片实现)
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(color: color)
        base.setBackgroundImage(image, for: state)
        return self
    }
}

// MARK: - 方法(自定义)
public extension DyWrapper where Base: UIButton {
    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: `Self`
    @discardableResult
    func expandClickArea(_ size: CGFloat = 10) -> Self {
        base.dy_setAssociatedObject(size, forKey: &UIButton.Keys.dy_expandSizeKey)
        return self
    }

    /// 设置图片方向
    /// - Parameters:
    ///   - direction: 图片方向
    ///   - spacing: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func layoutImage(direction: NSDirectionalRectEdge, spacing: CGFloat) -> Self {
        var config = base.configuration ?? UIButton.Configuration.plain()
        switch direction {
        case .top:
            config.imagePlacement = .top
            config.imagePadding = spacing
        case .bottom:
            config.imagePlacement = .bottom
            config.imagePadding = spacing
        case .leading:
            config.imagePlacement = .leading
            config.imagePadding = spacing
        case .trailing:
            config.imagePlacement = .trailing
            config.imagePadding = spacing
        default:
            break
        }
        base.configuration = config
        return self
    }
}
