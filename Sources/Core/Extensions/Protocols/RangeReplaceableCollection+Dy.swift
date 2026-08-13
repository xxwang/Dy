import Foundation

// MARK: - 构造方法
public extension RangeReplaceableCollection {
    /// 使用表达式结果创建一个指定大小的集合
    ///
    /// - Parameters:
    ///   - expression: 返回元素的自动闭包(惰性求值)
    ///   - count: 元素数量(必须 ≥ 0)
    /// - Throws: 若 `expression` 抛出错误,则初始化失败
    ///
    /// - Note: 表达式会在每次追加时重新求值(适合生成唯一值,如 UUID)
    ///
    /// - Example:
    ///     ```swift
    ///     let strings = Array(expression: "Hi", count: 3)
    ///     // ["Hi", "Hi", "Hi"]
    ///
    ///     let uuids = Array(expression: UUID(), count: 2)
    ///     // [UUID(), UUID()] — 两个不同 UUID
    ///     ```
    init(expression: @autoclosure () throws -> Element, count: Int) rethrows {
        precondition(count >= 0, "Count must be non-negative")
        self.init()
        guard count > 0 else { return }
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            try self.append(expression())
        }
    }
}

// MARK: - 下标
public extension RangeReplaceableCollection {
    /// 访问集合指定位置的元素
    /// - Parameters:
    ///   - offset: 元素的位置偏移
    /// - Returns: 指定位置的元素
    ///
    /// - Example:
    ///
    ///     var array = [10, 20, 30]
    ///     array[offset: 1] = 25
    ///     print(array) // 输出: [10, 25, 30]
    ///
    subscript(offset: Int) -> Element {
        get {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            return self[index(startIndex, offsetBy: offset)]
        }
        set {
            precondition(offset >= 0 && offset < count, "Index out of bounds")
            let offsetIndex = index(startIndex, offsetBy: offset)
            self.replaceSubrange(offsetIndex ..< index(after: offsetIndex), with: [newValue])
        }
    }

    /// 访问集合指定范围的元素
    /// - Parameter range: 元素的范围
    /// - Returns: 结果序列
    ///
    /// - Example:
    ///
    ///     var array = [1, 2, 3, 4]
    ///     array[1..<3] = [9, 9]
    ///     print(array) // 输出: [1, 9, 9, 4]
    ///
    subscript<R>(range range: R) -> SubSequence where R: RangeExpression, R.Bound == Int {
        get {
            let indexRange = range.relative(to: 0 ..< count)
            return self[index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound)]
        }
        set {
            let indexRange = range.relative(to: 0 ..< count)
            self.replaceSubrange(
                index(startIndex, offsetBy: indexRange.lowerBound) ..< index(startIndex, offsetBy: indexRange.upperBound),
                with: newValue
            )
        }
    }
}

// MARK: - 旋转
public extension DyWrapper where Base: RangeReplaceableCollection {
    /// 返回一个按指定位置旋转后的副本
    ///
    /// - Parameter places: 旋转位数正数向右旋转,负数向左旋转
    /// - Returns: 旋转后的新集合
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3, 4].dy.rotated(by: 1)  // [4, 1, 2, 3]
    ///     [1, 2, 3, 4].dy.rotated(by: -1) // [2, 3, 4, 1]
    ///     ```
    func rotated(by places: Int) -> Base {
        guard !base.isEmpty, places != 0 else { return base }

        let n = base.count
        let k = (places % n + n) % n
        // 向右旋转 k 位:后 k 个元素挪到前面,切分点取 n - k
        let splitIndex = base.index(base.startIndex, offsetBy: n - k)

        var result = Base()
        result.append(contentsOf: base[splitIndex...])
        result.append(contentsOf: base[..<splitIndex])
        return result
    }

    /// 原地旋转集合(通用实现,适用于所有 RangeReplaceableCollection)
    ///
    /// - Parameter places: 旋转位数正数向右旋转,负数向左旋转
    /// - Returns: 修改后的集合
    ///
    /// - Note: 该实现具有 O(n) 时间和空间复杂度
    ///         若需极致性能(如大数组),建议使用针对 `Array` 的特化版本
    @discardableResult
    func rotate(by places: Int) -> Base {
        guard !base.isEmpty, places != 0 else { return base }

        let n = base.count
        let k = (places % n + n) % n
        // 向右旋转 k 位:后 k 个元素挪到前面,切分点取 n - k
        let splitIndex = base.index(base.startIndex, offsetBy: n - k)

        var result = Base()
        result.append(contentsOf: base[splitIndex...])
        result.append(contentsOf: base[..<splitIndex])
        base = result

        return base
    }
}

