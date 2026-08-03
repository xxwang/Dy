import Foundation

// MARK: - 通用字典操作
extension DyWrapper where Base: DyDictionaryProtocol {
    /// 判断字典是否包含指定键
    func contains(key: Base.Key) -> Bool {
        base[key] != nil
    }

    /// 移除多个指定键
    @discardableResult
    func remove(keys: some Sequence<Base.Key>) -> Base {
        for key in keys {
            base.removeValue(forKey: key)
        }
        return base
    }

    /// 随机移除一个键值对
    @discardableResult
    func removeRandomValue() -> Base {
        for (k, _) in base {
            base.removeValue(forKey: k)
            break
        }
        return base
    }

    /// 将键值对映射为数组
    func mapToArray<T>(_ transform: (Base.Key, Base.Value) throws -> T) rethrows -> [T] {
        var result: [T] = []
        for (k, v) in base {
            result.append(try transform(k, v))
        }
        return result
    }

    /// 映射到新字典
    func mapToDictionary<K: Hashable, V>(_ transform: (Base.Key, Base.Value) throws -> (K, V)) rethrows -> [K: V] {
        var result: [K: V] = [:]
        for (k, v) in base {
            let (nk, nv) = try transform(k, v)
            result[nk] = nv
        }
        return result
    }

    /// compactMap 到新字典
    func compactMapToDictionary<K: Hashable, V>(_ transform: (Base.Key, Base.Value) throws -> (K, V)?) rethrows -> [K: V] {
        var result: [K: V] = [:]
        for (k, v) in base {
            if let (nk, nv) = try transform(k, v) {
                result[nk] = nv
            }
        }
        return result
    }

    /// 仅保留指定键
    func filter(keys: [Base.Key]) -> [Base.Key: Base.Value] {
        var result: [Base.Key: Base.Value] = [:]
        for key in keys {
            if let value = base[key] {
                result[key] = value
            }
        }
        return result
    }

    /// 转为 JSON Data (仅 String Key)
    func toData() -> Data? where Base.Key == String {
        try? JSONSerialization.data(withJSONObject: base)
    }
}

// MARK: - Value: Equatable
extension DyWrapper where Base: DyDictionaryProtocol, Base.Value: Equatable {
    /// 获取所有等于指定值的键
    func keys(forValue value: Base.Value) -> [Base.Key] {
        var result: [Base.Key] = []
        for (k, v) in base {
            if v == value {
                result.append(k)
            }
        }
        return result
    }
}
