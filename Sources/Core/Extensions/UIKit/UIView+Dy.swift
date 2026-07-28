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

// MARK: - 链式设置属性
public extension UIView {
    /// 是否启用 `autoresizing mask`(即`Autoresizing`)
    /// - Parameter enable: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func dy_translatesAutoresizingMaskIntoConstraints(_ enable: Bool) -> Self {
        self.translatesAutoresizingMaskIntoConstraints = enable
        return self
    }

    /// 设置自动调整掩码（Autoresizing Mask）
    /// - Parameter mask: 自动调整规则
    /// - Returns: `Self`
    @discardableResult
    func dy_autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        self.autoresizingMask = mask
        return self
    }

    /// 设置布局边距
    /// - Parameter margins: 边距
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_layoutMargins(_ margins: UIEdgeInsets) -> Self {
        self.layoutMargins = margins
        return self
    }

    /// 设置是否保留父视图的布局边距
    /// - Parameter preserves: `true` 保留父视图边距
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        self.preservesSuperviewLayoutMargins = preserves
        return self
    }

    /// 设置方向性布局边距
    /// - Parameter margins: 方向性边距
    /// - Returns: `Self`
    @discardableResult
    func dy_directionalLayoutMargins(_ margins: NSDirectionalEdgeInsets) -> Self {
        self.directionalLayoutMargins = margins
        return self
    }

    /// 设置是否从安全区域插入布局边距
    /// - Parameter insets: `true` 从安全区域插入
    /// - Returns: `Self`
    @discardableResult
    func dy_insetsLayoutMarginsFromSafeArea(_ insets: Bool) -> Self {
        self.insetsLayoutMarginsFromSafeArea = insets
        return self
    }

    /// 设置是否裁剪超出部分
    /// - Parameter clipsToBounds: 是否裁剪超出部分,`true`裁剪,`false`不裁剪
    /// - Returns: `Self`
    @discardableResult
    func dy_clipsToBounds(_ clipsToBounds: Bool) -> Self {
        self.clipsToBounds = clipsToBounds
        return self
    }

    /// 设置`tag`
    /// - Parameter tag: 要设置的`tag`数值
    /// - Returns: `Self`
    @discardableResult
    func dy_tag(_ tag: Int) -> Self {
        self.tag = tag
        return self
    }

    /// 设置内容填充模式
    /// - Parameter mode: 填充模式,例如`.scaleAspectFit`或`.scaleToFill`
    /// - Returns: `Self`
    @discardableResult
    func dy_contentMode(_ mode: UIView.ContentMode) -> Self {
        self.contentMode = mode
        return self
    }

    /// 设置是否允许用户交互
    /// - Parameter enabled: 是否允许交互,`true`表示允许交互,`false`表示禁用交互
    /// - Returns: `Self`
    @discardableResult
    func dy_isUserInteractionEnabled(_ enabled: Bool) -> Self {
        self.isUserInteractionEnabled = enabled
        return self
    }

    /// 设置多点触控是否启用
    /// - Parameter enabled: `true` 启用多点触控
    /// - Returns: `Self`
    @discardableResult
    func dy_isMultipleTouchEnabled(_ enabled: Bool) -> Self {
        self.isMultipleTouchEnabled = enabled
        return self
    }

    /// 设置是否独占触摸（阻止其他视图接收触摸）
    /// - Parameter exclusive: `true` 独占触摸
    /// - Returns: `Self`
    @discardableResult
    func dy_isExclusiveTouch(_ exclusive: Bool) -> Self {
        self.isExclusiveTouch = exclusive
        return self
    }

    /// 设置自动调整子视图尺寸
    /// - Parameter resizes: `true` 自动调整子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_autoresizesSubviews(_ resizes: Bool) -> Self {
        self.autoresizesSubviews = resizes
        return self
    }

    /// 设置界面样式
    /// - Parameter style: 设置界面风格
    /// - Returns: `Self`
    @discardableResult
    func dy_overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        self.overrideUserInterfaceStyle = style
        return self
    }

    /// 设置是否隐藏视图
    /// - Parameter isHidden: 是否隐藏视图,`true`表示隐藏,`false`表示显示
    /// - Returns: `Self`
    @discardableResult
    func dy_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置是否不透明（用于性能优化）
    /// - Parameter opaque: `true` 表示完全不透明，可提升渲染性能
    /// - Returns: `Self`
    @discardableResult
    func dy_isOpaque(_ opaque: Bool) -> Self {
        self.isOpaque = opaque
        return self
    }

    /// 设置透明度
    /// - Parameter alpha: 透明度值,范围为`0.0`到`1.0`,`0.0`为完全透明,`1.0`为完全不透明
    /// - Returns: `Self`
    @discardableResult
    func dy_alpha(_ alpha: CGFloat) -> Self {
        self.alpha = alpha
        return self
    }

    /// 设置`backgroundColor`
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor: 调整视图的 tintColor
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_tintColor(_ tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }

    /// 设置着色调整模式
    /// - Parameter mode: 调整模式（自动/正常/变暗）
    /// - Returns: `Self`
    @discardableResult
    func dy_tintAdjustmentMode(_ mode: UIView.TintAdjustmentMode) -> Self {
        self.tintAdjustmentMode = mode
        return self
    }

    /// 设置变换
    /// - Parameter transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func dy_transform(_ transform: CGAffineTransform) -> Self {
        self.transform = transform
        return self
    }

    /// 设置3D变换
    /// - Parameter transform3D: 3D变换
    /// - Returns: `Self`
    @discardableResult
    func dy_transform3D(_ transform3D: CATransform3D) -> Self {
        self.transform3D = transform3D
        return self
    }

    /// 限制最小字体尺寸
    /// - Parameter category: 最小字体尺寸
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_minimumContentSizeCategory(_ category: UIContentSizeCategory?) -> Self {
        self.minimumContentSizeCategory = category
        return self
    }

    /// 限制最大字体尺寸
    /// - Parameter category: 最大字体尺寸
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_maximumContentSizeCategory(_ category: UIContentSizeCategory?) -> Self {
        self.maximumContentSizeCategory = category
        return self
    }

    /// 设置圆角配置
    /// - Parameter configuration: 圆角配置对象
    /// - Returns: `Self`
    @discardableResult
    @available(iOS 26.0, *)
    func dy_cornerConfiguration(_ configuration: UICornerConfiguration) -> Self {
        self.cornerConfiguration = configuration
        return self
    }

    /// 设置恢复标识符
    /// - Parameter identifier: 恢复标识符字符串，用于状态恢复
    /// - Returns: `Self`
    @discardableResult
    func dy_restorationIdentifier(_ identifier: String?) -> Self {
        self.restorationIdentifier = identifier
        return self
    }

    /// 设置焦点组标识符
    /// - Parameter identifier: 焦点组的唯一标识符
    /// - Returns: `Self`
    @available(iOS 14.0, *)
    @discardableResult
    func dy_focusGroupIdentifier(_ identifier: String?) -> Self {
        self.focusGroupIdentifier = identifier
        return self
    }

    /// 设置焦点组优先级
    /// - Parameter priority: 焦点组的优先级
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_focusGroupPriority(_ priority: UIFocusGroupPriority) -> Self {
        self.focusGroupPriority = priority
        return self
    }

    /// 设置焦点效果
    /// - Parameter effect: 应用于视图的焦点视觉效果
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func dy_focusEffect(_ effect: UIFocusEffect?) -> Self {
        self.focusEffect = effect
        return self
    }

    /// 设置语义内容属性
    /// - Parameter attribute: 内容的语义方向属性（如强制从左到右）
    /// - Returns: `Self`
    @discardableResult
    func dy_semanticContentAttribute(_ attribute: UISemanticContentAttribute) -> Self {
        self.semanticContentAttribute = attribute
        return self
    }

    /// 设置内容缩放因子
    /// - Parameter factor: 内容的缩放比例，影响绘制分辨率
    /// - Returns: `Self`
    @discardableResult
    func dy_contentScaleFactor(_ factor: CGFloat) -> Self {
        self.contentScaleFactor = factor
        return self
    }

    /// 设置锚点
    /// - Parameter point: 图层变换的锚点，取值范围 [0,1]
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func dy_anchorPoint(_ point: CGPoint) -> Self {
        self.anchorPoint = point
        return self
    }

    /// 设置是否在绘制前清空上下文
    /// - Parameter clear: 是否清空，默认为 true
    /// - Returns: `Self`
    @discardableResult
    func dy_clearsContextBeforeDrawing(_ clear: Bool) -> Self {
        self.clearsContextBeforeDrawing = clear
        return self
    }

    /// 设置遮罩视图
    /// - Parameter mask: 用作遮罩的视图，其 alpha 通道决定可见区域
    /// - Returns: `Self`
    @discardableResult
    func dy_mask(_ mask: UIView?) -> Self {
        self.mask = mask
        return self
    }

    /// 设置手势识别器数组
    /// - Parameter recognizers: 手势识别器列表
    /// - Returns: `Self`
    @discardableResult
    func dy_gestureRecognizers(_ recognizers: [UIGestureRecognizer]?) -> Self {
        self.gestureRecognizers = recognizers
        return self
    }

    /// 设置运动效果数组
    /// - Parameter effects: 应用于视图的运动效果（如倾斜、摇晃）
    /// - Returns: `Self`
    @discardableResult
    func dy_motionEffects(_ effects: [UIMotionEffect]) -> Self {
        self.motionEffects = effects
        return self
    }
}

