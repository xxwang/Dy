import QuartzCore

// MARK: - 属性
public extension DyWrapper where Base: CASpringAnimation {
    /// 设置弹簧系统的质量(Mass)
    /// - Parameter mass: 质量(单位：任意)值越大,惯性越大,动画越“迟钝”
    ///   默认值：`1.0`典型范围：`0.1 ～ 10.0`
    /// - Returns: `Self`
    @discardableResult
    func mass(_ mass: CGFloat) -> Self {
        base.mass = mass
        return self
    }

    /// 设置弹簧的刚度(Stiffness)
    /// - Parameter stiffness: 刚度(单位：N/m)值越大,弹簧越“硬”,回弹越快
    ///   默认值：`100.0`典型范围：`10.0 ～ 1000.0`
    /// - Returns: `Self`
    @discardableResult
    func stiffness(_ stiffness: CGFloat) -> Self {
        base.stiffness = stiffness
        return self
    }

    /// 设置弹簧的阻尼(Damping)
    /// - Parameter damping: 阻尼(单位：Ns/m)值越大,能量衰减越快,振荡越少
    ///   默认值：`10.0`典型范围：`1.0 ～ 50.0`
    ///   - `damping < 2√(mass × stiffness)`：欠阻尼(有振荡)
    ///   - `damping = 2√(mass × stiffness)`：临界阻尼(最快无振荡)
    ///   - `damping > 2√(mass × stiffness)`：过阻尼(缓慢无振荡)
    /// - Returns: `Self`
    @discardableResult
    func damping(_ damping: CGFloat) -> Self {
        base.damping = damping
        return self
    }

    /// 设置动画开始时的初始速度(Initial Velocity)
    /// - Parameter velocity: 初始速度(单位：与 `toValue` 类型一致 / 秒)
    ///   默认值：`0.0`正值表示朝目标方向运动,负值表示反向
    /// - Returns: `Self`
    @discardableResult
    func initialVelocity(_ velocity: CGFloat) -> Self {
        base.initialVelocity = velocity
        return self
    }
}
