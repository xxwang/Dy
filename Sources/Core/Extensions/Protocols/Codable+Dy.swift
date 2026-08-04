import Foundation

// MARK: - 编码
public extension DyWrapper where Base: Encodable {
    /// 将对象编码为 `Data?`
    /// - Parameter encoder: 编码器,默认为 `JSONEncoder()`
    /// - Returns: 成功: `Data?` 失败: `nil`
    func encode(using encoder: JSONEncoder = .init()) -> Data? {
        try? encoder.encode(base)
    }

    /// 返回 `UTF-8`编码的`JSON`字符串表示
    /// - Parameter isFormat: 是否格式化(缩进+排序)
    /// - Returns: 成功返回`JSON`字符串,失败返回 `nil`
    func toString(format isFormat: Bool = false) -> String? {
        if isFormat {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            guard let data = self.encode(using: encoder) else { return nil }
            return String(data: data, encoding: .utf8)
        } else {
            guard let data = self.encode() else { return nil }
            return String(data: data, encoding: .utf8)
        }
    }
}

// MARK: - 解码
public extension DyWrapper where Base: Decodable {
    /// 从 `Data?` 解码为对象
    /// - Parameters:
    ///   - data: 待解码的 `Data?`
    ///   - decoder: 解码器
    /// - Returns: 解码后的对象
    static func decode(from data: Data?, using decoder: JSONDecoder = .init()) -> Base? {
        guard let data else { return nil }
        return try? decoder.decode(Base.self, from: data)
    }

    /// 从 `String?`(`UTF-8 JSON`)解码为对象
    /// - Parameters:
    ///   - string: `JSON`字符串
    ///   - decoder: 解码器
    /// - Returns: 解码后的对象
    static func decode(from string: String?, using decoder: JSONDecoder = .init()) -> Base? {
        guard let string, let data = string.data(using: .utf8) else { return nil }
        return self.decode(from: data, using: decoder)
    }

    /// 从 `[UInt8]?` 解码为对象
    /// - Parameters:
    ///   - bytes: `UInt8`数组
    ///   - decoder: 解码器
    /// - Returns: 解码后的对象
    static func decode(from bytes: [UInt8]?, using decoder: JSONDecoder = .init()) -> Base? {
        guard let bytes else { return nil }
        return self.decode(from: Data(bytes), using: decoder)
    }
}
