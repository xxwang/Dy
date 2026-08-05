import UIKit

// MARK: - 链式设置属性(布局)
public extension DyWrapper where Base: UIView {
    /// 设置控件的`frame`
    /// - Parameter frame: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func frame(_ frame: CGRect) -> Self {
        base.frame = frame
        return self
    }

    /// 设置控件的`bounds`
    /// - Parameter bounds: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func bounds(_ bounds: CGRect) -> Self {
        base.bounds = bounds
        return self
    }

    /// 设置控件的`origin`
    /// - Parameter origin: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func origin(_ origin: CGPoint) -> Self {
        var frame = base.frame
        frame.origin = origin
        base.frame = frame
        return self
    }

    /// 设置控件的`size`
    /// - Parameter size: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func size(_ size: CGSize) -> Self {
        var frame = base.frame
        frame.size = size
        base.frame = frame
        return self
    }

    /// 设置控件的`x`坐标
    /// - Parameter left: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func left(_ left: CGFloat) -> Self {
        var frame = base.frame
        frame.origin.x = left
        base.frame = frame
        return self
    }

    /// 设置控件的顶部`y`坐标
    /// - Parameter top: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func top(_ top: CGFloat) -> Self {
        var frame = base.frame
        frame.origin.y = top
        base.frame = frame
        return self
    }

    /// 设置控件的`width`
    /// - Parameter width: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat) -> Self {
        var frame = base.frame
        frame.size.width = width
        base.frame = frame
        return self
    }

    /// 设置控件的`height`
    /// - Parameter height: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func height(_ height: CGFloat) -> Self {
        var frame = base.frame
        frame.size.height = height
        base.frame = frame
        return self
    }

    /// 设置控件的`center`
    /// - Parameter center: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func center(_ center: CGPoint) -> Self {
        base.center = center
        return self
    }

    /// 设置控件的中心点`x`坐标
    /// - Parameter centerX: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func centerX(_ centerX: CGFloat) -> Self {
        var center = base.center
        center.x = centerX
        base.center = center
        return self
    }

    /// 设置控件的中心点`y`坐标
    /// - Parameter centerY: 要设置的值
    /// - Returns: `Self`
    @discardableResult
    func centerY(_ centerY: CGFloat) -> Self {
        var center = base.center
        center.y = centerY
        base.center = center
        return self
    }
}

// MARK: - 链式设置属性
public extension DyWrapper where Base: UIView {
    /// 是否启用 `autoresizing mask`(即`Autoresizing`)
    /// - Parameter enable: 是否开启
    /// - Returns: `Self`
    @discardableResult
    func translatesAutoresizingMaskIntoConstraints(_ enable: Bool) -> Self {
        base.translatesAutoresizingMaskIntoConstraints = enable
        return self
    }

    /// 设置自动调整掩码（Autoresizing Mask）
    /// - Parameter mask: 自动调整规则
    /// - Returns: `Self`
    @discardableResult
    func autoresizingMask(_ mask: UIView.AutoresizingMask) -> Self {
        base.autoresizingMask = mask
        return self
    }

    /// 设置布局边距
    /// - Parameter margins: 边距
    /// - Returns: `Self`
    @discardableResult
    func layoutMargins(_ margins: UIEdgeInsets) -> Self {
        base.layoutMargins = margins
        return self
    }

