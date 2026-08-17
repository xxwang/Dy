import UIKit
import os.log

private extension UIView {
    /// 关联属性键
    enum Keys {
        /// 用于保存粒子发射器暂停前的原始 birthRate,避免恢复时读不到正确值
        static var emitterOriginalRatesKey: UInt8 = 0
    }
}

extension UIView {
    /// 以 `CAEmitterCell` 的 `ObjectIdentifier` 为键,保存其暂停前的 birthRate
    var emitterOriginalRates: [ObjectIdentifier: Float] {
        get { self.solo.GetAO(forKey: &Keys.emitterOriginalRatesKey) as? [ObjectIdentifier: Float] ?? [:] }
        set { self.solo.SetAO(newValue, forKey: &Keys.emitterOriginalRatesKey, policy: .OBJC_ASSOCIATION_RETAIN) }
    }
}

// MARK: - 2D 变换
public extension SoloWrapper where Base: UIView {
    /// 旋转
    /// - Parameters:
    ///   - angle: 旋转角度
    ///   - relative: 是否在当前 `transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间,默认 1 秒
    ///   - completion: 动画完成回调
    func rotate(
        _ angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: SoloAction1<Bool>? = nil
    ) {
        let newTransform = relative ? base.transform.rotated(by: angle) : CGAffineTransform(rotationAngle: angle)
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
    func scale(
        x: CGFloat,
        y: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        completion: SoloAction1<Bool>? = nil
    ) {
        let newTransform = relative ? base.transform.scaledBy(x: x, y: y) : CGAffineTransform(scaleX: x, y: y)
        self.add2DTransform(transform: newTransform, animated: animated, duration: duration, completion: completion)
    }

    /// 添加2D 变换(支持动画)
    /// - Parameters:
    ///   - transform: 2D变换
    ///   - animated: 是否动画
    ///   - duration: 动画时长
    ///   - completion: 完成回调
    func add2DTransform(
        transform: CGAffineTransform,
        animated: Bool,
        duration: TimeInterval,
        completion: SoloAction1<Bool>? = nil
    ) {
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: 0,
                options: [.allowUserInteraction, .curveEaseOut], // 更自然的缓动
                animations: { self.base.transform = transform },
                completion: completion
            )
        } else {
            self.base.transform = transform
            completion?(true)
        }
    }
}

