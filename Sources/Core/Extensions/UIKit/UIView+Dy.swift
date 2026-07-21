import UIKit

public extension UIView {
    /// 水印配置
    struct DyWatermarkConfig {
        /// 水印文字
        let text: String
        /// 水印颜色
        let textColor: UIColor
        /// 水印字体
        let font: UIFont
        /// 水印密度
        let density: CGFloat
        /// 水印角度
        let angle: CGFloat
    }

    /// 截图选项
    struct DyScreenshotOptions {
        /// 是否使用屏幕缩放(默认 true)
        public var scaleToScreen: Bool = true
        /// 是否不透明(默认 false,即保留透明通道)
        public var opaque: Bool = false
        /// JPEG 压缩质量范围(仅对 JPEG 有效,默认 0.5...0.8)
        public var qualityRange: ClosedRange<CGFloat> = 0.5 ... 0.8

        public init() {}
    }

    /// 淡入淡出动画配置
    struct DyFadeAnimationOptions {
        /// 动画时长(默认 0.3 秒)
        public var duration: TimeInterval = 0.3
        /// 动画延迟(默认 0)
        public var delay: TimeInterval = 0
        /// 动画曲线(默认 `.easeInOut`)
        public var curve: UIView.AnimationCurve = .easeInOut
        /// 淡出完成后是否隐藏视图(仅淡出有效)
        public var hideOnCompletion: Bool = false
        /// 淡出完成后是否移除视图(仅淡出有效,优先级高于 `hideOnCompletion`)
        public var removeOnCompletion: Bool = false

        public init() {}
    }

    /// 粒子发射器配置
    struct DyEmitterConfig {
        /**------------------- 发射器属性 -------------------*/
        /// 发射器位置(`归一化坐标`,(0,0) 为左上,(1,1) 为右下;默认视图底部中心)
        public var position: CGPoint = .init(x: 0.5, y: 1.0)
        /// 发射器大小(默认 `.zero` 表示点发射器)
        public var size: CGSize = .zero
        /// 发射器形状(默认 `.line`)
        public var shape: CAEmitterLayerEmitterShape = .line
        /// 发射模式(默认 `.outline`)
        public var mode: CAEmitterLayerEmitterMode = .outline
        /// 是否开启三维深度效果(默认 `true`)
        public var preservesDepth: Bool = true
        /// 渲染模式(默认 `.oldestFirst`)
        public var renderMode: CAEmitterLayerRenderMode = .oldestFirst

        /**------------------- 粒子属性 -------------------*/
        /// 粒子图片名称数组(`必须提供有效 Asset 名称`)
        public var cellImages: [String] = []
        /// 粒子缩放比例(默认 `0.8`)
        public var scale: CGFloat = 0.8
        /// 缩放随机范围(默认 `0.3`)
        public var scaleRange: CGFloat = 0.3
        /// 生命周期(秒,默认 `5.0`)
        public var lifetime: Float = 5.0
        /// 生命周期随机范围(默认 `2.0`)
        public var lifetimeRange: Float = 2.0
        /// 出生率(每秒生成粒子数,默认 `15.0`)
        public var birthRate: Float = 15.0
        /// 粒子基础颜色(默认白色)
        public var color: UIColor = .white
        /// `颜色随机强度(0～1)`：控制 RGB 各通道的随机偏移幅度(默认 `0`)
        public var colorVariation: Float = 0.0
        /// 旋转速度(弧度/秒,默认 `π/4`)
        public var spin: CGFloat = .pi / 4
        /// 旋转随机范围(默认 `π/8`)
        public var spinRange: CGFloat = .pi / 8
        /// 初始速度(默认 `80`)
        public var velocity: CGFloat = 80
        /// 速度随机范围(默认 `40`)
        public var velocityRange: CGFloat = 40
        /// 发射基准角度(默认向上 `-π/2`)
        public var emissionLongitude: CGFloat = -.pi / 2
        /// 发射角度扩散范围(默认 `π/4`)
        public var emissionRange: CGFloat = .pi / 4
        /// X 轴加速度(默认 `0`)
        public var xAcceleration: CGFloat = 0
        /// Y 轴加速度(默认 `0`)
        public var yAcceleration: CGFloat = 0
        /// Z 轴加速度(默认 `0`)
        public var zAcceleration: CGFloat = 0
        /// 透明度变化速度(负值变透明,正值变实;默认 `0`)
        public var alphaSpeed: Float = 0
        /// 缩放变化速度(正值放大,负值缩小;默认 `0`)
        public var scaleSpeed: CGFloat = 0

        /// 是否只发射一次(发射后自动停止)
        public var fireOnce: Bool = false
        /// 自动移除时间(秒,`0` 表示不自动移除;若 `fireOnce = true`,此值会被忽略)
        public var autoRemoveAfter: TimeInterval = 0

        public init() {}
    }

    /// 抖动方向
    enum DyShakeDirection {
        /// 水平方向(左右抖动)
        case horizontal
        /// 垂直方向(上下抖动)
        case vertical
    }

