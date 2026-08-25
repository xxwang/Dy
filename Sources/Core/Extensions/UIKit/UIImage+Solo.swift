import UIKit
import CoreGraphics
import CoreImage
import CoreImage.CIFilterBuiltins
import ImageIO

/// 共享 `CIContext`（线程安全），避免每次滤镜操作重复创建昂贵实例。
private let solo_sharedCIContext: CIContext = CIContext(options: [
    .workingColorSpace: CGColorSpaceCreateDeviceRGB(),
    .useSoftwareRenderer: false,
])

// MARK: - 构造方法
public extension UIImage {
    /// 根据颜色和大小创建纯色图片,可选圆角半径
    /// - Parameters:
    ///   - color: 图片填充颜色,默认为黑色
    ///   - size: 图片尺寸,默认为1x1像素
    ///   - cornerRadius: 圆角半径,默认为0表示直角矩形
    convenience init?(color: UIColor = .black, size: CGSize = CGSize(width: 1, height: 1), cornerRadius: CGFloat = 0) {
        UIGraphicsBeginImageContextWithOptions(size, false, SoloScreen.screenScale)
        defer { UIGraphicsEndImageContext() }

        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        if cornerRadius > 0 {
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
            path.addClip()
        }

        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))

        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }

    /// 创建支持深浅色模式的动态图片
    /// - Parameters:
    ///   - lightImage: 浅色模式下的图片
    ///   - darkImage: 深色模式下的图片(可选)
    convenience init?(lightImage: UIImage, darkImage: UIImage? = nil) {
        // 委托系统原生 API：UIImage(lightImage:darkImage:) 原生支持 trait 动态切换，
        // 保留深浅色自动换图能力（原实现提取 cgImage 重建会丢失动态特性）
        self.init(lightImage: lightImage, darkImage: darkImage ?? lightImage)
    }

    /// 通过图片名称创建支持深浅色模式的动态图片
    /// - Parameters:
    ///   - lightImageName: 浅色模式下图片的名字
    ///   - darkImageName: 深色模式下图片的名字(可选)
    convenience init?(lightImageName: String, darkImageName: String? = nil) {
        guard let lightImage = UIImage(named: lightImageName) else { return nil }
        let darkImage = darkImageName.flatMap { UIImage(named: $0) }
        self.init(lightImage: lightImage, darkImage: darkImage)
    }
}

public extension UIImage {
    /// 默认压缩质量范围
    static let defaultQualityRange: ClosedRange<CGFloat> = 0.6 ... 0.8
}

// MARK: - UIImage属性
public extension UIImage {
    /// 获取图片解码后的位图大小(单位:字节),O(1) 估算,避免每次全量 JPEG 编码
    var solo_sizeInBytes: Int {
        guard let cg = self.cgImage else { return 0 }
        return cg.bytesPerRow * cg.height
    }

    /// 获取图片解码后的位图大小(单位:KB)
    var solo_sizeInKB: Double {
        return Double(self.solo_sizeInBytes) / 1024.0
    }

    /// 返回使用原始渲染模式的图片实例
    var solo_withOriginalRenderingMode: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    /// 返回使用模板渲染模式的图片实例
    var solo_withTemplateRenderingMode: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}

// MARK: - Base64 编码
public extension UIImage {
    /// 获取图像的 PNG 格式 Base64 编码字符串
    ///
    /// - Returns: Base64 字符串,若 PNG 数据生成失败则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let base64 = image.solo_pngBase64String {
    ///       print("data:image/png;base64,\(base64)")
    ///   }
    ///   ```
    var solo_pngBase64String: String? {
        return self.pngData()?.base64EncodedString()
    }

    /// 获取图像的 JPEG 格式 Base64 编码字符串
    ///
    /// - Parameter compressionQuality: 压缩质量,范围 `[0.0, 1.0]`值越高质量越高,文件越大
    /// - Returns: Base64 字符串,若 JPEG 数据生成失败则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let base64 = image.solo_jpegBase64String(compressionQuality: 0.8) {
    ///       print("data:image/jpeg;base64,\(base64)")
    ///   }
    ///   ```
    func solo_jpegBase64String(compressionQuality: CGFloat) -> String? {
        let quality = min(max(compressionQuality, 0), 1)
        return self.jpegData(compressionQuality: quality)?.base64EncodedString()
    }
}

// MARK: - 动态图片扩展
public extension UIImage {
    /// 创建适配深色/浅色模式的动态图片(通过图片名称)
    /// - Parameters:
    ///   - lightName: 浅色模式下的图片名称
    ///   - darkName: 深色模式下的图片名称(可选,默认使用浅色图片)
    /// - Returns: 动态图片(iOS 13+) 或者浅色图片(iOS 12及以下)
    ///
    /// - Example:
    ///
    ///     let dynamicImage = UIImage.solo_dynamic(lightImageName: "light_icon", darkImageName: "dark_icon")
    ///
    static func solo_dynamic(lightImageName: String, darkImageName: String? = nil) -> UIImage? {
        return UIImage(lightImageName: lightImageName, darkImageName: darkImageName)
    }

    /// 创建适配深色/浅色模式的动态图片(通过UIImage对象)
    /// - Parameters:
    ///   - light: 浅色模式下的图片
    ///   - dark: 深色模式下的图片(可选,默认使用浅色图片)
    /// - Returns: 动态图片(iOS 13+) 或者浅色图片(iOS 12及以下)
    ///
    /// - Example:
    ///
    ///     let dynamicImage = UIImage.solo_dynamic(light: lightImage, dark: darkImage)
    ///
    static func solo_dynamic(light: UIImage, dark: UIImage? = nil) -> UIImage? {
        return UIImage(lightImage: light, darkImage: dark)
    }
}

// MARK: - 图像压缩模式配置
/// 定义图片压缩的质量级别配置
public enum SoloCompressionMode {
    /// 低质量压缩(小尺寸/低质量)
    case low
    /// 中等质量压缩(推荐默认值)
    case medium
    /// 高质量压缩(大尺寸/高质量)
    case high
    /// 自定义配置
    case custom(maxResolution: CGFloat, maxFileSize: Int)

    /// 分辨率配置规则(单位：像素)
    private static let resolutionRule = (
        min: CGFloat(10),
        max: CGFloat(4096),
        low: CGFloat(512),
        default: CGFloat(1024),
        high: CGFloat(2048)
    )

    /// 文件大小配置规则(单位：字节)
    private static let dataSizeRule = (
        min: 10 * 1024,
        max: 20 * 1024 * 1024,
        low: 512 * 1024,
        default: 2 * 1024 * 1024,
        high: 10 * 1024 * 1024
    )

    /// 当前模式的最大文件大小(字节)
    var maxFileSize: Int {
        switch self {
        case .low: return Self.dataSizeRule.low
        case .medium: return Self.dataSizeRule.default
        case .high: return Self.dataSizeRule.high
        case let .custom(_, fileSize):
            return fileSize.solo_clamped(to: Self.dataSizeRule.min ... Self.dataSizeRule.max)
        }
    }

    /// 当前模式的最大边长(像素)
    var maxResolution: CGFloat {
        switch self {
        case .low: return Self.resolutionRule.low
        case .medium: return Self.resolutionRule.default
        case .high: return Self.resolutionRule.high
        case let .custom(resolution, _):
            return resolution.solo_clamped(to: Self.resolutionRule.min ... Self.resolutionRule.max)
        }
    }

    /// 根据原始尺寸计算调整后的尺寸
    /// - Parameter originalSize: 原始图片尺寸
    /// - Returns: 调整后的尺寸(保持宽高比)
    func resizedSize(for originalSize: CGSize) -> CGSize {
        guard originalSize.width >= Self.resolutionRule.min,
              originalSize.height >= Self.resolutionRule.min
        else {
            return originalSize
        }

        let longestEdge = max(originalSize.width, originalSize.height)
        guard longestEdge > maxResolution else { return originalSize }

        let scale = maxResolution / longestEdge
        return CGSize(width: originalSize.width * scale, height: originalSize.height * scale).solo_rounded()
    }
}

// MARK: - 图像压缩功能扩展
public extension UIImage {
    /// 同步压缩图片
    /// - Parameters:
    ///   - mode: 压缩模式(默认为.medium)
    ///   - qualityRange: JPEG压缩质量范围(0.0-1.0,默认为0.6-0.8)
    /// - Returns: 压缩后的JPEG数据
    func solo_compress(
        mode: SoloCompressionMode = .medium,
        qualityRange: ClosedRange<CGFloat> = UIImage.defaultQualityRange
    ) -> UIImage? {
        guard let resizedImage = self.solo_resized(to: mode.resizedSize(for: self.size)) else { return nil }
        guard let data = resizedImage.solo_compressedData(maxFileSize: mode.maxFileSize, qualityRange: qualityRange) else { return nil }
        return UIImage(data: data)
    }