    /// 设置是否保留父视图的布局边距
    /// - Parameter preserves: `true` 保留父视图边距
    /// - Returns: `Self`
    @discardableResult
    func preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        base.preservesSuperviewLayoutMargins = preserves
        return self
    }

    /// 设置方向性布局边距
    /// - Parameter margins: 方向性边距
    /// - Returns: `Self`
    @discardableResult
    func directionalLayoutMargins(_ margins: NSDirectionalEdgeInsets) -> Self {
        base.directionalLayoutMargins = margins
        return self
    }

    /// 设置是否从安全区域插入布局边距
    /// - Parameter insets: `true` 从安全区域插入
    /// - Returns: `Self`
    @discardableResult
    func insetsLayoutMarginsFromSafeArea(_ insets: Bool) -> Self {
        base.insetsLayoutMarginsFromSafeArea = insets
        return self
    }

    /// 设置是否裁剪超出部分
    /// - Parameter clipsToBounds: 是否裁剪超出部分,`true`裁剪,`false`不裁剪
    /// - Returns: `Self`
    @discardableResult
    func clipsToBounds(_ clipsToBounds: Bool) -> Self {
        base.clipsToBounds = clipsToBounds
        return self
    }

    /// 设置`tag`
    /// - Parameter tag: 要设置的`tag`数值
    /// - Returns: `Self`
    @discardableResult
    func tag(_ tag: Int) -> Self {
        base.tag = tag
        return self
    }

    /// 设置内容填充模式
    /// - Parameter mode: 填充模式,例如`.scaleAspectFit`或`.scaleToFill`
    /// - Returns: `Self`
    @discardableResult
    func contentMode(_ mode: UIView.ContentMode) -> Self {
        base.contentMode = mode
        return self
    }

    /// 设置是否允许用户交互
    /// - Parameter enabled: 是否允许交互,`true`表示允许交互,`false`表示禁用交互
    /// - Returns: `Self`
    @discardableResult
    func isUserInteractionEnabled(_ enabled: Bool) -> Self {
        base.isUserInteractionEnabled = enabled
        return self
    }

    /// 设置多点触控是否启用
    /// - Parameter enabled: `true` 启用多点触控
    /// - Returns: `Self`
    @discardableResult
    func isMultipleTouchEnabled(_ enabled: Bool) -> Self {
        base.isMultipleTouchEnabled = enabled
        return self
    }

    /// 设置是否独占触摸（阻止其他视图接收触摸）
    /// - Parameter exclusive: `true` 独占触摸
    /// - Returns: `Self`
    @discardableResult
    func isExclusiveTouch(_ exclusive: Bool) -> Self {
        base.isExclusiveTouch = exclusive
        return self
    }

    /// 设置自动调整子视图尺寸
    /// - Parameter resizes: `true` 自动调整子视图
    /// - Returns: `Self`
    @discardableResult
    func autoresizesSubviews(_ resizes: Bool) -> Self {
        base.autoresizesSubviews = resizes
        return self
    }

    /// 设置界面样式
    /// - Parameter style: 设置界面风格
    /// - Returns: `Self`
    @discardableResult
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        base.overrideUserInterfaceStyle = style
        return self
    }

    /// 设置是否隐藏视图
    /// - Parameter isHidden: 是否隐藏视图,`true`表示隐藏,`false`表示显示
    /// - Returns: `Self`
    @discardableResult
    func isHidden(_ isHidden: Bool) -> Self {
        base.isHidden = isHidden
        return self
    }

    /// 设置是否不透明（用于性能优化）
    /// - Parameter opaque: `true` 表示完全不透明，可提升渲染性能
    /// - Returns: `Self`
    @discardableResult
    func isOpaque(_ opaque: Bool) -> Self {
        base.isOpaque = opaque
        return self
    }

    /// 设置透明度
    /// - Parameter alpha: 透明度值,范围为`0.0`到`1.0`,`0.0`为完全透明,`1.0`为完全不透明
    /// - Returns: `Self`
    @discardableResult
    func alpha(_ alpha: CGFloat) -> Self {
        base.alpha = alpha
        return self
    }

    /// 设置`backgroundColor`
    /// - Parameter color: 背景颜色
    /// - Returns: `Self`
    @discardableResult
    func backgroundColor(_ color: UIColor?) -> Self {
        base.backgroundColor = color
        return self
    }

    /// 设置`tintColor`
    /// - Parameter tintColor: 调整视图的 tintColor
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ tintColor: UIColor?) -> Self {
        base.tintColor = tintColor
        return self
    }

    /// 设置着色调整模式
    /// - Parameter mode: 调整模式（自动/正常/变暗）
    /// - Returns: `Self`
    @discardableResult
    func tintAdjustmentMode(_ mode: UIView.TintAdjustmentMode) -> Self {
        base.tintAdjustmentMode = mode
        return self
    }

    /// 设置变换
    /// - Parameter transform: 变换
    /// - Returns: `Self`
    @discardableResult
    func transform(_ transform: CGAffineTransform) -> Self {
        base.transform = transform
        return self
    }

    /// 设置3D变换
    /// - Parameter transform3D: 3D变换
    /// - Returns: `Self`
    @discardableResult
    func transform3D(_ transform3D: CATransform3D) -> Self {
        base.transform3D = transform3D
        return self
    }

    /// 限制最小字体尺寸
    /// - Parameter category: 最小字体尺寸
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func minimumContentSizeCategory(_ category: UIContentSizeCategory?) -> Self {
        base.minimumContentSizeCategory = category
        return self
    }

    /// 限制最大字体尺寸
    /// - Parameter category: 最大字体尺寸
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func maximumContentSizeCategory(_ category: UIContentSizeCategory?) -> Self {
        base.maximumContentSizeCategory = category
        return self
    }

    /// 设置圆角配置
    /// - Parameter configuration: 圆角配置对象
    /// - Returns: `Self`
    @discardableResult
    @available(iOS 26.0, *)
    func cornerConfiguration(_ configuration: UICornerConfiguration) -> Self {
        base.cornerConfiguration = configuration
        return self
    }

    /// 设置恢复标识符
    /// - Parameter identifier: 恢复标识符字符串，用于状态恢复
    /// - Returns: `Self`
    @discardableResult
    func restorationIdentifier(_ identifier: String?) -> Self {
        base.restorationIdentifier = identifier
        return self
    }

    /// 设置焦点组标识符
    /// - Parameter identifier: 焦点组的唯一标识符
    /// - Returns: `Self`
    @available(iOS 14.0, *)
    @discardableResult
    func focusGroupIdentifier(_ identifier: String?) -> Self {
        base.focusGroupIdentifier = identifier
        return self
    }

    /// 设置焦点组优先级
    /// - Parameter priority: 焦点组的优先级
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func focusGroupPriority(_ priority: UIFocusGroupPriority) -> Self {
        base.focusGroupPriority = priority
        return self
    }

    /// 设置焦点效果
    /// - Parameter effect: 应用于视图的焦点视觉效果
    /// - Returns: `Self`
    @available(iOS 15.0, *)
    @discardableResult
    func focusEffect(_ effect: UIFocusEffect?) -> Self {
        base.focusEffect = effect
        return self
    }

    /// 设置语义内容属性
    /// - Parameter attribute: 内容的语义方向属性（如强制从左到右）
    /// - Returns: `Self`
    @discardableResult
    func semanticContentAttribute(_ attribute: UISemanticContentAttribute) -> Self {
        base.semanticContentAttribute = attribute
        return self
    }

    /// 设置内容缩放因子
    /// - Parameter factor: 内容的缩放比例，影响绘制分辨率
    /// - Returns: `Self`
    @discardableResult
    func contentScaleFactor(_ factor: CGFloat) -> Self {
        base.contentScaleFactor = factor
        return self
    }

    /// 设置锚点
    /// - Parameter point: 图层变换的锚点，取值范围 [0,1]
    /// - Returns: `Self`
    @available(iOS 16.0, *)
    @discardableResult
    func anchorPoint(_ point: CGPoint) -> Self {
        base.anchorPoint = point
        return self
    }

    /// 设置是否在绘制前清空上下文
    /// - Parameter clear: 是否清空，默认为 true
    /// - Returns: `Self`
    @discardableResult
    func clearsContextBeforeDrawing(_ clear: Bool) -> Self {
        base.clearsContextBeforeDrawing = clear
        return self
    }

    /// 设置遮罩视图
    /// - Parameter mask: 用作遮罩的视图，其 alpha 通道决定可见区域
    /// - Returns: `Self`
    @discardableResult
    func mask(_ mask: UIView?) -> Self {
        base.mask = mask
        return self
    }

    /// 设置手势识别器数组
    /// - Parameter recognizers: 手势识别器列表
    /// - Returns: `Self`
    @discardableResult
    func gestureRecognizers(_ recognizers: [UIGestureRecognizer]?) -> Self {
        base.gestureRecognizers = recognizers
        return self
    }

    /// 设置运动效果数组
    /// - Parameter effects: 应用于视图的运动效果（如倾斜、摇晃）
    /// - Returns: `Self`
    @discardableResult
    func motionEffects(_ effects: [UIMotionEffect]) -> Self {
        base.motionEffects = effects
        return self
    }
}

