import UIKit

// MARK: - 2D 变换
public extension UIView {
    /// 旋转
    /// - Parameters:
    ///   - angle: 旋转角度
    ///   - relative: 是否在当前 `transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间,默认 1 秒
    ///   - completion: 动画完成回调
    func dy_rotate(
        _ angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        let newTransform = relative ? self.transform.rotated(by: angle) : CGAffineTransform(rotationAngle: angle)
        self.add2DTransform(transform: newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 缩放
    /// - Parameters:
    ///   - x: `水平`缩放比例
    ///   - y: `垂直`缩放比例
    ///   - relative: 是否在当前 `transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间,默认 1 秒
    ///   - completion: 动画完成回调
    func dy_scale(
        x: CGFloat,
        y: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: ((Bool) -> Void)? = nil
    ) {
        let newTransform = relative ? self.transform.scaledBy(x: x, y: y) : CGAffineTransform(scaleX: x, y: y)
        self.add2DTransform(transform: newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 添加2D 变换(支持动画)
    /// - Parameters:
    ///   - transform: 2D变换
    ///   - animated: 是否动画
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func dy_add2DTransform(
        transform: CGAffineTransform,
        animated: Bool,
        duration: TimeInterval,
        completion: ((Bool) -> Void)?
    ) {
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.allowUserInteraction, .curveEaseOut], // 更自然的缓动
                animations: { self.transform = transform },
                completion: completion
            )
        } else {
            self.transform = transform
            completion?(true)
        }
    }
}

// MARK: - 3D 变换
public extension UIView {
    /// 沿 X 轴进行 3D 旋转
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500（值越大透视越强）
    ///   - completion: 动画完成回调
    func dy_rotate3D(
        aroundX angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: ((Bool) -> Void)? = nil
    ) {
        let current = relative ? self.layer.transform : CATransform3DIdentity
        var transform = CATransform3DIdentity
        transform.m34 = -perspective
        let rotation = CATransform3DRotate(transform, angle, 1, 0, 0)
        let newTransform = relative ? CATransform3DConcat(current, rotation) : rotation

        self.add3DTransform(newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 沿 Y 轴进行 3D 旋转
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500
    ///   - completion: 动画完成回调
    func dy_rotate3D(
        aroundY angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: ((Bool) -> Void)? = nil
    ) {
        let current = relative ? self.layer.transform : CATransform3DIdentity
        var transform = CATransform3DIdentity
        transform.m34 = -perspective
        let rotation = CATransform3DRotate(transform, angle, 0, 1, 0)
        let newTransform = relative ? CATransform3DConcat(current, rotation) : rotation

        self.add3DTransform(newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 沿 Z 轴进行 3D 旋转（等效于 2D 旋转，但使用 3D 引擎）
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500
    ///   - completion: 动画完成回调
    func dy_rotate3D(
        aroundZ angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: ((Bool) -> Void)? = nil
    ) {
        let current = relative ? self.layer.transform : CATransform3DIdentity
        var transform = CATransform3DIdentity
        transform.m34 = -perspective
        let rotation = CATransform3DRotate(transform, angle, 0, 0, 1)
        let newTransform = relative ? CATransform3DConcat(current, rotation) : rotation

        self.add3DTransform(newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 复合 3D 旋转（按 X → Y → Z 顺序应用）
    /// - Parameters:
    ///   - x: X 轴旋转角度
    ///   - y: Y 轴旋转角度
    ///   - z: Z 轴旋转角度
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500
    ///   - completion: 动画完成回调
    ///
    /// - Warning: 旋转顺序为 X → Y → Z，不同顺序结果不同
    func dy_rotate3D(
        x: CGFloat,
        y: CGFloat,
        z: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: ((Bool) -> Void)? = nil
    ) {
        let current = relative ? self.layer.transform : CATransform3DIdentity
        var transform = CATransform3DIdentity
        transform.m34 = -perspective
        transform = CATransform3DRotate(transform, x, 1, 0, 0)
        transform = CATransform3DRotate(transform, y, 0, 1, 0)
        transform = CATransform3DRotate(transform, z, 0, 0, 1)
        let newTransform = relative ? CATransform3DConcat(current, transform) : transform

        self.add3DTransform(newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 3D 缩放
    /// - Parameters:
    ///   - x: 水平缩放比例
    ///   - y: 垂直缩放比例
    ///   - z: 深度缩放比例，默认 1.0
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500
    ///   - completion: 动画完成回调
    func dy_scale3D(
        x: CGFloat,
        y: CGFloat,
        z: CGFloat = 1,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: ((Bool) -> Void)? = nil
    ) {
        let current = relative ? self.layer.transform : CATransform3DIdentity
        var transform = CATransform3DIdentity
        transform.m34 = -perspective
        let scale = CATransform3DScale(transform, x, y, z)
        let newTransform = relative ? CATransform3DConcat(current, scale) : scale

        self.add3DTransform(newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 添加3D变化(支持动画)
    /// - Parameters:
    ///   - transform: 3D变换
    ///   - animated: 是否动画
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func dy_add3DTransform(
        _ transform: CATransform3D,
        animated: Bool,
        duration: TimeInterval,
        completion: ((Bool) -> Void)?
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = self.layer.transform
            animation.toValue = transform
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            self.layer.add(animation, forKey: "3d_transform")
            self.layer.transform = transform
            CATransaction.commit()
        } else {
            self.layer.transform = transform
            completion?(true)
        }
    }
}

// MARK: - 阴影
public extension UIView {
    /// 添加标准外阴影效果
    ///
    /// - Note: 此阴影基于 `CALayer.shadow*` 属性实现,`不会随 bounds 自动更新`
    ///
    /// - Parameters:
    ///   - color: 阴影颜色默认为 `#137992`
    ///   - radius: 阴影模糊半径默认为 `3`
    ///   - offset: 阴影偏移量(正 x 向右,正 y 向下)默认为 `.zero`
    ///   - opacity: 阴影不透明度,范围 `[0, 1]`默认为 `0.5`
    ///   - path: 可选的阴影路径若提供,可提升性能并精确控制形状;若为 `nil`,系统自动计算
    func dy_addShadow(
        color: UIColor,
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5,
        path: CGPath? = nil
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = min(max(opacity, 0), 1)
        self.layer.shadowPath = path
        self.layer.masksToBounds = false
    }
}

// MARK: - 圆角
public extension UIView {
    /// 设置圆角(⚠️前提: 需要视图的`frame`已经确定)
    /// - Parameters:
    ///   - radius: 圆角的半径
    ///   - corners: 需要设置圆角的角(例如`.topLeft`,`.topRight`,`.allCorners`等)
    /// - Returns: 当前视图`self`
    @discardableResult
    func dy_roundedCorner(radius: CGFloat, corners: UIRectCorner) -> Self {
        guard !self.bounds.isEmpty else {
            print("⚠️ Warning: roundedCorner called with zero bounds. Call after layout.")
            return self
        }

        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = maskPath.cgPath
        self.layer.mask = shapeLayer

        return self
    }
}

// MARK: - 角标 (徽章)
public extension UIView {
    /// 添加或更新角标
    /// - Parameters:
    ///   - number: `0`移除,`""`小红点,其他数字(>99 显示 "99+")
    ///   - position: 相对于自身 `bounds` 的归一化位置 (`0～1`),默认右上角 (`x=1, y=0`)
    func dy_showBadge(_ number: String, position: CGPoint = CGPoint(x: 1, y: 0)) {
        guard number != "0" else {
            self.removeBadge()
            return
        }

        if self.badgeLabel == nil {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = UIColor(hex: "#EE0565")
            label.font = .systemFont(ofSize: 10)
            label.clipsToBounds = true
            self.addSubview(label)
            self.badgeLabel = label
        }

        let label = self.badgeLabel!
        label.text = number.isEmpty ? "" : (Int(number) ?? 0 > 99 ? "99+" : number)

        // 更新圆角
        label.layer.cornerRadius = number.isEmpty ? 5 : 8

        // 更新约束
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(label.constraints.filter { $0.firstItem as? UIView == label || $0.secondItem as? UIView == label })

        let size: CGFloat = number.isEmpty ? 10 : max(label.intrinsicContentSize.width + 10, 16)
        let height: CGFloat = number.isEmpty ? 10 : 16

        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: size),
            label.heightAnchor.constraint(equalToConstant: height),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: self.bounds.width * (position.x - 0.5)),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: self.bounds.height * (position.y - 0.5)),
        ])
    }

    /// 移除角标
    func dy_removeBadge() {
        self.badgeLabel?.removeFromSuperview()
        self.badgeLabel = nil
    }
}

// MARK: - 水印
public extension UIView {
    /// 添加水印(不会自动响应 `bounds` 变化)
    func dy_addWatermark(
        _ text: String,
        textColor: UIColor = .black.withAlphaComponent(0.2),
        font: UIFont = .systemFont(ofSize: 12),
        density: CGFloat = 0.5,
        angle: CGFloat = -CGFloat.pi / 6
    ) {
        self.removeWatermark()
        let config = UIView.WatermarkConfig(text: text, textColor: textColor, font: font, density: density, angle: angle)
        self.watermarkConfig = config
        self.applyWatermark(with: config)
    }

    /// 手动刷新水印(例如在 `viewDidLayoutSubviews`、`rotation` 后调用)
    func dy_updateWatermark() {
        guard let config = self.watermarkConfig else { return }
        self.applyWatermark(with: config)
    }

    /// 移除水印
    func dy_removeWatermark() {
        self.removeWatermarkLayers()
        self.watermarkConfig = nil
    }
}

// MARK: - 过渡动画(淡入淡出)
public extension UIView {
    /// 淡入动画
    ///
    /// - Parameters:
    ///   - options: 动画配置
    ///   - completion: 动画完成回调(`finished` 表示是否正常完成)
    ///
    /// - Important:
    ///   - `不会自动修改 `isHidden``,请确保视图已处于可见状态(`isHidden = false`)
    ///   - 若视图当前 `alpha == 1`,仍会执行动画(从当前 alpha 到 1)
    func dy_fadeIn(
        options: UIView.FadeAnimationOptions = UIView.FadeAnimationOptions(),
        completion: ((Bool) -> Void)? = nil
    ) {
        // 仅重置 alpha,不干预 isHidden(避免意外显示)
        self.alpha = 0

        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction] // 保持交互
        UIView.animate(
            withDuration: options.duration,
            delay: options.delay,
            options: animationOptions,
            animations: {
                self.alpha = 1
            },
            completion: completion
        )
    }

    /// 淡出动画
    ///
    /// - Parameters:
    ///   - options: 动画配置
    ///   - completion: 动画完成回调
    ///
    /// - Important:
    ///   - 若 `removeOnCompletion = true`,视图将被移除,后续操作无效
    ///   - `hideOnCompletion` 在 `removeOnCompletion = true` 时被忽略
    func dy_fadeOut(
        options: UIView.FadeAnimationOptions = UIView.FadeAnimationOptions(),
        completion: ((Bool) -> Void)? = nil
    ) {
        let finalCompletion: (Bool) -> Void = { [weak self] finished in
            guard let self else { return }
            if options.removeOnCompletion {
                self.removeFromSuperview()
            } else if options.hideOnCompletion {
                self.isHidden = true
            }
            completion?(finished)
        }

        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        UIView.animate(
            withDuration: options.duration,
            delay: options.delay,
            options: animationOptions,
            animations: {
                self.alpha = 0
            },
            completion: finalCompletion
        )
    }
}

// MARK: - 抖动效果
public extension UIView {
    /// 为视图添加抖动效果
    ///
    /// - Parameters:
    ///   - direction: 抖动方向,默认为 `.horizontal`(水平)
    ///   - animationType: 动画缓动类型,默认为 `.easeOut`
    ///   - duration: 动画总时长(秒),默认 `0.6``弹簧模式下此参数被忽略`
    ///   - amplitude: 最大抖动幅度(像素),默认 `20`
    ///   - shakeCount: 抖动次数(一个“来回”算两次),默认 `5`(即 2～3 个完整周期)
    ///   - completion: 动画完成后的回调闭包
    ///
    /// - Important:
    ///   - 每次调用会`自动移除`之前同类型的抖动动画,避免叠加
    ///   - 弹簧模式 (`spring`) 会模拟自然衰减的弹性抖动,`不依赖 `shakeCount` 和 `duration``,
    ///     但 `amplitude` 仍控制初始偏移量
    func dy_shake(
        direction: UIView.ShakeDirection = .horizontal,
        animationType: UIView.ShakeAnimationType = .easeOut,
        duration: TimeInterval = 0.6,
        amplitude: CGFloat = 20,
        shakeCount: Int = 5,
        completion: (() -> Void)? = nil
    ) {
        // 移除可能存在的旧抖动动画,防止叠加
        self.layer.removeAnimation(forKey: "shake")
        self.layer.removeAnimation(forKey: "springShake")

        if animationType == .spring {
            self.springShake(
                direction: direction,
                amplitude: amplitude,
                completion: completion
            )
        } else {
            let animation = self.createShakeAnimation(
                direction: direction,
                animationType: animationType,
                duration: duration,
                amplitude: amplitude,
                shakeCount: shakeCount
            )
            animation.keyPath = "shake"

            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            self.layer.add(animation, forKey: "shake")
            CATransaction.commit()
        }
    }
}

// MARK: - 粒子发射器
public extension UIView {
    /// 启动粒子发射器
    ///
    /// - Parameter config: 粒子发射器配置
    /// - Returns: 创建的 `CAEmitterLayer` 实例
    ///
    /// - Important:
    ///   - 视图的 `bounds` 必须已确定(建议在 `layoutSubviews` 后调用)
    ///   - `config.cellImages` 中的图片必须存在于 Asset Catalog
    ///   - 若图片加载失败,该粒子将被跳过(不会崩溃)
    @discardableResult
    func dy_startEmitter(config: UIView.EmitterConfig) -> CAEmitterLayer {
        self.stopEmitter()

        let emitter = CAEmitterLayer()
        emitter.name = "emitter"
        emitter.emitterPosition = CGPoint(
            x: bounds.width * config.position.x,
            y: bounds.height * config.position.y
        )
        emitter.emitterSize = config.size
        emitter.emitterShape = config.shape
        emitter.emitterMode = config.mode
        emitter.preservesDepth = config.preservesDepth
        emitter.renderMode = config.renderMode

        // 存储原始 birthRate 用于 resume
        let originalBirthRate = config.birthRate

        // 创建粒子单元
        let cells = config.cellImages.compactMap { imageName -> CAEmitterCell? in
            guard let image = UIImage(named: imageName)?.cgImage else {
                print("⚠️ Warning: Particle image '\(imageName)' not found in Assets.")
                return nil
            }
            let cell = CAEmitterCell()
            cell.contents = image
            cell.scale = config.scale
            cell.scaleRange = config.scaleRange
            cell.scaleSpeed = config.scaleSpeed
            cell.lifetime = config.lifetime
            cell.lifetimeRange = config.lifetimeRange
            cell.birthRate = config.fireOnce ? config.birthRate : 0 // 先设为0,稍后启动
            cell.color = config.color.cgColor
            // 正确设置颜色随机范围(基于 0～1 的色值偏移)
            cell.redRange = config.colorVariation
            cell.greenRange = config.colorVariation
            cell.blueRange = config.colorVariation
            cell.alphaRange = config.colorVariation
            cell.alphaSpeed = config.alphaSpeed
            cell.spin = config.spin
            cell.spinRange = config.spinRange
            cell.velocity = config.velocity
            cell.velocityRange = config.velocityRange
            cell.emissionLongitude = config.emissionLongitude
            cell.emissionRange = config.emissionRange
            cell.xAcceleration = config.xAcceleration
            cell.yAcceleration = config.yAcceleration
            cell.zAcceleration = config.zAcceleration
            return cell
        }

        guard !cells.isEmpty else {
            print("❌ Error: No valid particle images provided.")
            return emitter // 返回空发射器(可选：抛出异常或断言)
        }

        emitter.emitterCells = cells
        self.layer.addSublayer(emitter)

        // 启动发射(延迟一帧确保图层已添加)
        DispatchQueue.main.async {
            cells.forEach { $0.birthRate = originalBirthRate }
        }

        // 处理自动停止/移除
        let removeDelay: TimeInterval
        if config.fireOnce {
            // 按最大可能生命周期计算
            removeDelay = Double(config.lifetime + config.lifetimeRange) + 0.5
        } else if config.autoRemoveAfter > 0 {
            removeDelay = config.autoRemoveAfter
        } else {
            return emitter // 不需要自动移除
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + removeDelay) {
            // 停止生成新粒子
            cells.forEach { $0.birthRate = 0 }
            // 等待现有粒子消亡后再移除图层
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                emitter.removeFromSuperlayer()
            }
        }

        return emitter
    }

    /// 停止并移除所有粒子发射器
    func dy_stopEmitter() {
        self.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil } // 兼容旧版
            .forEach { $0.removeFromSuperlayer() }
    }

    /// 暂停粒子发射(保留已有粒子动画)
    func dy_pauseEmitter() {
        self.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil }
            .forEach { emitter in
                emitter.emitterCells?.forEach { $0.birthRate = 0 }
            }
    }

