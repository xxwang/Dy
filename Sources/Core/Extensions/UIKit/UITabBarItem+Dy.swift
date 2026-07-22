import UIKit

// MARK: - 链式设置属性
public extension UITabBarItem {
    /// 设置标题
    /// - Parameter title: 标题文本
    /// - Returns: `Self`
    @discardableResult
    func dy_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置按钮标题的文本属性
    /// - Parameters:
    ///   - attributes: 文本属性字典,如字体、颜色等
    ///   - state: 控件状态,如 `.normal`、`.highlighted` 等
    /// - Returns: `Self`
    @discardableResult
    func dy_titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 设置默认图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func dy_image(_ image: UIImage?) -> Self {
        if let img = image {
            self.image = img.withRenderingMode(.alwaysOriginal)
        } else {
            self.image = nil
        }
        return self
    }

    /// 设置选中图片
    /// - Parameter image: 图片
    /// - Returns: `Self`
    @discardableResult
    func dy_selectedImage(_ image: UIImage?) -> Self {
        if let img = image {
            self.selectedImage = img.withRenderingMode(.alwaysOriginal)
        } else {
            self.selectedImage = nil
        }
        return self
    }

    /// 设置图片的内边距
    /// - Parameter imageInsets: 图片的内边距
    /// - Returns: `Self`
    @discardableResult
    func dy_imageInsets(_ imageInsets: UIEdgeInsets) -> Self {
        self.imageInsets = imageInsets
        return self
    }

    /// 设置标题的位置调整
    /// - Parameter titleOffset: 标题相对于默认位置的偏移量
    /// - Returns: `Self`
    @discardableResult
    func dy_titlePositionAdjustment(_ titleOffset: UIOffset) -> Self {
        self.titlePositionAdjustment = titleOffset
        return self
    }

    /// 设置 `badgeColor` 颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_badgeColor(_ color: UIColor?) -> Self {
        self.badgeColor = color
        return self
    }

    /// 设置 `badgeValue` 值
    /// - Parameter value: 值
    /// - Returns: `Self`
    @discardableResult
    func dy_badgeValue(_ value: String?) -> Self {
        self.badgeValue = value
        return self
    }
}

// MARK: - 链式方法
public extension UITabBarItem {
    /// 设置`Badge`文本属性
    /// - Parameters:
    ///   - textAttributes: 文本属性字典(如字体、颜色等)
    ///   - state: 控制状态(如 `.normal` 或 `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func dy_badgeTextAttributes(_ textAttributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        self.setBadgeTextAttributes(textAttributes, for: state)
        return self
    }

    /// 设置图标的渲染模式
    /// - Parameter renderingMode: 渲染模式(默认使用 `.alwaysOriginal`)
    /// - Returns: `Self`
    @discardableResult
    func dy_imageRenderingMode(_ renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> Self {
        if let image = self.image {
            self.image = image.withRenderingMode(renderingMode)
        }
        if let selectedImage = self.selectedImage {
            self.selectedImage = selectedImage.withRenderingMode(renderingMode)
        }
        return self
    }
}
