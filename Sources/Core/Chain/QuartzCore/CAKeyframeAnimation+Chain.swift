import QuartzCore

// MARK: - 属性
public extension DyWrapper where Base: CAKeyframeAnimation {
    /// 设置动画的关键帧值数组
    /// - Parameter values: 动画在各关键帧的值(如 `[0.0, 1.0]`、`[red, green, blue]`、`[point1, point2]`)
    ///   类型需与 `keyPath` 对应(如 `position` 需 `NSValue(cgPoint:)`)
    /// - Note:
    ///   - 若同时设置了 `path`,则 `values` 会被忽略
    ///   - 传 `nil` 可清空值数组
    /// - Returns: `Self`
    @discardableResult
    func values(_ values: [Any]?) -> Self {
        base.values = values
        return self
    }

    /// 设置各关键帧的相对时间点
    /// - Parameter keyTimes: 时间比例数组,范围 `[0.0, 1.0]`,必须单调递增
    ///   长度必须与 `values` 或路径控制点数量一致
    /// - Warning: 长度不匹配会导致动画行为未定义或崩溃
    /// - Returns: `Self`
    @discardableResult
    func keyTimes(_ keyTimes: [Double]) -> Self {
        base.keyTimes = keyTimes.map { $0 as NSNumber }
        return self
    }

    /// 设置关键帧之间的插值计算模式
    /// - Parameter mode: 插值方式(如 `.linear`, `.discrete`, `.paced`, `.cubic`)
    ///   - `.cubic`: 启用三次样条插值,可配合 `tensionValues`/`continuityValues`/`biasValues` 使用
    /// - Returns: `Self`
    @discardableResult
    func calculationMode(_ mode: CAAnimationCalculationMode) -> Self {
        base.calculationMode = mode
        return self
    }

    /// 设置动画沿指定路径运动(常用于 `position` 属性)
    /// - Parameter path: 贝塞尔路径(如 `UIBezierPath` 转 `CGPath`)
    /// - Note:
    ///   - 若设置了 `path`,`values` 将被忽略
    ///   - 需配合 `rotationMode` 实现“沿路径旋转”效果
    /// - Returns: `Self`
    @discardableResult
    func path(_ path: CGPath) -> Self {
        base.path = path
        return self
    }

    /// 为每一段关键帧动画设置独立的时间函数
    /// - Parameter timingFunctions: 时间函数数组,长度应为 `关键帧数 - 1`
    ///   例如：3 个关键帧 → 2 个时间函数
    /// - Returns: `Self`
    @discardableResult
    func timingFunctions(_ timingFunctions: [CAMediaTimingFunction]) -> Self {
        base.timingFunctions = timingFunctions
        return self
    }

    /// 设置三次样条曲线的`紧度`(Tension)
    /// - Parameter tensionValues:
    ///   - 正值 → 曲线更“紧”(接近直线)
    ///   - 负值 → 曲线更“松”(更圆滑)
    ///   - 长度通常与控制点数一致,未指定位置默认为 `0.0`
    /// - Note: 仅在 `calculationMode = .cubic` 时有效
    /// - Returns: `Self`
    @discardableResult
    func tensionValues(_ tensionValues: [Double]) -> Self {
        base.tensionValues = tensionValues.map { $0 as NSNumber }
        return self
    }

    /// 设置三次样条曲线的`连续性`(Continuity)
    /// - Parameter continuityValues:
    ///   - 正值 → 拐角更“锐利”
    ///   - 负值 → 拐角更“平滑”(倒角)
    /// - Note: 仅在 `calculationMode = .cubic` 时有效
    /// - Returns: `Self`
    @discardableResult
    func continuityValues(_ continuityValues: [Double]) -> Self {
        base.continuityValues = continuityValues.map { $0 as NSNumber }
        return self
    }

    /// 设置三次样条曲线的`偏置`(Bias)
    /// - Parameter biasValues:
    ///   - 正值 → 曲线偏向`前一个`控制点
    ///   - 负值 → 曲线偏向`后一个`控制点
    /// - Note: 仅在 `calculationMode = .cubic` 时有效
    /// - Returns: `Self`
    @discardableResult
    func biasValues(_ biasValues: [Double]) -> Self {
        base.biasValues = biasValues.map { $0 as NSNumber }
        return self
    }

    /// 设置图层是否沿路径自动旋转以对齐切线方向
    /// - Parameter rotationMode:
    ///   - `.rotateAuto`: 自动旋转(最常用)
    ///   - `.rotateAutoReverse`: 反向旋转(适用于镜像效果)
    ///   - `nil`(默认): 不旋转
    /// - Warning: 仅在设置了 `path` 时有效
    /// - Returns: `Self`
    @discardableResult
    func rotationMode(_ rotationMode: CAAnimationRotationMode?) -> Self {
        base.rotationMode = rotationMode
        return self
    }
}