    /// 异步压缩图片(推荐UI线程使用)
    /// - Parameters:
    ///   - mode: 压缩模式
    ///   - qualityRange: 质量范围
    ///   - queue: 执行队列(默认后台队列)
    ///   - completion: 完成后回调(自动返回主线程)
    func solo_asyncCompress(
        mode: SoloCompressionMode = .medium,
        qualityRange: ClosedRange<CGFloat> = UIImage.defaultQualityRange,
        queue: DispatchQueue = .global(qos: .userInitiated),
        completion: @escaping SoloAction1<UIImage?>
    ) {
        queue.async {
            guard let result = self.solo_compress(mode: mode, qualityRange: qualityRange) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async { completion(result) }
        }
    }

    /// 同步压缩图片(返回`Data`)
    /// - Parameters:
    ///   - maxFileSize: 最大文件大小(字节)
    ///   - qualityRange: 质量范围
    /// - Returns: 压缩后的图片`Data`
    func solo_compressedData(
        maxFileSize: Int,
        qualityRange: ClosedRange<CGFloat> = UIImage.defaultQualityRange
    ) -> Data? {
        var quality = qualityRange.upperBound
        var result: Data?

        while quality >= qualityRange.lowerBound {
            guard let data = self.jpegData(compressionQuality: quality), data.count <= maxFileSize else {
                quality -= 0.05
                continue
            }
            result = data
            break
        }

        return result ?? self.jpegData(compressionQuality: qualityRange.lowerBound)
    }

    /// 调整图片尺寸
    private func solo_resized(to newSize: CGSize) -> UIImage? {
        if self.size == newSize {
            return self
        }
        return self.solo_resizedUsingImageIO(newSize) ?? self.solo_resizedUsingCoreGraphics(newSize)
    }

    /// 使用`ImageIO`调整尺寸(最佳性能)
    /// - Parameter newSize: 目标大小
    /// - Returns: `UIImage?`
    private func solo_resizedUsingImageIO(_ newSize: CGSize) -> UIImage? {
        guard let data = self.pngData(), let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }

        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(newSize.width, newSize.height),
        ]

        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else { return nil }
        return UIImage(cgImage: cgImage)
    }

    /// 使用`CoreGraphics`调整尺寸(兼容方案)
    /// - Parameter newSize: 目标大小
    /// - Returns: `UIImage?`
    private func solo_resizedUsingCoreGraphics(_ newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { context in
            context.cgContext.interpolationQuality = .high
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// MARK: - 裁剪相关
public extension UIImage {
    /// 裁剪图片到指定矩形区域
    /// - Parameter rect: 裁剪区域(基于图片坐标系)
    /// - Returns: 裁剪后的图片,如果区域无效返回nil
    func solo_crop(to rect: CGRect) -> UIImage? {
        let scaledRect = rect.applying(CGAffineTransform(scaleX: self.scale, y: self.scale))

        guard let cgImage = self.cgImage?.cropping(to: scaledRect) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }

    /// 限制图片不超过最大尺寸(保持宽高比)
    /// - Parameter maxSize: 最大允许尺寸
    /// - Returns: 调整后的图片(如不需调整则返回原图)
    func solo_limit(to maxSize: CGSize) -> UIImage {
        if self.size.width <= maxSize.width, self.size.height <= maxSize.height {
            return self
        }

        let aspectRatio = min(maxSize.width / self.size.width, maxSize.height / self.size.height)
        let newSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)

        return UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}

// MARK: - 拉伸相关
public extension UIImage {
    /// 创建可拉伸图片(从中心点拉伸)
    func solo_makeResizableFromCenter() -> UIImage {
        let insets = UIEdgeInsets(
            top: (self.size.height / 2).solo_floor(),
            left: (self.size.width / 2).solo_floor(),
            bottom: (self.size.height / 2).solo_ceil(),
            right: (self.size.width / 2).solo_ceil()
        )
        return self.resizableImage(withCapInsets: insets, resizingMode: .stretch)
    }

    /// 创建自定义可拉伸图片
    /// - Parameters:
    ///   - insets: 不拉伸的区域
    ///   - mode: 拉伸模式(默认.stretch)
    func solo_makeResizable(insets: UIEdgeInsets, mode: UIImage.ResizingMode = .stretch) -> UIImage {
        return self.resizableImage(withCapInsets: insets, resizingMode: mode)
    }
}

// MARK: - 缩放相关
public extension UIImage {
    /// 等比缩放图片到指定尺寸(可能留有空白)
    /// - Parameter size: 目标尺寸
    func solo_scaleAspectFit(to size: CGSize) -> UIImage {
        let aspectRatio = min(size.width / self.size.width, size.height / self.size.height)
        let newSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)

        return UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(x: (size.width - newSize.width) / 2,
                                 y: (size.height - newSize.height) / 2,
                                 width: newSize.width,
                                 height: newSize.height))
        }
    }

    /// 等比填充缩放图片到指定尺寸(可能裁剪)
    /// - Parameter size: 目标尺寸
    func solo_scaleAspectFill(to size: CGSize) -> UIImage {
        let aspectRatio = max(size.width / self.size.width, size.height / self.size.height)
        let scaledSize = CGSize(width: self.size.width * aspectRatio, height: self.size.height * aspectRatio)

        return UIGraphicsImageRenderer(size: size).image { _ in
            self.draw(in: CGRect(x: (size.width - scaledSize.width) / 2,
                                 y: (size.height - scaledSize.height) / 2,
                                 width: scaledSize.width,
                                 height: scaledSize.height))
        }
    }

    /// 缩放图片到指定宽度(保持宽高比)
    /// - Parameters:
    ///   - newWidth: 目标宽度
    ///   - opaque: 是否不透明背景
    func solo_scale(toWidth newWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scaleFactor = newWidth / self.size.width
        let newSize = CGSize(width: newWidth, height: self.size.height * scaleFactor)

        UIGraphicsBeginImageContextWithOptions(newSize, opaque, self.scale)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    /// 缩放图片到指定高度(保持宽高比)
    /// - Parameters:
    ///   - newHeight: 目标高度
    ///   - opaque: 是否不透明背景
    func solo_scale(toHeight newHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scaleFactor = newHeight / self.size.height
        let newSize = CGSize(width: self.size.width * scaleFactor, height: newHeight)

        UIGraphicsBeginImageContextWithOptions(newSize, opaque, self.scale)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - 图片旋转与翻转
public extension UIImage {
    /// 修正图片方向(确保总是 .up 方向)
    /// - Returns: 方向修正后的图片
    ///
    /// - Example:
    ///
    ///     let fixedImage = capturedImage.solo_fixOrientation()
    ///
    func solo_fixOrientation() -> UIImage {
        guard self.imageOrientation != .up, let _ = self.cgImage else { return self }

        let drawRect = CGRect(origin: .zero, size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: drawRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? self
    }

    /// 按角度旋转图片(正数顺时针,负数逆时针)
    /// - Parameter degrees: 旋转角度(单位：度)
    /// - Returns: 旋转后的图片
    ///
    /// - Example:
    ///
    ///     let rotatedImage = image.solo_rotate(degrees: 90)
    ///
    func solo_rotate(degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        return self.solo_rotate(radians: radians)
    }

    /// 按弧度旋转图片
    /// - Parameter radians: 旋转弧度
    /// - Returns: 旋转后的图片
    ///
    /// - Example:
    ///
    ///     let rotatedImage = image.solo_rotate(radians: -.pi / 2)
    ///
    func solo_rotate(radians: CGFloat) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        // 计算旋转后所需画布尺寸
        let rect = CGRect(origin: .zero, size: self.size)
        let rotatedRect = rect.applying(CGAffineTransform(rotationAngle: radians))
        let boundingSize = CGSize(
            width: (rotatedRect.width).solo_ceil(),
            height: (rotatedRect.height).solo_ceil()
        )

        let renderer = UIGraphicsImageRenderer(size: boundingSize)
        return renderer.image { context in
            // 移动原点到中心
            context.cgContext.translateBy(x: boundingSize.width / 2, y: boundingSize.height / 2)
            context.cgContext.rotate(by: radians)

            // 绘制原始图像(居中)
            let drawRect = CGRect(
                x: -self.size.width / 2,
                y: -self.size.height / 2,
                width: self.size.width,
                height: self.size.height
            )
            context.cgContext.draw(cgImage, in: drawRect)
        }
    }

    /// 水平翻转图片(镜像)
    /// - Returns: 水平翻转后的图片
    ///
    /// - Example:
    ///
    ///     let mirroredImage = image.solo_flipHorizontal()
    ///
    func solo_flipHorizontal() -> UIImage? {
        return self.solo_apply(orientation: .upMirrored)
    }

    /// 垂直翻转图片
    /// - Returns: 垂直翻转后的图片
    ///
    /// - Example:
    ///
    ///     let flippedImage = image.solo_flipVertical()
    ///
    func solo_flipVertical() -> UIImage? {
        return self.solo_apply(orientation: .downMirrored)
    }

    /// 应用指定的 `UIImage.Orientation` 并返回新图像
    /// - Parameter orientation: 目标方向
    /// - Returns: 转换后的 `UIImage`,失败时返回 nil
    private func solo_apply(orientation: UIImage.Orientation) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }

        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        var drawRect = rect
        var transform = CGAffineTransform.identity

        // 构建变换矩阵
        switch orientation {
        case .up:
            return self
        case .upMirrored:
            transform = transform.translatedBy(x: rect.width, y: 0).scaledBy(x: -1, y: 1)
        case .down:
            transform = transform.translatedBy(x: rect.width, y: rect.height).rotated(by: .pi)
        case .downMirrored:
            transform = transform.translatedBy(x: 0, y: rect.height).scaledBy(x: 1, y: -1)
        case .left:
            drawRect.size = CGSize(width: rect.height, height: rect.width)
            transform = transform.translatedBy(x: 0, y: rect.width).rotated(by: .pi * 1.5)
        case .leftMirrored:
            drawRect.size = CGSize(width: rect.height, height: rect.width)
            transform = transform.translatedBy(x: rect.height, y: rect.width)
                .scaledBy(x: -1, y: 1)
                .rotated(by: .pi * 1.5)
        case .right:
            drawRect.size = CGSize(width: rect.height, height: rect.width)
            transform = transform.translatedBy(x: rect.height, y: 0).rotated(by: .pi / 2)
        case .rightMirrored:
            drawRect.size = CGSize(width: rect.height, height: rect.width)
            transform = transform.scaledBy(x: -1, y: 1).rotated(by: .pi / 2)
        @unknown default:
            return nil
        }

        // 渲染上下文
        let renderer = UIGraphicsImageRenderer(size: drawRect.size)
        return renderer.image { context in
            let ctx = context.cgContext

            // 处理坐标系(CoreGraphics Y轴向下)
            switch orientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.scaleBy(x: -1, y: 1)
                ctx.translateBy(x: -drawRect.width, y: 0)
            default:
                ctx.scaleBy(x: 1, y: -1)
                ctx.translateBy(x: 0, y: -rect.height)
            }

            ctx.concatenate(transform)
            ctx.draw(cgImage, in: rect)
        }
    }
}

