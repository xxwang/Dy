import Foundation

// MARK: - 字典构造器
public extension Dictionary {
    /// 根据 KeyPath 对序列分组构造字典,值为元素数组
    ///
    /// - Parameters:
    ///   - sequence: 要分组的元素序列
    ///   - keyPath: 用于提取分组键的 `KeyPath`
    /// - Returns: 分组后的字典,类型为 `[Key: [S.Element]]`
    /// - Example:
    ///   ```swift
    ///   struct Item { let category: String; let value: Int }
    ///   let items = [Item(category: "A", value: 1), Item(category: "B", value: 2)]
    ///   let dict = Dictionary(grouping: items, by: \.category)
    ///   // ["A": [Item(...)], "B": [Item(...)]]
    ///   ```
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

// MARK: - 通用字典操作
public extension Dictionary {
    /// 判断字典是否包含指定键
    ///
    /// - Parameter key: 要检查的键
    /// - Returns: 若存在该键则返回 `true`,否则 `false`
    func dy_contains(key: Key) -> Bool {
        self[key] != nil
    }

    /// 从字典中移除多个指定的键
    ///
    /// - Parameter keys: 要移除的键序列（如数组、Set 等）
    mutating func dy_remove(keys: some Sequence<Key>) {
        for key in keys {
            self.removeValue(forKey: key)
        }
    }

    /// 随机移除一个键值对,并返回被移除的值
    ///
    /// - Returns: 被移除的值;若字典为空则返回 `nil`
    @discardableResult
    mutating func dy_removeRandomValue() -> Value? {
        guard let key = keys.randomElement() else { return nil }
        return self.removeValue(forKey: key)
    }

    /// 将字典的每个键值对映射为新类型的元素,并返回数组
    ///
    /// - Parameter transform: 接收 `(Key, Value)` 并返回新元素的转换闭包
    /// - Returns: 转换后的新数组
    /// - Throws: 若 `transform` 抛出错误,则本方法也会抛出相同错误
    func dy_mapToArray<T>(_ transform: (Key, Value) throws -> T) rethrows -> [T] {
        try map(transform)
    }

    /// 将字典映射为新类型的字典（键和值均可变）
    ///
    /// - Parameter transform: 接收 `(Key, Value)` 并返回 `(K, V)` 元组的闭包
    /// - Returns: 转换后的新字典
    /// - Throws: 若 `transform` 抛出错误,则本方法也会抛出相同错误
    /// - Note: 若转换后存在重复键，后者覆盖前者（类似 `uniquingKeysWith`）
    func dy_mapToDictionary<K: Hashable, V>(
        _ transform: (_ key: Key, _ value: Value) throws -> (K, V)
    ) rethrows -> [K: V] {
        let pairs: [(K, V)] = try self.map(transform)
        return Swift.Dictionary(pairs, uniquingKeysWith: { _, latest in latest })
    }

    /// 过滤并映射字典为新字典,支持跳过某些元素（返回 `nil`）
    ///
    /// - Parameter transform: 接收 `(Key, Value)` 并返回可选 `(K, V)?` 的闭包
    /// - Returns: 转换后的新字典（跳过返回 `nil` 的项）
    /// - Throws: 若 `transform` 抛出错误,则本方法也会抛出相同错误
    /// - Note: 结果中不会包含 `nil` 映射项,且要求键唯一
    func dy_compactMapToDictionary<K: Hashable, V>(
        _ transform: (_ key: Key, _ value: Value) throws -> (K, V)?
    ) rethrows -> [K: V] {
        let pairs: [(K, V)] = try self.compactMap(transform)
        return Swift.Dictionary(pairs, uniquingKeysWith: { _, new in new })
    }

    /// 仅保留指定键构成的新字典
    ///
    /// - Parameter keys: 要保留的键数组
    /// - Returns: 仅包含这些键（若存在）的新字典
    func dy_filter(keys: [Key]) -> [Key: Value] {
        var result: [Key: Value] = [:]
        for key in keys {
            if let value = self[key] {
                result[key] = value
            }
        }
        return result
    }

