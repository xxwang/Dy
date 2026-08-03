import Foundation

// MARK: - 条件判断
public extension DyWrapper where Base: Sequence {
    /// 检查序列中没有任何元素满足指定条件
    ///
    /// - Parameter condition: 判断闭包
    /// - Returns: 若无元素满足条件,返回 `true`;否则返回 `false`
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 3, 5].dy.noneSatisfy { $0.isMultiple(of: 2) } // true
    ///     ```
    func noneSatisfy(_ condition: (Base.Element) throws -> Bool) rethrows -> Bool {
        return try !base.contains { try condition($0) }
    }

    /// 返回不满足条件的元素(即“排除”满足条件的元素)
    ///
    /// - Parameter condition: 过滤条件
    /// - Returns: 新数组,包含不满足条件的元素
    /// - Note: 类似 Lodash 的 `reject`
    ///
    /// - Example:
    ///     ```swift
    ///     [2, 4, 7].dy.reject { $0.isMultiple(of: 2) } // [7]
    ///     ```
    func reject(_ condition: (Base.Element) throws -> Bool) rethrows -> [Base.Element] {
        return try base.filter { try !condition($0) }
    }

    /// 统计满足条件的元素个数
    ///
    /// - Parameter condition: 判断闭包
    /// - Returns: 满足条件的元素数量
    ///
    /// - Example:
    ///     ```swift
    ///     [2, 4, 7].dy.count { $0.isMultiple(of: 2) } // 2
    ///     ```
    func count(_ condition: (Base.Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for element in base where try condition(element) {
            count += 1
        }
        return count
    }
}

// MARK: - 遍历
public extension DyWrapper where Base: Sequence {
    /// 反向遍历序列中的每个元素
    ///
    /// - Parameter body: 对每个元素执行的操作
    ///
    /// - Example:
    ///     ```swift
    ///     [0, 2, 4].dy.forEachReversed { print($0) } // 4, 2, 0
    ///     ```
    func forEachReversed(_ body: (Base.Element) throws -> Void) rethrows {
        try base.reversed().forEach(body)
    }

    /// 仅对满足条件的元素执行操作
    ///
    /// - Parameters:
    ///   - condition: 过滤条件
    ///   - body: 对匹配元素执行的操作
    ///
    /// - Example:
    ///     ```swift
    ///     [0, 2, 4, 7].dy.forEachWhere({ $0.isMultiple(of: 2) }) { print($0) }
    ///     // 输出: 0, 2, 4
    ///     ```
    func forEachWhere(
        _ condition: (Base.Element) throws -> Bool,
        _ body: (Base.Element) throws -> Void
    ) rethrows {
        for element in base where try condition(element) {
            try body(element)
        }
    }
}

// MARK: - 转换与聚合
public extension DyWrapper where Base: Sequence {
    /// 对序列进行前缀累积(scan),返回每一步的中间结果
    ///
    /// - Parameters:
    ///   - initial: 初始值
    ///   - next: 累积函数 `(runningValue, currentElement) -> newValue`
    /// - Returns: 包含每一步累积结果的数组
    /// - Note: 类似 RxSwift 的 `scan` 或 Haskell 的 `scanl1`
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3].dy.scan(initial: 0, +) // [1, 3, 6]
    ///     ```
    func scan<U>(initial: U, _ next: (U, Base.Element) throws -> U) rethrows -> [U] {
        var running = initial
        return try base.map { element in
            running = try next(running, element)
            return running
        }
    }

    /// 查找序列中`唯一`满足条件的元素
    ///
    /// - Parameter condition: 查找条件
    /// - Returns: 若恰好有一个元素满足条件,返回该元素;否则返回 `nil`
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 3, 4].dy.single { $0.isMultiple(of: 2) } // Optional(4)
    ///     [2, 4].dy.single { $0.isMultiple(of: 2) }    // nil(多个匹配)
    ///     ```
    func single(_ condition: (Base.Element) throws -> Bool) rethrows -> Base.Element? {
        var found: Base.Element?
        for element in base where try condition(element) {
            guard found == nil else { return nil } // 多于一个
            found = element
        }
        return found
    }

    /// 根据条件将序列分为两部分：匹配与不匹配
    ///
    /// - Parameter condition: 分区条件
    /// - Returns: 元组 `(matching, nonMatching)`
    ///
    /// - Example:
    ///     ```swift
    ///     let (evens, odds) = [0, 1, 2, 3].dy.partition { $0.isMultiple(of: 2) }
    ///     // evens = [0, 2], odds = [1, 3]
    ///     ```
    func partition(_ condition: (Base.Element) throws -> Bool) rethrows -> ([Base.Element], [Base.Element]) {
        var matching = [Base.Element]()
        var nonMatching = [Base.Element]()
        for element in base {
            if try condition(element) {
                matching.append(element)
            } else {
                nonMatching.append(element)
            }
        }
        return (matching, nonMatching)
    }

    /// 计算序列中所有元素在指定属性上的总和
    ///
    /// - Parameter keyPath: 指向 `AdditiveArithmetic` 属性的 `KeyPath`
    /// - Returns: 总和
    ///
    /// - Example:
    ///     ```swift
    ///     struct Item { let price: Double }
    ///     let items = [Item(price: 10), Item(price: 20)]
    ///     items.dy.sum(\.price) // 30.0
    ///     ```
    func sum<T: AdditiveArithmetic>(_ keyPath: KeyPath<Base.Element, T>) -> T {
        return base.reduce(.zero) { $0 + $1[keyPath: keyPath] }
    }
}

// MARK: - Element: Hashable
public extension DyWrapper where Base: Sequence, Base.Element: Hashable {
    /// 检查当前序列是否包含另一个序列中的所有元素
    ///
    /// - Parameter elements: 要检查的元素序列
    /// - Returns: 若全部包含,返回 `true`
    /// - Note: 时间复杂度 O(n + m),使用 `Set` 优化查找
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3].dy.containsAll([1, 3]) // true
    ///     ```
    func containsAll(_ elements: some Sequence<Base.Element>) -> Bool {
        let set = Set(base)
        return elements.allSatisfy(set.contains)
    }

    /// 检查序列中是否存在重复元素
    ///
    /// - Returns: 若存在重复,返回 `true`
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 2, 3].dy.hasDuplicates // true
    ///     ```
    var hasDuplicates: Bool {
        var seen = Set<Base.Element>()
        for element in base {
            if !seen.insert(element).inserted {
                return true
            }
        }
        return false
    }

    /// 获取序列中所有重复出现的元素(去重后)
    ///
    /// - Returns: 重复元素的数组(无序,无重复)
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 1, 2, 3, 3].dy.duplicates // [1, 3](顺序不定)
    ///     ```
    var duplicates: [Base.Element] {
        var seen = Set<Base.Element>()
        var duplicates = Set<Base.Element>()
        for element in base {
            if !seen.insert(element).inserted {
                duplicates.insert(element)
            }
        }
        return Array(duplicates)
    }
}

// MARK: - Element: AdditiveArithmetic
public extension DyWrapper where Base: Sequence, Base.Element: AdditiveArithmetic {
    /// 计算序列中所有元素的总和
    ///
    /// - Returns: 元素总和
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3].dy.sum() // 6
    ///     [1.5, 2.5].dy.sum() // 4.0
    ///     ```
    func sum() -> Base.Element {
        return base.reduce(.zero, +)
    }
}