// MARK: - 图片圆角处理
public extension UIImage {
    /// 为图片添加圆角
    /// - Parameter radius: 圆角半径(nil时生成圆形图片)
    /// - Returns: 带圆角的图片
    func solo_roundedCorner(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(self.size.width, self.size.height) / 2
        let cornerRadius = radius ?? maxRadius

        return UIGraphicsImageRenderer(size: self.size).image { _ in
            let rect = CGRect(origin: .zero, size: self.size)
            UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
            self.draw(in: rect)
        }
    }

    /// 为图片添加指定圆角(可控制每个角)
    /// - Parameters:
    ///   - targetSize: 目标尺寸(nil使用原图尺寸)
    ///   - radius: 圆角半径
    ///   - corners: 需要添加圆角的方位
    /// - Returns: 处理后的图片
    func solo_roundedCorner(targetSize: CGSize? = nil,
                            radius: CGFloat,
                            corners: UIRectCorner = .allCorners) -> UIImage?
    {
        let targetSize = targetSize ?? self.size

        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            let rect = CGRect(origin: .zero, size: targetSize)
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            path.addClip()
            self.draw(in: rect)
        }
    }

    /// 生成带边框的圆角图片
    /// - Parameters:
    ///   - targetSize: 目标大小
    ///   - radius: 圆角半径
    ///   - corners: 圆角方位
    ///   - borderWidth: 边框宽度
    ///   - borderColor: 边框颜色
    ///   - backgroundColor: 背景颜色
    /// - Returns: `UIImage`
    func solo_roundedCorner(targetSize: CGSize,
                            radius: CGFloat,
                            corners: UIRectCorner = .allCorners,
                            borderWidth: CGFloat = 0,
                            borderColor: UIColor? = nil,
                            backgroundColor: UIColor? = nil) -> UIImage?
    {
        return UIGraphicsImageRenderer(size: targetSize).image { context in
            // 设置背景色
            backgroundColor?.setFill()
            UIBezierPath(rect: context.format.bounds).fill()

            // 创建并应用圆角路径
            let rect = CGRect(origin: .zero, size: targetSize)
            let path = (radius == targetSize.width / 2 && targetSize.width == targetSize.height) ?
                UIBezierPath(ovalIn: rect) : UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            path.addClip()

            // 绘制图片
            self.draw(in: rect)

            // 绘制边框
            if borderWidth > 0, let borderColor {
                borderColor.setStroke()
                path.lineWidth = borderWidth
                path.stroke()
            }
        }
    }

    /// 生成圆形图片
    /// - Returns: 圆形裁剪后的图片
    func solo_circularImage() -> UIImage? {
        let diameter = min(self.size.width, self.size.height)
        return self.solo_roundedCorner(radius: diameter / 2)
    }
}

// MARK: - 颜色分析
public extension UIImage {
    /// 表示一种被统计的颜色及其出现次数
    struct SoloCountedColor {
        public let color: UIColor
        public let count: Int

        public init(color: UIColor, count: Int) {
            self.color = color
            self.count = count
        }
    }

    /// 图片颜色分析结果,包含背景色、主色、辅色和细节色
    struct SoloColorPalette {
        public let background: UIColor
        public let primary: UIColor
        public let secondary: UIColor
        public let detail: UIColor

        public init(
            background: UIColor,
            primary: UIColor,
            secondary: UIColor,
            detail: UIColor
        ) {
            self.background = background
            self.primary = primary
            self.secondary = secondary
            self.detail = detail
        }
    }

    /// 分析图片的颜色,返回背景色、主色、辅色和细节色
    ///
    /// 此方法会先将图片缩小以提升性能,默认最大边长为 250pt
    /// 背景色通过边缘区域采样估算,主色等通过对比度和区分度筛选
    ///
    /// - Parameter maxSize: 缩放后的最大尺寸(宽高均不超过该值)默认为 `CGSize(width: 250, height: 250)`
    /// - Returns: 包含四种角色颜色的 `SoloColorPalette`若分析失败,返回默认黑白组合
    ///
    /// - Example:
    ///   ```swift
    ///   if let image = UIImage(named: "avatar") {
    ///       let palette = image.solo_analyzeColors(maxSize: CGSize(width: 100, height: 100))
    ///       view.backgroundColor = palette.background
    ///   }
    ///   ```
    func solo_analyzeColors(maxSize: CGSize = CGSize(width: 250, height: 250)) -> SoloColorPalette {
        guard let cgImage = self.cgImage else {
            let fallbackColor = UIColor.black
            return SoloColorPalette(
                background: fallbackColor,
                primary: .white,
                secondary: .white,
                detail: .white
            )
        }

        // 计算缩放尺寸,保持宽高比,且不超过 maxSize
        let scale = min(maxSize.width / self.size.width, maxSize.height / self.size.height, 1.0)
        let targetSize = CGSize(
            width: self.size.width * scale,
            height: self.size.height * scale
        )

        // 创建位图上下文(RGBA8,Premultiplied Last,即 BGRA)
        let width = Int(targetSize.width)
        let height = Int(targetSize.height)
        guard width > 0, height > 0 else {
            let fallback = UIColor.black
            return SoloColorPalette(background: fallback, primary: .white, secondary: .white, detail: .white)
        }

        let bytesPerRow = width * 4
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: bitmapInfo
        ) else {
            let fallback = UIColor.black
            return SoloColorPalette(background: fallback, primary: .white, secondary: .white, detail: .white)
        }

        let rect = CGRect(origin: .zero, size: targetSize)
        context.draw(cgImage, in: rect)

        guard let data = context.data else {
            let fallback = UIColor.black
            return SoloColorPalette(background: fallback, primary: .white, secondary: .white, detail: .white)
        }

        let pixelData = data.bindMemory(to: UInt8.self, capacity: bytesPerRow * height)

        // 用于统计所有颜色
        let allColors = NSCountedSet()
        // 用于统计边缘颜色(背景候选)
        let edgeColors = NSCountedSet()

