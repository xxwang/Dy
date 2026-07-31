import QuartzCore

// MARK: - 链式设置属性
public extension DyWrapper where Base: CABasicAnimation {
    /// 设置动画的起始值
    /// - Parameter value: 动画开始时的值(如 `CGFloat`, `CGColor`, `CGPoint`, `CGSize` 等)
    ///   若为 `nil`,则使用图层当前值作为起点
    /// - Returns: `Self`
    @discardableResult
    func fromValue(_ value: Any?) -> Self {
        base.fromValue = value
        return self
    }

    /// 设置动画的结束值
    /// - Parameter value: 动画结束时的目标值(类型需与 `fromValue` 兼容)
    ///   若为 `nil` 且未设置 `byValue`,动画可能无效果
    /// - Returns: `Self`
    @discardableResult
    func toValue(_ value: Any?) -> Self {
        base.toValue = value
        return self
    }

    /// 设置动画的`变化增量`(而非绝对目标值)
    /// - Parameter byValue: 相对于当前值的变化量(如位移 `100`、旋转 `.pi/2`)
    /// - Note:
    ///   - `byValue` 与 `fromValue`/`toValue` `互斥`：若同时设置,Core Animation 优先使用 `toValue`
    ///   - 适用于“在当前位置基础上移动/旋转/缩放”的场景
    /// - Returns: `Self`
    @discardableResult
    func byValue(_ byValue: Any?) -> Self {
        base.byValue = byValue
        return self
    }

    /// 通过键值编码(KVC)为动画设置自定义属性
    /// - Parameters:
    ///   - value: 要设置的值(可为任意类型)
    ///   - keyPath: 属性的键路径字符串(如 `"customID"`)
    /// - Warning:
    ///   此方法绕过编译时检查,`拼写错误会导致运行时警告或静默失败`
    ///   仅建议用于存储元数据(如动画标识),`不要用于核心动画参数`
    /// - Returns: `Self`
    @discardableResult
    func setValue(_ value: Any?, forKeyPath keyPath: String) -> Self {
        base.setValue(value, forKeyPath: keyPath)
        return self
    }
}
