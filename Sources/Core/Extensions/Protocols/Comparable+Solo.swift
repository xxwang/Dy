import Foundation

// MARK: - 范围判断
public extension Comparable {
    /// 判断值是否在闭区间 `[lower...upper]` 内
    /// - Parameter range: 闭区间(如 `1...10`)
    /// - Returns: 是否包含
    func solo_isWithin(_ range: ClosedRange<Self>) -> Bool {
        return range.contains(self)
    }

    /// 判断值是否在开区间 `[lower..<upper)` 内
    /// - Parameter range: 开区间(如 `1..<10`)
    /// - Returns: 是否包含
    func solo_isWithin(_ range: Range<Self>) -> Bool {
        return range.contains(self)
    }

    /// 判断值是否在数组的最小值与最大值之间(含端点)
    /// - Parameter array: 用于确定范围的数组
    /// - Returns: 若数组为空返回 `false`;否则返回是否在 `[min, max]` 内
    func solo_isWithin(array: [Self]) -> Bool {
        guard let min = array.min(), let max = array.max() else { return false }
        return self >= min && self <= max
    }
}

// MARK: - 值裁剪
public extension Comparable {
    /// 将值限制在闭区间 `[lower...upper]` 内
    /// - Parameter range: 闭区间
    /// - Returns: 裁剪后的值
    func solo_clamped(to range: ClosedRange<Self>) -> Self {
        return Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
    }

    /// 将值限制不低于指定最小值
    /// - Parameter minimum: 最小允许值
    /// - Returns: 裁剪后的值
    func solo_clamped(minimum: Self) -> Self {
        return Swift.max(self, minimum)
    }

    /// 将值限制不超过指定最大值
    /// - Parameter maximum: 最大允许值
    /// - Returns: 裁剪后的值
    func solo_clamped(maximum: Self) -> Self {
        return Swift.min(self, maximum)
    }
}

// MARK: - Comparable + Strideable + SignedInteger
public extension Comparable where Self: Strideable, Self.Stride: SignedInteger {
    /// 将整数值限制在开区间 `[lower..<upper)` 内(结果仍为有效整数)
    /// - 说明：若值 ≥ upper,则返回 `upper - 1`
    /// - 注意：仅适用于整数类型(如 `Int`, `UInt`)
    func solo_clamped(to range: Range<Self>) -> Self {
        if self < range.lowerBound {
            return range.lowerBound
        } else if self >= range.upperBound {
            return range.upperBound.advanced(by: -1)
        }
        return self
    }
}

// MARK: - Comparable: SignedNumeric
public extension Comparable where Self: SignedNumeric {
    /// 计算与目标值的绝对距离
    /// - Parameter target: 目标值
    /// - Returns: 绝对差值 `|self - target|`
    func solo_distance(to target: Self) -> Self {
        return Swift.abs(self - target)
    }
}