// MARK: - 链式设置图层属性
public extension DyWrapper where Base: UIView {
    /// 设置`layer.borderColor`
    /// - Parameter color: 边框颜色
    /// - Returns: `Self`
    @discardableResult
    func borderColor(_ color: UIColor) -> Self {
        base.layer.dy.borderColor(color)
        return self
    }

    /// 设置`layer.borderWidth`
    /// - Parameter width: 边框宽度
    /// - Returns: `Self`
    @discardableResult
    func borderWidth(_ width: CGFloat) -> Self {
        base.layer.dy.borderWidth(width)
        return self
    }

    /// 是否开启光栅化
    /// - Parameter rasterize: 是否开启光栅化,`true`表示开启,`false`表示关闭
    /// - Returns: `Self`
    @discardableResult
    func shouldRasterize(_ rasterize: Bool) -> Self {
        base.layer.dy.shouldRasterize(rasterize)
        return self
    }

    /// 设置光栅化比例
    /// - Parameter scale: 光栅化比例,通常为当前主屏幕 scale(`DyScreen.screenScale`)
    /// - Returns: `Self`
    @discardableResult
    func rasterizationScale(_ scale: CGFloat) -> Self {
        base.layer.dy.rasterizationScale(scale)
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色
    /// - Returns: `Self`
    @discardableResult
    func shadowColor(_ color: UIColor) -> Self {
        base.layer.dy.shadowColor(color)
        return self
    }

    /// 设置阴影偏移
    /// - Parameter offset: 阴影的偏移量,正值表示偏向右下,负值偏向左上
    /// - Returns: `Self`
    @discardableResult
    func shadowOffset(_ offset: CGSize) -> Self {
        base.layer.dy.shadowOffset(offset)
        return self
    }

    /// 设置阴影圆角
    /// - Parameter radius: 阴影的圆角半径,设置为`0`表示没有圆角
    /// - Returns: `Self`
    @discardableResult
    func shadowRadius(_ radius: CGFloat) -> Self {
        base.layer.dy.shadowRadius(radius)
        return self
    }

    /// 设置阴影不透明度
    /// - Parameter opacity: 阴影的透明度,范围是`0.0`到`1.0`,`0.0`表示完全透明,`1.0`表示完全不透明
    /// - Returns: `Self`
    @discardableResult
    func shadowOpacity(_ opacity: Float) -> Self {
        base.layer.dy.shadowOpacity(opacity)
        return self
    }

    /// 设置阴影路径
    /// - Parameter path: 用于阴影的`CGPath`路径,通常设置为视图的`boundingPath`,以优化阴影渲染性能
    /// - Returns: `Self`
    @discardableResult
    func shadowPath(_ path: CGPath) -> Self {
        base.layer.dy.shadowPath(path)
        return self
    }

    /// 设置`layer.cornerRadius`
    /// - Parameter cornerRadius: 圆角半径,设置为0表示没有圆角
    /// - Returns: `Self`
    @discardableResult
    func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        base.layer.dy.cornerRadius(cornerRadius)
        return self
    }