    /// 恢复粒子发射
    func dy_resumeEmitter() {
        self.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil }
            .forEach { emitter in
                // 恢复每个 cell 的原始 birthRate(这里假设它们相同)
                let originalRate = emitter.emitterCells?.first?.birthRate ?? 1.0
                emitter.emitterCells?.forEach { $0.birthRate = originalRate }
            }
    }
}

// MARK: - 截图
public extension UIView {
    /// 截取整个视图的快照
    /// - Parameter options: 截图配置选项
    /// - Returns: 截图 UIImage,失败返回 nil
    ///
    /// - 注意:
    ///   - 请确保在`主线程`调用,且视图已完成布局和渲染
    ///   - 对于大视图可能消耗较多内存
    func dy_captureScreenshot(options: UIView.ScreenshotOptions = UIView.ScreenshotOptions()) -> UIImage? {
        assert(Thread.isMainThread, "captureScreenshot must be called on main thread")

        let bounds = self.bounds
        guard bounds.width > 0, bounds.height > 0 else {
            debugPrint("⚠️ 截图失败: 视图 bounds 无效 (\(bounds))")
            return nil
        }

        let scale = options.scaleToScreen ? UIScreen.main.scale : 1.0

        UIGraphicsBeginImageContextWithOptions(bounds.size, options.opaque, scale)
        defer {
            // 必须无条件结束,避免内存泄漏
            UIGraphicsEndImageContext()
        }

        guard UIGraphicsGetCurrentContext() != nil else {
            debugPrint("⚠️ 截图失败: 无法创建图形上下文")
            return nil
        }

        // 渲染整个视图层级
        self.drawHierarchy(in: bounds, afterScreenUpdates: false)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            debugPrint("⚠️ 截图失败: 无法从上下文提取图像")
            return nil
        }

        return image.compress(qualityRange: options.qualityRange)
    }

    /// 截取视图指定区域
    /// - Parameters:
    ///   - rect: 要截取的区域(基于视图坐标系)
    ///   - options: 截图配置选项
    /// - Returns: 裁剪后的 `UIImage`,失败返回 nil
    ///
    /// - 注意:
    ///   - 区域超出视图范围会自动裁剪
    func dy_captureScreenshot(in rect: CGRect, options: UIView.ScreenshotOptions = UIView.ScreenshotOptions()) -> UIImage? {
        guard let fullImage = self.captureScreenshot(options: options) else {
            return nil
        }

        let validRect = rect.intersection(self.bounds)
        guard !validRect.isEmpty else {
            debugPrint("⚠️ 截图失败: 裁剪区域与视图无交集")
            return nil
        }

        // 使用fullImage自身的scale,而非屏幕scale
        let scaledRect = CGRect(
            x: validRect.origin.x * fullImage.scale,
            y: validRect.origin.y * fullImage.scale,
            width: validRect.size.width * fullImage.scale,
            height: validRect.size.height * fullImage.scale
        )

        return fullImage.crop(to: scaledRect)
    }
}
