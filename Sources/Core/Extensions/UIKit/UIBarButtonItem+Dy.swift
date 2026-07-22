import UIKit

// MARK: - 构造方法
public extension UIBarButtonItem {
    /// 创建一个具有固定宽度的空白占位按钮
    ///
    /// - Note:
    ///     虽然名称含 "`flexible`",但此实现为`固定宽度`,与系统 `.flexibleSpace` 不同
    ///     若需真正的弹性空间,请直接使用 `.init(barButtonSystemItem: .flexibleSpace, ...)`
    /// - Parameter width: 指定的固定宽度(单位：点)
    convenience init(fixedSpace width: CGFloat) {
        self.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        self.width = width
    }
}

// MARK: - 链式设置属性
public extension UIBarButtonItem {
    /// 设置按钮的显示样式(如 `.plain`、`.done` 等)
    ///
    /// - Parameter style: 指定按钮的视觉样式
    /// - Returns: `Self`
    @discardableResult
    func dy_style(_ style: UIBarButtonItem.Style) -> Self {
        self.style = style
        return self
    }

    /// 设置按钮是否可交互(启用/禁用状态)
    ///
    /// - Parameter isEnabled: `true` 表示启用,`false` 表示禁用
    /// - Returns: `Self`
    @discardableResult
    func dy_isEnabled(_ isEnabled: Bool) -> Self {
        self.isEnabled = isEnabled
        return self
    }

    /// 设置自定义视图(如 `UILabel`、`UIButton` 等)作为按钮内容
    /// - Parameter customView: 要作为按钮内容的自定义视图
    /// - Returns: `Self`
    @discardableResult
    func dy_customView(_ customView: UIView?) -> Self {
        self.customView = customView
        return self
    }

    /// 设置按钮的文本标题
    ///
    /// - Parameter title: 要显示的字符串标题,可为 `nil` 以移除标题
    /// - Returns: `Self`
    @discardableResult
    func dy_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置按钮的图标图像
    ///
    /// - Parameter image: 要显示的图像,可为 `nil` 以移除图像
    /// - Returns: `Self`
    @discardableResult
    func dy_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置按钮在指定状态下的背景图像(适用于系统样式的按钮)
    ///
    /// - Parameters:
    ///   - backgroundImage: 背景图像,可为 `nil` 以清除
    ///   - state: 控件状态(如 `.normal`, `.highlighted`)
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) -> Self {
        self.setBackgroundImage(backgroundImage, for: state, barMetrics: .default)
        return self
    }

    /// 设置按钮的宽度(仅在非自定义视图模式下有效)
    ///
    /// - Parameter width: 按钮的固定宽度(单位：点)
    /// - Returns: `Self`
    @discardableResult
    func dy_width(_ width: CGFloat) -> Self {
        self.width = width
        return self
    }

    /// 设置按钮点击事件的目标对象(通常为 ViewController 或其他响应者)
    ///
    /// - Parameter target: 接收点击事件的对象,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func dy_target(_ target: AnyObject?) -> Self {
        self.target = target
        return self
    }

    /// 设置按钮点击事件的响应方法(`Selector`)
    ///
    /// - Parameter action: 方法选择器(如 `#selector(doSomething)`),可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func dy_action(_ action: Selector?) -> Self {
        self.action = action
        return self
    }

    /// 同时设置目标对象和响应方法(常用快捷方式)
    ///
    /// - Parameters:
    ///   - target: 事件接收者
    ///   - action: 对应的 `Selector`
    /// - Returns: `Self`
    @discardableResult
    func dy_addTarget(_ target: AnyObject, action: Selector) -> Self {
        self.target = target
        self.action = action
        return self
    }

    /// 预声明按钮可能使用的标题集合(用于布局优化,尤其在动态切换标题时)
    ///
    /// - Parameter possibleTitles: 所有可能出现的标题字符串集合,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func dy_possibleTitles(_ possibleTitles: Set<String>?) -> Self {
        self.possibleTitles = possibleTitles
        return self
    }
}

// MARK: - 链式方法
public extension UIBarButtonItem {
    /// 设置按钮图标的渲染模式(例如保持原始颜色或使用模板色)
    ///
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    @discardableResult
    func dy_imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentImage = self.image {
            self.image = currentImage.withRenderingMode(renderingMode)
        }
        return self
    }

    /// 设置按钮背景图像的渲染模式
    /// - Note: 仅对 `.normal` 状态 + `.default` 样式下的背景图生效
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundImageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentBackground = self.backgroundImage(for: .normal, barMetrics: .default) {
            let renderedImage = currentBackground.withRenderingMode(renderingMode)
            self.setBackgroundImage(renderedImage, for: .normal, barMetrics: .default)
        }
        return self
    }
}