    /// 设置`layer.maskedCorners`
    /// - Parameter maskedCorners: 要设置的角
    /// - Returns: `Self`
    @discardableResult
    func maskedCorners(_ maskedCorners: CACornerMask) -> Self {
        base.layer.dy.maskedCorners(maskedCorners)
        return self
    }

    /// 设置是否`layer.masksToBounds`
    /// - Parameter masksToBounds: 是否裁切,`true`表示裁切,`false`表示不裁切
    /// - Returns: `Self`
    @discardableResult
    func masksToBounds(_ masksToBounds: Bool) -> Self {
        base.layer.dy.masksToBounds(masksToBounds)
        return self
    }

    /// 设置圆角曲线风格
    /// - Parameter curve: `.circular`(默认) 或 `.continuous`(更顺滑)
    /// - Returns: `Self`
    @discardableResult
    func cornerCurve(_ curve: CALayerCornerCurve) -> Self {
        base.layer.cornerCurve = curve
        return self
    }

    /// 设置图层透明度(独立于 `alpha`,不影响子视图)
    /// - Parameter opacity: 透明度值,范围 [0, 1]
    /// - Returns: `Self`
    @discardableResult
    func opacity(_ opacity: Float) -> Self {
        base.layer.opacity = opacity
        return self
    }

    /// 设置 Z 轴层级(影响同级视图渲染/事件顺序)
    /// - Parameter zPosition: Z 轴位置,越大越靠前
    /// - Returns: `Self`
    @discardableResult
    func zPosition(_ zPosition: CGFloat) -> Self {
        base.layer.zPosition = zPosition
        return self
    }

    /// 设置图层名称(Xcode View Hierarchy 中可见)
    /// - Parameter name: 图层名称,用于调试
    /// - Returns: `Self`
    @discardableResult
    func name(_ name: String) -> Self {
        base.layer.name = name
        return self
    }
}

