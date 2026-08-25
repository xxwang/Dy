import UIKit

// MARK: - 属性
public extension UIScrollView {
    /// 获取滚动视图当前在内容坐标系中的可见区域
    ///
    /// - Returns: 一个 `CGRect`,表示当前可见的内容区域(原点为 `contentOffset`,大小为 `bounds.size`)
    ///   即使 `contentSize` 小于 `bounds.size`,该区域仍正确反映视口位置
    ///   注意：此区域可能包含超出 `contentSize` 的部分(例如弹性回弹时)
    var dy_visibleRect: CGRect {
        return CGRect(origin: self.contentOffset, size: self.bounds.size)
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

        let originalShowsIndicators = (self.showsHorizontalScrollIndicator, self.showsVerticalScrollIndicator)
        if !options.showsScrollIndicators {
            self.showsHorizontalScrollIndicator = false
            self.showsVerticalScrollIndicator = false
        }
        defer {
            self.showsHorizontalScrollIndicator = originalShowsIndicators.0
            self.showsVerticalScrollIndicator = originalShowsIndicators.1
        }

        let scale = options.scaleToScreen ? DyScreen.screenScale : 1.0
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, options.opaque, scale)
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
        context.translateBy(x: -self.contentOffset.x, y: -self.contentOffset.y)
        self.layer.render(in: context)

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

        let originalOffset = self.contentOffset
        let originalShowsIndicators = (self.showsHorizontalScrollIndicator, self.showsVerticalScrollIndicator)
        func restoreIndicators() {
            self.showsHorizontalScrollIndicator = originalShowsIndicators.0
            self.showsVerticalScrollIndicator = originalShowsIndicators.1
        }
        if !options.showsScrollIndicators {
            self.showsHorizontalScrollIndicator = false
            self.showsVerticalScrollIndicator = false
        }

        let scale = options.scaleToScreen ? DyScreen.screenScale : 1.0
        let totalSize = self.contentSize
        guard totalSize.width > 0, totalSize.height > 0 else {
            debugPrint("截图失败: contentSize 无效")
            completion(nil)
            return
        }

        UIGraphicsBeginImageContextWithOptions(totalSize, options.opaque, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            debugPrint("截图失败: 无法获取图形上下文")
            restoreIndicators()
            self.setContentOffset(originalOffset, animated: false)
            completion(nil)
            return
        }

        // 分页渲染(避免一次性绘制过大内容导致内存峰值)
        let pageSize = self.bounds.size
        let totalPages = Int((totalSize.height / pageSize.height).dy_ceil())

        /// 图形上下文须在整个分页渲染完成前保持打开,否则异步渲染会拿到已关闭的上下文得到空白图
        func renderPage(index: Int) {
            let yOffset = CGFloat(index) * pageSize.height
            self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)

            // 延迟一帧,等待布局/绘制刷新后再渲染当前页
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                context.saveGState()
                context.translateBy(x: 0, y: yOffset)
                self.self.layer.render(in: context)
                context.restoreGState()

                if index < totalPages - 1 {
                    renderPage(index: index + 1)
                } else {
                    let image = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    restoreIndicators()
                    self.setContentOffset(originalOffset, animated: false)
                    completion(image?.dy_compress(qualityRange: options.qualityRange))
                }
            }
        }
        renderPage(index: 0)
    }
}
