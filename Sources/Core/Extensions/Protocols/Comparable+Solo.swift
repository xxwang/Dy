import Foundation

// MARK: - 范围判断
public extension SoloWrapper where Base: Comparable {
    /// 判断值是否在闭区间 `[lower...upper]` 内
    /// - Parameter range: 闭区间(如 `1...10`)
    /// - Returns: 是否包含
    func isWithin(_ range: ClosedRange<Base>) -> Bool {
        return range.contains(base)
    }

    /// 判断值是否在开区间 `[lower..<upper)` 内
    /// - Parameter range: 开区间(如 `1..<10`)
    /// - Returns: 是否包含
    func isWithin(_ range: Range<Base>) -> Bool {
        return range.contains(base)
    }

    /// 判断值是否在数组的最小值与最大值之间(含端点)
    /// - Parameter array: 用于确定范围的数组
    /// - Returns: 若数组为空返回 `false`;否则返回是否在 `[min, max]` 内
    func isWithin(array: [Base]) -> Bool {
        guard let min = array.min(), let max = array.max() else { return false }
        return base >= min && base <= max
    }
}

// MARK: - 值裁剪
public extension SoloWrapper where Base: Comparable {
    /// 将值限制在闭区间 `[lower...upper]` 内
    /// - Parameter range: 闭区间
    /// - Returns: 裁剪后的值
    func clamped(to range: ClosedRange<Base>) -> Base {
        return Swift.max(range.lowerBound, Swift.min(base, range.upperBound))
    }

    /// 将值限制不低于指定最小值
    /// - Parameter minimum: 最小允许值
    /// - Returns: 裁剪后的值
    func clamped(minimum: Base) -> Base {
        return Swift.max(base, minimum)
    }

    /// 将值限制不超过指定最大值
    /// - Parameter maximum: 最大允许值
    /// - Returns: 裁剪后的值
    func clamped(maximum: Base) -> Base {
        return Swift.min(base, maximum)
    }
}

// MARK: - Comparable & Strideable & SignedInteger
public extension SoloWrapper where Base: Comparable, Base: Strideable, Base.Stride: SignedInteger {
    /// 将整数值限制在开区间 `[lower..<upper)` 内(结果仍为有效整数)
    /// - 说明：若值 ≥ upper,则返回 `upper - 1`
    /// - 注意：仅适用于整数类型(如 `Int`, `UInt`)
    func clamped(to range: Range<Base>) -> Base {
        if base < range.lowerBound {
            return range.lowerBound
        } else if base >= range.upperBound {
            return range.upperBound.advanced(by: -1)
        }
        return base
    }
}

// MARK: - Comparable & SignedNumeric
public extension SoloWrapper where Base: Comparable, Base: SignedNumeric {
    /// 计算与目标值的绝对距离
    /// - Parameter target: 目标值
    /// - Returns: 绝对差值 `|self - target|`
    func distance(to target: Base) -> Base {
        return Swift.abs(base - target)
    }
}