// MARK: - 链式设置图层属性
public extension UIView {
    /// 设置`layer.borderColor`
    /// - Parameter color: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func dy_borderColor(_ color: UIColor) -> Self {
        self.layer.dy_borderColor(color)
        return self
    }

    /// 设置`layer.borderWidth`
    /// - Parameter width: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func dy_borderWidth(_ width: CGFloat) -> Self {
        self.layer.dy_borderWidth(width)
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化,`true`表示开启,`false`表示关闭
    /// - Returns: `Self`
    @discardableResult
    func dy_shouldRasterize(_ rasterize: Bool) -> Self {
        self.layer.dy_shouldRasterize(rasterize)
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例,通常为当前主屏幕 scale(`DyScreen.screenScale`)
    /// - Returns: `Self`
    @discardableResult
    func dy_rasterizationScale(_ scale: CGFloat) -> Self {
        self.layer.dy_rasterizationScale(scale)
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_shadowColor(_ color: UIColor) -> Self {
        self.layer.dy_shadowColor(color)
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset: 阴影的偏移量,正值表示偏向右下,负值偏向左上
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowOffset(_ offset: CGSize) -> Self {
        self.layer.dy_shadowOffset(offset)
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 阴影的圆角半径,设置为`0`表示没有圆角
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowRadius(_ radius: CGFloat) -> Self {
        self.layer.dy_shadowRadius(radius)
        return self
    }

    /// 设置阴影不透明度
    /// - Parameter opacity: 阴影的透明度,范围是`0.0`到`1.0`,`0.0`表示完全透明,`1.0`表示完全不透明
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowOpacity(_ opacity: Float) -> Self {
        self.layer.dy_shadowOpacity(opacity)
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 用于阴影的`CGPath`路径,通常设置为视图的`boundingPath`,以优化阴影渲染性能
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowPath(_ path: CGPath) -> Self {
        self.layer.dy_shadowPath(path)
        return self
    }

    /// 设置`layer.cornerRadius`
    /// - Parameter cornerRadius: 圆角半径,设置为0表示没有圆角
    /// - Returns: `Self`
    @discardableResult
    func dy_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.layer.dy_cornerRadius(cornerRadius)
        return self
    }

    /// 设置`layer.maskedCorners`
    /// - Parameter maskedCorners: 要设置的角
    /// - Returns: `Self`
    @discardableResult
    func dy_maskedCorners(_ maskedCorners: CACornerMask) -> Self {
        self.layer.dy_maskedCorners(maskedCorners)
        return self
    }

    /// 设置是否`layer.masksToBounds`
    /// - Parameter masksToBounds: 是否裁切,`true`表示裁切,`false`表示不裁切
    /// - Returns: `Self`
    @discardableResult
    func dy_masksToBounds(_ masksToBounds: Bool) -> Self {
        self.layer.dy_masksToBounds(masksToBounds)
        return self
    }
}

// MARK: - 链式方法
public extension UIView {
    /// 添加子控件到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: `Self`
    @discardableResult
    func dy_addSubview(_ subview: UIView) -> Self {
        self.addSubview(subview)
        return self
    }

    /// 将当前视图从父视力中移除
    /// - Returns: `Self`
    @discardableResult
    func dy_removeFromSuperview() -> Self {
        self.removeFromSuperview()
        return self
    }

    /// 标记固有尺寸需要重新计算
    /// - Returns: `Self`
    @discardableResult
    func dy_invalidateIntrinsicContentSize() -> Self {
        self.invalidateIntrinsicContentSize()
        return self
    }

    /// 请求重新布局
    /// - Returns: `Self`
    @discardableResult
    func dy_setNeedsLayout() -> Self {
        self.setNeedsLayout()
        return self
    }

    /// 立即强制布局更新
    /// - Returns: `Self`
    @discardableResult
    func dy_layoutIfNeeded() -> Self {
        self.layoutIfNeeded()
        return self
    }

    /// 标记需要更新约束
    /// - Returns: `Self`
    @discardableResult
    func dy_setNeedsUpdateConstraints() -> Self {
        self.setNeedsUpdateConstraints()
        return self
    }

    /// 标记属性需要更新
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func dy_setNeedsUpdateProperties() -> Self {
        self.setNeedsUpdateProperties()
        return self
    }

    /// 立即更新属性
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func dy_updateProperties() -> Self {
        self.updateProperties()
        return self
    }

    /// 在需要时更新属性
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func dy_updatePropertiesIfNeeded() -> Self {
        self.updatePropertiesIfNeeded()
        return self
    }

    /// 如果需要，立即更新约束
    /// - Returns: `Self`
    @discardableResult
    func dy_updateConstraintsIfNeeded() -> Self {
        self.updateConstraintsIfNeeded()
        return self
    }

    /// 更新视图的约束（子类可重写）
    /// - Returns: `Self`
    @discardableResult
    func dy_updateConstraints() -> Self {
        self.updateConstraints()
        return self
    }

    /// 如果需要，更新 trait 集合
    /// - Returns: `Self`
    @discardableResult
    func dy_updateTraitsIfNeeded() -> Self {
        if #available(iOS 17.0, *) {
            self.updateTraitsIfNeeded()
        }
        return self
    }

    /// 内容吸附优先级(防止视图被拉伸得比其内容所需更大)
    /// - Parameters:
    ///   - priority: 约束优先级
    ///   - axis: 约束作用的轴向
    /// - Returns: `Self`
    @discardableResult
    func dy_setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentHuggingPriority(priority, for: axis)
        return self
    }

    /// 内容抗压缩优先级(防止视图被压缩得比其内容所需更小)
    /// - Parameters:
    ///   - priority: 约束优先级
    ///   - axis: 约束作用的轴向
    /// - Returns: `Self`
    @discardableResult
    func dy_setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        self.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }

    /// 调整视图尺寸以适应其内容
    /// - Returns: `Self`
    @discardableResult
    @objc func dy_sizeToFit() -> Self {
        self.sizeToFit()
        return self
    }

    /// 在指定索引位置插入子视图
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - index: 插入位置的索引
    /// - Returns: `Self`
    @discardableResult
    func dy_insertSubview(_ view: UIView, at index: Int) -> Self {
        self.insertSubview(view, at: index)
        return self
    }

    /// 交换两个子视图的位置
    /// - Parameters:
    ///   - index1: 第一个子视图的索引
    ///   - index2: 第二个子视图的索引
    /// - Returns: `Self`
    @discardableResult
    func dy_exchangeSubview(at index1: Int, withSubviewAt index2: Int) -> Self {
        self.exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }

    /// 将子视图插入到指定兄弟视图的下方
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - siblingSubview: 参考的兄弟视图
    /// - Returns: `Self`
    @discardableResult
    func dy_insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) -> Self {
        self.insertSubview(view, belowSubview: siblingSubview)
        return self
    }

    /// 将子视图插入到指定兄弟视图的上方
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - siblingSubview: 参考的兄弟视图
    /// - Returns: `Self`
    @discardableResult
    func dy_insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        self.insertSubview(view, aboveSubview: siblingSubview)
        return self
    }

    /// 将指定子视图移到最前面
    /// - Parameter view: 要前置的子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_bringSubviewToFront(_ view: UIView) -> Self {
        self.bringSubviewToFront(view)
        return self
    }

    /// 将指定子视图移到最后面
    /// - Parameter view: 要后置的子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_sendSubviewToBack(_ view: UIView) -> Self {
        self.sendSubviewToBack(view)
        return self
    }

    /// 标记视图需要重绘
    /// - Returns: `Self`
    @discardableResult
    func dy_setNeedsDisplay() -> Self {
        self.setNeedsDisplay()
        return self
    }

    /// 添加运动效果
    /// - Parameter effect: 要添加的运动效果（如倾斜、摇晃）
    /// - Returns: `Self`
    @discardableResult
    func dy_addMotionEffect(_ effect: UIMotionEffect) -> Self {
        self.addMotionEffect(effect)
        return self
    }

    /// 移除运动效果
    /// - Parameter effect: 要移除的运动效果
    /// - Returns: `Self`
    @discardableResult
    func dy_removeMotionEffect(_ effect: UIMotionEffect) -> Self {
        self.removeMotionEffect(effect)
        return self
    }
}