        let edgeMargin = max(1, min(5, width / 10)) // 动态边缘宽度

        for y in 0 ..< height {
            for x in 0 ..< width {
                let offset = (y * width + x) * 4
                let red = CGFloat(pixelData[offset]) / 255.0
                let green = CGFloat(pixelData[offset + 1]) / 255.0
                let blue = CGFloat(pixelData[offset + 2]) / 255.0
                // 忽略 alpha,统一设为 1.0(因已 premultiplied)
                let color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

                allColors.add(color)

                // 采样四周边缘像素作为背景候选
                if x < edgeMargin || x >= width - edgeMargin ||
                    y < edgeMargin || y >= height - edgeMargin
                {
                    edgeColors.add(color)
                }
            }
        }

        /// 辅助函数：判断是否为黑白
        func isBlackOrWhite(_ color: UIColor) -> Bool {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let gray = 0.299 * r + 0.587 * g + 0.114 * b
            return gray < 0.1 || gray > 0.9
        }

        /// 辅助函数：判断是否为深色
        func isDark(_ color: UIColor) -> Bool {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getRed(&r, green: &g, blue: &b, alpha: &a)
            let luminance = 0.299 * r + 0.587 * g + 0.114 * b
            return luminance < 0.5
        }

        /// 辅助函数：判断两种颜色是否足够区分
        func isDistinct(_ c1: UIColor, _ c2: UIColor) -> Bool {
            var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0
            var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0
            c1.getRed(&r1, green: &g1, blue: &b1, alpha: nil)
            c2.getRed(&r2, green: &g2, blue: &b2, alpha: nil)
            let dr = r1 - r2, dg = g1 - g2, db = b1 - b2
            return sqrt(dr * dr + dg * dg + db * db) > 0.2
        }

        /// 辅助函数：判断颜色与背景是否有足够对比度
        func hasContrast(_ color: UIColor, against background: UIColor) -> Bool {
            var r1: CGFloat = 0, g1: CGFloat = 0, b1: CGFloat = 0
            var r2: CGFloat = 0, g2: CGFloat = 0, b2: CGFloat = 0
            color.getRed(&r1, green: &g1, blue: &b1, alpha: nil)
            background.getRed(&r2, green: &g2, blue: &b2, alpha: nil)
            let l1 = 0.299 * r1 + 0.587 * g1 + 0.114 * b1
            let l2 = 0.299 * r2 + 0.587 * g2 + 0.114 * b2
            return (l1 - l2).solo_abs() > 0.3
        }

        // 筛选背景色：从边缘颜色中找出现频率最高的非随机色
        let minEdgeCount = max(1, Int(Double(edgeColors.count) * 0.02))
        var backgroundCandidates: [SoloCountedColor] = []

        for obj in edgeColors {
            guard let color = obj as? UIColor else { continue }
            let count = edgeColors.count(for: color)
            if count >= minEdgeCount {
                backgroundCandidates.append(SoloCountedColor(color: color, count: count))
            }
        }

        backgroundCandidates.sort { $0.count > $1.count }

        var backgroundColor = backgroundCandidates.first?.color ?? UIColor.black

        // 如果首选是黑白,尝试找一个非黑白的次选
        if isBlackOrWhite(backgroundColor), !backgroundCandidates.isEmpty {
            for candidate in backgroundCandidates {
                if !isBlackOrWhite(candidate.color) {
                    backgroundColor = candidate.color
                    break
                }
            }
        }

        let isDarkBG = isDark(backgroundColor)

        // 筛选前景色：与背景明暗相反,且非边缘主导色
        var foregroundCandidates: [SoloCountedColor] = []
        let minForegroundCount = max(1, Int(Double(allColors.count) * 0.01))

        for obj in allColors {
            guard let color = obj as? UIColor else { continue }
            let count = allColors.count(for: color)
            if count >= minForegroundCount, isDark(color) != isDarkBG {
                foregroundCandidates.append(SoloCountedColor(color: color, count: count))
            }
        }

        foregroundCandidates.sort { $0.count > $1.count }

        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        let whiteColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let fallbackColor = isDarkBG ? whiteColor : blackColor

        var primary: UIColor?
        var secondary: UIColor?
        var detail: UIColor?

        for candidate in foregroundCandidates {
            let color = candidate.color
            if primary == nil, hasContrast(color, against: backgroundColor) {
                primary = color
            } else if secondary == nil,
                      let p = primary,
                      isDistinct(color, p),
                      hasContrast(color, against: backgroundColor)
            {
                secondary = color
            } else if detail == nil,
                      let s = secondary,
                      let p = primary,
                      isDistinct(color, s),
                      isDistinct(color, p),
                      hasContrast(color, against: backgroundColor)
            {
                detail = color
                break
            }
        }

        return SoloColorPalette(
            background: backgroundColor,
            primary: primary ?? fallbackColor,
            secondary: secondary ?? fallbackColor,
            detail: detail ?? fallbackColor
        )
    }

    /// 异步提取图片的主题色(出现频率最高的非黑白、非透明色)
    ///
    /// 内部会将图片缩放到 40x40 以加速计算
    ///
    /// - Parameter completion: 回调返回主题色,若失败则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   image.solo_extractThemeColor { color in
    ///       DispatchQueue.main.async {
    ///           self.titleLabel.textColor = color ?? .label
    ///       }
    ///   }
    ///   ```
    func solo_extractThemeColor(_ completion: @escaping SoloAction1<UIColor?>) {
        guard let cgImage = self.cgImage else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            let thumbSize = CGSize(width: 40, height: 40)
            let width = Int(thumbSize.width)
            let height = Int(thumbSize.height)
            let bytesPerRow = width * 4
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue

            guard let context = CGContext(
                data: nil,
                width: width,
                height: height,
                bitsPerComponent: 8,
                bytesPerRow: bytesPerRow,
                space: colorSpace,
                bitmapInfo: bitmapInfo
            ) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            context.draw(cgImage, in: CGRect(origin: .zero, size: thumbSize))
            guard let data = context.data else {
                DispatchQueue.main.async { completion(nil) }
                return
            }

            let pixelData = data.bindMemory(to: UInt8.self, capacity: bytesPerRow * height)
            let countedColors = NSCountedSet()

            for y in 0 ..< height {
                for x in 0 ..< width {
                    let offset = (y * width + x) * 4
                    let alpha = pixelData[offset + 3]
                    if alpha < 10 {
                        continue
                    } // 忽略透明像素

                    let red = Int(pixelData[offset])
                    let green = Int(pixelData[offset + 1])
                    let blue = Int(pixelData[offset + 2])

                    // 过滤近黑白
                    if (red > 240 && green > 240 && blue > 240) || (red < 15 && green < 15 && blue < 15) {
                        continue
                    }

                    // 使用整数数组作为哈希键(比 UIColor 更高效)
                    let colorKey = [red, green, blue]
                    countedColors.add(colorKey)
                }
            }

            var bestColor: [Int]?
            var maxCount = 0

            for obj in countedColors {
                if let key = obj as? [Int], key.count == 3 {
                    let count = countedColors.count(for: key)
                    if count > maxCount {
                        maxCount = count
                        bestColor = key
                    }
                }
            }

            var result: UIColor?
            if let best = bestColor {
                result = UIColor(
                    red: CGFloat(best[0]) / 255.0,
                    green: CGFloat(best[1]) / 255.0,
                    blue: CGFloat(best[2]) / 255.0,
                    alpha: 1.0
                )
            }

            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    /// 同步获取图片的平均颜色(基于 Core Image 的 CIAreaAverage 滤镜)
    ///
    /// 此方法优先使用现有的 CIImage,若不存在则尝试从 CGImage 构建
    /// 结果基于 sRGB 颜色空间计算,确保跨设备一致性
    ///
    /// - Returns: 平均颜色;若图片无效或处理失败,返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let avgColor = image.solo_averageColor() {
    ///       view.backgroundColor = avgColor
    ///   }
    ///   ```
    func solo_averageColor() -> UIColor? {
        // 尝试获取有效的 CIImage
        var ciImage: CIImage?
        if let existingCI = self.ciImage {
            ciImage = existingCI
        } else if let cg = self.cgImage {
            ciImage = CIImage(cgImage: cg)
        }

        guard let inputCI = ciImage else {
            return nil // 无法构建 CIImage
        }

        // 使用 CIAreaAverage 计算整图平均色
        guard let filter = CIFilter(name: "CIAreaAverage") else {
            return nil
        }
        filter.setValue(inputCI, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: inputCI.extent), forKey: kCIInputExtentKey)

        guard let outputImage = filter.outputImage,
              !outputImage.extent.isEmpty
        else {
            return nil
        }

        // 复用共享 CIContext(线程安全)
        var bitmap = [UInt8](repeating: 0, count: 4)
        solo_sharedCIContext.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        // 检查 alpha 是否有效(避免全透明)
        let alpha = CGFloat(bitmap[3]) / 255.0
        if alpha <= 0 {
            return nil
        }

        return UIColor(
            red: CGFloat(bitmap[0]) / 255.0,
            green: CGFloat(bitmap[1]) / 255.0,
            blue: CGFloat(bitmap[2]) / 255.0,
            alpha: alpha
        )
    }

    /// 获取图片指定坐标处的像素颜色(同步)
    ///
    /// - Note: 坐标基于图片的自然尺寸(`size`),原点在左上角
    /// - Warning: 若图片无 `cgImage`(如 PDF、纯色图),返回 `nil`
    ///
    /// - Parameter point: 图片上的点(单位：point)
    /// - Returns: 该点的颜色,若坐标越界或无法读取则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   if let color = image.solo_color(at: CGPoint(x: 10, y: 20)) {
    ///       print("Color: \(color)")
    ///   }
    ///   ```
    func solo_color(at point: CGPoint) -> UIColor? {
        guard let cgImage = self.cgImage else { return nil }
        guard point.x >= 0, point.y >= 0, point.x < self.size.width, point.y < self.size.height else {
            return nil
        }

        // 将 point 转换为像素坐标(考虑 scale)
        let scaleX = CGFloat(cgImage.width) / self.size.width
        let scaleY = CGFloat(cgImage.height) / self.size.height
        let pixelX = Int(point.x * scaleX)
        let pixelY = Int(point.y * scaleY)

        // 注意：CGImage 像素原点在左下角,需翻转 Y
        let flippedY = cgImage.height - 1 - pixelY
        guard pixelX >= 0, pixelX < cgImage.width, flippedY >= 0, flippedY < cgImage.height else {
            return nil
        }

        let bytesPerRow = cgImage.bytesPerRow
        let bitsPerPixel = cgImage.bitsPerPixel
        let bytesPerPixel = bitsPerPixel / 8

        guard let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data,
              let ptr = CFDataGetBytePtr(data)
        else {
            return nil
        }

        let pixelOffset = flippedY * bytesPerRow + pixelX * bytesPerPixel

        // 支持 RGBA 或 BGRA(常见情况)
        let alphaInfo = cgImage.alphaInfo
        let isBGRA = alphaInfo == .premultipliedLast || alphaInfo == .last

        let r: UInt8, g: UInt8, b: UInt8, a: UInt8
        if isBGRA {
            b = ptr[pixelOffset]
            g = ptr[pixelOffset + 1]
            r = ptr[pixelOffset + 2]
            a = ptr[pixelOffset + 3]
        } else {
            r = ptr[pixelOffset]
            g = ptr[pixelOffset + 1]
            b = ptr[pixelOffset + 2]
            a = ptr[pixelOffset + 3]
        }

        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(a) / 255.0
        )
    }

    /// 异步获取图片指定坐标处的像素颜色
    ///
    /// - Parameter point: 图片上的点(单位：point)
    /// - Parameter completion: 回调返回颜色或 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   image.solo_color(at: CGPoint(x: 50, y: 50)) { color in
    ///       DispatchQueue.main.async {
    ///           self.indicatorView.backgroundColor = color
    ///       }
    ///   }
    ///   ```
    func solo_color(at point: CGPoint, completion: @escaping SoloAction1<UIColor?>) {
        DispatchQueue.global(qos: .userInteractive).async {
            let color = self.solo_color(at: point)
            DispatchQueue.main.async {
                completion(color)
            }
        }
    }
}

