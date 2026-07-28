import UIKit

// MARK: - 属性
public extension UIButton {
    /// 按钮的常用状态
    var dy_allStates: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下按钮标题的`CGSize`
    /// - Parameter maxWidth: 最大行宽度
    /// - Returns: 标题的`size`
    func dy_size(maxWidth: CGFloat? = nil) -> CGSize {
        let maxWidth = maxWidth ?? DyScreen.screenWidth
        return if let currentAttributedTitle = self.currentAttributedTitle {
            currentAttributedTitle.dy_size(maxWidth: maxWidth)
        } else {
            self.titleLabel?.dy_size(maxWidth: maxWidth) ?? .zero
        }
    }
}

// MARK: - 扩大按钮点击区域
extension UIButton {
    /// 关联属性键(使用稳定内存地址作为 key)
    private enum Keys {
        /// 扩展点击区域大小
        static var dy_expandSizeKey: UInt8 = 0
    }

    /// 重写点触及范围检测
    /// - Parameter point: 当前触摸点的坐标
    /// - Parameter event: 当前的触摸事件
    /// - Returns: 如果触摸点在扩展的区域内,则返回 `true`,否则返回 `false`
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expandedRect = self.dy_expandedRect()
        // 如果没有扩展范围,则使用原始范围
        if expandedRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return expandedRect.contains(point)
        }
    }

    /// 获取扩展的点击区域,如果没有设置扩展范围,则使用按钮的原始大小
    func dy_expandedRect() -> CGRect {
        if let expandSize: CGFloat = self.dy_getAssociatedObject(forKey: &Keys.dy_expandSizeKey) {
            return CGRect(
                x: bounds.origin.x - expandSize,
                y: bounds.origin.y - expandSize,
                width: bounds.size.width + 2 * expandSize,
                height: bounds.size.height + 2 * expandSize
            )
        }
        return self.bounds
    }
}

// MARK: - 链式设置属性(UIButton.Configuration)
public extension UIButton {
    /// 设置按钮的 `UIButton.Configuration`
    /// - Parameter configuration: 按钮的新配置对象
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_configuration(_ configuration: UIButton.Configuration?) -> Self {
        self.configuration = configuration
        return self
    }

    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_titleC(_ title: String) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.title = title
        self.configuration = configuration
        return self
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_attributedTitleC(_ attributedTitle: AttributedString?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.attributedTitle = attributedTitle
        self.configuration = configuration
        return self
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_subtitle(_ subtitle: String) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.subtitle = subtitle
        self.configuration = configuration
        return self
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.attributedSubtitle = attributedSubtitle
        self.configuration = configuration
        return self
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_imageC(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.image = image
        configuration.imagePlacement = placement
        self.configuration = configuration
        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_backgroundImageC(_ backgroundImage: UIImage?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.background.image = backgroundImage
        self.configuration = configuration
        return self
    }

    /// 添加一个`UIAction`
    /// - Parameters:
    ///   - action: `UIAction`中实际执行的闭包代码
    ///   - controlEvents: 事件类型
    /// - Returns: `Self`
    @available(iOS 14.0, *)
    @discardableResult
    func dy_addAction(_ action: @escaping DyAction1<UIAction>, for controlEvents: UIControl.Event = .touchUpInside) -> Self {
        let action = UIAction { a in
            action(a)
        }
        self.removeAction(action, for: controlEvents)
        self.addAction(action, for: controlEvents)
        return self
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_isLoading(_ loading: Bool) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.showsActivityIndicator = loading
        self.configuration = configuration
        self.isUserInteractionEnabled = !loading
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_imagePadding(_ padding: CGFloat) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.imagePadding = padding
        self.configuration = configuration
        return self
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_titlePadding(_ padding: CGFloat) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.titlePadding = padding
        self.configuration = configuration
        return self
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_baseBackgroundColor(_ color: UIColor?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.baseBackgroundColor = color
        self.configuration = configuration
        return self
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_baseForegroundColor(_ color: UIColor?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.baseForegroundColor = color
        self.configuration = configuration
        return self
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.imagePlacement = imagePlacement
        self.configuration = configuration
        return self
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.contentInsets = contentInsets
        self.configuration = configuration
        return self
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.cornerStyle = cornerStyle
        self.configuration = configuration
        return self
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.background.strokeColor = strokeColor
        self.configuration = configuration
        return self
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    func dy_backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        var configuration = self.configuration ?? UIButton.Configuration.plain()
        configuration.background.strokeWidth = strokeWidth
        self.configuration = configuration
        return self
    }
}

// MARK: - 链式方法
public extension UIButton {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_title(_ title: String, for state: UIControl.State = .normal) -> Self {
        self.setTitle(title, for: state)
        return self
    }

    /// 设置按钮在指定状态下的富文本标题
    /// - Parameters:
    ///   - attributedTitle: 富文本对象,可为 `nil` 清除标题
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_attributedTitle(_ attributedTitle: NSAttributedString?, for state: UIControl.State = .normal) -> Self {
        self.setAttributedTitle(attributedTitle, for: state)
        return self
    }

    /// 设置按钮在指定状态下的标题颜色
    /// - Parameters:
    ///   - color: 标题颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_titleColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        self.setTitleColor(color, for: state)
        return self
    }

    /// 设置按钮标题的字体
    /// - Parameter font: 要应用的字体
    /// - Returns: `Self`
    @discardableResult
    func dy_font(_ font: UIFont) -> Self {
        self.titleLabel?.font = font
        return self
    }

    /// 设置按钮在指定状态下的前景图片
    /// - Parameters:
    ///   - image: 图片对象,可为 `nil` 清除图片
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的背景图片
    /// - Parameters:
    ///   - image: 背景图片,可为 `nil` 清除背景
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.setBackgroundImage(image, for: state)
        return self
    }

    /// 设置按钮在指定状态下的纯色背景(通过生成纯色图片实现)
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - state: 按钮状态,默认为 `.normal`
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundColor(_ color: UIColor, for state: UIControl.State = .normal) -> Self {
        let image = UIImage(color: color)
        self.setBackgroundImage(image, for: state)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIButton {
    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: `Self`
    @discardableResult
    func dy_expandClickArea(_ size: CGFloat = 10) -> Self {
        self.dy_setAssociatedObject(size, forKey: &UIButton.Keys.dy_expandSizeKey)
        return self
    }

    /// 设置图片方向
    /// - Parameters:
    ///   - direction: 图片方向
    ///   - spacing: 间距
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_layoutImage(direction: NSDirectionalRectEdge, spacing: CGFloat) -> Self {
        var config = self.configuration ?? UIButton.Configuration.plain()
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
        self.configuration = config
        return self
    }
}