// MARK: - 删除
public extension DyWrapper where Base: RangeReplaceableCollection {
    /// 删除第一个满足条件的元素
    ///
    /// - Parameter where: 判断条件
    /// - Returns: 被删除的元素,若无匹配则返回 `nil`
    ///
    /// - Example:
    ///     ```swift
    ///     var arr = [1, 2, 3, 2]
    ///     arr.dy.removeFirst(where: { $0 == 2 }) // 删除第一个 2
    ///     // arr == [1, 3, 2]
    ///     ```
    @discardableResult
    func removeFirst(where condition: (Base.Element) throws -> Bool) rethrows -> Base.Element? {
        guard let index = try base.firstIndex(where: condition) else { return nil }
        return base.remove(at: index)
    }

    /// 删除所有重复元素(基于 `Hashable`)
    ///
    /// - Parameter by: 提取用于比较的 `Hashable` 值的函数
    ///
    /// - Example:
    ///     ```swift
    ///     var words = ["a", "b", "a", "c"]
    ///     words.dy.removeDuplicates(by: { $0 })
    ///     // ["a", "b", "c"]
    ///     ```
    func removeDuplicates<T: Hashable>(by transform: (Base.Element) throws -> T) rethrows {
        var seen = Set<T>()
        try base.removeAll { element in
            let key = try transform(element)
            return !seen.insert(key).inserted
        }
    }

    /// 删除所有重复元素(基于 `Hashable`)
    ///
    /// - Note: 保留首次出现的元素
    ///
    /// - Example:
    ///     ```swift
    ///     var nums = [1, 2, 1, 3]
    ///     nums.dy.removeDuplicates()
    ///     // [1, 2, 3]
    ///     ```
    func removeDuplicates() where Base.Element: Hashable {
        var seen = Set<Base.Element>()
        base.removeAll { !seen.insert($0).inserted }
    }

    /// 随机删除一个元素
    ///
    /// - Returns: 被删除的元素,若集合为空则返回 `nil`
    ///
    /// - Example:
    ///     ```swift
    ///     var deck = ["♠️", "♥️", "♦️", "♣️"]
    ///     let card = deck.dy.removeRandomElement()
    ///     ```
    @discardableResult
    func removeRandomElement() -> Base.Element? {
        guard let randomIndex = base.indices.randomElement() else { return nil }
        return base.remove(at: randomIndex)
    }
}

// MARK: - 条件截取
public extension DyWrapper where Base: RangeReplaceableCollection {
    /// 原地保留从头开始满足条件的连续元素
    ///
    /// - Parameter while: 判断条件
    /// - Returns: 修改后的集合
    ///
    /// - Example:
    ///     ```swift
    ///     var nums = [1, 2, 3, 1]
    ///     nums.dy.keep(while: { $0 < 3 })
    ///     // [1, 2]
    ///     ```
    @discardableResult
    func keep(while condition: (Base.Element) throws -> Bool) rethrows -> Self {
        if let firstNonMatching = try base.firstIndex(where: { try !condition($0) }) {
            base.removeSubrange(firstNonMatching...)
        }
        return self
    }

    /// 返回从头开始满足条件的连续元素
    ///
    /// - Parameter while: 判断条件
    /// - Returns: 新集合
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3, 1].dy.take(while: { $0 < 3 }) // [1, 2]
    ///     ```
    func take(while condition: (Base.Element) throws -> Bool) rethrows -> Base {
        return try Base(base.prefix(while: condition))
    }

    /// 返回跳过开头满足条件的连续元素后的剩余部分
    ///
    /// - Parameter while: 判断条件
    /// - Returns: 新集合
    ///
    /// - Example:
    ///     ```swift
    ///     [1, 2, 3, 1].dy.skip(while: { $0 < 3 }) // [3, 1]
    ///     ```
    func skip(while condition: (Base.Element) throws -> Bool) rethrows -> Base {
        guard let firstNonMatching = try base.firstIndex(where: { try !condition($0) }) else {
            return Base()
        }
        return Base(base[firstNonMatching...])
    }
}

// MARK: - 追加
public extension DyWrapper where Base: RangeReplaceableCollection {
    /// 仅当元素非 `nil` 时追加
    ///
    /// - Parameter element: 可选元素
    ///
    /// - Example:
    ///     ```swift
    ///     var arr = [1]
    ///     arr.dy.appendIfNonNil(2)    // [1, 2]
    ///     arr.dy.appendIfNonNil(nil)  // 无变化
    ///     ```
    func appendIfNonNil(_ element: Base.Element?) {
        if let element {
            base.append(element)
        }
    }

    /// 仅当序列非 `nil` 时追加其所有元素
    ///
    /// - Parameter contentsOf: 可选序列
    ///
    /// - Example:
    ///     ```swift
    ///     var arr = [1]
    ///     arr.dy.appendIfNonNil(contentsOf: [2, 3]) // [1, 2, 3]
    ///     arr.dy.appendIfNonNil(contentsOf: nil)    // 无变化
    ///     ```
    func appendIfNonNil(contentsOf newElements: (some Sequence<Base.Element>)?) {
        if let newElements {
            base.append(contentsOf: newElements)
        }
    }
}