// MARK: - 3D 变换
public extension SoloWrapper where Base: UIView {
    /// 沿 X 轴进行 3D 旋转
    /// - Parameters:
    ///   - angle: 旋转角度（弧度）
    ///   - relative: 是否在当前 `layer.transform` 基础上叠加
    ///   - animated: 是否启用动画
    ///   - duration: 动画持续时间，默认 1 秒
    ///   - perspective: 透视强度，默认 1/500（值越大透视越强）
    ///   - completion: 动画完成回调
    func rotate3D(
        aroundX angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: SoloAction1<Bool>? = nil
    ) {
        let current = relative ? base.layer.transform : CATransform3DIdentity
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
    func rotate3D(
        aroundY angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: SoloAction1<Bool>? = nil
    ) {
        let current = relative ? base.layer.transform : CATransform3DIdentity
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
    func rotate3D(
        aroundZ angle: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: SoloAction1<Bool>? = nil
    ) {
        let current = relative ? base.layer.transform : CATransform3DIdentity
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
    func rotate3D(
        x: CGFloat,
        y: CGFloat,
        z: CGFloat,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: SoloAction1<Bool>? = nil
    ) {
        let current = relative ? base.layer.transform : CATransform3DIdentity
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
    func scale3D(
        x: CGFloat,
        y: CGFloat,
        z: CGFloat = 1,
        relative: Bool = true,
        animated: Bool = false,
        duration: TimeInterval = 1,
        perspective: CGFloat = 1 / 500,
        completion: SoloAction1<Bool>? = nil
    ) {
        let current = relative ? base.layer.transform : CATransform3DIdentity
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
    func add3DTransform(
        _ transform: CATransform3D,
        animated: Bool,
        duration: TimeInterval,
        completion: SoloAction1<Bool>? = nil
    ) {
        if animated {
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                completion?(true)
            }
            let animation = CABasicAnimation(keyPath: "transform")
            animation.fromValue = base.layer.transform
            animation.toValue = transform
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            base.layer.add(animation, forKey: "3d_transform")
            base.layer.transform = transform
            CATransaction.commit()
        } else {
            base.layer.transform = transform
            completion?(true)
        }
    }
}

// MARK: - 阴影
public extension SoloWrapper where Base: UIView {
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
    func addShadow(
        color: UIColor,
        radius: CGFloat = 3,
        offset: CGSize = .zero,
        opacity: Float = 0.5,
        path: CGPath? = nil
    ) {
        base.layer.shadowColor = color.cgColor
        base.layer.shadowOffset = offset
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = min(max(opacity, 0), 1)
        base.layer.shadowPath = path
        base.layer.masksToBounds = false
    }
}

// MARK: - 角标 (徽章)
public extension SoloWrapper where Base: UIView {
    /// 添加或更新角标
    /// - Parameters:
    ///   - number: `0`移除,`""`小红点,其他数字(>99 显示 "99+")
    ///   - position: 相对于自身 `bounds` 的归一化位置 (`0～1`),默认右上角 (`x=1, y=0`)
    func showBadge(_ number: String, position: CGPoint = CGPoint(x: 1, y: 0)) {
        guard number != "0" else {
            self.removeBadge()
            return
        }

        if base.badgeLabel == nil {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = .white
            label.backgroundColor = UIColor(hex: "#EE0565")
            label.font = .systemFont(ofSize: 10)
            label.clipsToBounds = true
            base.addSubview(label)
            base.badgeLabel = label
        }

        guard let label = base.badgeLabel else {
            assertionFailure("badgeLabel should not be nil after creation")
            return
        }
        label.text = number.isEmpty ? "" : ((Int(number) ?? 0) > 99 ? "99+" : number)

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
            label.centerXAnchor.constraint(equalTo: base.centerXAnchor, constant: base.bounds.width * (position.x - 0.5)),
            label.centerYAnchor.constraint(equalTo: base.centerYAnchor, constant: base.bounds.height * (position.y - 0.5)),
        ])
    }

    /// 移除角标
    func removeBadge() {
        base.badgeLabel?.removeFromSuperview()
        base.badgeLabel = nil
    }
}

// MARK: - 水印
public extension SoloWrapper where Base: UIView {
    /// 添加水印(不会自动响应 `bounds` 变化)
    func addWatermark(
        _ text: String,
        textColor: UIColor = .black.withAlphaComponent(0.2),
        font: UIFont = .systemFont(ofSize: 12),
        density: CGFloat = 0.5,
        angle: CGFloat = -CGFloat.pi / 6
    ) {
        self.removeWatermark()
        let config = UIView.SoloWatermarkConfig(text: text, textColor: textColor, font: font, density: density, angle: angle)
        base.watermarkConfig = config
        self.applyWatermark(with: config)
    }

    /// 手动刷新水印(例如在 `viewDidLayoutSubviews`、`rotation` 后调用)
    func updateWatermark() {
        guard let config = base.watermarkConfig else { return }
        self.applyWatermark(with: config)
    }

    /// 移除水印
    func removeWatermark() {
        self.removeWatermarkLayers()
        base.watermarkConfig = nil
    }

    private func applyWatermark(with config: UIView.SoloWatermarkConfig) {
        self.removeWatermarkLayers()
        self.addWatermarkLayers(
            text: config.text,
            textColor: config.textColor,
            font: config.font,
            density: config.density,
            angle: config.angle
        )
    }

    private func addWatermarkLayers(text: String, textColor: UIColor, font: UIFont, density: CGFloat, angle: CGFloat) {
        let textSize = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).size

        let safeDensity = max(density, 0.01)
        let hSpacing = textSize.width * 2 / safeDensity
        let vSpacing = textSize.height * 2 / safeDensity

        let rows = Int((base.bounds.height + vSpacing) / vSpacing) + 1
        let cols = Int((base.bounds.width + hSpacing) / hSpacing) + 1

        for r in 0 ..< rows {
            for c in 0 ..< cols {
                let x = CGFloat(c) * hSpacing - hSpacing / 2
                let y = CGFloat(r) * vSpacing - vSpacing / 2
                let layer = self.createWatermarkLayer(text: text, textColor: textColor, font: font, position: CGPoint(x: x, y: y), angle: angle)
                layer.name = "solo.watermark"
                base.layer.addSublayer(layer)
            }
        }
    }

    private func removeWatermarkLayers() {
        base.layer.sublayers?.forEach {
            if $0.name == "solo.watermark" {
                $0.removeFromSuperlayer()
            }
        }
    }

    private func createWatermarkLayer(text: String, textColor: UIColor, font: UIFont, position: CGPoint, angle: CGFloat) -> CALayer {
        let size = (text as NSString).boundingRect(
            with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        ).size

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { ctx in
            textColor.set()
            (text as NSString).draw(at: .zero, withAttributes: [.font: font, .foregroundColor: textColor])
        }

        let layer = CALayer()
        layer.contents = image.cgImage
        layer.frame = CGRect(origin: position, size: size)
        layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        layer.name = "solo.watermark.content"
        return layer
    }
}

// MARK: - 过渡动画(淡入淡出)
public extension SoloWrapper where Base: UIView {
    /// 淡入动画
    ///
    /// - Parameters:
    ///   - options: 动画配置
    ///   - completion: 动画完成回调(`finished` 表示是否正常完成)
    ///
    /// - Important:
    ///   - `不会自动修改 `isHidden``,请确保视图已处于可见状态(`isHidden = false`)
    ///   - 若视图当前 `alpha == 1`,仍会执行动画(从当前 alpha 到 1)
    func fadeIn(
        options: UIView.SoloFadeAnimationOptions = UIView.SoloFadeAnimationOptions(),
        completion: SoloAction1<Bool>? = nil
    ) {
        // 仅重置 alpha,不干预 isHidden(避免意外显示)
        base.alpha = 0

        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction] // 保持交互
        UIView.animate(
            withDuration: options.duration,
            delay: options.delay,
            options: animationOptions,
            animations: {
                self.base.alpha = 1
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
    func fadeOut(
        options: UIView.SoloFadeAnimationOptions = UIView.SoloFadeAnimationOptions(),
        completion: SoloAction1<Bool>? = nil
    ) {
        let finalCompletion: SoloAction1<Bool> = { [weak base] finished in
            guard let base else { return }
            if options.removeOnCompletion {
                base.removeFromSuperview()
            } else if options.hideOnCompletion {
                base.isHidden = true
            }
            completion?(finished)
        }

        let animationOptions: UIView.AnimationOptions = [.allowUserInteraction]
        UIView.animate(
            withDuration: options.duration,
            delay: options.delay,
            options: animationOptions,
            animations: {
                self.base.alpha = 0
            },
            completion: finalCompletion
        )
    }
}

// MARK: - 抖动效果
public extension SoloWrapper where Base: UIView {
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
    func shake(
        direction: UIView.SoloShakeDirection = .horizontal,
        animationType: UIView.SoloShakeAnimationType = .easeOut,
        duration: TimeInterval = 0.6,
        amplitude: CGFloat = 20,
        shakeCount: Int = 5,
        completion: SoloAction? = nil
    ) {
        // 移除可能存在的旧抖动动画,防止叠加
        base.layer.removeAnimation(forKey: "shake")
        base.layer.removeAnimation(forKey: "springShake")

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
            base.layer.add(animation, forKey: "shake")
            CATransaction.commit()
        }
    }

    /// 创建基础关键帧抖动动画(非弹簧)
    private func createShakeAnimation(
        direction: UIView.SoloShakeDirection,
        animationType: UIView.SoloShakeAnimationType,
        duration: TimeInterval,
        amplitude: CGFloat,
        shakeCount: Int
    ) -> CAKeyframeAnimation {
        let keyPath = direction == .horizontal ?
            "transform.translation.x" : "transform.translation.y"

        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fillMode = .forwards

        // 设置缓动函数
        switch animationType {
        case .linear:
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
        case .easeIn:
            animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        case .easeOut:
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        case .easeInOut:
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        case .spring:
            assertionFailure("Spring should not use this path")
        }

        // 生成振幅递减的关键帧值
        var values: [CGFloat] = [0] // 从原点开始
        let step = amplitude / CGFloat(shakeCount)

        for i in 1 ... shakeCount {
            let currentAmplitude = amplitude - step * CGFloat(i - 1)
            if i % 2 == 1 {
                values.append(currentAmplitude)
            } else {
                values.append(-currentAmplitude)
            }
        }
        values.append(0) // 回到原点

        animation.values = values
        return animation
    }

    /// 创建弹簧抖动效果(更真实的物理回弹)
    private func springShake(
        direction: UIView.SoloShakeDirection,
        amplitude: CGFloat,
        completion: SoloAction? = nil
    ) {
        let keyPath = direction == .horizontal ?
            "transform.translation.x" : "transform.translation.y"

        // 第一次向正方向弹出
        let firstSpring = CASpringAnimation(keyPath: keyPath)
        firstSpring.fromValue = 0
        firstSpring.toValue = amplitude
        firstSpring.damping = 8
        firstSpring.stiffness = 200
        firstSpring.mass = 1.0
        firstSpring.initialVelocity = 5
        firstSpring.duration = firstSpring.settlingDuration

        // 第二次向负方向回弹(衔接第一次)
        let secondSpring = CASpringAnimation(keyPath: keyPath)
        secondSpring.fromValue = amplitude
        secondSpring.toValue = -amplitude * 0.7 // 衰减
        secondSpring.beginTime = CACurrentMediaTime() + firstSpring.duration
        secondSpring.damping = 8
        secondSpring.stiffness = 200
        secondSpring.mass = 1.0
        secondSpring.duration = secondSpring.settlingDuration

        // 第三次回到原点
        let thirdSpring = CASpringAnimation(keyPath: keyPath)
        thirdSpring.fromValue = -amplitude * 0.7
        thirdSpring.toValue = 0
        thirdSpring.beginTime = CACurrentMediaTime() + firstSpring.duration + secondSpring.duration
        thirdSpring.damping = 8
        thirdSpring.stiffness = 200
        thirdSpring.mass = 1.0
        thirdSpring.duration = thirdSpring.settlingDuration

        // 组合动画
        let group = CAAnimationGroup()
        group.animations = [firstSpring, secondSpring, thirdSpring]
        group.duration = firstSpring.duration + secondSpring.duration + thirdSpring.duration
        group.isRemovedOnCompletion = true
        group.fillMode = .forwards

        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        base.layer.add(group, forKey: "springShake")
        CATransaction.commit()
    }
}

// MARK: - 粒子发射器
public extension SoloWrapper where Base: UIView {
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
    func startEmitter(config: UIView.SoloEmitterConfig) -> CAEmitterLayer {
        self.stopEmitter()

        let emitter = CAEmitterLayer()
        emitter.name = "emitter"
        emitter.emitterPosition = CGPoint(
            x: base.bounds.width * config.position.x,
            y: base.bounds.height * config.position.y
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
                os_log(.error, "⚠️ Warning: Particle image '%{public}@' not found in Assets.", imageName)
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
            os_log(.error, "❌ Error: No valid particle images provided.")
            return emitter // 返回空发射器(可选：抛出异常或断言)
        }

        emitter.emitterCells = cells
        base.layer.addSublayer(emitter)

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
    func stopEmitter() {
        base.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil } // 兼容旧版
            .forEach { $0.removeFromSuperlayer() }
    }

