import UIKit

// MARK: - 属性
public extension UIScrollView {
    /// 获取滚动视图当前在内容坐标系中的可见区域
    ///
    /// - Returns: 一个 `CGRect`,表示当前可见的内容区域(原点为 `contentOffset`,大小为 `bounds.size`)
    ///   即使 `contentSize` 小于 `bounds.size`,该区域仍正确反映视口位置
    ///   注意：此区域可能包含超出 `contentSize` 的部分(例如弹性回弹时)
    var dy_visibleRect: CGRect {
        return CGRect(origin: contentOffset, size: bounds.size)
    }
}

// MARK: - 截图
public extension UIScrollView {
    /// 截图选项(与 UIView 的选项保持一致)
    struct DyScreenshotOptions {
        /// 是否考虑屏幕缩放(默认 true)
        public var scaleToScreen: Bool = true
        /// 截图后是否保留透明通道(默认 false)
        public var opaque: Bool = false
        /// JPEG 压缩质量范围(0-1,默认 0.6...0.8)
        public var qualityRange: ClosedRange<CGFloat> = 0.6 ... 0.8
        /// 截图后是否立即释放上下文(默认 true)
        public var releaseContextImmediately: Bool = true
        /// 是否包含滚动条(默认 false)
        public var showsScrollIndicators: Bool = false

        public init() {}
    }

    /// 获取当前可见区域的截图
    /// - Parameter options: 截图配置选项
    /// - Returns: 可见区域的截图,失败返回 nil
    func dy_captureVisibleScreenshot(options: DyScreenshotOptions = DyScreenshotOptions()) -> UIImage? {
        assert(Thread.isMainThread, "captureVisibleScreenshot must be called on main thread")

        let originalShowsIndicators = (showsHorizontalScrollIndicator, showsVerticalScrollIndicator)
        if !options.showsScrollIndicators {
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
        }
        defer {
            showsHorizontalScrollIndicator = originalShowsIndicators.0
            showsVerticalScrollIndicator = originalShowsIndicators.1
        }

        let scale = options.scaleToScreen ? DyScreen.screenScale : 1.0
        UIGraphicsBeginImageContextWithOptions(bounds.size, options.opaque, scale)
        defer {
            if options.releaseContextImmediately {
                UIGraphicsEndImageContext()
            }
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            debugPrint("截图失败: 无法获取图形上下文")
            return nil
        }

        // 调整坐标系以适应内容偏移量
        context.translateBy(x: -contentOffset.x, y: -contentOffset.y)
        layer.render(in: context)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            debugPrint("截图失败: 无法从上下文获取图像")
            return nil
        }

        return image.dy_compress(qualityRange: options.qualityRange)
    }

    /// 异步截取整个 contentSize 的长截图
    /// - Parameters:
    ///   - options: 截图配置选项
    ///   - completion: 完成回调,返回截图的 `UIImage?`
    func dy_captureFullScreenshot(options: DyScreenshotOptions = DyScreenshotOptions(),
                                  completion: @escaping DyAction1<UIImage?>)
    {
        assert(Thread.isMainThread, "captureFullScreenshot must be called on main thread")

        let originalOffset = contentOffset
        let originalShowsIndicators = (showsHorizontalScrollIndicator, showsVerticalScrollIndicator)
        func restoreIndicators() {
            showsHorizontalScrollIndicator = originalShowsIndicators.0
            showsVerticalScrollIndicator = originalShowsIndicators.1
        }
        if !options.showsScrollIndicators {
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
        }

        let scale = options.scaleToScreen ? DyScreen.screenScale : 1.0
        let totalSize = contentSize
        guard totalSize.width > 0, totalSize.height > 0 else {
            debugPrint("截图失败: contentSize 无效")
            completion(nil)
            return
        }

        UIGraphicsBeginImageContextWithOptions(totalSize, options.opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            debugPrint("截图失败: 无法获取图形上下文")
            restoreIndicators()
            setContentOffset(originalOffset, animated: false)
            completion(nil)
            return
        }

        // 分页渲染(避免一次性绘制过大内容导致内存峰值)
        let pageSize = bounds.size
        let totalPages = Int(ceil(totalSize.height / pageSize.height))

        /// 图形上下文须在整个分页渲染完成前保持打开,否则异步渲染会拿到已关闭的上下文得到空白图
        func dy_renderPage(index: Int) {
            let yOffset = CGFloat(index) * pageSize.height
            setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)

            // 延迟一帧,等待布局/绘制刷新后再渲染当前页
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                context.saveGState()
                context.translateBy(x: 0, y: yOffset)
                self.layer.render(in: context)
                context.restoreGState()

                if index < totalPages - 1 {
                    dy_renderPage(index: index + 1)
                } else {
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    restoreIndicators()
                    self.setContentOffset(originalOffset, animated: false)
                    completion(image?.dy_compress(qualityRange: options.qualityRange))
                }
            }
        }

        dy_renderPage(index: 0)
    }
}