// MARK: - 颜色调整
public extension UIImage {
    /// 修改图像的渲染模式
    /// - Parameter renderingMode: 目标渲染模式(如 `.alwaysTemplate`)
    /// - Returns: 应用新渲染模式后的 `UIImage`
    func solo_renderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self.withRenderingMode(renderingMode)
    }

    /// 使用指定颜色对图像进行着色(适用于模板图像)
    /// - Parameters:
    ///   - color: 目标着色颜色
    ///   - renderingMode: 渲染模式,默认为 `.alwaysOriginal`(若需模板着色,应传 `.alwaysTemplate`)
    /// - Returns: 着色后的新图像;若失败则返回原图
    ///
    /// > ⚠️ 注意：此方法在 iOS 13+ 才可用低版本请使用 `tint` 或确保图像为 `.alwaysTemplate` 模式
    func solo_tintColor(with color: UIColor, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage {
        return self.withTintColor(color).withRenderingMode(renderingMode)
    }

    /// 为 SF Symbol 图像应用符号配置(如粗细、层级、尺寸等)
    /// - Parameter configuration: 符号配置对象
    /// - Returns: 应用配置后的新图像;若失败返回 `nil`
    func solo_symbolConfiguration(_ configuration: UIImage.SymbolConfiguration) -> UIImage? {
        return self.withConfiguration(configuration)
    }

    /// 设置图像的整体透明度(Alpha 值)
    /// - Parameter alpha: 透明度值,范围 0.0(完全透明)到 1.0(完全不透明)
    /// - Returns: 透明度调整后的新图像;若失败返回原图
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "example.png")
    ///   let newImage = image?.solo_imageAlpha(0.5)
    ///   // newImage: 透明度为 50% 的图像
    ///   ```
    func solo_imageAlpha(_ alpha: CGFloat) -> UIImage {
        // 边界检查
        guard alpha >= 0.0, alpha <= 1.0 else { return self }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            self.draw(at: .zero, blendMode: .normal, alpha: alpha)
        }
    }

    /// 使用指定颜色填充图像的不透明区域(常用于图标着色)
    /// - Parameter color: 填充颜色
    /// - Returns: 填充后的新图像;若失败返回原图
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "icon")?.withRenderingMode(.alwaysTemplate)
    ///   let filled = image?.solo_filled(with: .red)
    ///   ```
    func solo_filled(with color: UIColor) -> UIImage {
        guard let cgImage = self.cgImage else { return self }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            // 先绘制原始图像作为遮罩(仅取 Alpha 通道)
            context.cgContext.clip(to: CGRect(origin: .zero, size: self.size), mask: cgImage)
            // 再用指定颜色填充裁剪区域
            color.setFill()
            context.fill(CGRect(origin: .zero, size: self.size))
        }
    }

    /// 为图像添加纯色背景(保留原图内容,下方叠加背景色)
    /// - Parameter color: 背景颜色
    /// - Returns: 带背景色的新图像;若失败返回原图
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "logo-transparent.png")
    ///   let withBg = image?.solo_backgroundColor(.systemBlue)
    ///   ```
    func solo_backgroundColor(_ color: UIColor) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            color.setFill()
            context.fill(context.format.bounds)
            self.draw(at: .zero)
        }
    }

    /// 使用指定颜色与混合模式对图像进行着色(高级自定义效果)
    /// - Parameters:
    ///   - color: 着色底色
    ///   - blendMode: 混合模式(如 `.multiply`, `.overlay` 等)
    ///   - alpha: 绘制时的透明度(默认 1.0)
    /// - Returns: 着色后的新图像;若失败返回原图
    ///
    /// - Example:
    ///   ```swift
    ///   let image = UIImage(named: "texture.png")
    ///   let tinted = image?.solo_tint(.red, blendMode: .multiply)
    ///   ```
    func solo_tint(_ color: UIColor, blendMode: CGBlendMode, alpha: CGFloat = 1.0) -> UIImage {
        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            // 先绘制底色
            color.setFill()
            context.fill(CGRect(origin: .zero, size: self.size))
            // 再以指定混合模式叠加原图
            self.draw(in: CGRect(origin: .zero, size: self.size), blendMode: blendMode, alpha: alpha)
        }
    }
}

// MARK: - 背景透明化
public extension UIImage {
    /// 移除接近白色的背景,使其变为透明
    /// - Returns: 白色背景区域透明化后的新图像;若失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let logo = UIImage(named: "company_logo")
    ///   let transparentLogo = logo?.solo_removeWhiteBackground()
    ///   ```
    func solo_removeWhiteBackground() -> UIImage? {
        // 允许一定容差(222～255 表示浅灰到纯白)
        let colorRange: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return self.solo_makeBackgroundTransparent(colorRange: colorRange)
    }

    /// 移除接近黑色的背景,使其变为透明
    /// - Returns: 黑色背景区域透明化后的新图像;若失败返回 `nil`
    func solo_removeBlackBackground() -> UIImage? {
        // 容差范围：0～32(深灰到纯黑)
        let colorRange: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return self.solo_makeBackgroundTransparent(colorRange: colorRange)
    }

