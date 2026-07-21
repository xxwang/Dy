import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIScrollView {
    /// 设置滚动视图的代理
    ///
    /// - Parameter delegate: 遵循 `UIScrollViewDelegate` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置内容偏移量(`contentOffset`),自动限制在有效范围内
    ///
    /// - Parameter offset: 目标偏移点即使传入超出范围的值,也会被裁剪至合法区间：
    ///   - 最小 X：`-contentInset.left`
    ///   - 最大 X：`contentSize.width + contentInset.right`
    ///   - 最小 Y：`-contentInset.top`
    ///   - 最大 Y：`contentSize.height + contentInset.bottom`
    /// - Returns: `Self`
    @discardableResult
    func contentOffset(_ offset: CGPoint) -> Self {
        let clampedX = min(
            max(offset.x, -base.contentInset.left),
            base.contentSize.width + base.contentInset.right
        )
        let clampedY = min(
            max(offset.y, -base.contentInset.top),
            base.contentSize.height + base.contentInset.bottom
        )
        base.contentOffset = CGPoint(x: clampedX, y: clampedY)
        return self
    }

    /// 设置可滚动内容区域的大小(`contentSize`)
    ///
    /// - Parameter size: 内容区域尺寸宽度和高度将被限制为 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func contentSize(_ size: CGSize) -> Self {
        let validSize = CGSize(
            width: max(size.width, 0),
            height: max(size.height, 0)
        )
        base.contentSize = validSize
        return self
    }

    /// 设置内容内边距(`contentInset`),控制内容与滚动视图边缘的距离
    ///
    /// - Parameter inset: 内边距常用于避开导航栏、TabBar 等
    /// - Returns: `Self`
    ///
    /// - Note: 此设置需配合有效的 `contentSize` 才能体现滚动效果
    @discardableResult
    func contentInset(_ inset: UIEdgeInsets) -> Self {
        base.contentInset = inset
        return self
    }

    /// 启用或禁用弹性回弹效果(`bounces`)
    ///
    /// - Parameter bounces: `true` 表示滑动到边缘时有弹性回弹;`false` 则无
    /// - Returns: `Self`
    @discardableResult
    func bounces(_ bounces: Bool) -> Self {
        base.bounces = bounces
        return self
    }

    /// 是否始终启用水平方向的弹性效果(即使内容未超出视图宽度)
    ///
    /// - Parameter bounces: `true` 表示总是可以水平弹性滑动
    /// - Returns: `Self`
    @discardableResult
    func alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        base.alwaysBounceHorizontal = bounces
        return self
    }

    /// 是否始终启用垂直方向的弹性效果(即使内容未超出视图高度)
    ///
    /// - Parameter bounces: `true` 表示总是可以垂直弹性滑动
    /// - Returns: `Self`
    @discardableResult
    func alwaysBounceVertical(_ bounces: Bool) -> Self {
        base.alwaysBounceVertical = bounces
        return self
    }

    /// 启用或禁用分页滚动(`isPagingEnabled`)
    ///
    /// - Parameter enabled: `true` 表示每次滑动停靠在整页位置(如轮播图)
    /// - Returns: `Self`
    @discardableResult
    func isPagingEnabled(_ enabled: Bool) -> Self {
        base.isPagingEnabled = enabled
        return self
    }

    /// 控制是否显示水平滚动条
    ///
    /// - Parameter enabled: `true` 显示,`false` 隐藏
    /// - Returns: `Self`
    @discardableResult
    func showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        base.showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 控制是否显示垂直滚动条
    ///
    /// - Parameter enabled: `true` 显示,`false` 隐藏
    /// - Returns: `Self`
    @discardableResult
    func showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        base.showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滚动条的内边距(`scrollIndicatorInsets`)
    ///
    /// - Parameter inset: 滚动条距离滚动视图四边的距离
    /// - Returns: `Self`
    @discardableResult
    func scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        base.scrollIndicatorInsets = inset
        return self
    }

    /// 启用或禁用用户滚动交互
    ///
    /// - Parameter enabled: `true` 允许滚动,`false` 禁止
    /// - Returns: `Self`
    @discardableResult
    func isScrollEnabled(_ enabled: Bool) -> Self {
        base.isScrollEnabled = enabled
        return self
    }

    /// 设置滚动条样式(颜色和外观)
    ///
    /// - Parameter style: 如 `.default`, `.black`, `.white`
    /// - Returns: `Self`
    @discardableResult
    func indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        base.indicatorStyle = style
        return self
    }

    /// 设置减速率(松手后滚动停止的速度)
    ///
    /// - Parameter rate: 系统预设值如 `.normal` 或 `.fast`
    /// - Returns: `Self`
    @discardableResult
    func decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        base.decelerationRate = rate
        return self
    }

    /// 启用方向锁定(拖拽时仅沿一个方向滚动)
    ///
    /// - Parameter enabled: `true` 表示锁定初始拖拽方向
    /// - Returns: `Self`
    @discardableResult
    func isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        base.isDirectionalLockEnabled = enabled
        return self
    }

    /// 控制是否响应状态栏点击滚动到顶部
    ///
    /// - Parameter scrollsToTop: `true` 允许点击状态栏回到顶部
    /// - Returns: `Self`
    @discardableResult
    func scrollsToTop(_ scrollsToTop: Bool) -> Self {
        base.scrollsToTop = scrollsToTop
        return self
    }
}

