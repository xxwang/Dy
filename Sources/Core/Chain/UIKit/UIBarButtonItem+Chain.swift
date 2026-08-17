import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: UIBarButtonItem {
    /// 设置按钮的显示样式(如 `.plain`、`.done` 等)
    ///
    /// - Parameter style: 指定按钮的视觉样式
    /// - Returns: `Self`
    @discardableResult
    func style(_ style: UIBarButtonItem.Style) -> Self {
        base.style = style
        return self
    }

    /// 设置按钮是否可交互(启用/禁用状态)
    ///
    /// - Parameter isEnabled: `true` 表示启用,`false` 表示禁用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isEnabled = isEnabled
        return self
    }

    /// 设置自定义视图(如 `UILabel`、`UIButton` 等)作为按钮内容
    /// - Parameter customView: 要作为按钮内容的自定义视图
    /// - Returns: `Self`
    @discardableResult
    func customView(_ customView: UIView?) -> Self {
        base.customView = customView
        return self
    }

    /// 设置按钮的文本标题
    ///
    /// - Parameter title: 要显示的字符串标题,可为 `nil` 以移除标题
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 设置按钮的图标图像
    ///
    /// - Parameter image: 要显示的图像,可为 `nil` 以移除图像
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 设置按钮在指定状态下的背景图像(适用于系统样式的按钮)
    ///
    /// - Parameters:
    ///   - backgroundImage: 背景图像,可为 `nil` 以清除
    ///   - state: 控件状态(如 `.normal`, `.highlighted`)
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State) -> Self {
        base.setBackgroundImage(backgroundImage, for: state, barMetrics: .default)
        return self
    }

    /// 设置按钮的宽度(仅在非自定义视图模式下有效)
    ///
    /// - Parameter width: 按钮的固定宽度(单位：点)
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        base.width = width
        return self
    }

    /// 设置按钮点击事件的目标对象(通常为 ViewController 或其他响应者)
    ///
    /// - Parameter target: 接收点击事件的对象,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func target(_ target: AnyObject?) -> Self {
        base.target = target
        return self
    }

    /// 设置按钮点击事件的响应方法(`Selector`)
    ///
    /// - Parameter action: 方法选择器(如 `#selector(doSomething)`),可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func action(_ action: Selector?) -> Self {
        base.action = action
        return self
    }

    /// 同时设置目标对象和响应方法(常用快捷方式)
    ///
    /// - Parameters:
    ///   - target: 事件接收者
    ///   - action: 对应的 `Selector`
    /// - Returns: `Self`
    @discardableResult
    func addTarget(_ target: AnyObject, action: Selector) -> Self {
        base.target = target
        base.action = action
        return self
    }

    /// 预声明按钮可能使用的标题集合(用于布局优化,尤其在动态切换标题时)
    ///
    /// - Parameter possibleTitles: 所有可能出现的标题字符串集合,可为 `nil`
    /// - Returns: `Self`
    @discardableResult
    func possibleTitles(_ possibleTitles: Set<String>?) -> Self {
        base.possibleTitles = possibleTitles
        return self
    }
}

// MARK: - 链式方法
public extension SoloWrapper where Base: UIBarButtonItem {
    /// 设置按钮图标的渲染模式(例如保持原始颜色或使用模板色)
    ///
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    @discardableResult
    func imageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentImage = base.image {
            base.image = currentImage.withRenderingMode(renderingMode)
        }
        return self
    }

    /// 设置按钮背景图像的渲染模式
    /// - Note: 仅对 `.normal` 状态 + `.default` 样式下的背景图生效
    /// - Parameter renderingMode: 渲染模式(如 `.alwaysOriginal`, `.alwaysTemplate`)
    /// - Returns: `Self`
    @discardableResult
    func backgroundImageRenderingMode(_ renderingMode: UIImage.RenderingMode) -> Self {
        if let currentBackground = base.backgroundImage(for: .normal, barMetrics: .default) {
            let renderedImage = currentBackground.withRenderingMode(renderingMode)
            base.setBackgroundImage(renderedImage, for: .normal, barMetrics: .default)
        }
        return self
    }
}