    /// 将指定 RGB 范围内的像素设为透明
    /// - Parameter colorRange: `[Rmin, Rmax, Gmin, Gmax, Bmin, Bmax]`,每个分量 0～255
    /// - Returns: 透明化后的新图像;若输入无效或处理失败,返回 `nil`
    private func solo_makeBackgroundTransparent(colorRange: [CGFloat]) -> UIImage? {
        guard colorRange.count == 6,
              let cgImage = self.cgImage,
              let maskedCGImage = cgImage.copy(maskingColorComponents: colorRange)
        else {
            return nil
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            // Core Graphics 原点在左下,UIKit 在左上 → 需翻转 Y 轴
            context.cgContext.translateBy(x: 0, y: self.size.height)
            context.cgContext.scaleBy(x: 1, y: -1)
            context.cgContext.draw(maskedCGImage, in: CGRect(origin: .zero, size: self.size))
        }
    }
}

// MARK: - 特效处理
public extension UIImage {
    /// 应用高斯模糊效果
    /// - Parameter radius: 模糊半径(建议 0～100),默认 20
    /// - Returns: 模糊后的新图像;若失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let portrait = UIImage(named: "profile")
    ///   let blurred = portrait?.solo_gaussianBlur(radius: 15)
    ///   ```
    func solo_gaussianBlur(radius: CGFloat = 20) -> UIImage? {
        guard radius >= 0 else { return nil }
        return self.solo_applyCoreImageFilter(filterName: "CIGaussianBlur", parameters: [kCIInputRadiusKey: radius])
    }

    /// 应用像素化(马赛克)效果
    /// - Parameter scale: 像素块大小(越大越模糊),默认 20
    /// - Returns: 像素化后的新图像;若失败返回 `nil`
    func solo_pixelation(scale: CGFloat = 20) -> UIImage? {
        guard scale > 0 else { return nil }
        return self.solo_applyCoreImageFilter(filterName: "CIPixellate", parameters: [kCIInputScaleKey: scale])
    }

    /// 通用 Core Image 滤镜应用方法
    /// - Parameters:
    ///   - filterName: CIFilter 名称(如 "CIGaussianBlur")
    ///   - parameters: 滤镜参数字典
    /// - Returns: 处理后的新图像;若失败返回 `nil`
    private func solo_applyCoreImageFilter(filterName: String, parameters: [String: Any]) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }

        // 合并用户参数与输入图像
        var finalParams = parameters
        finalParams[kCIInputImageKey] = ciImage

        guard let filter = CIFilter(name: filterName, parameters: finalParams),
              let outputImage = filter.outputImage
        else {
            return nil
        }

        // 使用共享 CIContext 提升性能(线程安全)
        guard let cgImage = solo_sharedCIContext.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        // 根据原始 UIImage 的 scale 和 orientation 创建新的 UIImage
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

// MARK: - 滤镜效果
public extension UIImage {
    /// 内置照片滤镜类型
    enum SoloPhotoFilter {
        case sepia(intensity: CGFloat = 1.0) // 棕褐色调
        case noir // 黑白胶片
        case vignette(intensity: CGFloat = 1.0, radius: CGFloat = 1.0) // 暗角
        case tonal // 单色调(灰阶艺术感)
    }

    /// 应用指定滤镜效果
    /// - Parameter filter: 要应用的滤镜
    /// - Returns: 滤镜处理后的新图像;若失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let photo = UIImage(named: "vacation")
    ///   let vintagePhoto = photo?.solo_filter(.sepia(intensity: 0.8))
    ///   ```
    func solo_filter(_ filter: SoloPhotoFilter) -> UIImage? {
        let filterName: String
        var parameters: [String: Any] = [:]

        switch filter {
        case let .sepia(intensity):
            filterName = "CISepiaTone"
            parameters[kCIInputIntensityKey] = max(0, min(1, intensity)) // 限制 0～1
        case .noir:
            filterName = "CIPhotoEffectNoir"
        case let .vignette(intensity, radius):
            filterName = "CIVignette"
            parameters[kCIInputIntensityKey] = intensity
            parameters[kCIInputRadiusKey] = radius
        case .tonal:
            filterName = "CIPhotoEffectTonal"
        }

        return self.solo_applyCoreImageFilter(filterName: filterName, parameters: parameters)
    }
}

// MARK: - 人脸处理
public extension UIImage {
    /// 检测图像中的人脸位置
    /// - Returns: 人脸边界框数组(UIKit 坐标系,原点左上);若无结果或失败返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let groupPhoto = UIImage(named: "team")
    ///   let faces = groupPhoto?.solo_detectFaces()
    ///   ```
    func solo_detectFaces() -> [CGRect]? {
        guard let ciImage = CIImage(image: self) else { return nil }

        let options: [String: Any] = [
            CIDetectorAccuracy: CIDetectorAccuracyHigh,
        ]

        guard let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options) else {
            return nil
        }

        let features = detector.features(in: ciImage)

        // 将 Core Image 坐标(原点左下)转换为 UIKit 坐标(原点左上)
        return features.compactMap { feature in
            var rect = feature.bounds
            rect.origin.y = self.size.height - rect.maxY
            return rect
        }
    }

    /// 对检测到的人脸区域应用马赛克(像素化)效果
    /// - Parameter pixelScale: 像素块大小,默认 10.0
    /// - Returns: 人脸打码后的新图像;若无人脸或失败,返回原图
    func solo_pixelateFaces(pixelScale: CGFloat = 10.0) -> UIImage? {
        guard pixelScale > 0,
              let ciImage = CIImage(image: self),
              let faces = self.solo_detectFaces(),
              !faces.isEmpty
        else {
            return self
        }

        // 创建全图马赛克版本
        guard let pixelFilter = CIFilter(name: "CIPixellate") else { return self }
        pixelFilter.setValue(ciImage, forKey: kCIInputImageKey)
        pixelFilter.setValue(pixelScale, forKey: kCIInputScaleKey)
        guard let pixelatedImage = pixelFilter.outputImage else { return self }

        // 创建人脸区域的合成蒙版(白色为人脸,黑色为其他)
        let maskSize = ciImage.extent.size
        let white = CIColor(red: 1, green: 1, blue: 1)
        let black = CIColor(red: 0, green: 0, blue: 0)

        var compositeMask: CIImage?

        for faceRect in faces {
            let center = CIVector(x: faceRect.midX, y: faceRect.midY)
            let radius = max(faceRect.width, faceRect.height) * 0.6 // 稍微扩大覆盖

            guard let radial = CIFilter(name: "CIRadialGradient",
                                        parameters: [
                                            "inputCenter": center,
                                            "inputRadius0": 0,
                                            "inputRadius1": radius,
                                            "inputColor0": white,
                                            "inputColor1": black,
                                        ]) else { continue }

            let gradient = radial.outputImage?.cropped(to: CGRect(origin: .zero, size: maskSize)) ?? CIImage(color: black)

            if compositeMask == nil {
                compositeMask = gradient
            } else {
                // 使用最大值合并多个圆形蒙版
                guard let blend = CIFilter(name: "CIMaximumComponent") else { continue }
                blend.setValue(compositeMask, forKey: kCIInputImageKey)
                blend.setValue(gradient, forKey: kCIInputBackgroundImageKey)
                compositeMask = blend.outputImage
            }
        }

        // 若未生成有效蒙版,直接返回原图
        guard let finalMask = compositeMask else { return self }

        // 使用蒙版混合：原图(背景) + 马赛克图(前景)
        guard let blendFilter = CIFilter(name: "CIBlendWithMask") else { return self }
        blendFilter.setValue(pixelatedImage, forKey: kCIInputImageKey)
        blendFilter.setValue(ciImage, forKey: kCIInputBackgroundImageKey)
        blendFilter.setValue(finalMask, forKey: kCIInputMaskImageKey)

        guard let outputImage = blendFilter.outputImage else { return self }

        // 渲染为 UIImage
        guard let cgImage = solo_sharedCIContext.createCGImage(outputImage, from: ciImage.extent) else {
            return self
        }

        return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

// MARK: - 渐变图像
public extension UIImage {
    /// 渐变方向选项
    enum SoloGradientDirection {
        case horizontal // 左 → 右
        case vertical // 上 → 下
        case diagonalTopLeftToBottomRight // ↘
        case diagonalTopRightToBottomLeft // ↙
        case custom(start: CGPoint, end: CGPoint) // 自定义

        /// 根据尺寸计算起点和终点
        func points(for size: CGSize) -> (start: CGPoint, end: CGPoint) {
            switch self {
            case .horizontal:
                return (.zero, CGPoint(x: size.width, y: 0))
            case .vertical:
                return (.zero, CGPoint(x: 0, y: size.height))
            case .diagonalTopLeftToBottomRight:
                return (.zero, CGPoint(x: size.width, y: size.height))
            case .diagonalTopRightToBottomLeft:
                return (CGPoint(x: size.width, y: 0), CGPoint(x: 0, y: size.height))
            case let .custom(start, end):
                return (start, end)
            }
        }
    }

    /// 创建线性渐变图像
    /// - Parameters:
    ///   - colors: 至少一个颜色
    ///   - size: 图像尺寸,默认 1x1(可拉伸)
    ///   - cornerRadius: 圆角半径,默认 0(直角)
    ///   - locations: 颜色分布位置(0.0～1.0),可选
    ///   - direction: 渐变方向,默认水平
    /// - Returns: 渐变图像;若颜色为空返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let gradient = UIImage.solo_gradientImage(
    ///       colors: [.red, .blue],
    ///       size: CGSize(width: 100, height: 100),
    ///       cornerRadius: 10
    ///   )
    ///   ```
    static func solo_gradientImage(
        colors: [UIColor],
        size: CGSize = CGSize(width: 1, height: 1),
        cornerRadius: CGFloat = 0,
        locations: [CGFloat]? = nil,
        direction: SoloGradientDirection = .horizontal
    ) -> UIImage? {
        guard !colors.isEmpty else { return nil }

        // 单色直接返回纯色图(带圆角)
        if colors.count == 1 {
            return UIImage(color: colors[0], size: size, cornerRadius: cornerRadius)
        }

        let format = UIGraphicsImageRendererFormat.default()
        format.scale = SoloScreen.screenScale // 使用主屏缩放,适合 UI 资源
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { context in
            // 应用圆角裁剪
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            path.addClip()

            // 构建 CGGradient
            guard let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map(\.cgColor) as CFArray,
                locations: locations?.map { min(max($0, 0), 1) } // 限制 0～1
            ) else { return }

            let (startPoint, endPoint) = direction.points(for: size)
            context.cgContext.drawLinearGradient(
                gradient,
                start: startPoint,
                end: endPoint,
                options: [.drawsBeforeStartLocation, .drawsAfterEndLocation]
            )
        }
    }
}

