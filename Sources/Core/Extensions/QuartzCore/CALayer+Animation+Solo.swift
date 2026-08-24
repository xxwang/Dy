import QuartzCore
import UIKit

// MARK: - CABasicAnimation
public extension CALayer {
    /// 表示平移动画的方向轴
    enum SoloAxis {
        case x
        case y
    }

    /// 使用基本动画将图层移动到指定位置
    ///
    /// 此方法通过修改 `position` 属性实现平滑位移动画
    ///
    /// - Parameters:
    ///   - to: 目标位置
    ///   - duration: 动画持续时间(秒),默认为 2.0
    ///   - delay: 动画开始前的延迟时间(秒),默认为 0
    ///   - repeatCount: 动画重复次数,默认为 1设为 `.infinity` 可无限重复
    ///   - removedOnCompletion: 动画结束后是否从图层移除,默认为 `false`(保留最终状态)
    ///   - timingFunction: 动画缓动函数,默认为 `.default`
    ///
    /// - Example:
    ///   ```swift
    ///   layer.solo_basicAnimationMove(to: CGPoint(x: 100, y: 100), duration: 1.5)
    ///   ```
    func solo_basicAnimationMove(
        to point: CGPoint,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addBasicAnimation(
            keyPath: "position",
            fromValue: self.position,
            toValue: point,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用基本动画沿 X 轴或 Y 轴平移图层
    ///
    /// - Parameters:
    ///   - axis: 平移方向(`.x` 或 `.y`)
    ///   - to: 目标偏移量(单位：点)
    ///   - duration: 动画持续时间(秒),默认为 2.0
    ///   - delay: 动画开始前的延迟时间(秒),默认为 0
    ///   - repeatCount: 动画重复次数,默认为 1
    ///   - removedOnCompletion: 动画结束后是否移除,默认为 `false`
    ///   - timingFunction: 动画缓动函数,默认为 `.default`
    ///
    /// - Example:
    ///   ```swift
    ///   layer.solo_basicAnimationTranslation(axis: .x, to: 100, duration: 1.0)
    ///   ```
    func solo_basicAnimationTranslation(
        axis: SoloAxis,
        to value: CGFloat,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        let keyPath: String = switch axis {
        case .x:
            "transform.translation.x"
        case .y:
            "transform.translation.y"
        }
        self.solo_addBasicAnimation(
            keyPath: keyPath,
            fromValue: nil, // Core Animation 自动使用当前值
            toValue: value,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用基本动画改变图层的圆角半径
    ///
    /// - Parameters:
    ///   - to: 目标圆角半径
    ///   - duration: 动画持续时间(秒),默认为 2.0
    ///   - delay: 动画开始前的延迟时间(秒),默认为 0
    ///   - repeatCount: 动画重复次数,默认为 1
    ///   - removedOnCompletion: 动画结束后是否移除,默认为 `false`
    ///   - timingFunction: 动画缓动函数,默认为 `.default`
    ///
    /// - Example:
    ///   ```swift
    ///   layer.solo_basicAnimationCornerRadius(to: 20, duration: 0.5)
    ///   ```
    func solo_basicAnimationCornerRadius(
        to radius: CGFloat,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addBasicAnimation(
            keyPath: "cornerRadius",
            fromValue: cornerRadius,
            toValue: radius,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用基本动画对图层进行缩放
    ///
    /// - Parameters:
    ///   - to: 目标缩放比例(1.0 表示原始大小)
    ///   - duration: 动画持续时间(秒),默认为 2.0
    ///   - delay: 动画开始前的延迟时间(秒),默认为 0
    ///   - repeatCount: 动画重复次数,默认为 1
    ///   - removedOnCompletion: 动画结束后是否移除,默认为 `true`(因缩放通常不保留)
    ///   - timingFunction: 动画缓动函数,默认为 `.default`
    ///
    /// - Example:
    ///   ```swift
    ///   layer.solo_basicAnimationScale(to: 1.5, duration: 0.3)
    ///   ```
    func solo_basicAnimationScale(
        to scale: CGFloat,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = true,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addBasicAnimation(
            keyPath: "transform.scale",
            fromValue: nil,
            toValue: scale,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用基本动画对图层进行旋转
    ///
    /// - Parameters:
    ///   - to: 目标旋转角度(弧度)
    ///   - duration: 动画持续时间(秒),默认为 2.0
    ///   - delay: 动画开始前的延迟时间(秒),默认为 0
    ///   - repeatCount: 动画重复次数,默认为 1
    ///   - removedOnCompletion: 动画结束后是否移除,默认为 `true`
    ///   - timingFunction: 动画缓动函数,默认为 `.default`
    ///
    /// - Example:
    ///   ```swift
    ///   layer.solo_basicAnimationRotation(to: .pi, duration: 1.0)
    ///   ```
    func solo_basicAnimationRotation(
        to angle: CGFloat,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = true,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addBasicAnimation(
            keyPath: "transform.rotation",
            fromValue: nil,
            toValue: angle,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 内部通用方法：应用 `CABasicAnimation`
    ///
    /// - Note: 不建议外部直接调用
    private func solo_addBasicAnimation(
        keyPath: String,
        fromValue: Any?,
        toValue: Any?,
        duration: TimeInterval,
        delay: TimeInterval,
        repeatCount: Float,
        removedOnCompletion: Bool,
        timingFunction: CAMediaTimingFunctionName
    ) {
        let animation = CABasicAnimation(keyPath: keyPath)
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = max(0, duration)
        animation.beginTime = CACurrentMediaTime() + max(0, delay)
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removedOnCompletion
        animation.fillMode = removedOnCompletion ? .removed : .forwards
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        self.add(animation, forKey: animation.keyPath)
    }
}

// MARK: - CAKeyframeAnimation
public extension CALayer {
    /// 使用关键帧动画沿一系列点移动图层
    ///
    /// - Parameters:
    ///   - positions: 位置点数组
    ///   - keyTimes: 每个关键帧的时间比例(0.0 ～ 1.0),可选
    ///   - duration: 动画总时长(秒),默认为 2.0
    ///   - delay: 延迟时间(秒),默认为 0
    ///   - repeatCount: 重复次数,默认为 1
    ///   - removedOnCompletion: 是否在完成后移除动画,默认为 `false`
    ///   - timingFunction: 缓动函数,默认为 `.default`
    ///
    /// - Precondition: `positions` 非空
    func solo_keyframeAnimationMove(
        positions: [CGPoint],
        keyTimes: [NSNumber]? = nil,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        guard !positions.isEmpty else { return }
        self.solo_addKeyframeAnimation(
            keyPath: "position",
            values: positions,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用关键帧动画实现抖动效果(常用于错误提示等)
    ///
    /// 默认使用 ±5 度的轻微旋转
    ///
    /// - Parameters:
    ///   - angles: 旋转角度数组(弧度),默认为 `[-5°, +5°, -5°]`
    ///   - keyTimes: 时间比例数组,可选
    ///   - duration: 动画总时长(秒),默认为 0.3
    ///   - delay: 延迟时间(秒),默认为 0
    ///   - repeatCount: 重复次数,默认为 1
    ///   - removedOnCompletion: 是否在完成后移除动画,默认为 `true`
    ///   - timingFunction: 缓动函数,默认为 `.linear`(更自然的抖动)
    func solo_keyframeAnimationShake(
        angles: [CGFloat] = [
            (-5).solo_radians(),
            5.solo_radians(),
            (-5).solo_radians(),
        ],
        keyTimes: [NSNumber]? = nil,
        duration: TimeInterval = 0.3,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = true,
        timingFunction: CAMediaTimingFunctionName = .linear
    ) {
        guard !angles.isEmpty else { return }
        self.solo_addKeyframeAnimation(
            keyPath: "transform.rotation",
            values: angles,
            keyTimes: keyTimes,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: nil,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 使用贝塞尔路径驱动图层的位置动画
    ///
    /// - Parameters:
    ///   - path: 路径(`CGPath`)
    ///   - duration: 动画总时长(秒),默认为 2.0
    ///   - delay: 延迟时间(秒),默认为 0
    ///   - repeatCount: 重复次数,默认为 1
    ///   - removedOnCompletion: 是否在完成后移除动画,默认为 `false`
    ///   - timingFunction: 缓动函数,默认为 `.default`
    ///
    /// - Precondition: `path` 非空
    func solo_keyframeAnimationAlongPath(
        _ path: CGPath,
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addKeyframeAnimation(
            keyPath: "position",
            values: nil,
            keyTimes: nil,
            duration: duration,
            delay: delay,
            repeatCount: repeatCount,
            path: path,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 内部通用方法：应用 `CAKeyframeAnimation`
    private func solo_addKeyframeAnimation(
        keyPath: String,
        values: [Any]? = nil,
        keyTimes: [NSNumber]? = nil,
        duration: TimeInterval,
        delay: TimeInterval,
        repeatCount: Float,
        path: CGPath?,
        removedOnCompletion: Bool,
        timingFunction: CAMediaTimingFunctionName
    ) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.duration = max(0, duration)
        animation.beginTime = CACurrentMediaTime() + max(0, delay)
        animation.repeatCount = repeatCount
        animation.isRemovedOnCompletion = removedOnCompletion
        animation.fillMode = removedOnCompletion ? .removed : .forwards
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)

        if let values, !values.isEmpty {
            animation.values = values
        }

        if let keyTimes, !keyTimes.isEmpty {
            animation.keyTimes = keyTimes
        }

        if let path {
            animation.path = path
            animation.calculationMode = .paced
            animation.rotationMode = .rotateAuto
        }

        self.add(animation, forKey: animation.keyPath)
    }
}

// MARK: - CASpringAnimation
public extension CALayer {
    /// 使用弹簧动画改变图层的 bounds
    ///
    /// - Parameters:
    ///   - to: 目标 bounds
    ///   - delay: 延迟时间(秒),默认为 0
    ///   - mass: 质量(默认 10.0)
    ///   - stiffness: 刚度(默认 5000)
    ///   - damping: 阻尼(默认 100.0)
    ///   - initialVelocity: 初始速度(默认 5)
    ///   - repeatCount: 重复次数,默认为 1
    ///   - removedOnCompletion: 是否在完成后移除动画,默认为 `false`
    ///   - timingFunction: 缓动函数,默认为 `.default`
    func solo_springAnimationBounds(
        to bounds: CGRect,
        delay: TimeInterval = 0,
        mass: CGFloat = 10.0,
        stiffness: CGFloat = 5000,
        damping: CGFloat = 100.0,
        initialVelocity: CGFloat = 5,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        self.solo_addSpringAnimation(
            keyPath: "bounds",
            toValue: bounds,
            delay: delay,
            mass: mass,
            stiffness: stiffness,
            damping: damping,
            initialVelocity: initialVelocity,
            repeatCount: repeatCount,
            removedOnCompletion: removedOnCompletion,
            timingFunction: timingFunction
        )
    }

    /// 内部通用方法：应用 `CASpringAnimation`
    private func solo_addSpringAnimation(
        keyPath: String,
        toValue: Any?,
        delay: TimeInterval,
        mass: CGFloat,
        stiffness: CGFloat,
        damping: CGFloat,
        initialVelocity: CGFloat,
        repeatCount: Float,
        removedOnCompletion: Bool,
        timingFunction: CAMediaTimingFunctionName
    ) {
        let animation = CASpringAnimation(keyPath: keyPath)
        animation.beginTime = CACurrentMediaTime() + max(0, delay)
        animation.mass = max(0.01, mass)
        animation.stiffness = max(1, stiffness)
        animation.damping = max(0.01, damping)
        animation.initialVelocity = initialVelocity
        animation.duration = animation.settlingDuration
        animation.toValue = toValue
        animation.isRemovedOnCompletion = removedOnCompletion
        animation.fillMode = removedOnCompletion ? .removed : .forwards
        animation.timingFunction = CAMediaTimingFunction(name: timingFunction)
        self.add(animation, forKey: animation.keyPath)
    }
}

// MARK: - CAAnimationGroup
public extension CALayer {
    /// 同时执行一组动画
    ///
    /// - Parameters:
    ///   - animations: 动画数组
    ///   - duration: 总时长(秒),默认为 2.0
    ///   - delay: 延迟时间(秒),默认为 0
    ///   - repeatCount: 重复次数,默认为 1
    ///   - removedOnCompletion: 是否在完成后移除动画,默认为 `false`
    ///   - timingFunction: 缓动函数,默认为 `.default`
    ///
    /// - Precondition: `animations` 非空
    func solo_addAnimationGroup(
        _ animations: [CAAnimation],
        duration: TimeInterval = 2.0,
        delay: TimeInterval = 0,
        repeatCount: Float = 1,
        removedOnCompletion: Bool = false,
        timingFunction: CAMediaTimingFunctionName = .default
    ) {
        guard !animations.isEmpty else { return }
        let group = CAAnimationGroup()
        group.animations = animations
        group.duration = max(0, duration)
        group.beginTime = CACurrentMediaTime() + max(0, delay)
        group.repeatCount = repeatCount
        group.isRemovedOnCompletion = removedOnCompletion
        group.fillMode = removedOnCompletion ? .removed : .forwards
        group.timingFunction = CAMediaTimingFunction(name: timingFunction)
        self.add(group, forKey: "animationGroup")
    }
}

// MARK: - CATransition
public extension CALayer {
    /// 添加过渡动画(常用于视图切换)
    ///
    /// - Parameters:
    ///   - type: 过渡类型(如 `.fade`, `.push` 等)
    ///   - subtype: 方向(如 `.fromLeft`),可选
    ///   - duration: 动画时长(秒),默认为 0.35
    ///   - delay: 延迟时间(秒),默认为 0
    func solo_addTransition(
        type: CATransitionType,
        subtype: CATransitionSubtype? = nil,
        duration: CFTimeInterval = 0.35,
        delay: TimeInterval = 0
    ) {
        let transition = CATransition()
        transition.type = type
        transition.subtype = subtype
        transition.duration = max(0, duration)
        transition.beginTime = CACurrentMediaTime() + max(0, delay)
        self.add(transition, forKey: "transition")
    }
}