// MARK: - 链式方法自定义
public extension UIView {
    /// 把`self`添加到父视图
    /// - Parameter superview: 父视图,`self`将被添加为该视图的子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_addTo(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(self)
        }
        return self
    }

    /// 把`self`添加到`UIStackView`中
    /// - Parameter stackView: `UIStackView`
    /// - Returns: `Self`
    @discardableResult
    func dy_addTo(_ stackView: UIStackView) -> Self {
        stackView.addArrangedSubview(self)
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: `Self`
    @discardableResult
    func dy_addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { self.addSubview($0) }
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后, 会生成一张独立的图像,停止滚动后可以监听
    /// - Returns: `Self`
    @discardableResult
    func dy_rasterize() -> Self {
        self.layer.drawsAsynchronously = true
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = self.traitCollection.displayScale
        return self
    }

    /// 立即刷新布局
    /// - Returns: `Self`
    @discardableResult
    func dy_updateLayout() -> Self {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return self
    }
}

// MARK: - 链式设置手势
public extension UIView {
    /// 添加手势识别器
    /// - Parameter gestureRecognizer: 要添加的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dy_addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        self.addGestureRecognizer(gestureRecognizer)
        return self
    }

    /// 移除手势识别器
    /// - Parameter gestureRecognizer: 要移除的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dy_removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        self.removeGestureRecognizer(gestureRecognizer)
        return self
    }

    /// 添加多个手势识别器
    /// - Parameter recognizers: 手势识别器数组
    /// - Returns: `Self`
    @discardableResult
    func dy_addGestureRecognizers(_ recognizers: [UIGestureRecognizer]) -> Self {
        self.isUserInteractionEnabled = true
        for recognizer in recognizers {
            self.addGestureRecognizer(recognizer)
        }
        return self
    }

    /// 移除多个指定手势识别器
    /// - Parameter recognizers: 要移除的手势识别器数组
    /// - Returns: `Self`
    @discardableResult
    func dy_removeGestureRecognizer(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 移除所有手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dy_removeGestureRecognizers() -> Self {
        self.gestureRecognizers?.forEach { recognizer in
            self.removeGestureRecognizer(recognizer)
        }
        return self
    }
}

