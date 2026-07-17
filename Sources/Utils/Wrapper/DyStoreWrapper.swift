import Foundation

/// 用 `UserDefaults` 存储属性,自动处理默认值、编码和类型兼容
@propertyWrapper
public struct DyStoreWrapper<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    /// 创建一个 `UserDefaults` 绑定属性
    /// - Parameters:
    ///   - key: 存储键名
    ///   - defaultValue: 默认值(读取不到时返回)
    ///   - userDefaults: 存储容器,默认为 .standard
    public init(_ key: String, default defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// 获取或设置存储的值
    public var wrappedValue: T {
        get {
            // 直接读取(适用于 Bool/String/Int 等)
            if let value = userDefaults.object(forKey: key) as? T {
                return value
            }
            // 尝试从 Data 解码(适用于 Codable)
            if let data = userDefaults.data(forKey: key),
               let decoded = decode(from: data)
            {
                return decoded
            }
            // 都失败 → 返回默认值
            return defaultValue
        }
        set {
            // 如果是 nil(仅 Optional 类型),删除键
            if let style = Mirror(reflecting: newValue).displayStyle,
               style == .optional,
               Mirror(reflecting: newValue).children.isEmpty
            {
                userDefaults.removeObject(forKey: key)
                return
            }

            // 原生支持的类型：直接存
            if newValue is DyStorable {
                userDefaults.set(newValue as Any, forKey: key)
                return
            }

            // Codable 类型：转成 Data 存
            if let encodable = newValue as? Encodable {
                do {
                    let data = try JSONEncoder().encode(encodable)
                    userDefaults.set(data, forKey: key)
                } catch {
                    print("⚠️ DyDefault 编码失败 (key: \(key)) - \(error)")
                    userDefaults.removeObject(forKey: key)
                }
                return
            }

            // 不支持的类型：报错并清理
            print("❌ DyDefault 不支持类型 \(T.self) (key: \(key))")
            userDefaults.removeObject(forKey: key)
        }
    }

    /// 投影值,用于调用 `$property.remove()`
    public var projectedValue: DyStoreWrapper<T> {
        self
    }

    /// 从 `UserDefaults` 中删除此键
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
}

// MARK: - 辅助：解码 Data
private extension DyStoreWrapper {
    func decode(from data: Data) -> T? {
        guard let decodableType = T.self as? Decodable.Type else { return nil }
        do {
            let decoded = try JSONDecoder().decode(decodableType, from: data)
            return decoded as? T
        } catch {
            print("⚠️ DyDefault 解码失败 (key: \(key)) - \(error)")
            return nil
        }
    }
}

// MARK: - 支持的类型
private protocol DyStorable {}
extension Bool: DyStorable {}
extension Int: DyStorable {}
extension Int8: DyStorable {}
extension Int16: DyStorable {}
extension Int32: DyStorable {}
extension Int64: DyStorable {}
extension UInt: DyStorable {}
extension UInt8: DyStorable {}
extension UInt16: DyStorable {}
extension UInt32: DyStorable {}
extension UInt64: DyStorable {}
extension Float: DyStorable {}
extension Double: DyStorable {}
extension String: DyStorable {}
extension Date: DyStorable {}
extension Data: DyStorable {}
extension Array: DyStorable where Element: DyStorable {}
extension Dictionary: DyStorable where Key == String, Value: DyStorable {}
