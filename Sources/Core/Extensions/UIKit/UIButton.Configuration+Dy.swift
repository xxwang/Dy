import UIKit

// MARK: - 链式设置属性
@available(iOS 15.0, *)
public extension UIButton.Configuration {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_title(_ title: String) -> Self {
        var configuration = self
        configuration.title = title
        self = configuration
        return self
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_subtitle(_ subtitle: String) -> Self {
        var configuration = self
        configuration.subtitle = subtitle
        self = configuration
        return self
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        var configuration = self
        configuration.image = image
        configuration.imagePlacement = placement
        self = configuration
        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_backgroundImage(_ backgroundImage: UIImage?) -> Self {
        var configuration = self
        configuration.background.image = backgroundImage
        self = configuration
        return self
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_isLoading(_ loading: Bool) -> Self {
        var configuration = self
        configuration.showsActivityIndicator = loading
        self = configuration
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_imagePadding(_ padding: CGFloat) -> Self {
        var configuration = self
        configuration.imagePadding = padding
        self = configuration
        return self
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_titlePadding(_ padding: CGFloat) -> Self {
        var configuration = self
        configuration.titlePadding = padding
        self = configuration
        return self
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_baseBackgroundColor(_ color: UIColor?) -> Self {
        var configuration = self
        configuration.baseBackgroundColor = color
        self = configuration
        return self
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @discardableResult
    mutating func dy_baseForegroundColor(_ color: UIColor?) -> Self {
        var configuration = self
        configuration.baseForegroundColor = color
        self = configuration
        return self
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @discardableResult
    mutating func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        var configuration = self
        configuration.attributedTitle = attributedTitle
        self = configuration
        return self
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @discardableResult
    mutating func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        var configuration = self
        configuration.attributedSubtitle = attributedSubtitle
        self = configuration
        return self
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @discardableResult
    mutating func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        var configuration = self
        configuration.imagePlacement = imagePlacement
        self = configuration
        return self
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @discardableResult
    mutating func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        var configuration = self
        configuration.contentInsets = contentInsets
        self = configuration
        return self
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @discardableResult
    mutating func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        var configuration = self
        configuration.cornerStyle = cornerStyle
        self = configuration
        return self
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    mutating func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        var configuration = self
        configuration.background.strokeColor = strokeColor
        self = configuration
        return self
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    mutating func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        var configuration = self
        configuration.background.strokeWidth = strokeWidth
        self = configuration
        return self
    }
}