// MARK: - 链式设置属性
public extension UIScrollView {
    /// 设置下拉刷新控件
    /// - Parameter refreshControl: 下拉刷新控件
    /// - Returns: `Self`
    @discardableResult
    func dy_refreshControl(_ refreshControl: UIRefreshControl) -> Self {
        self.refreshControl = refreshControl
        return self
    }

    /// 设置滚动视图的代理
    ///
    /// - Parameter delegate: 遵循 `UIScrollViewDelegate` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UIScrollViewDelegate?) -> Self {
        self.delegate = delegate
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
    func dy_contentOffset(_ offset: CGPoint) -> Self {
        let clampedX = min(
            max(offset.x, -self.contentInset.left),
            self.contentSize.width + self.contentInset.right
        )
        let clampedY = min(
            max(offset.y, -self.contentInset.top),
            self.contentSize.height + self.contentInset.bottom
        )
        self.contentOffset = CGPoint(x: clampedX, y: clampedY)
        return self
    }

    /// 设置可滚动内容区域的大小(`contentSize`)
    ///
    /// - Parameter size: 内容区域尺寸宽度和高度将被限制为 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func dy_contentSize(_ size: CGSize) -> Self {
        let validSize = CGSize(
            width: max(size.width, 0),
            height: max(size.height, 0)
        )
        self.contentSize = validSize
        return self
    }

    /// 设置内容内边距(`contentInset`),控制内容与滚动视图边缘的距离
    ///
    /// - Parameter inset: 内边距常用于避开导航栏、TabBar 等
    /// - Returns: `Self`
    ///
    /// - Note: 此设置需配合有效的 `contentSize` 才能体现滚动效果
    @discardableResult
    func dy_contentInset(_ inset: UIEdgeInsets) -> Self {
        self.contentInset = inset
        return self
    }

    /// 启用或禁用弹性回弹效果(`bounces`)
    ///
    /// - Parameter bounces: `true` 表示滑动到边缘时有弹性回弹;`false` 则无
    /// - Returns: `Self`
    @discardableResult
    func dy_bounces(_ bounces: Bool) -> Self {
        self.bounces = bounces
        return self
    }

    /// 是否始终启用水平方向的弹性效果(即使内容未超出视图宽度)
    ///
    /// - Parameter bounces: `true` 表示总是可以水平弹性滑动
    /// - Returns: `Self`
    @discardableResult
    func dy_alwaysBounceHorizontal(_ bounces: Bool) -> Self {
        self.alwaysBounceHorizontal = bounces
        return self
    }

    /// 是否始终启用垂直方向的弹性效果(即使内容未超出视图高度)
    ///
    /// - Parameter bounces: `true` 表示总是可以垂直弹性滑动
    /// - Returns: `Self`
    @discardableResult
    func dy_alwaysBounceVertical(_ bounces: Bool) -> Self {
        self.alwaysBounceVertical = bounces
        return self
    }

    /// 启用或禁用分页滚动(`isPagingEnabled`)
    ///
    /// - Parameter enabled: `true` 表示每次滑动停靠在整页位置(如轮播图)
    /// - Returns: `Self`
    @discardableResult
    func dy_isPagingEnabled(_ enabled: Bool) -> Self {
        self.isPagingEnabled = enabled
        return self
    }

    /// 控制是否显示水平滚动条
    ///
    /// - Parameter enabled: `true` 显示,`false` 隐藏
    /// - Returns: `Self`
    @discardableResult
    func dy_showsHorizontalScrollIndicator(_ enabled: Bool) -> Self {
        self.showsHorizontalScrollIndicator = enabled
        return self
    }

    /// 控制是否显示垂直滚动条
    ///
    /// - Parameter enabled: `true` 显示,`false` 隐藏
    /// - Returns: `Self`
    @discardableResult
    func dy_showsVerticalScrollIndicator(_ enabled: Bool) -> Self {
        self.showsVerticalScrollIndicator = enabled
        return self
    }

    /// 设置滚动条的内边距(`scrollIndicatorInsets`)
    ///
    /// - Parameter inset: 滚动条距离滚动视图四边的距离
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollIndicatorInsets(_ inset: UIEdgeInsets) -> Self {
        self.scrollIndicatorInsets = inset
        return self
    }

    /// 启用或禁用用户滚动交互
    ///
    /// - Parameter enabled: `true` 允许滚动,`false` 禁止
    /// - Returns: `Self`
    @discardableResult
    func dy_isScrollEnabled(_ enabled: Bool) -> Self {
        self.isScrollEnabled = enabled
        return self
    }

    /// 设置滚动条样式(颜色和外观)
    ///
    /// - Parameter style: 如 `.default`, `.black`, `.white`
    /// - Returns: `Self`
    @discardableResult
    func dy_indicatorStyle(_ style: UIScrollView.IndicatorStyle) -> Self {
        self.indicatorStyle = style
        return self
    }

    /// 设置减速率(松手后滚动停止的速度)
    ///
    /// - Parameter rate: 系统预设值如 `.normal` 或 `.fast`
    /// - Returns: `Self`
    @discardableResult
    func dy_decelerationRate(_ rate: UIScrollView.DecelerationRate) -> Self {
        self.decelerationRate = rate
        return self
    }

    /// 启用方向锁定(拖拽时仅沿一个方向滚动)
    ///
    /// - Parameter enabled: `true` 表示锁定初始拖拽方向
    /// - Returns: `Self`
    @discardableResult
    func dy_isDirectionalLockEnabled(_ enabled: Bool) -> Self {
        self.isDirectionalLockEnabled = enabled
        return self
    }

    /// 控制是否响应状态栏点击滚动到顶部
    ///
    /// - Parameter scrollsToTop: `true` 允许点击状态栏回到顶部
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollsToTop(_ scrollsToTop: Bool) -> Self {
        self.scrollsToTop = scrollsToTop
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIScrollView {
    /// 滚动到内容顶部(考虑 `contentInset.top`)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToEndTop(_ animated: Bool = true) -> Self {
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: -self.contentInset.top), animated: animated)
        return self
    }

    /// 滚动到内容底部(考虑 `contentInset.bottom` 和可见区域)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToEndBottom(_ animated: Bool = true) -> Self {
        let maxY = max(0, self.contentSize.height - self.bounds.height) + self.contentInset.bottom
        self.setContentOffset(CGPoint(x: self.contentOffset.x, y: maxY), animated: animated)
        return self
    }

    /// 滚动到内容最左侧(考虑 `contentInset.left`)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToEndLeft(_ animated: Bool = true) -> Self {
        self.setContentOffset(CGPoint(x: -self.contentInset.left, y: self.contentOffset.y), animated: animated)
        return self
    }

    /// 滚动到内容最右侧(考虑 `contentInset.right` 和可见区域)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToEndRight(_ animated: Bool = true) -> Self {
        let maxX = max(0, self.contentSize.width - self.bounds.width) + self.contentInset.right
        self.setContentOffset(CGPoint(x: maxX, y: self.contentOffset.y), animated: animated)
        return self
    }
}

// MARK: - 链式分页滚动(上下左右一页)
public extension UIScrollView {
    /// 向上滚动一页(若启用分页,则对齐页面;否则滚动一屏高度)
    ///
    /// - Parameter animated: 是否启用滚动动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollUp(_ animated: Bool = true) -> Self {
        let this = self
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
    func dy_scrollDown(_ animated: Bool = true) -> Self {
        let this = self
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
    func dy_scrollLeft(_ animated: Bool = true) -> Self {
        let this = self
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
    func dy_scrollRight(_ animated: Bool = true) -> Self {
        let this = self
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
