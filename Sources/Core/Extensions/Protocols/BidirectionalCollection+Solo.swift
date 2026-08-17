import Foundation

// MARK: - 下标
public extension BidirectionalCollection {
    /// 安全地通过偏移量访问元素
    ///
    /// - Parameter offset:
    ///   - `0` 表示第一个元素
    ///   - `-1` 表示最后一个元素
    ///   - 正数向后偏移,负数向前偏移
    /// - Returns: 对应位置的元素,若越界则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let arr = [10, 20, 30]
    ///   print(arr[safe: 0])   // Optional(10)
    ///   print(arr[safe: -1])  // Optional(30)
    ///   print(arr[safe: 5])   // nil
    ///   ```
    subscript(safe offset: Int) -> Element? {
        let count = self.count
        // 空集合直接返回 nil
        guard count > 0 else { return nil }

        let index: Index
        if offset >= 0 {
            // 正向偏移：0, 1, 2, ...
            guard offset < count else { return nil }
            index = self.index(startIndex, offsetBy: offset)
        } else {
            // 负向偏移：-1 (last), -2, ...
            let positiveIndex = count + offset
            guard positiveIndex >= 0 else { return nil }
            index = self.index(startIndex, offsetBy: positiveIndex)
        }
        return self[index]
    }
}

// MARK: - 获取元素
public extension SoloWrapper where Base: BidirectionalCollection {
    /// 返回集合从头部截取指定数量的元素
    /// - Parameter count: 要截取的元素数量
    /// - Returns: 截取后的集合
    ///
    /// - Example:
    ///
    ///     let array = [1, 2, 3, 4, 5]
    ///     print(array.solo.prefix(count: 3)) // 输出:[1, 2, 3]
    ///
    func prefix(count: Int) -> Base.SubSequence {
        guard count > 0 else { return base[base.startIndex ..< base.startIndex] }
        return base.prefix(count)
    }

    /// 返回集合从尾部截取指定数量的元素
    /// - Parameter count: 要截取的元素数量
    /// - Returns: 截取后的集合
    ///
    /// - Example:
    ///
    ///     let array = [1, 2, 3, 4, 5]
    ///     print(array.solo.suffix(count: 3)) // 输出:[3, 4, 5]
    ///
    func suffix(count: Int) -> Base.SubSequence {
        guard count > 0 else { return base[base.endIndex ..< base.endIndex] }
        return base.suffix(count)
    }
}
