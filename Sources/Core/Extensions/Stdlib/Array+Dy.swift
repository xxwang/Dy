import Foundation

// MARK: - 下标
public extension Array {
    /// 安全下标访问,避免越界崩溃
    /// - Parameter index: 要访问的索引
    /// - Returns: 若索引有效则返回对应元素,否则返回 `nil`
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - 通用数组
public extension Array {
    /// 将数组按指定大小分割为多个子数组
    /// - Parameter chunkSize: 每个子数组的最大元素数量,必须大于 0
    /// - Returns: 分割后的二维数组;若 `chunkSize <= 0` 则返回空数组
    func dy_split(by chunkSize: Int) -> [[Element]] {
        guard chunkSize > 0 else { return [] }
        return stride(from: 0, to: count, by: chunkSize).map {
            Array(self[$0 ..< Swift.min($0 + chunkSize, count)])
        }
    }

    /// 根据转换函数将数组元素分组为字典
    /// - Parameter transform: 将每个元素映射为字典键的闭包,键类型需符合 `Hashable`
    /// - Returns: 以转换结果为键、对应元素列表为值的字典
    /// - Throws: 若 `transform` 抛出错误,则本方法也会抛出相同错误
    func dy_grouped<T: Hashable>(by transform: (Element) throws -> T) rethrows -> [T: [Element]] {
        var groups: [T: [Element]] = [:]
        for element in self {
            let key = try transform(element)
            groups[key, default: []].append(element)
        }
        return groups
    }

    /// 在数组开头插入一个新元素,返回新数组
    /// - Parameter element: 要插入的元素
    /// - Returns: 新生成的数组,原数组不变
    func dy_prepended(_ element: Element) -> [Element] {
        return [element] + self
    }

    /// 安全地交换数组中两个索引位置的元素
    /// - Parameters:
    ///   - index1: 第一个索引
    ///   - index2: 第二个索引
    /// - Note: 若任一索引越界,或两索引相同,则不执行任何操作
    mutating func dy_swap(at index1: Int, with index2: Int) {
        guard
            index1 != index2,
            index1 >= 0, index1 < count,
            index2 >= 0, index2 < count
        else { return }
        let temp = self[index1]
        self[index1] = self[index2]
        self[index2] = temp
    }

    /// 安全获取指定索引的元素,若越界则返回默认值
    /// - Parameters:
    ///   - index: 要访问的索引
    ///   - defaultValue: 索引无效时返回的默认值（使用 `@autoclosure` 延迟求值）
    /// - Returns: 有效索引处的元素,或默认值
    func dy_safeValue(at index: Int, default defaultValue: @autoclosure () -> Element) -> Element {
        return indices.contains(index) ? self[index] : defaultValue()
    }

    /// 使用 `JSONSerialization` 将数组序列化为 `Data`
    /// - Returns: 若数组内容兼容 JSON（仅含 `String`, `Number`, `Bool`, `Array`, `Dictionary`, `NSNull`）,则返回 `Data`;否则返回 `nil`
    /// - Note: 此方法不进行编译期类型检查,运行时可能失败
    func dy_toData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self)
    }
}

// MARK: - Element: Equatable
public extension Array where Element: Equatable {
    /// 查找所有等于指定值的元素的索引
    /// - Parameter element: 要查找的元素
    /// - Returns: 所有匹配元素的索引数组（按顺序）
    func dy_indices(of element: Element) -> [Int] {
        return enumerated().compactMap { $1 == element ? $0 : nil }
    }

    /// 查找第一个满足条件的元素的索引
    /// - Parameter condition: 判断元素是否满足条件的闭包
    /// - Returns: 第一个满足条件的元素索引,若无则返回 `nil`
    /// - Throws: 若 `condition` 抛出错误,则本方法也会抛出相同错误
    func dy_index(where condition: (Element) throws -> Bool) rethrows -> Int? {
        return try firstIndex(where: condition)
    }

    /// 查找等于指定值的第一个元素的索引
    /// - Parameter element: 要查找的元素
    /// - Returns: 第一个匹配元素的索引,若无则返回 `nil`
    func dy_index(of element: Element) -> Int? {
        return firstIndex(of: element)
    }

    /// 从数组中移除指定元素
    /// - Parameters:
    ///   - element: 要移除的元素
    ///   - all: 若为 `true`,移除所有匹配项;若为 `false`（默认）,仅移除第一个匹配项
    /// - Returns: 修改后的数组（用于链式调用）
    @discardableResult
    mutating func dy_remove(_ element: Element, all: Bool = false) -> Self {
        if all {
            self.removeAll { $0 == element }
        } else if let index = firstIndex(of: element) {
            self.remove(at: index)
        }
        return self
    }
}

// MARK: - Element: Hashable
public extension Array where Element: Hashable {
    /// 返回去重后的数组,保留元素首次出现的顺序
    /// - Returns: 去重后的新数组
    func dy_unique() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }

    /// 批量移除多个指定元素
    /// - Parameters:
    ///   - elements: 要移除的元素数组
    ///   - all: 若为 `true`（默认）,移除所有匹配项;若为 `false`,每个元素仅移除第一次出现
    /// - Returns: 修改后的数组（用于链式调用）
    @discardableResult
    mutating func dy_removeItems(_ elements: [Element], all: Bool = true) -> Self {
        let removalSet = Set(elements)
        if all {
            removeAll { removalSet.contains($0) }
        } else {
            for element in removalSet {
                if let index = firstIndex(of: element) {
                    remove(at: index)
                }
            }
        }
        return self
    }
}

// MARK: - Element: NSAttributedString
public extension Array where Element: NSAttributedString {
    /// 将多个 `NSAttributedString` 合并为一个
    /// - Returns: 合并后的 `NSAttributedString`
    func dy_combined() -> NSAttributedString {
        let result = NSMutableAttributedString()
        self.forEach { result.append($0) }
        return result
    }
}



// MARK: - Element: NSObjectProtocol
public extension Array where Element: NSObjectProtocol {
    /// 将数组转换为 `NSArray`,用于需要 Objective-C 兼容的 API
    /// - Returns: 等价的 `NSArray` 实例
    func dy_toNSArray() -> NSArray {
        return self as NSArray
    }
}