    /// 暂停粒子发射(保留已有粒子动画)
    func pauseEmitter() {
        base.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil }
            .forEach { emitter in
                var rates = base.emitterOriginalRates
                emitter.emitterCells?.forEach { cell in
                    rates[ObjectIdentifier(cell)] = cell.birthRate
                    cell.birthRate = 0
                }
                base.emitterOriginalRates = rates
            }
    }

    /// 恢复粒子发射
    func resumeEmitter() {
        base.layer.sublayers?
            .compactMap { $0 as? CAEmitterLayer }
            .filter { $0.name == "emitter" || $0.name == nil }
            .forEach { emitter in
                let rates = base.emitterOriginalRates
                emitter.emitterCells?.forEach { cell in
                    // 恢复暂停前保存的原始 birthRate;若未保存则保持当前值
                    cell.birthRate = rates[ObjectIdentifier(cell)] ?? cell.birthRate
                }
            }
    }
}

// MARK: - 截图
public extension SoloWrapper where Base: UIView {
    /// 截取整个视图的快照
    /// - Parameter options: 截图配置选项
    /// - Returns: 截图 UIImage,失败返回 nil
    ///
    /// - 注意:
    ///   - 请确保在`主线程`调用,且视图已完成布局和渲染
    ///   - 对于大视图可能消耗较多内存
    func captureScreenshot(options: UIView.SoloScreenshotOptions = UIView.SoloScreenshotOptions()) -> UIImage? {
        assert(Thread.isMainThread, "captureScreenshot must be called on main thread")

        let bounds = base.bounds
        guard bounds.width > 0, bounds.height > 0 else {
            os_log(.error, "⚠️ 截图失败: 视图 bounds 无效")
            return nil
        }

        let scale = options.scaleToScreen ? SoloScreen.screenScale : 1.0

        UIGraphicsBeginImageContextWithOptions(bounds.size, options.opaque, scale)
        defer {
            // 必须无条件结束,避免内存泄漏
            UIGraphicsEndImageContext()
        }

        guard UIGraphicsGetCurrentContext() != nil else {
            os_log(.error, "⚠️ 截图失败: 无法创建图形上下文")
            return nil
        }

        // 渲染整个视图层级
        base.drawHierarchy(in: bounds, afterScreenUpdates: false)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            os_log(.error, "⚠️ 截图失败: 无法从上下文提取图像")
            return nil
        }

        return image.solo.compress(qualityRange: options.qualityRange)
    }

    /// 截取视图指定区域
    /// - Parameters:
    ///   - rect: 要截取的区域(基于视图坐标系)
    ///   - options: 截图配置选项
    /// - Returns: 裁剪后的 `UIImage`,失败返回 nil
    ///
    /// - 注意:
    ///   - 区域超出视图范围会自动裁剪
    func captureScreenshot(in rect: CGRect, options: UIView.SoloScreenshotOptions = UIView.SoloScreenshotOptions()) -> UIImage? {
        guard let fullImage = self.captureScreenshot(options: options) else {
            return nil
        }

        let validRect = rect.intersection(base.bounds)
        guard !validRect.isEmpty else {
            os_log(.error, "⚠️ 截图失败: 裁剪区域与视图无交集")
            return nil
        }

        // 使用fullImage自身的scale,而非屏幕scale
        let scaledRect = CGRect(
            x: validRect.origin.x * fullImage.scale,
            y: validRect.origin.y * fullImage.scale,
            width: validRect.size.width * fullImage.scale,
            height: validRect.size.height * fullImage.scale
        )

        return fullImage.solo.crop(to: scaledRect)
    }
}