// MARK: - 链式方法
public extension DyWrapper where Base: UIView {
    /// 添加子控件到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: `Self`
    @discardableResult
    func addSubview(_ subview: UIView) -> Self {
        base.addSubview(subview)
        return self
    }

    /// 将当前视图从父视力中移除
    /// - Returns: `Self`
    @discardableResult
    func removeFromSuperview() -> Self {
        base.removeFromSuperview()
        return self
    }

    /// 标记固有尺寸需要重新计算
    /// - Returns: `Self`
    @discardableResult
    func invalidateIntrinsicContentSize() -> Self {
        base.invalidateIntrinsicContentSize()
        return self
    }

    /// 请求重新布局
    /// - Returns: `Self`
    @discardableResult
    func setNeedsLayout() -> Self {
        base.setNeedsLayout()
        return self
    }

    /// 立即强制布局更新
    /// - Returns: `Self`
    @discardableResult
    func layoutIfNeeded() -> Self {
        base.layoutIfNeeded()
        return self
    }

    /// 标记需要更新约束
    /// - Returns: `Self`
    @discardableResult
    func setNeedsUpdateConstraints() -> Self {
        base.setNeedsUpdateConstraints()
        return self
    }

    /// 标记属性需要更新
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func setNeedsUpdateProperties() -> Self {
        base.setNeedsUpdateProperties()
        return self
    }

    /// 立即更新属性
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func updateProperties() -> Self {
        base.updateProperties()
        return self
    }

    /// 在需要时更新属性
    /// - Returns: `Self`
    @available(iOS 26.0, *)
    @discardableResult
    func updatePropertiesIfNeeded() -> Self {
        base.updatePropertiesIfNeeded()
        return self
    }

    /// 如果需要，立即更新约束
    /// - Returns: `Self`
    @discardableResult
    func updateConstraintsIfNeeded() -> Self {
        base.updateConstraintsIfNeeded()
        return self
    }

    /// 更新视图的约束（子类可重写）
    /// - Returns: `Self`
    @discardableResult
    func updateConstraints() -> Self {
        base.updateConstraints()
        return self
    }

    /// 如果需要，更新 trait 集合
    /// - Returns: `Self`
    @discardableResult
    func updateTraitsIfNeeded() -> Self {
        if #available(iOS 17.0, *) {
            base.updateTraitsIfNeeded()
        }
        return self
    }

    /// 内容吸附优先级(防止视图被拉伸得比其内容所需更大)
    /// - Parameters:
    ///   - priority: 约束优先级
    ///   - axis: 约束作用的轴向
    /// - Returns: `Self`
    @discardableResult
    func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        base.setContentHuggingPriority(priority, for: axis)
        return self
    }

    /// 内容抗压缩优先级(防止视图被压缩得比其内容所需更小)
    /// - Parameters:
    ///   - priority: 约束优先级
    ///   - axis: 约束作用的轴向
    /// - Returns: `Self`
    @discardableResult
    func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        base.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }

    /// 调整视图尺寸以适应其内容
    /// - Returns: `Self`
    @discardableResult
    func sizeToFit() -> Self {
        base.sizeToFit()
        return self
    }

    /// 在指定索引位置插入子视图
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - index: 插入位置的索引
    /// - Returns: `Self`
    @discardableResult
    func insertSubview(_ view: UIView, at index: Int) -> Self {
        base.insertSubview(view, at: index)
        return self
    }

    /// 交换两个子视图的位置
    /// - Parameters:
    ///   - index1: 第一个子视图的索引
    ///   - index2: 第二个子视图的索引
    /// - Returns: `Self`
    @discardableResult
    func exchangeSubview(at index1: Int, withSubviewAt index2: Int) -> Self {
        base.exchangeSubview(at: index1, withSubviewAt: index2)
        return self
    }

    /// 将子视图插入到指定兄弟视图的下方
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - siblingSubview: 参考的兄弟视图
    /// - Returns: `Self`
    @discardableResult
    func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) -> Self {
        base.insertSubview(view, belowSubview: siblingSubview)
        return self
    }

    /// 将子视图插入到指定兄弟视图的上方
    /// - Parameters:
    ///   - view: 要插入的子视图
    ///   - siblingSubview: 参考的兄弟视图
    /// - Returns: `Self`
    @discardableResult
    func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) -> Self {
        base.insertSubview(view, aboveSubview: siblingSubview)
        return self
    }

    /// 将指定子视图移到最前面
    /// - Parameter view: 要前置的子视图
    /// - Returns: `Self`
    @discardableResult
    func bringSubviewToFront(_ view: UIView) -> Self {
        base.bringSubviewToFront(view)
        return self
    }

    /// 将指定子视图移到最后面
    /// - Parameter view: 要后置的子视图
    /// - Returns: `Self`
    @discardableResult
    func sendSubviewToBack(_ view: UIView) -> Self {
        base.sendSubviewToBack(view)
        return self
    }

    /// 标记视图需要重绘
    /// - Returns: `Self`
    @discardableResult
    func setNeedsDisplay() -> Self {
        base.setNeedsDisplay()
        return self
    }

    /// 添加运动效果
    /// - Parameter effect: 要添加的运动效果（如倾斜、摇晃）
    /// - Returns: `Self`
    @discardableResult
    func addMotionEffect(_ effect: UIMotionEffect) -> Self {
        base.addMotionEffect(effect)
        return self
    }

    /// 移除运动效果
    /// - Parameter effect: 要移除的运动效果
    /// - Returns: `Self`
    @discardableResult
    func removeMotionEffect(_ effect: UIMotionEffect) -> Self {
        base.removeMotionEffect(effect)
        return self
    }
}

