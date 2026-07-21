import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIPageControl {
    /// 设置当前选中指示器的颜色
    ///
    /// - Parameter color: 当前页指示器的颜色,传入 `nil` 将恢复默认颜色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func currentPageIndicatorTintColor(_ color: UIColor?) -> Self {
        base.currentPageIndicatorTintColor = color
        return self
    }

    /// 设置未选中状态下的指示器颜色
    ///
    /// - Parameter color: 未选中指示器的颜色,传入 `nil` 将恢复默认颜色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func pageIndicatorTintColor(_ color: UIColor?) -> Self {
        base.pageIndicatorTintColor = color
        return self
    }

    /// 设置当只有一页时是否隐藏分页指示器
    ///
    /// - Parameter isHidden: 是否隐藏分页指示器
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func hidesForSinglePage(_ isHidden: Bool) -> Self {
        base.hidesForSinglePage = isHidden
        return self
    }

    /// 设置当前页码
    ///
    /// - Parameter current: 当前页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func currentPage(_ current: Int) -> Self {
        base.currentPage = current
        return self
    }

    /// 设置总页数
    ///
    /// - Parameter count: 总页数
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func numberOfPages(_ count: Int) -> Self {
        base.numberOfPages = count
        return self
    }

    /// 设置分页控制的背景样式
    ///
    /// - Parameter style: 背景样式
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func backgroundStyle(_ style: UIPageControl.BackgroundStyle) -> Self {
        base.backgroundStyle = style
        return self
    }

    /// 设置是否允许连续交互
    ///
    /// - Parameter allows: 是否允许连续交互
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func allowsContinuousInteraction(_ allows: Bool) -> Self {
        base.allowsContinuousInteraction = allows
        return self
    }

    /// 设置指示器的首选图像
    ///
    /// - Parameter image: 图像,传入 `nil` 清除图像设置
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func preferredIndicatorImage(_ image: UIImage?) -> Self {
        base.preferredIndicatorImage = image
        return self
    }

    /// 设置分页控制的方向
    ///
    /// - Parameter direction: 分页控件的布局方向
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 16.0, *)
    @discardableResult
    func direction(_ direction: UIPageControl.Direction) -> Self {
        base.direction = direction
        return self
    }

    /// 设置当前页指示器的首选图像
    ///
    /// - Parameter image: 当前页指示器图像,传入 `nil` 清除图像设置
    /// - Returns: 当前实例(支持链式调用)
    @available(iOS 16.0, *)
    @discardableResult
    func preferredCurrentPageIndicatorImage(_ image: UIImage?) -> Self {
        base.preferredCurrentPageIndicatorImage = image
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UIPageControl {
    /// 设置某一页的自定义指示器图像
    ///
    /// - Parameters:
    ///   - image: 指示器图像,传入 `nil` 清除图像设置
    ///   - page: 页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func indicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        guard (0 ..< base.numberOfPages).contains(page) else { return self }
        base.setIndicatorImage(image, forPage: page)
        return self
    }

    /// 设置某一页的自定义当前页指示器图像
    ///
    /// - Parameters:
    ///   - image: 当前页指示器图像,传入 `nil` 清除图像设置
    ///   - page: 页码,必须在 `[0, numberOfPages - 1]` 范围内
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func currentPageIndicatorImage(_ image: UIImage?, forPage page: Int) -> Self {
        guard (0 ..< base.numberOfPages).contains(page) else { return self }
        base.setCurrentPageIndicatorImage(image, forPage: page)
        return self
    }
}
