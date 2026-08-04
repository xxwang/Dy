import QuartzCore

// MARK: - 属性
public extension DyWrapper where Base: CATransition {
    /// 设置转场动画的类型
    /// - Parameter type: 动画类型(如 `.fade`, `.push`, `.moveIn`, `.reveal`)
    ///   - `.fade`: 淡入淡出(最常用,兼容性最好)
    ///   - `.push` / `.moveIn` / `.reveal`: 带方向的滑动效果(需配合 `subtype`)
    /// - Returns: `Self`
    @discardableResult
    func type(_ type: CATransitionType) -> Self {
        base.type = type
        return self
    }

    /// 设置转场动画的方向(仅对部分 `type` 有效)
    /// - Parameter subtype: 方向(如 `.fromRight`, `.fromTop`)
    /// - Note:
    ///   - 仅当 `type` 为 `.push`, `.moveIn`, `.reveal` 时生效
    ///   - 若 `type = .fade`,此设置将被忽略
    /// - Returns: `Self`
    @discardableResult
    func subtype(_ subtype: CATransitionSubtype) -> Self {
        base.subtype = subtype
        return self
    }

    /// 设置转场动画的起始进度
    /// - Parameter startProgress: 起始时间比例,范围 `[0.0, 1.0]`
    ///   - `0.0`：从头开始(默认)
    ///   - `0.5`：从中间开始
    ///   - 常用于反向动画或片段播放
    /// - Warning: 值超出 `[0.0, 1.0]` 可能导致未定义行为
    /// - Returns: `Self`
    @discardableResult
    func startProgress(_ startProgress: Float) -> Self {
        base.startProgress = startProgress
        return self
    }

    /// 设置转场动画的结束进度
    /// - Parameter endProgress: 结束时间比例,范围 `[0.0, 1.0]`
    ///   - `1.0`：播放完整动画(默认)
    ///   - `0.8`：提前结束
    ///   - 与 `startProgress` 配合可实现任意片段播放
    /// - Warning: 值超出 `[0.0, 1.0]` 可能导致未定义行为
    /// - Returns: `Self`
    @discardableResult
    func endProgress(_ endProgress: Float) -> Self {
        base.endProgress = endProgress
        return self
    }
}
