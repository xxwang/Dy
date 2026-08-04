import QuartzCore

// MARK: - 链式设置属性
public extension DyWrapper where Base: CAAnimationGroup {
    /// 设置动画组中包含的动画数组
    /// - Note: 若传入空数组 `[]`,动画组将执行但不包含任何子动画;
    ///         若需清空动画,可传 `nil`(等价于 `self.animations = nil`)
    /// - Parameter animations: 要加入动画组的 `CAAnimation` 子动画数组(可为 `nil`)
    /// - Returns: `Self`
    @discardableResult
    func animations(_ animations: [CAAnimation]?) -> Self {
        base.animations = animations
        return self
    }
}