// MARK: - 链式方法自定义
public extension DyWrapper where Base: UIView {
    /// 把`self`添加到父视图
    /// - Parameter superview: 父视图,`self`将被添加为该视图的子视图
    /// - Returns: `Self`
    @discardableResult
    func add2(_ superview: UIView?) -> Self {
        if let superview {
            superview.addSubview(base)
        }
        return self
    }

    /// 把`self`添加到`UIStackView`中
    /// - Parameter stackView: `UIStackView`
    /// - Returns: `Self`
    @discardableResult
    func add2(_ stackView: UIStackView) -> Self {
        stackView.addArrangedSubview(base)
        return self
    }

    /// 添加子控件数组到当前视图上
    /// - Parameter subviews: 要添加的子控件数组
    /// - Returns: `Self`
    @discardableResult
    func addSubviews(_ subviews: [UIView]) -> Self {
        subviews.forEach { base.addSubview($0) }
        return self
    }

    /// 离屏渲染 + 栅格化 - 异步绘制之后, 会生成一张独立的图像,停止滚动后可以监听
    /// - Returns: `Self`
    @discardableResult
    func rasterize() -> Self {
        base.layer.drawsAsynchronously = true
        base.layer.shouldRasterize = true
        base.layer.rasterizationScale = base.traitCollection.displayScale
        return self
    }

    /// 立即刷新布局
    /// - Returns: `Self`
    @discardableResult
    func updateLayout() -> Self {
        base.setNeedsLayout()
        base.layoutIfNeeded()
        return self
    }
}

// MARK: - 链式设置手势
public extension DyWrapper where Base: UIView {
    /// 添加手势识别器
    /// - Parameter gestureRecognizer: 要添加的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        base.addGestureRecognizer(gestureRecognizer)
        return self
    }

    /// 移除手势识别器
    /// - Parameter gestureRecognizer: 要移除的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) -> Self {
        base.removeGestureRecognizer(gestureRecognizer)
        return self
    }

    /// 添加多个手势识别器
    /// - Parameter recognizers: 手势识别器数组
    /// - Returns: `Self`
    @discardableResult
    func addGestureRecognizers(_ recognizers: [UIGestureRecognizer]) -> Self {
        base.isUserInteractionEnabled = true
        for recognizer in recognizers {
            base.addGestureRecognizer(recognizer)
        }
        return self
    }

    /// 移除多个指定手势识别器
    /// - Parameter recognizers: 要移除的手势识别器数组
    /// - Returns: `Self`
    @discardableResult
    func removeGestureRecognizer(_ recognizers: [UIGestureRecognizer]) -> Self {
        for recognizer in recognizers {
            base.removeGestureRecognizer(recognizer)
        }
        return self
    }

    /// 移除所有手势识别器
    /// - Returns: `Self`
    @discardableResult
    func removeGestureRecognizers() -> Self {
        base.gestureRecognizers?.forEach { recognizer in
            base.removeGestureRecognizer(recognizer)
        }
        return self
    }
}

