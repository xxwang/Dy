import Foundation

public extension RangeExpression where Bound == Int {
    /// 将区间转换为包含所有整数的数组
    /// - Note: 仅支持有限区间。开放区间(如 `1...`、`..<Int.max`)元素数量无界,
    ///   超出安全上限(1000 万)时返回空数组,避免一次性分配过量内存导致崩溃。
    /// - Returns: 区间内所有整数构成的数组
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...5
    ///   print(range.dy_collect) // [1, 2, 3, 4, 5]
    ///   ```
    var dy_collect: [Int] {
        let bounds = self.relative(to: Int.min ..< Int.max)
        let count = bounds.upperBound - bounds.lowerBound
        guard count > 0, count <= 10000000 else { return [] }
        return Array(bounds.lowerBound ..< bounds.upperBound)
    }

    /// 检查区间是否包含数组中的所有整数
    /// - Parameter elements: 待检查的整数数组
    /// - Returns: 若所有元素均在区间内,返回 `true`;否则返回 `false`
    ///
    /// - Example:
    ///   ```swift
    ///   let range = 1...5
    ///   print(range.dy_containsAll([2, 3])) // true
    ///   print(range.dy_containsAll([2, 6])) // false
    ///   ```
    func dy_containsAll(_ elements: [Int]) -> Bool {
        let bounds = self.relative(to: Int.min ..< Int.max)
        return elements.allSatisfy(bounds.contains)
    }
}
