import Foundation

// MARK: - 类型转换
public extension Range where Bound == String.Index {
    /// 将 `Range<String.Index>` 转换为 `NSRange`
    ///
    /// - Parameter string: 所属的原始字符串（必须包含此范围,否则行为未定义）
    /// - Returns: 对应的 `NSRange`;若范围无效或超出字符串边界,可能返回包含 `NSNotFound` 的结果
    /// - Note: 此方法依赖 Foundation 的 `NSRange(_:in:)` 初始化器,仅适用于 UTF-16 兼容字符串
    /// - Example:
    ///   ```swift
    ///   let str = "Hello, world!"
    ///   let range = str.startIndex..<str.index(str.startIndex, offsetBy: 5)
    ///   let nsRange = range.solo_toNSRange(in: str) // {0, 5}
    ///   ```
    func solo_toNSRange(in string: String) -> NSRange {
        return NSRange(self, in: string)
    }
}

// MARK: - 整数半开区间（Range<Int>）操作扩展
public extension Range where Bound == Int {
    /// 返回区间内的一个随机整数
    ///
    /// - Returns: 半开区间 `[lowerBound, upperBound)` 内的随机整数值
    /// - Note: 若区间为空（如 `5..<5`）,调用会触发运行时错误
    /// - Example:
    ///   ```swift
    ///   let range = 1..<10
    ///   let randomValue = range.solo_random() // 如 7
    ///   ```
    func solo_random() -> Int {
        Int.random(in: self)
    }

    /// 根据指定偏移量平移整个区间
    ///
    /// - Parameter offset: 要偏移的整数值（正数向右,负数向左）
    /// - Returns: 新的半开区间 `(lowerBound + offset) ..< (upperBound + offset)`
    /// - Example:
    ///   ```swift
    ///   let range = 1..<5
    ///   print(range.solo_offset(by: 2)) // 3..<7
    ///   ```
    func solo_offset(by offset: Int) -> Range<Int> {
        return (lowerBound + offset) ..< (upperBound + offset)
    }
}

// MARK: - 通用可比较类型半开区间的集合运算扩展
public extension Range where Bound: Comparable {
    /// 计算与另一个半开区间的交集
    ///
    /// - Parameter other: 另一个半开区间
    /// - Returns: 交集区间（若存在重叠）,否则返回 `nil`
    /// - Note: 半开区间 `[a, b)` 与 `[b, c)` 无交集
    /// - Example:
    ///   ```swift
    ///   let r1 = 1..<10
    ///   let r2 = 5..<15
    ///   print(r1.solo_intersection(with: r2)) // Optional(5..<10)
    ///   ```
    func solo_intersection(with other: Range<Bound>) -> Range<Bound>? {
        let lower = Swift.max(lowerBound, other.lowerBound)
        let upper = Swift.min(upperBound, other.upperBound)
        return lower < upper ? lower ..< upper : nil
    }

    /// 计算包含两个区间的最小并集（覆盖两者范围的最小区间）
    ///
    /// - Parameter other: 另一个半开区间
    /// - Returns: 从两区间最小下界到最大上界的半开区间
    /// - Note: 即使两区间不连续（如 `1..<3` 和 `5..<7`）,也会返回 `1..<7`,使用时需注意语义
    /// - Example:
    ///   ```swift
    ///   let r1 = 1..<10
    ///   let r2 = 5..<15
    ///   print(r1.solo_union(with: r2)) // 1..<15
    ///   ```
    func solo_union(with other: Range<Bound>) -> Range<Bound> {
        let lower = Swift.min(lowerBound, other.lowerBound)
        let upper = Swift.max(upperBound, other.upperBound)
        return lower ..< upper
    }

    /// 计算本区间相对于另一个区间的差集（即移除重叠部分后剩余的部分）
    ///
    /// - Parameter other: 要减去的半开区间
    /// - Returns: 差集组成的区间数组（0～2 个半开区间）
    /// - Example:
    ///   ```swift
    ///   let r1 = 1..<10
    ///   let r2 = 4..<6
    ///   print(r1.solo_difference(with: r2)) // [1..<4, 6..<10]
    ///   ```
    func solo_difference(with other: Range<Bound>) -> [Range<Bound>] {
        guard let intersection = solo_intersection(with: other) else {
            return [self] // 无交集,整个区间保留
        }

        var result: [Range<Bound>] = []

        // 左侧剩余部分
        if lowerBound < intersection.lowerBound {
            result.append(lowerBound ..< intersection.lowerBound)
        }

        // 右侧剩余部分
        if upperBound > intersection.upperBound {
            result.append(intersection.upperBound ..< upperBound)
        }

        return result
    }
}
