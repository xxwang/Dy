import QuartzCore

// MARK: - 属性
public extension DyWrapper where Base: CAAnimation {
    /// 设置动画的代理对象
    /// - Parameter delegate: 遵循 `CAAnimationDelegate` 协议的代理实例
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: CAAnimationDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置动画播放速度默认值为 `1.0`
    /// - Parameter speed: 播放速度倍率(>1 加快,<1 减慢,0 暂停)
    /// - Returns: `Self`
    @discardableResult
    func speed(_ speed: Float) -> Self {
        base.speed = speed
        return self
    }

    /// 设置动画持续时间(秒)
    /// - Parameter duration: 动画从开始到结束所需的时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func duration(_ duration: TimeInterval) -> Self {
        base.duration = duration
        return self
    }

    /// 设置动画重复播放的总时长(秒)
    /// 注意：若同时设置了 `repeatCount`,此属性可能被忽略
    /// - Parameter repeatDuration: 重复播放的总时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func repeatDuration(_ repeatDuration: TimeInterval) -> Self {
        base.repeatDuration = repeatDuration
        return self
    }

    /// 设置动画开始的绝对时间(基于 `CACurrentMediaTime()`)
    /// - Parameter beginTime: 动画开始的媒体时间(通常为 `CACurrentMediaTime() + delay`)
    /// - Returns: `Self`
    @discardableResult
    func beginTime(_ beginTime: TimeInterval) -> Self {
        base.beginTime = beginTime
        return self
    }

    /// 设置动画的时间偏移量(秒),用于跳过动画开头部分
    /// - Parameter timeOffset: 时间偏移量(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func timeOffset(_ timeOffset: CFTimeInterval) -> Self {
        base.timeOffset = timeOffset
        return self
    }

    /// 设置动画延迟开始的时间(相对当前时间)
    /// ⚠️ 注意：此方法会覆盖之前设置的 `beginTime`
    /// - Parameter delay: 延迟时间(单位：秒)
    /// - Returns: `Self`
    @discardableResult
    func delay(_ delay: TimeInterval) -> Self {
        base.beginTime = CACurrentMediaTime() + delay
        return self
    }

    /// 设置动画重复播放的次数
    /// - Parameter repeatCount: 重复次数(`Float.infinity` 表示无限循环)
    /// - Returns: `Self`
    @discardableResult
    func repeatCount(_ repeatCount: Float) -> Self {
        base.repeatCount = repeatCount
        return self
    }

    /// 设置动画是否在完成一次后自动反向播放
    /// - Parameter autoreverses: `true` 表示开启自动反转
    /// - Returns: `Self`
    @discardableResult
    func autoreverses(_ autoreverses: Bool) -> Self {
        base.autoreverses = autoreverses
        return self
    }

    /// 设置动画的时间函数(缓动效果),使用系统预设名称
    /// - Parameter name: 系统预设的缓动类型(如 `.easeIn`, `.linear` 等)
    /// - Returns: `Self`
    @discardableResult
    func timingFunction(_ name: CAMediaTimingFunctionName) -> Self {
        base.timingFunction = CAMediaTimingFunction(name: name)
        return self
    }

    /// 设置动画的时间函数(缓动效果),使用自定义贝塞尔曲线
    /// - Parameter function: 自定义的 `CAMediaTimingFunction` 实例
    /// - Returns: `Self`
    @discardableResult
    func timingFunction(_ function: CAMediaTimingFunction) -> Self {
        base.timingFunction = function
        return self
    }

    /// 设置动画在非活跃时间段的填充行为
    /// 常用于配合 `isRemovedOnCompletion = false` 保持最终状态
    /// - Parameter fillMode: 填充模式(推荐 `.forwards` 或 `.both`)
    /// - Returns: `Self`
    @discardableResult
    func fillMode(_ fillMode: CAMediaTimingFillMode) -> Self {
        base.fillMode = fillMode
        return self
    }

    /// 设置动画完成后是否从图层中自动移除
    /// 若需保持动画结束时的状态,请设为 `false` 并配合 `fillMode = .forwards`
    /// - Parameter isRemovedOnCompletion: `false` 表示保留动画最终状态
    /// - Returns: `Self`
    @discardableResult
    func isRemovedOnCompletion(_ isRemovedOnCompletion: Bool) -> Self {
        base.isRemovedOnCompletion = isRemovedOnCompletion
        return self
    }
}

// MARK: - 属性(自定义)
public extension DyWrapper where Base: CAAnimation {
    /// 使用闭包方式设置动画的开始与结束回调
    /// 推荐的 completion 处理方式,避免 `CATransaction` 的全局副作用
    /// - Parameters:
    ///   - start: 动画开始时调用的闭包(可选)
    ///   - stop: 动画结束时调用的闭包(可选),`finished` 表示是否正常完成
    /// - Returns: `Self`
    @discardableResult
    func on(
        start: ((CAAnimation) -> Void)? = nil,
        stop: ((CAAnimation, Bool) -> Void)? = nil
    ) -> Self {
        let delegate = Base.DyBlockAnimationDelegate()
        delegate.dy_onStart = start
        delegate.dy_onStop = stop
        base.delegate = delegate
        return self
    }
}