// MARK: - 图像加载(仅限本地资源)
public extension UIImage {
    /// 从本地资源名称加载静态图像
    ///
    /// 此方法从主 `Bundle` 中查找指定名称的图像资源(支持 Asset Catalog 和文件系统)
    /// 若资源不存在,返回 `nil`
    ///
    /// - Parameter name: 图像资源名称(不含扩展名)
    /// - Returns: 加载成功的 `UIImage`,若资源不存在则返回 `nil`
    ///
    /// - Note: 不支持网络 URL如需加载网络图像,请使用 `URLSession` 获取 `Data` 后调用 `UIImage(data:)`
    ///
    /// - Example:
    ///   ```swift
    ///   let icon = UIImage.solo_fromResource(named: "app_icon")
    ///   ```
    static func solo_fromResource(named name: String) -> UIImage? {
        guard !name.isEmpty else { return nil }
        return UIImage(named: name)
    }

    /// 从本地文件路径加载静态图像
    ///
    /// 支持绝对路径(如 Documents 目录下的文件)路径必须指向有效的图像文件
    ///
    /// - Parameter path: 图像文件的绝对路径
    /// - Returns: 加载成功的 `UIImage`,若路径无效或文件损坏则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    ///   let imagePath = (documentsPath as NSString).appendingPathComponent("photo.jpg")
    ///   let image = UIImage.solo_fromFile(at: imagePath)
    ///   ```
    static func solo_fromFile(at path: String) -> UIImage? {
        guard !path.isEmpty, FileManager.default.fileExists(atPath: path) else { return nil }
        return UIImage(contentsOfFile: path)
    }
}

// MARK: - GIF 动画支持
public extension UIImage {
    /// GIF 资源来源类型
    ///
    /// 用于指定 GIF 数据的获取方式,支持从 `Data`、`Bundle` 资源或 `NSDataAsset` 加载
    enum SoloGIFSource {
        /// 直接提供 GIF 的原始数据
        case data(Data)
        /// 从主 Bundle 中按名称加载(自动附加 `.gif` 扩展名)
        case resource(String)
        /// 从 `NSDataAsset` 加载(需在 Asset Catalog 中配置 Data Set)
        case asset(String)
    }

    /// 从指定来源创建 GIF 动画图像
    ///
    /// 解析 GIF 数据并生成 `UIImage` 动画对象若 GIF 无效、无帧或解析失败,返回 `nil`
    ///
    /// - Parameter source: GIF 资源来源
    /// - Returns: 动画图像对象,失败时返回 `nil`
    ///
    /// - Important: 此方法`不支持网络 URL`请先通过异步方式下载数据,再传入 `.data`
    ///
    /// - Example:
    ///   ```swift
    ///   let gif = UIImage.solo_animatedGIF(from: .resource("loading"))
    ///   imageView.image = gif
    ///   ```
    static func solo_animatedGIF(from source: SoloGIFSource) -> UIImage? {
        guard let data = self.solo_gifData(from: source) else { return nil }
        return self.solo_animatedGIF(from: data)
    }

    /// 从原始数据创建 GIF 动画图像
    ///
    /// - Parameter data: GIF 格式的原始二进制数据
    /// - Returns: 动画图像对象,失败时返回 `nil`
    private static func solo_animatedGIF(from data: Data) -> UIImage? {
        guard !data.isEmpty,
              let source = CGImageSourceCreateWithData(data as CFData, nil),
              let (images, duration) = self.solo_extractGIFFrames(from: source),
              !images.isEmpty
        else {
            return nil
        }
        return UIImage.animatedImage(with: images, duration: duration)
    }

    /// 从 `SoloGIFSource` 提取原始数据
    private static func solo_gifData(from source: SoloGIFSource) -> Data? {
        switch source {
        case let .data(data):
            return data.isEmpty ? nil : data

        case let .resource(name):
            guard !name.isEmpty,
                  let url = Bundle.main.url(forResource: name, withExtension: "gif"),
                  let data = try? Data(contentsOf: url)
            else {
                return nil
            }
            return data

        case let .asset(name):
            guard #available(iOS 14.0, *), // 与最低支持版本对齐
                  !name.isEmpty,
                  let asset = NSDataAsset(name: name),
                  !asset.data.isEmpty
            else {
                return nil
            }
            return asset.data
        }
    }

    /// 从 `CGImageSource` 提取所有 GIF 帧及其总播放时长
    ///
    /// - Parameter source: 已创建的 GIF 图像源
    /// - Returns: 包含帧图像数组和总时长的元组,若无有效帧则返回 `nil`
    private static func solo_extractGIFFrames(from source: CGImageSource) -> (images: [UIImage], duration: TimeInterval)? {
        let frameCount = CGImageSourceGetCount(source)
        guard frameCount > 0 else { return nil }

        var images: [UIImage] = []
        var totalDuration: TimeInterval = 0

        for index in 0 ..< frameCount {
            guard let cgImage = CGImageSourceCreateImageAtIndex(source, index, nil) else {
                continue
            }

            let delay = self.solo_gifFrameDelay(from: source, at: index)
            totalDuration += max(delay, 0.01) // 防止零延迟导致播放异常

            images.append(UIImage(cgImage: cgImage))
        }

        return images.isEmpty ? nil : (images, totalDuration)
    }

    /// 获取 GIF 指定帧的显示延迟时间(秒)
    ///
    /// 优先读取 `kCGImagePropertyGIFUnclampedDelayTime`,其次 `kCGImagePropertyGIFDelayTime`
    /// 若均未设置,默认返回 0.1 秒
    ///
    /// - Parameters:
    ///   - source: GIF 图像源
    ///   - index: 帧索引(从 0 开始)
    /// - Returns: 延迟时间(秒)
    private static func solo_gifFrameDelay(from source: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [String: Any],
              let gifDict = properties[kCGImagePropertyGIFDictionary as String] as? [String: Any]
        else {
            return 0.1
        }

        // 注意：GIF 规范中 delay time 原始单位为 1/100 秒,ImageIO 读取时已转换为秒返回
        if let unclamped = gifDict[kCGImagePropertyGIFUnclampedDelayTime as String] as? Double, unclamped > 0 {
            return unclamped
        }
        if let clamped = gifDict[kCGImagePropertyGIFDelayTime as String] as? Double, clamped > 0 {
            return clamped
        }
        return 0.1
    }
}

// MARK: - 水印处理
public extension UIImage {
    /// 水印位置枚举
    ///
    /// 支持预设位置(如左上、右下、居中)或自定义坐标点
    enum SoloWatermarkPosition {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
        case center
        case custom(CGPoint)

