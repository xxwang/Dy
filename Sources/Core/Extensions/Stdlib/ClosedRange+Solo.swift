import Foundation

// MARK: - 整数闭区间 (Int) 的随机值扩展
public extension ClosedRange where Bound == Int {
    /// 返回区间内的一个随机整数
    ///
    /// - Returns: 区间 `[lowerBound, upperBound]` 内的随机值
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...10
    ///   let randomValue = range.solo_random()
    ///   ```
    func solo_random() -> Int {
        .random(in: self)
    }
}

// MARK: - 整数闭区间的偏移操作扩展
public extension ClosedRange where Bound == Int {
    /// 返回偏移后的区间
    ///
    /// - Parameter offset: 要偏移的整数值(正数向右,负数向左)
    /// - Returns: 新的闭区间
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...5
    ///   print(range.solo_offset(by: 2)) // 3...7
    ///   ```
    func solo_offset(by offset: Int) -> ClosedRange<Int> {
        return (lowerBound + offset) ... (upperBound + offset)
    }
}

// MARK: - 任意可比较类型闭区间的集合运算扩展（交集与并集）
public extension ClosedRange where Bound: Comparable {
    /// 计算与另一个区间的交集
    ///
    /// - Parameter other: 另一个闭区间
    /// - Returns: 交集区间,若无交集则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let r1 = 1...10
    ///   let r2 = 5...15
    ///   print(r1.solo_intersection(with: r2)) // Optional(5...10)
    ///   ```
    func solo_intersection(with other: ClosedRange<Bound>) -> ClosedRange<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)
        return lower <= upper ? lower ... upper : nil
    }

    /// 计算包含两个区间的最小并集
    ///
    /// - Parameter other: 另一个闭区间
    /// - Returns: 并集闭区间
    ///
    /// - Example:
    ///   ```swift
    ///   let r1 = 1...10
    ///   let r2 = 15...20
    ///   print(r1.solo_union(with: r2)) // 1...20
    ///   ```
    func solo_union(with other: ClosedRange<Bound>) -> ClosedRange<Bound> {
        let lower = Swift.min(lowerBound, other.lowerBound)
        let upper = Swift.max(upperBound, other.upperBound)
        return lower ... upper
    }
}

// MARK: - 支持步进的闭区间差集运算扩展（适用于 Int、Double 等）
public extension ClosedRange where Bound: Strideable, Bound.Stride: SignedInteger {
    /// 计算本区间相对于另一个区间的差集
    ///
    /// - Parameter other: 要减去的区间
    /// - Returns: 差集组成的闭区间数组(0～2 个区间)
    ///
    /// - Example:
    ///   ```swift
    ///   let r1 = 1...10
    ///   let r2 = 5...15
    ///   print(r1.solo_difference(with: r2)) // [1...4]
    ///   ```
    func solo_difference(with other: ClosedRange<Bound>) -> [ClosedRange<Bound>] {
        guard let intersection = solo_intersection(with: other) else {
            return [self] // 无交集,整个区间保留
        }

        var result: [ClosedRange<Bound>] = []

        // 左侧剩余部分
        if lowerBound < intersection.lowerBound {
            let beforeUpper = intersection.lowerBound.advanced(by: -1)
            result.append(lowerBound ... beforeUpper)
        }

        // 右侧剩余部分
        if upperBound > intersection.upperBound {
            let afterLower = intersection.upperBound.advanced(by: 1)
            result.append(afterLower ... upperBound)
        }

        return result
    }
}