    /// 尝试将字典转为 `JSON Data`（要求 `Key == String`）
    ///
    /// - Note: 仅当 `Key` 为 `String` 且所有值均为 JSON 兼容类型（如 `String`, `Number`, `Bool`, `Array`, `Dictionary`, `NSNull`）时有效
    /// - Returns: 成功则返回 `Data`,否则返回 `nil`
    /// - Warning: 若 `Key` 不是 `String`,会触发 `assertionFailure` 并返回 `nil`
    func dy_toData() -> Data? {
        guard Key.self == String.self else {
            assertionFailure("data requires Key == String")
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: self)
    }
}

// MARK: - 嵌套字典路径访问扩展（仅限 [String: Any]）
public extension [String: Any] {
    /// 通过字符串路径安全访问或设置嵌套字典中的值
    ///
    /// - Note: 仅适用于 `[[String: Any]]` 嵌套结构
    ///         设置时会自动创建中间层级;传入 `nil` 可删除路径末尾的键
    /// - Parameter path: 键路径数组,如 `["user", "profile", "name"]`
    /// - Returns: 路径对应的值（若路径无效则返回 `nil`）
    /// - Example:
    ///   ```swift
    ///   var dict: [String: Any] = [:]
    ///   dict[path: ["a", "b"]] = "hello"
    ///   print(dict[path: ["a", "b"]]) // Optional("hello")
    ///   dict[path: ["a", "b"]] = nil  // 删除该键
    ///   ```
    subscript(path: [String]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var current: Any? = self
            for key in path {
                guard let nested = current as? [String: Any],
                      let value = nested[key]
                else {
                    return nil
                }
                current = value
            }
            return current
        }
        set {
            guard !path.isEmpty else { return }

            func setInNested(_ dict: inout [String: Any], at path: ArraySlice<String>, to value: Any?) {
                guard let first = path.first else { return }
                if path.count == 1 {
                    if let val = value {
                        dict[first] = val
                    } else {
                        dict.removeValue(forKey: first)
                    }
                } else {
                    var subDict = dict[first] as? [String: Any] ?? [:]
                    setInNested(&subDict, at: path.dropFirst(), to: value)
                    dict[first] = subDict
                }
            }

            var mutableSelf = self
            setInNested(&mutableSelf, at: path[...], to: newValue)
            self = mutableSelf
        }
    }
}

// MARK: - Value: Equatable
public extension Dictionary where Value: Equatable {
    /// 获取所有等于指定值的键
    ///
    /// - Parameter value: 要匹配的值
    /// - Returns: 所有对应键的数组
    func dy_keys(forValue value: Value) -> [Key] {
        compactMap { k, v in v == value ? k : nil }
    }
}

// MARK: - 运算符重载
public extension Dictionary {
    /// 合并两个字典（右侧值优先）
    ///
    /// - Parameters:
    ///   - lhs: 左侧字典
    ///   - rhs: 右侧字典
    /// - Returns: 合并后的新字典（`rhs` 中的值会覆盖 `lhs` 中的同名键）
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        lhs.merging(rhs, uniquingKeysWith: { _, new in new })
    }

    /// 就地合并右侧字典到左侧（右侧值优先）
    ///
    /// - Parameters:
    ///   - lhs: 左侧字典（将被修改）
    ///   - rhs: 右侧字典
    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    /// 从字典中移除指定键集合,返回新字典
    ///
    /// - Parameters:
    ///   - lhs: 原始字典
    ///   - keys: 要移除的键序列
    /// - Returns: 移除指定键后的新字典
    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        keys.forEach { result.removeValue(forKey: $0) }
        return result
    }

    /// 就地从字典中移除指定键集合
    ///
    /// - Parameters:
    ///   - lhs: 字典（将被修改）
    ///   - keys: 要移除的键序列
    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        keys.forEach { lhs.removeValue(forKey: $0) }
    }
}