    /// 抖动动画类型
    enum DyShakeAnimationType {
        /// 线性动画
        case linear
        /// 渐入动画
        case easeIn
        /// 渐出动画
        case easeOut
        /// 渐入渐出动画
        case easeInOut
        /// 弹簧效果动画(模拟弹性回弹)
        case spring
    }
}

extension UIView {
    /// 关联属性键
    struct AssociatedKeys {
        static var badgeLabel = UnsafeRawPointer(bitPattern: "UIView.badgeLabel".hashValue)!
        static var watermark = UnsafeRawPointer(bitPattern: "UIView.watermark".hashValue)!
    }

    /// 角标Label
    var badgeLabel: UILabel? {
        get { self.dy_getAssociatedObject(forKey: AssociatedKeys.badgeLabel) }
        set { self.dy_setAssociatedObject(newValue, forKey: AssociatedKeys.badgeLabel, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// 水印配置属性
    var watermarkConfig: DyWatermarkConfig? {
        get { self.dy_getAssociatedObject(forKey: AssociatedKeys.watermark) }
        set { self.dy_setAssociatedObject(newValue, forKey: AssociatedKeys.watermark, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: - 属性
public extension UIView {
    /// 视图的大小
    var dy_size: CGSize {
        get { return self.frame.size }
        set { self.frame = CGRect(origin: self.dy_origin, size: newValue) }
    }

    /// 视图的位置坐标
    var dy_origin: CGPoint {
        get { return self.frame.origin }
        set { self.frame = CGRect(origin: newValue, size: self.dy_size) }
    }

    /// 视图中心
    var dy_center: CGPoint {
        get { return self.center }
        set { self.center = newValue }
    }

    /// 视图的宽度
    var dy_width: CGFloat {
        get { return self.frame.width }
        set { self.frame = CGRect(origin: self.dy_origin, size: CGSize(width: newValue, height: self.dy_size.height)) }
    }

    /// 视图的高度
    var dy_height: CGFloat {
        get { return self.frame.height }
        set { self.frame = CGRect(origin: self.dy_origin, size: CGSize(width: self.dy_size.width, height: newValue)) }
    }

    /// 视图的顶部位置 (等同于 `y`)
    var dy_top: CGFloat {
        get { return self.frame.origin.y }
        set { self.frame = CGRect(origin: CGPoint(x: self.dy_origin.x, y: newValue), size: self.dy_size) }
    }

    /// 视图的左侧位置 (等同于 `x`)
    var dy_left: CGFloat {
        get { return self.frame.origin.x }
        set { self.frame = CGRect(origin: CGPoint(x: newValue, y: self.dy_origin.y), size: self.dy_size) }
    }

    /// 视图中心点的 x 坐标
    var dy_centerX: CGFloat {
        get { return self.center.x }
        set { self.center = CGPoint(x: newValue, y: self.center.y) }
    }

    /// 视图中心点的 y 坐标
    var dy_centerY: CGFloat {
        get { return self.center.y }
        set { self.center = CGPoint(x: self.dy_centerX, y: newValue) }
    }

    /// 视图的中心点 (基于自身 bounds 坐标系)
    var dy_middle: CGPoint {
        return CGPoint(x: self.dy_width / 2, y: self.dy_height / 2)
    }
}

// MARK: - 视图信息与查找
public extension UIView {
    /// 当前视图的有效布局方向
    var dy_layoutDirection: UIUserInterfaceLayoutDirection {
        return self.effectiveUserInterfaceLayoutDirection
    }

    /// 查找该视图所属的视图控制器(通过响应者链)
    var dy_viewController: UIViewController? {
        var responder: UIResponder? = self.next
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }

    /// 递归查找当前视图层级中的第一响应者
    var dy_firstResponder: UIView? {
        guard !self.isFirstResponder else { return self }
        for subview in self.subviews {
            if let first = subview.dy_firstResponder {
                return first
            }
        }
        return nil
    }

    /// 获取所有子视图(深度优先,包含所有后代)
    var dy_allSubviews: [UIView] {
        self.subviews + self.subviews.flatMap(\.dy_allSubviews)
    }
}

// MARK: - 视图类型查找
public extension UIView {
    /// 判断当前视图层级中是否包含指定类型的子视图(深度优先)
    /// - Parameter type: 要查找的视图类型
    /// - Returns: 若存在则返回 `true`
    func dy_containsSubview(ofType type: (some UIView).Type) -> Bool {
        self.dy_findSubview(ofType: type) != nil
    }

    /// 递归查找指定类型的最近父视图
    /// - Parameter type: 要查找的父视图类型
    /// - Returns: 找到的第一个匹配父视图,若无则返回 `nil`
    func dy_findSuperview<T: UIView>(ofType type: T.Type) -> T? {
        var current = self.superview
        while let view = current {
            if let matched = view as? T {
                return matched
            }
            current = view.superview
        }
        return nil
    }

    /// 递归查找满足条件的最近父视图
    /// - Parameter predicate: 判断闭包
    /// - Returns: 找到的第一个匹配父视图,若无则返回 `nil`
    func dy_findSuperview(where predicate: (UIView) -> Bool) -> UIView? {
        var current = self.superview
        while let view = current {
            if predicate(view) {
                return view
            }
            current = view.superview
        }
        return nil
    }

    /// 递归查找指定类型的第一个子视图(深度优先)
    /// - Parameter type: 要查找的子视图类型
    /// - Returns: 找到的第一个匹配子视图,若无则返回 `nil`
    func dy_findSubview<T: UIView>(ofType type: T.Type) -> T? {
        for subview in self.subviews {
            if let matched = subview as? T {
                return matched
            }
            if let found = subview.dy_findSubview(ofType: type) {
                return found
            }
        }
        return nil
    }

    /// 递归查找满足条件的第一个子视图(深度优先)
    /// - Parameter predicate: 判断闭包
    /// - Returns: 找到的第一个匹配子视图,若无则返回 `nil`
    func dy_findSubview(where predicate: (UIView) -> Bool) -> UIView? {
        for subview in self.subviews {
            if predicate(subview) {
                return subview
            }
            if let found = subview.dy_findSubview(where: predicate) {
                return found
            }
        }
        return nil
    }

    /// 递归查找所有指定类型的子视图
    /// - Parameter type: 要查找的子视图类型
    /// - Returns: 所有匹配的子视图数组(深度优先顺序)
    func dy_findSubviews<T: UIView>(ofType type: T.Type) -> [T] {
        var result: [T] = []
        for subview in self.subviews {
            if let matched = subview as? T {
                result.append(matched)
            }
            result.append(contentsOf: subview.dy_findSubviews(ofType: type))
        }
        return result
    }

    /// 递归查找所有满足条件的子视图
    /// - Parameter predicate: 判断闭包
    /// - Returns: 所有匹配的子视图数组(深度优先顺序)
    func dy_findSubviews(where predicate: (UIView) -> Bool) -> [UIView] {
        var result: [UIView] = []
        for subview in self.subviews {
            if predicate(subview) {
                result.append(subview)
            }
            result.append(contentsOf: subview.dy_findSubviews(where: predicate))
        }
        return result
    }
}

// MARK: - 视图调试与操作
public extension UIView {
    /// 为当前视图及其所有子视图添加调试边框和背景色(仅在 `DEBUG` 模式生效)
    /// - Parameters:
    ///   - borderWidth: 边框宽度,默认为 1
    ///   - borderColor: 边框颜色,默认为随机色
    ///   - backgroundColor: 背景色,默认为随机色(半透明以保留内容可见性)
    func dy_debugHighlight(
        borderWidth: CGFloat = 1,
        borderColor: UIColor = .dy_random,
        backgroundColor: UIColor = .dy_random.withAlphaComponent(0.2)
    ) {
        #if DEBUG
            // 高亮当前视图
            self.layer.borderWidth = borderWidth
            self.layer.borderColor = borderColor.cgColor
            self.backgroundColor = backgroundColor

            // 递归高亮子视图
            for subview in self.subviews {
                subview.dy_debugHighlight(
                    borderWidth: borderWidth,
                    borderColor: borderColor,
                    backgroundColor: backgroundColor
                )
            }
        #endif
    }

    /// 移除当前视图的所有直接子视图
    func dy_removeAllSubviews() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    /// 强制收起当前视图层级中的键盘(等效于 `resignFirstResponder`)
    func dy_hideKeyboard() {
        self.endEditing(true)
    }
}

// MARK: - 视图位置判断
public extension UIView {
    /// 判断给定点是否在当前视图的 bounds 范围内(点需位于当前视图的本地坐标系中)
    /// - Parameter point: 待检测的点(坐标系：self)
    /// - Returns: 若点在视图内容区域内则返回 `true`
    func dy_containsLocalPoint(_ point: CGPoint) -> Bool {
        self.bounds.contains(point)
    }

    /// 判断给定点是否在当前视图的 frame 范围内(点需位于父视图的坐标系中)
    /// - Parameter point: 待检测的点(坐标系：superview)
    /// - Returns: 若点在视图 frame 区域内则返回 `true`
    func dy_containsFramePoint(_ point: CGPoint) -> Bool {
        self.frame.contains(point)
    }

    /// 判断在指定坐标系中的点是否落在当前视图内
    /// - Parameters:
    ///   - point: 待检测的点
    ///   - coordinateSpace: 该点所在的坐标系(如 window、另一个 view 等)
    /// - Returns: 若点落在当前视图 bounds 内则返回 true
    func dy_containsPoint(_ point: CGPoint, in coordinateSpace: UICoordinateSpace) -> Bool {
        guard self.window != nil else { return false }

        let localPoint = self.convert(point, from: coordinateSpace)
        return self.bounds.contains(localPoint)
    }
}
