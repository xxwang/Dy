import Foundation

// MARK: - Collection
public extension Collection {
    /// 获取集合的完整索引范围
    ///
    /// - Returns: 从 `startIndex` 到 `endIndex` 的半开区间
    ///
    /// - Example:
    ///     ```swift
    ///     let array = [1, 2, 3]
    ///     print(array.solo_range) // 0..<3
    ///     ```
    var solo_range: Range<Index> {
        startIndex ..< endIndex
    }

    /// 安全地访问集合中指定索引的元素
    ///
    /// - Parameter index: 要访问的索引
    /// - Returns: 若索引有效,返回对应元素;否则返回 `nil`
    ///
    /// - Example:
    ///     ```swift
    ///     let arr = [10, 20, 30]
    ///     print(arr.solo_safe(at: 1))  // Optional(20)
    ///     print(arr.solo_safe(at: 10)) // nil
    ///     ```
    func solo_safe(at index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

    /// 查找满足条件的所有元素索引
    ///
    /// - Parameter condition: 判断元素是否符合条件的闭包
    /// - Returns: 所有匹配元素的索引数组(可能为空)
    ///
    /// - Example:
    ///     ```swift
    ///     let values = [1, 7, 1, 2, 4, 1, 8]
    ///     print(values.solo_indices(where: { $0 == 1 })) // [0, 2, 5]
    ///     ```
    func solo_indices(where condition: (Element) throws -> Bool) rethrows -> [Index] {
        try indices.compactMap { index in
            try condition(self[index]) ? index : nil
        }
    }

    /// 串行遍历集合中的每个元素
    ///
    /// - Parameter operation: 对每个元素执行的操作
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3].solo_forEach { print($0) }
    ///     ```
    func solo_forEach(_ operation: SoloAction1<Element>) {
        for element in self {
            operation(element)
        }
    }

    /// 将集合切片并依次对每个切片执行操作
    ///
    /// - Parameters:
    ///   - size: 每个切片的大小(必须 > 0)
    ///   - operation: 对每个切片执行的操作
    ///
    /// - Example:
    ///     ```swift
    ///     let data = [0, 1, 2, 3, 4]
    ///     data.solo_slice(by: 2) { chunk in
    ///         print(chunk)
    ///     }
    ///     // 输出: [0, 1], [2, 3], [4]
    ///     ```
    func solo_slice(by size: Int, operation: SoloAction1<[Element]>) {
        guard size > 0 else { return }
        var start = startIndex
        while start != endIndex {
            let end = index(start, offsetBy: size, limitedBy: endIndex) ?? endIndex
            operation(Array(self[start ..< end]))
            start = end
        }
    }

    /// 将集合按固定大小分组
    ///
    /// - Parameter size: 每组的元素数量(必须 > 0)
    /// - Returns: 二维数组,每组最多包含 `size` 个元素
    /// - Note: 最后一组可能少于 `size` 个元素
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3, 4, 5].solo_chunked(by: 2) // [[1, 2], [3, 4], [5]]
    ///     "Hello".solo_chunked(by: 3)         // [["H", "e", "l"], ["l", "o"]]
    ///     ```
    func solo_chunked(by size: Int) -> [[Element]] {
        guard size > 0 else { return [] }
        var result: [[Element]] = []
        var startIndex = self.startIndex

        while startIndex < endIndex {
            let nextIndex = index(startIndex, offsetBy: size, limitedBy: endIndex) ?? endIndex
            result.append(Array(self[startIndex ..< nextIndex]))
            startIndex = nextIndex
        }
        return result
    }
}

// MARK: - Element: Equatable
public extension Collection where Element: Equatable {
    /// 查找所有等于指定值的元素索引
    ///
    /// - Parameter item: 要查找的元素
    /// - Returns: 所有匹配元素的索引数组(可能为空)
    ///
    /// - Example:
    ///     ```swift
    ///     let letters = ["a", "b", "a", "c"]
    ///     print(letters.solo_indices(of: "a")) // [0, 2]
    ///     ```
    func solo_indices(of item: Element) -> [Index] {
        solo_indices { $0 == item }
    }
}

// MARK: - Element: BinaryInteger
public extension Collection where Element: BinaryInteger {
    /// 计算整数集合的算术平均值
    ///
    /// - Returns: 平均值(`Double` 类型)若集合为空,返回 `0.0`
    ///
    /// - Example:
    ///     ```swift
    ///     let scores = [80, 90, 100]
    ///     print(scores.solo_average) // 90.0
    ///     ```
    var solo_average: Double {
        guard !isEmpty else { return 0.0 }
        // 使用 reduce(into:) 避免中间溢出(对大整数更安全)
        let sum = reduce(0 as Double) { acc, value in
            acc + Double(value)
        }
        return sum / Double(count)
    }
}

// MARK: - Element: FloatingPoint
public extension Collection where Element: FloatingPoint {
    /// 计算浮点数集合的算术平均值
    ///
    /// - Returns: 平均值(与元素同类型)若集合为空,返回 `.zero`
    ///
    /// - Example:
    ///     ```swift
    ///     let temps = [36.5, 37.0, 36.8]
    ///     print(temps.solo_average) // ≈ 36.766...
    ///     ```
    var solo_average: Element {
        guard !isEmpty else { return .zero }
        return reduce(.zero, +) / Element(count)
    }
}