        /// 根据目标尺寸、图像尺寸和边距计算水印矩形区域
        ///
        /// - Parameters:
        ///   - size: 水印内容的尺寸(文本或图像)
        ///   - imageSize: 背景图像的尺寸
        ///   - margin: 边距
        /// - Returns: 水印应绘制的 `CGRect`
        func rect(forSize size: CGSize, inImageSize imageSize: CGSize, margin: CGFloat) -> CGRect {
            let x: CGFloat
            let y: CGFloat

            switch self {
            case .topLeft:
                x = margin
                y = margin
            case .topRight:
                x = imageSize.width - size.width - margin
                y = margin
            case .bottomLeft:
                x = margin
                y = imageSize.height - size.height - margin
            case .bottomRight:
                x = imageSize.width - size.width - margin
                y = imageSize.height - size.height - margin
            case .center:
                x = (imageSize.width - size.width) / 2
                y = (imageSize.height - size.height) / 2
            case let .custom(point):
                x = point.x
                y = point.y
            }

            // 防止负坐标(极端小图或大边距)
            let clampedX = max(0, x)
            let clampedY = max(0, y)
            return CGRect(x: clampedX, y: clampedY, width: size.width, height: size.height)
        }
    }

    /// 为图像添加文字水印
    ///
    /// 此方法在保留原始图像的基础上,叠加指定文字水印,并支持自定义位置、边距和文本样式
    ///
    /// - Parameters:
    ///   - text: 水印文字内容若为空字符串,则不绘制水印
    ///   - attributes: 文字属性字典(如字体、颜色等)若为 `nil`,使用系统默认样式
    ///   - position: 水印位置,默认为 `.bottomRight`
    ///   - margin: 水印与图像边缘的间距(单位：点),默认为 `20`
    /// - Returns: 添加水印后的新图像若输入无效,返回原始图像
    ///
    /// - Example:
    ///   ```swift
    ///   let attributes: [NSAttributedString.Key: Any] = [
    ///       .font: UIFont.boldSystemFont(ofSize: 36),
    ///       .foregroundColor: UIColor.white.withAlphaComponent(0.8),
    ///       .backgroundColor: UIColor.black.withAlphaComponent(0.3)
    ///   ]
    ///   let result = image.solo_addTextWatermark(
    ///       text: "机密",
    ///       attributes: attributes,
    ///       position: .topLeft,
    ///       margin: 16
    ///   )
    ///   ```
    func solo_addTextWatermark(
        text: String,
        attributes: [NSAttributedString.Key: Any]? = nil,
        position: SoloWatermarkPosition = .bottomRight,
        margin: CGFloat = 20
    ) -> UIImage {
        // 快速返回：空文本或无效尺寸
        guard !text.isEmpty, self.size.width > 0, self.size.height > 0 else {
            return self
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false // 支持透明背景
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            // 绘制原始图像
            self.draw(at: .zero)

            // 计算文本尺寸
            let textSize = text.size(withAttributes: attributes)
            guard textSize.width > 0, textSize.height > 0 else { return }

            // 计算水印位置
            let textRect = position.rect(forSize: textSize, inImageSize: self.size, margin: margin)
            text.draw(in: textRect, withAttributes: attributes)
        }
    }

    /// 为图像添加图片水印
    ///
    /// 在原始图像上叠加另一张图像作为水印,支持位置、边距和透明度控制
    ///
    /// - Parameters:
    ///   - watermarkImage: 水印图像若为 `nil` 或空尺寸,不绘制水印
    ///   - position: 水印位置,默认为 `.bottomRight`
    ///   - margin: 水印与图像边缘的间距(单位：点),默认为 `20`
    ///   - alpha: 水印透明度,取值范围 `[0.0, 1.0]`,默认为 `1.0`
    /// - Returns: 添加水印后的新图像若水印无效,返回原始图像
    ///
    /// - Example:
    ///   ```swift
    ///   let result = image.solo_addImageWatermark(
    ///       watermarkImage: logo,
    ///       position: .center,
    ///       margin: 0,
    ///       alpha: 0.6
    ///   )
    ///   ```
    func solo_addImageWatermark(
        watermarkImage: UIImage?,
        position: SoloWatermarkPosition = .bottomRight,
        margin: CGFloat = 20,
        alpha: CGFloat = 1.0
    ) -> UIImage {
        guard let watermarkImage,
              watermarkImage.size.width > 0,
              watermarkImage.size.height > 0,
              self.size.width > 0,
              self.size.height > 0
        else {
            return self
        }

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)

        return renderer.image { context in
            self.draw(at: .zero)

            let watermarkSize = watermarkImage.size
            let watermarkRect = position.rect(forSize: watermarkSize, inImageSize: self.size, margin: margin)
            watermarkImage.draw(in: watermarkRect, blendMode: .normal, alpha: min(max(alpha, 0), 1))
        }
    }

    /// 创建文字占位图像
    ///
    /// 常用于用户头像、缩略图等场景,用首字母或简写生成美观的占位图
    ///
    /// - Parameters:
    ///   - text: 显示的文字(建议 1～2 个字符)
    ///   - size: 图像尺寸(单位：点)
    ///   - backgroundColor: 背景色,默认为 `.systemGray`
    ///   - textColor: 文字颜色,默认为 `.white`
    ///   - font: 文字字体,默认为 `systemFont(ofSize: 24)`
    ///   - isCircular: 是否裁剪为圆形,默认为 `false`
    /// - Returns: 生成的占位图像,若尺寸无效则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let placeholder = UIImage.solo_placeholder(
    ///       with: "A",
    ///       size: CGSize(width: 60, height: 60),
    ///       isCircular: true
    ///   )
    ///   ```
    static func solo_placeholder(
        with text: String,
        size: CGSize,
        backgroundColor: UIColor = .systemGray,
        textColor: UIColor = .white,
        font: UIFont = .systemFont(ofSize: 24),
        isCircular: Bool = false
    ) -> UIImage? {
        guard size.width > 0, size.height > 0, !text.isEmpty else { return nil }

        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { _ in
            let bounds = CGRect(origin: .zero, size: size)

            // 绘制背景(圆形或矩形)
            let path: UIBezierPath = isCircular ? UIBezierPath(ovalIn: bounds) : UIBezierPath(rect: bounds)

            backgroundColor.setFill()
            path.fill()

            // 绘制文字
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
            ]

            let textSize = text.size(withAttributes: attributes)
            let origin = CGPoint(
                x: max(0, (size.width - textSize.width) / 2),
                y: max(0, (size.height - textSize.height) / 2)
            )

            text.draw(at: origin, withAttributes: attributes)
        }
    }
}

// MARK: - 实用功能
public extension UIImage {
    /// 将图像平铺至指定尺寸
    ///
    /// 适用于生成背景纹理、图案填充等场景
    ///
    /// - Parameter size: 目标尺寸(单位：点)
    /// - Returns: 平铺后的新图像
    ///
    /// - Example:
    ///   ```swift
    ///   let tiled = patternImage.solo_tiled(to: view.bounds.size)
    ///   ```
    func solo_tiled(to size: CGSize) -> UIImage {
        guard size.width > 0, size.height > 0 else { return self }

        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { _ in
            UIColor(patternImage: self).setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }

    /// 异步获取远程图像的原始尺寸(不下载完整图像)
    ///
    /// 利用 `ImageIO` 仅读取图像元数据,高效且节省流量
    ///
    /// - Parameters:
    ///   - url: 图像的网络地址
    ///   - maximumDimension: 可选的最大边长(保持宽高比缩放)若为 `nil`,返回原始尺寸
    /// - Returns: 图像尺寸(已应用最大边长限制),若解析失败返回 `.zero`
    ///
    /// - Warning: 此方法为同步阻塞调用,`不应在主线程执行`
    ///
    /// - Example:
    ///   ```swift
    ///   DispatchQueue.global().async {
    ///       let size = UIImage.solo_sizeOfRemoteImage(at: url, maximumDimension: 1024)
    ///       print("Image size: \(size)")
    ///   }
    ///   ```
    static func solo_sizeOfRemoteImage(at url: URL, maximumDimension: CGFloat? = nil) -> CGSize {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
              let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
              let height = properties[kCGImagePropertyPixelHeight] as? CGFloat,
              width > 0, height > 0
        else {
            return .zero
        }

        var size = CGSize(width: width, height: height)

        if let maxDim = maximumDimension, maxDim > 0 {
            let ratio = min(maxDim / size.width, maxDim / size.height)
            if ratio < 1 {
                size = CGSize(width: size.width * ratio, height: size.height * ratio)
            }
        }

        return size
    }
}
