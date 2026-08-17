import UIKit

// MARK: - 链式设置属性
@available(iOS 15.0, *)
public extension SoloWrapper where Base == UIButton.Configuration {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        var configuration = base
        configuration.title = title
        base = configuration
        return self
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    func subtitle(_ subtitle: String) -> Self {
        var configuration = base
        configuration.subtitle = subtitle
        base = configuration
        return self
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        var configuration = base
        configuration.image = image
        configuration.imagePlacement = placement
        base = configuration
        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        var configuration = base
        configuration.background.image = backgroundImage
        base = configuration
        return self
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    func isLoading(_ loading: Bool) -> Self {
        var configuration = base
        configuration.showsActivityIndicator = loading
        base = configuration
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Self {
        var configuration = base
        configuration.imagePadding = padding
        base = configuration
        return self
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func titlePadding(_ padding: CGFloat) -> Self {
        var configuration = base
        configuration.titlePadding = padding
        base = configuration
        return self
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    @discardableResult
    func baseBackgroundColor(_ color: UIColor?) -> Self {
        var configuration = base
        configuration.baseBackgroundColor = color
        base = configuration
        return self
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    @discardableResult
    func baseForegroundColor(_ color: UIColor?) -> Self {
        var configuration = base
        configuration.baseForegroundColor = color
        base = configuration
        return self
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    @discardableResult
    func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        var configuration = base
        configuration.attributedTitle = attributedTitle
        base = configuration
        return self
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    @discardableResult
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        var configuration = base
        configuration.attributedSubtitle = attributedSubtitle
        base = configuration
        return self
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    @discardableResult
    func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        var configuration = base
        configuration.imagePlacement = imagePlacement
        base = configuration
        return self
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    @discardableResult
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        var configuration = base
        configuration.contentInsets = contentInsets
        base = configuration
        return self
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    @discardableResult
    func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        var configuration = base
        configuration.cornerStyle = cornerStyle
        base = configuration
        return self
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        var configuration = base
        configuration.background.strokeColor = strokeColor
        base = configuration
        return self
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        var configuration = base
        configuration.background.strokeWidth = strokeWidth
        base = configuration
        return self
    }
}
