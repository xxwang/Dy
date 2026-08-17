import Foundation

extension Dictionary: SoloExtension {}

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

// MARK: - 通用字典操作
public extension SoloWrapper where Base == [String: Any] {
    /// 尝试将字典转为 `JSON Data`（要求 `Key == String`）
    ///
    /// - Note: 仅当 `Key` 为 `String` 且所有值均为 JSON 兼容类型（如 `String`, `Number`, `Bool`, `Array`, `Dictionary`, `NSNull`）时有效
    /// - Returns: 成功则返回 `Data`,否则返回 `nil`
    /// - Warning: 若 `Key` 不是 `String`,会触发 `assertionFailure` 并返回 `nil`
    func toData() -> Data? {
        guard Base.Key.self == String.self else {
            assertionFailure("data requires Key == String")
            return nil
        }
        return try? JSONSerialization.data(withJSONObject: self)
    }
}
