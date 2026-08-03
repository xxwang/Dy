import Foundation

// MARK: - 字典构造器
public extension Dictionary {
    /// 根据 KeyPath 对序列分组构造字典,值为元素数组
    init<S: Sequence>(grouping sequence: S, by keyPath: KeyPath<S.Element, Key>) where Value == [S.Element] {
        self.init(grouping: sequence, by: { $0[keyPath: keyPath] })
    }
}

// MARK: - 嵌套字典路径访问扩展（仅限 [String: Any]）
public extension [String: Any] {
    /// 通过字符串路径安全访问或设置嵌套字典中的值
    subscript(path: [String]) -> Any? {
        get {
            guard !path.isEmpty else { return nil }
            var current: Any? = self
            for key in path {
                guard let nested = current as? [String: Any],
                      let value = nested[key]
                else { return nil }
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
    static func + (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        lhs.merging(rhs, uniquingKeysWith: { _, new in new })
    }

    static func += (lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }

    static func - (lhs: [Key: Value], keys: some Sequence<Key>) -> [Key: Value] {
        var result = lhs
        keys.forEach { result.removeValue(forKey: $0) }
        return result
    }

    static func -= (lhs: inout [Key: Value], keys: some Sequence<Key>) {
        keys.forEach { lhs.removeValue(forKey: $0) }
    }
}

// MARK: - Value: Equatable
public extension Dictionary where Value: Equatable {
    /// 获取所有等于指定值的键
    func dy_keys(forValue value: Value) -> [Key] {
        compactMap { k, v in v == value ? k : nil }
    }
}
