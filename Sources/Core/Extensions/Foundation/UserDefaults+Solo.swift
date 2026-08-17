import Foundation

// MARK: - Codable类型支持
public extension SoloWrapper where Base: UserDefaults {
    /// 将符合 `Codable` 协议的对象保存到 `UserDefaults`
    ///
    /// - Parameters:
    ///   - object: 要保存的对象(若为 `nil`,则删除对应键)
    ///   - key: 存储键
    ///   - encoder: 用于序列化的编码器,默认为 `JSONEncoder()`
    func setCodable(_ object: (some Codable)?, forKey key: String, encoder: JSONEncoder = JSONEncoder()) {
        guard let object else {
            base.removeObject(forKey: key)
            return
        }
        if let data = try? encoder.encode(object) {
            base.set(data, forKey: key)
        }
    }

    /// 从 `UserDefaults` 中读取并反序列化指定类型的 `Codable` 对象
    ///
    /// - Parameters:
    ///   - type: 目标类型(通常通过 `MyStruct.self` 传入)
    ///   - key: 存储键
    ///   - decoder: 用于反序列化的解码器,默认为 `JSONDecoder()`
    /// - Returns: 成功解码的对象,或 `nil`(键不存在、数据损坏、类型不匹配等)
    func codable<T: Codable>(_ type: T.Type, forKey key: String, decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = base.data(forKey: key) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