// MARK: - 链式手势(自定义)
public extension UIView {
    /// 添加单击手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func dy_onTapGestureRecognizer(_ block: @escaping DyAction1<UITapGestureRecognizer>) -> Self {
        let tap = UITapGestureRecognizer()
            .dy_onRecognized { recognizer in
                if let tap = recognizer as? UITapGestureRecognizer {
                    block(tap)
                }
            }
        return self.dy_addGestureRecognizer(tap)
    }

    /// 添加长按手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - minimumDuration: 最小按压时长
    ///   - block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func dy_onLongPressGestureRecognizer(minimumDuration: TimeInterval = 0.5, _ block: @escaping DyAction1<UILongPressGestureRecognizer>) -> Self {
        let longPress = UILongPressGestureRecognizer.dy_longPressGestureRecognizer()
            .dy_minimumPressDuration(minimumDuration)
            .dy_onRecognized { recognizer in
                if let longPress = recognizer as? UILongPressGestureRecognizer {
                    block(longPress)
                }
            }
        return self.dy_addGestureRecognizer(longPress)
    }

    /// 添加拖动手势(平移)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势触发时的回调(识别时持续回调)
    /// - Returns: `Self`
    @discardableResult
    func dy_onPanGestureRecognizer(_ block: @escaping DyAction1<UIPanGestureRecognizer>) -> Self {
        let pan = UIPanGestureRecognizer.dy_panGestureRecognizer()
            .dy_onRecognized { recognizer in
                if let pan = recognizer as? UIPanGestureRecognizer {
                    block(pan)
                }
            }
        return self.dy_addGestureRecognizer(pan)
    }

    /// 添加从屏幕边缘开始的拖动手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - edges: 触发边缘
    ///   - block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func dy_onScreenEdgePanGestureRecognizer(edges: UIRectEdge, _ block: @escaping DyAction1<UIScreenEdgePanGestureRecognizer>) -> Self {
        let screenEdgePan = UIScreenEdgePanGestureRecognizer.dy_screenEdgePanGestureRecognizer()
            .dy_edges(edges)
            .dy_onRecognized { recognizer in
                if let screenEdgePan = recognizer as? UIScreenEdgePanGestureRecognizer {
                    block(screenEdgePan)
                }
            }
        return self.dy_addGestureRecognizer(screenEdgePan)
    }

    /// 添加滑动手势(轻扫)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - direction: 滑动方向
    ///   - block: 手势触发时回调
    /// - Returns: `Self`
    @discardableResult
    func dy_onSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction = .right,
                                     _ block: @escaping DyAction1<UISwipeGestureRecognizer>) -> Self
    {
        let swipeGesture = UISwipeGestureRecognizer.dy_swipeGestureRecognizer()
            .dy_direction(direction)
            .dy_onRecognized { recognizer in
                if let swipe = recognizer as? UISwipeGestureRecognizer {
                    block(swipe)
                }
            }
        return self.dy_addGestureRecognizer(swipeGesture)
    }

    /// 添加捏合手势(用于缩放)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势触发时回调
    /// - Returns: `Self`
    @discardableResult
    func onPinchGestureRecognizer(_ block: @escaping DyAction1<UIPinchGestureRecognizer>) -> Self {
        let pinch = UIPinchGestureRecognizer.dy_pinchGestureRecognizer()
            .dy_onRecognized { recognizer in
                if let pinch = recognizer as? UIPinchGestureRecognizer {
                    block(pinch)
                }
            }
        return self.dy_addGestureRecognizer(pinch)
    }

    /// 添加旋转手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势触发时回调
    /// - Returns: `Self`
    @discardableResult
    func dy_onRotationGestureRecognizer(_ block: @escaping DyAction1<UIRotationGestureRecognizer>) -> Self {
        let rotation = UIRotationGestureRecognizer.dy_rotationGestureRecognizer()
            .dy_onRecognized { recognizer in
                if let rotation = recognizer as? UIRotationGestureRecognizer {
                    block(rotation)
                }
            }
        return self.dy_addGestureRecognizer(rotation)
    }
}
