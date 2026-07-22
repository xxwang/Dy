import UIKit

// MARK: - 链式设置属性
public extension UIPageControl {
    /// 设置当前选中指示器的颜色
    ///
    /// - Parameter color: 当前页指示器的颜色,传入 `nil` 将恢复默认颜色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_currentPageIndicatorTintColor(_ color: UIColor?) -> Self {
        self.currentPageIndicatorTintColor = color
        return self
    }

    /// 设置未选中状态下的指示器颜色
    ///
    /// - Parameter color: 未选中指示器的颜色,传入 `nil` 将恢复默认颜色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_pageIndicatorTintColor(_ color: UIColor?) -> Self {
        self.pageIndicatorTintColor = color
        return self
    }

    /// 设置当只有一页时是否隐藏分页指示器
    ///
    /// - Parameter isHidden: 是否隐藏分页指示器
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_hidesForSinglePage(_ isHidden: Bool) -> Self {
        self.hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    ///
    /// - Parameter current: 当前页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_currentPage(_ current: Int) -> Self {
        self.currentPage = current
        return self
    }

    /// 设置总页数
    ///
    /// - Parameter count: 总页数
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_numberOfPages(_ count: Int) -> Self {
        self.numberOfPages = count
        return self
    }

    /// 设置分页控制的背景样式
    ///
    /// - Parameter style: 背景样式
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 14.0, *)
    @discardableResult
    func dy_backgroundStyle(_ style: UIPageControl.BackgroundStyle) -> Self {
        self.backgroundStyle = style
        return self
    }

    /// 设置是否允许连续交互
    ///
    /// - Parameter allows: 是否允许连续交互
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 14.0, *)
    @discardableResult
    func dy_allowsContinuousInteraction(_ allows: Bool) -> Self {
        self.allowsContinuousInteraction = allows
        return self
    }

    /// 设置指示器的首选图像
    ///
    /// - Parameter image: 图像,传入 `nil` 清除图像设置
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 14.0, *)
    @discardableResult
    func dy_preferredIndicatorImage(_ image: UIImage?) -> Self {
        self.preferredIndicatorImage = image
        return self
    }

    /// 设置分页控制的方向
    ///
    /// - Parameter direction: 分页控件的布局方向
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 16.0, *)
    @discardableResult
    func dy_direction(_ direction: UIPageControl.Direction) -> Self {
        self.direction = direction
        return self
    }

    /// 设置当前页指示器的首选图像
    ///
    /// - Parameter image: 当前页指示器图像,传入 `nil` 清除图像设置
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 16.0, *)
    @discardableResult
    func dy_preferredCurrentPageIndicatorImage(_ image: UIImage?) -> Self {
        self.preferredCurrentPageIndicatorImage = image
        return self
    }
}

// MARK: - 链式方法
public extension UIPageControl {
    /// 设置某一页的自定义指示器图像
    ///
    /// - Parameters:
    ///   - image: 指示器图像,传入 `nil` 清除图像设置
    ///   - page: 页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 14.0, *)
    @discardableResult
    func dy_indicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        guard (0 ..< self.numberOfPages).contains(page) else { return self }
        self.setIndicatorImage(image, forPage: page)
        return self
    }

    /// 设置某一页的自定义当前页指示器图像
    ///
    /// - Parameters:
    ///   - image: 当前页指示器图像,传入 `nil` 清除图像设置
    ///   - page: 页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 16.0, *)
    @discardableResult
    func dy_currentPageIndicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        guard (0 ..< self.numberOfPages).contains(page) else { return self }
        self.setCurrentPageIndicatorImage(image, forPage: page)
        return self
    }
}
