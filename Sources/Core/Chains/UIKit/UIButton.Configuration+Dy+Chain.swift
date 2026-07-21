import UIKit

@available(iOS 15.0, *)
extension UIButton.Configuration: DyExtension {}

// MARK: - 属性
@available(iOS 15.0, *)
public extension DyWrapper where Base == UIButton.Configuration {
    /// 设置按钮在指定状态下的普通文本标题
    /// - Parameters:
    ///   - title: 标题字符串
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String) -> Self {
        var configuration = self.base
        configuration.title = title
        self.base = configuration
        return self
    }

    /// 设置按钮副标题
    /// - Parameter subtitle: 副标题
    /// - Returns: `Self`
    @discardableResult
    func subtitle(_ subtitle: String) -> Self {
        var configuration = self.base
        configuration.subtitle = subtitle
        self.base = configuration
        return self
    }

    /// 设置图标
    /// - Parameters:
    ///   - image: 图标
    ///   - placement: 位置
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?, placement: NSDirectionalRectEdge = .leading) -> Self {
        var configuration = self.base
        configuration.image = image
        configuration.imagePlacement = placement
        self.base = configuration
        return self
    }

    /// 设置背景图片
    /// - Parameter backgroundImage: 背景图片
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?) -> Self {
        var configuration = self.base
        configuration.background.image = backgroundImage
        self.base = configuration
        return self
    }

    /// 设置加载状态(自动禁用交互 + 显示指示器)
    /// - Parameter loading: 是否加载
    /// - Returns: `Self`
    @discardableResult
    func isLoading(_ loading: Bool) -> Self {
        var configuration = self.base
        configuration.showsActivityIndicator = loading
        self.base = configuration
        return self
    }

    /// 设置图标间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func imagePadding(_ padding: CGFloat) -> Self {
        var configuration = self.base
        configuration.imagePadding = padding
        self.base = configuration
        return self
    }

    /// 设置标题间距
    /// - Parameter padding: 间距
    /// - Returns: `Self`
    @discardableResult
    func titlePadding(_ padding: CGFloat) -> Self {
        var configuration = self.base
        configuration.titlePadding = padding
        self.base = configuration
        return self
    }

    /// 设置主背景色(仅对 .filled / .tinted 有效)
    /// - Parameter color: 背景色
    /// - Returns: `Self`
    func baseBackgroundColor(_ color: UIColor?) -> Self {
        var configuration = self.base
        configuration.baseBackgroundColor = color
        self.base = configuration
        return self
    }

    /// 设置主前景色(文字/图标颜色(前景色))
    /// - Parameter color: 前景色
    /// - Returns: `Self`
    func baseForegroundColor(_ color: UIColor?) -> Self {
        var configuration = self.base
        configuration.baseForegroundColor = color
        self.base = configuration
        return self
    }

    /// 设置属性标题
    /// - Parameter attributedTitle: 属性标题
    /// - Returns: `Self`
    func attributedTitle(_ attributedTitle: AttributedString?) -> Self {
        var configuration = self.base
        configuration.attributedTitle = attributedTitle
        self.base = configuration
        return self
    }

    /// 设置属性副标题
    /// - Parameter attributedSubtitle: 属性副标题
    /// - Returns: `Self`
    func attributedSubtitle(_ attributedSubtitle: AttributedString?) -> Self {
        var configuration = self.base
        configuration.attributedSubtitle = attributedSubtitle
        self.base = configuration
        return self
    }

    /// 设置图标位置
    /// - Parameter imagePlacement: 图标位置
    /// - Returns: `Self`
    func imagePlacement(_ imagePlacement: NSDirectionalRectEdge) -> Self {
        var configuration = self.base
        configuration.imagePlacement = imagePlacement
        self.base = configuration
        return self
    }

    /// 设置内容与边缘间距
    /// - Parameter contentInsets: 间距
    /// - Returns: `Self`
    func contentInsets(_ contentInsets: NSDirectionalEdgeInsets) -> Self {
        var configuration = self.base
        configuration.contentInsets = contentInsets
        self.base = configuration
        return self
    }

    /// 设置圆角风格
    /// - Parameter cornerStyle: 圆角样式
    /// - Returns: `Self`
    func cornerStyle(_ cornerStyle: UIButton.Configuration.CornerStyle) -> Self {
        var configuration = self.base
        configuration.cornerStyle = cornerStyle
        self.base = configuration
        return self
    }

    /// 设置边框颜色
    /// - Parameter strokeColor: 边框颜色
    /// - Returns: `Self`
    func backgroundStrokeColor(_ strokeColor: UIColor?) -> Self {
        var configuration = self.base
        configuration.background.strokeColor = strokeColor
        self.base = configuration
        return self
    }

    /// 设置边框宽度
    /// - Parameter strokeWidth: 边框宽度
    /// - Returns: `Self`
    func backgroundStrokeWidth(_ strokeWidth: CGFloat) -> Self {
        var configuration = self.base
        configuration.background.strokeWidth = strokeWidth
        self.base = configuration
        return self
    }
}