// MARK: - 方法(自定义)
public extension DyWrapper where Base: UIScrollView {
    /// 滚动到内容顶部(考虑 `contentInset.top`)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToEndTop(_ animated: Bool = true) -> Self {
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: -base.contentInset.top), animated: animated)
        return self
    }

    /// 滚动到内容底部(考虑 `contentInset.bottom` 和可见区域)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToEndBottom(_ animated: Bool = true) -> Self {
        let maxY = max(0, base.contentSize.height - base.bounds.height) + base.contentInset.bottom
        base.setContentOffset(CGPoint(x: base.contentOffset.x, y: maxY), animated: animated)
        return self
    }

    /// 滚动到内容最左侧(考虑 `contentInset.left`)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToEndLeft(_ animated: Bool = true) -> Self {
        base.setContentOffset(CGPoint(x: -base.contentInset.left, y: base.contentOffset.y), animated: animated)
        return self
    }

    /// 滚动到内容最右侧(考虑 `contentInset.right` 和可见区域)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollToEndRight(_ animated: Bool = true) -> Self {
        let maxX = max(0, base.contentSize.width - base.bounds.width) + base.contentInset.right
        base.setContentOffset(CGPoint(x: maxX, y: base.contentOffset.y), animated: animated)
        return self
    }
}

// MARK: - 分页滚动(上下左右一页)
public extension DyWrapper where Base: UIScrollView {
    /// 向上滚动一页(若启用分页,则对齐页面;否则滚动一屏高度)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollUp(_ animated: Bool = true) -> Self {
        let this = self.base
        let minY = -this.contentInset.top
        var targetY = this.contentOffset.y - this.bounds.height
        if this.isPagingEnabled, this.bounds.height > 0 {
            let page = floor((targetY + this.contentInset.top) / this.bounds.height)
            targetY = max(minY, page * this.bounds.height - this.contentInset.top)
        } else {
            targetY = max(minY, targetY)
        }
        this.setContentOffset(CGPoint(x: this.contentOffset.x, y: targetY), animated: animated)
        return self
    }

    /// 向下滚动一页(若启用分页,则对齐页面;否则滚动一屏高度)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollDown(_ animated: Bool = true) -> Self {
        let this = self.base
        let maxY = max(0, this.contentSize.height - this.bounds.height) + this.contentInset.bottom
        var targetY = this.contentOffset.y + this.bounds.height
        if this.isPagingEnabled, this.bounds.height > 0 {
            let page = floor((targetY + this.contentInset.top) / this.bounds.height)
            targetY = min(maxY, page * this.bounds.height - this.contentInset.top)
        } else {
            targetY = min(maxY, targetY)
        }
        this.setContentOffset(CGPoint(x: this.contentOffset.x, y: targetY), animated: animated)
        return self
    }

    /// 向左滚动一页(若启用分页,则对齐页面;否则滚动一屏宽度)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollLeft(_ animated: Bool = true) -> Self {
        let this = self.base
        let minX = -this.contentInset.left
        var targetX = this.contentOffset.x - this.bounds.width
        if this.isPagingEnabled, this.bounds.width > 0 {
            let page = floor((targetX + this.contentInset.left) / this.bounds.width)
            targetX = max(minX, page * this.bounds.width - this.contentInset.left)
        } else {
            targetX = max(minX, targetX)
        }
        this.setContentOffset(CGPoint(x: targetX, y: this.contentOffset.y), animated: animated)
        return self
    }

    /// 向右滚动一页(若启用分页,则对齐页面;否则滚动一屏宽度)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func scrollRight(_ animated: Bool = true) -> Self {
        let this = self.base
        let maxX = max(0, this.contentSize.width - this.bounds.width) + this.contentInset.right
        var targetX = this.contentOffset.x + this.bounds.width
        if this.isPagingEnabled, this.bounds.width > 0 {
            let page = floor((targetX + this.contentInset.left) / this.bounds.width)
            targetX = min(maxX, page * this.bounds.width - this.contentInset.left)
        } else {
            targetX = min(maxX, targetX)
        }
        this.setContentOffset(CGPoint(x: targetX, y: this.contentOffset.y), animated: animated)
        return self
    }
}