// MARK: - 链式手势(自定义)
public extension DyWrapper where Base: UIView {
    /// 添加单击手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func onTapGestureRecognizer(_ block: @escaping DyAction1<UITapGestureRecognizer>) -> Self {
        let tap = UITapGestureRecognizer()
            .dy
            .onRecognized { recognizer in
                if let tap = recognizer as? UITapGestureRecognizer {
                    block(tap)
                }
            }
            .build()
        return self.addGestureRecognizer(tap)
    }

    /// 添加长按手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - minimumDuration: 最小按压时长
    ///   - block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func onLongPressGestureRecognizer(minimumDuration: TimeInterval = 0.5, _ block: @escaping DyAction1<UILongPressGestureRecognizer>) -> Self {
        let longPress = UILongPressGestureRecognizer.longPressGestureRecognizer()
            .dy
            .minimumPressDuration(minimumDuration)
            .onRecognized { recognizer in
                if let longPress = recognizer as? UILongPressGestureRecognizer {
                    block(longPress)
                }
            }
            .build()
        return self.addGestureRecognizer(longPress)
    }

    /// 添加拖动手势(平移)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势进行中持续回调(began/changed/ended 各触发一次)
    /// - Returns: `Self`
    @discardableResult
    func onPanGestureRecognizer(_ block: @escaping DyAction1<UIPanGestureRecognizer>) -> Self {
        let pan = UIPanGestureRecognizer.panGestureRecognizer()
        pan.dy
            .onStateChanged { [weak pan] _ in
                guard let pan else { return }
                block(pan)
            }
            .build()
        return self.addGestureRecognizer(pan)
    }

    /// 添加从屏幕边缘开始的拖动手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - edges: 触发边缘
    ///   - block: 手势触发时的回调
    /// - Returns: `Self`
    @discardableResult
    func onScreenEdgePanGestureRecognizer(edges: UIRectEdge, _ block: @escaping DyAction1<UIScreenEdgePanGestureRecognizer>) -> Self {
        let screenEdgePan = UIScreenEdgePanGestureRecognizer.screenEdgePanGestureRecognizer()
            .dy
            .edges(edges)
            .onRecognized { recognizer in
                if let screenEdgePan = recognizer as? UIScreenEdgePanGestureRecognizer {
                    block(screenEdgePan)
                }
            }
            .build()
        return self.addGestureRecognizer(screenEdgePan)
    }

    /// 添加滑动手势(轻扫)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameters:
    ///   - direction: 滑动方向
    ///   - block: 手势触发时回调
    /// - Returns: `Self`
    @discardableResult
    func onSwipeGestureRecognizer(direction: UISwipeGestureRecognizer.Direction = .right,
                                  _ block: @escaping DyAction1<UISwipeGestureRecognizer>) -> Self
    {
        let swipeGesture = UISwipeGestureRecognizer.swipeGestureRecognizer()
            .dy
            .direction(direction)
            .onRecognized { recognizer in
                if let swipe = recognizer as? UISwipeGestureRecognizer {
                    block(swipe)
                }
            }
            .build()
        return self.addGestureRecognizer(swipeGesture)
    }

    /// 添加捏合手势(用于缩放)
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势进行中持续回调(began/changed/ended 各触发一次)
    /// - Returns: `Self`
    @discardableResult
    func onPinchGestureRecognizer(_ block: @escaping DyAction1<UIPinchGestureRecognizer>) -> Self {
        let pinch = UIPinchGestureRecognizer.pinchGestureRecognizer()
        pinch
            .dy
            .onStateChanged { [weak pinch] _ in
                guard let pinch else { return }
                block(pinch)
            }
            .build()
        return self.addGestureRecognizer(pinch)
    }

    /// 添加旋转手势
    /// - Warning: 闭包被内部手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 手势进行中持续回调(began/changed/ended 各触发一次)
    /// - Returns: `Self`
    @discardableResult
    func onRotationGestureRecognizer(_ block: @escaping DyAction1<UIRotationGestureRecognizer>) -> Self {
        let rotation = UIRotationGestureRecognizer.rotationGestureRecognizer()
        rotation
            .dy
            .onStateChanged { [weak rotation] _ in
                guard let rotation else { return }
                block(rotation)
            }
        return self.addGestureRecognizer(rotation)
    }
}
