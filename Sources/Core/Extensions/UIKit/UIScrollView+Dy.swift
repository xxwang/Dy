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

        let scale = options.scaleToScreen ? UIScreen.main.scale : 1.0
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

        UIGraphicsEndImageContext()
        return image.dy_compress(qualityRange: options.qualityRange)
    }

    /// 异步截取整个 contentSize 的长截图
    /// - Parameters:
    ///   - options: 截图配置选项
    ///   - completion: 完成回调,返回截图的 `UIImage?`
    func dy_captureFullScreenshot(options: DyScreenshotOptions = DyScreenshotOptions(),
                                  completion: @escaping (_ image: UIImage?) -> Void)
    {
        assert(Thread.isMainThread, "captureFullScreenshot must be called on main thread")

        let originalOffset = contentOffset
        let originalShowsIndicators = (showsHorizontalScrollIndicator, showsVerticalScrollIndicator)
        if !options.showsScrollIndicators {
            showsHorizontalScrollIndicator = false
            showsVerticalScrollIndicator = false
        }

        let scale = options.scaleToScreen ? UIScreen.main.scale : 1.0
        let totalSize = contentSize
        guard totalSize.width > 0, totalSize.height > 0 else {
            debugPrint("截图失败: contentSize 无效")
            completion(nil)
            return
        }

        UIGraphicsBeginImageContextWithOptions(totalSize, options.opaque, scale)
        defer {
            if options.releaseContextImmediately {
                UIGraphicsEndImageContext()
            }
            showsHorizontalScrollIndicator = originalShowsIndicators.0
            showsVerticalScrollIndicator = originalShowsIndicators.1
            setContentOffset(originalOffset, animated: false)
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            debugPrint("截图失败: 无法获取图形上下文")
            completion(nil)
            return
        }

        // 分页渲染(避免内存问题)
        let pageSize = bounds.size
        let totalPages = Int(ceil(totalSize.height / pageSize.height))

        func dy_renderPage(index: Int) {
            let yOffset = CGFloat(index) * pageSize.height
            setContentOffset(CGPoint(x: 0, y: yOffset), animated: false)

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
                    completion(image?.dy_compress(qualityRange: options.qualityRange))
                }
            }
        }

        dy_renderPage(index: 0)
    }
}
