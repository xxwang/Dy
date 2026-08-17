import Foundation

public protocol SoloBoundedClosedRange: RangeExpression where Bound: Comparable {
    var lowerBound: Bound { get }
    var upperBound: Bound { get }
}

extension ClosedRange: SoloBoundedClosedRange {}
extension ClosedRange: SoloExtension {}

// MARK: - 整数闭区间 (Int) 的随机值扩展
public extension SoloWrapper where Base == ClosedRange<Int> {
    /// 返回区间内的一个随机整数
    ///
    /// - Returns: 区间 `[lowerBound, upperBound]` 内的随机值
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...10
    ///   let randomValue = range.solo.randomElement()
    ///   ```
    func randomElement() -> Int {
        return .random(in: base)
    }
}

// MARK: - 整数闭区间的偏移操作扩展
public extension SoloWrapper where Base == ClosedRange<Int> {
    /// 返回偏移后的区间
    ///
    /// - Parameter offset: 要偏移的整数值(正数向右,负数向左)
    /// - Returns: 新的闭区间
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...5
    ///   print(range.solo.offset(by: 2)) // 3...7
    ///   ```
    func offset(by offset: Int) -> Base {
        return (base.lowerBound + offset) ... (base.upperBound + offset)
    }
}

// MARK: - 任意可比较类型闭区间的集合运算扩展（交集与并集）
public extension SoloWrapper where Base: SoloBoundedClosedRange {
    /// 计算与另一个区间的交集
    ///
    /// - Parameter other: 另一个闭区间
    /// - Returns: 交集区间,若无交集则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let r1 = 1...10
    ///   let r2 = 5...15
    ///   print(r1.solo.intersection(with: r2)) // Optional(5...10)
    ///   ```
    func intersection(with other: ClosedRange<Base.Bound>) -> ClosedRange<Base.Bound>? {
        let lower = Swift.max(base.lowerBound, other.lowerBound)
        let upper = Swift.min(base.upperBound, other.upperBound)
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
    ///   print(r1.solo.union(with: r2)) // 1...20
    ///   ```
    func union(with other: ClosedRange<Base.Bound>) -> ClosedRange<Base.Bound> {
        let lower = Swift.min(base.lowerBound, other.lowerBound)
        let upper = Swift.max(base.upperBound, other.upperBound)
        return lower ... upper
    }
}

// MARK: - Base.Bound: Strideable
public extension SoloWrapper where Base: SoloBoundedClosedRange, Base.Bound: Strideable {
    /// 计算本区间相对于另一个区间的差集
    ///
    /// - Parameter other: 要减去的区间
    /// - Returns: 差集组成的闭区间数组(0～2 个区间)
    ///
    /// - Example:
    ///   ```swift
    ///   let r1 = 1...10
    ///   let r2 = 5...15
    ///   print(r1.solo.difference(with: r2)) // [1...4]
    ///   ```
    func difference(with other: ClosedRange<Base.Bound>) -> [ClosedRange<Base.Bound>] {
        guard let intersection = self.intersection(with: other) else {
            return [base.lowerBound ... base.upperBound] // 无交集,整个区间保留
        }

        var result: [ClosedRange<Base.Bound>] = []

        // 左侧剩余部分
        if base.lowerBound < intersection.lowerBound {
            let beforeUpper = intersection.lowerBound.advanced(by: -1)
            result.append(base.lowerBound ... beforeUpper)
        }

        // 右侧剩余部分
        if base.upperBound > intersection.upperBound {
            let afterLower = intersection.upperBound.advanced(by: 1)
            result.append(afterLower ... base.upperBound)
        }

        return result
    }
}
