import QuartzCore

public extension CAAnimation {
    // MARK: - DyBlockAnimationDelegate
    class DyBlockAnimationDelegate: NSObject {
        /// 动画开始时触发的闭包
        var dy_onStart: DyAction1<CAAnimation>?

        /// 动画结束时触发的闭包,`finished` 表示是否完整播放完毕
        var dy_onStop: DyAction2<CAAnimation, Bool>?

        override init() {
            super.init()
        }
    }
}

// MARK: - CAAnimationDelegate实现
extension CAAnimation.DyBlockAnimationDelegate: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        self.dy_onStart?(anim)
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.dy_onStop?(anim, flag)
        anim.delegate = nil
    }
}

// MARK: - 链式设置属性
public extension CAAnimation {
    /// 设置动画的代理对象
    /// - Parameter delegate: 遵循 `CAAnimationDelegate` 协议的代理实例
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: CAAnimationDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置动画播放速度默认值为 `1.0`
    /// - Parameter speed: 播放速度倍率(>1 加快,<1 减慢,0 暂停)
    /// - Returns: `Self`
    @discardableResult
    func dy_speed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }

    /// 设置动画持续时间(秒)
    /// - Parameter duration: 动画从开始到结束所需的时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func dy_duration(_ duration: TimeInterval) -> Self {
        self.duration = duration
        return self
    }

    /// 设置动画重复播放的总时长(秒)
    /// 注意：若同时设置了 `repeatCount`,此属性可能被忽略
    /// - Parameter repeatDuration: 重复播放的总时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func dy_repeatDuration(_ repeatDuration: TimeInterval) -> Self {
        self.repeatDuration = repeatDuration
        return self
    }

    /// 设置动画开始的绝对时间(基于 `CACurrentMediaTime()`)
    /// - Parameter beginTime: 动画开始的媒体时间(通常为 `CACurrentMediaTime() + delay`)
    /// - Returns: `Self`
    @discardableResult
    func dy_beginTime(_ beginTime: TimeInterval) -> Self {
        self.beginTime = beginTime
        return self
    }

    /// 设置动画的时间偏移量(秒),用于跳过动画开头部分
    /// - Parameter timeOffset: 时间偏移量(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func dy_timeOffset(_ timeOffset: CFTimeInterval) -> Self {
        self.timeOffset = timeOffset
        return self
    }

    /// 设置动画延迟开始的时间(相对当前时间)
    /// ⚠️ 注意：此方法会覆盖之前设置的 `beginTime`
    /// - Parameter delay: 延迟时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func dy_delay(_ delay: TimeInterval) -> Self {
        self.beginTime = CACurrentMediaTime() + delay
        return self
    }

    /// 设置动画重复播放的次数
    /// - Parameter repeatCount: 重复次数(`Float.infinity` 表示无限循环)
    /// - Returns: `Self`
    @discardableResult
    func dy_repeatCount(_ repeatCount: Float) -> Self {
        self.repeatCount = repeatCount
        return self
    }

    /// 设置动画是否在完成一次后自动反向播放
    /// - Parameter autoreverses: `true` 表示开启自动反转
    /// - Returns: `Self`
    @discardableResult
    func dy_autoreverses(_ autoreverses: Bool) -> Self {
        self.autoreverses = autoreverses
        return self
    }

    /// 设置动画的时间函数(缓动效果),使用系统预设名称
    /// - Parameter name: 系统预设的缓动类型(如 `.easeIn`, `.linear` 等)
    /// - Returns: `Self`
    @discardableResult
    func dy_timingFunction(_ name: CAMediaTimingFunctionName) -> Self {
        self.timingFunction = CAMediaTimingFunction(name: name)
        return self
    }

    /// 设置动画的时间函数(缓动效果),使用自定义贝塞尔曲线
    /// - Parameter function: 自定义的 `CAMediaTimingFunction` 实例
    /// - Returns: `Self`
    @discardableResult
    func dy_timingFunction(_ function: CAMediaTimingFunction) -> Self {
        self.timingFunction = function
        return self
    }

    /// 设置动画在非活跃时间段的填充行为
    /// 常用于配合 `isRemovedOnCompletion = false` 保持最终状态
    /// - Parameter fillMode: 填充模式(推荐 `.forwards` 或 `.both`)
    /// - Returns: `Self`
    @discardableResult
    func dy_fillMode(_ fillMode: CAMediaTimingFillMode) -> Self {
        self.fillMode = fillMode
        return self
    }

    /// 设置动画完成后是否从图层中自动移除
    /// 若需保持动画结束时的状态,请设为 `false` 并配合 `fillMode = .forwards`
    /// - Parameter isRemovedOnCompletion: `false` 表示保留动画最终状态
    /// - Returns: `Self`
    @discardableResult
    func dy_isRemovedOnCompletion(_ isRemovedOnCompletion: Bool) -> Self {
        self.isRemovedOnCompletion = isRemovedOnCompletion
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension CAAnimation {
    /// 使用闭包方式设置动画的开始与结束回调
    /// 推荐的 completion 处理方式,避免 `CATransaction` 的全局副作用
    /// - Warning: 闭包被 `CAAnimation.delegate` **强引用**。若闭包内使用 `self`，
    ///   请务必使用 `[weak self]`（如 `stop: { [weak self] _, _ in ... }`），
    ///   否则配合 `dy_isRemovedOnCompletion(false)` 使用时会造成 `self → animation → delegate → 闭包 → self` 的循环引用泄漏。
    /// - Parameters:
    ///   - start: 动画开始时调用的闭包(可选)
    ///   - stop: 动画结束时调用的闭包(可选),`finished` 表示是否正常完成
    /// - Returns: `Self`
    @discardableResult
    func dy_on(
        start: DyAction1<CAAnimation>? = nil,
        stop: DyAction2<CAAnimation, Bool>? = nil
    ) -> Self {
        let delegate = Self.DyBlockAnimationDelegate()
        delegate.dy_onStart = start
        delegate.dy_onStop = stop
        self.delegate = delegate
        return self
    }
}
