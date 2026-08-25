import Foundation
import os.log

/// `JSONEncoder` / `JSONDecoder` 是线程安全的，可全局复用，避免每次读写都新建
private let soloSharedEncoder = JSONEncoder()
private let soloSharedDecoder = JSONDecoder()

/// 用 `UserDefaults` 存储属性,自动处理默认值、编码和类型兼容
@propertyWrapper
public struct SoloDataStore<T> {
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
            if let optional = newValue as? AnyOptionalProtocol, optional.isNil {
                userDefaults.removeObject(forKey: key)
                return
            }

            // 原生支持的类型：直接存
            if newValue is SoloStorable {
                userDefaults.set(newValue as Any, forKey: key)
                return
            }

            // Codable 类型：转成 Data 存
            if let encodable = newValue as? Encodable {
                do {
                    let data = try soloSharedEncoder.encode(encodable)
                    userDefaults.set(data, forKey: key)
                } catch {
                    os_log(.error, "SoloDataStore 编码失败 key=%{public}@ error=%{public}@", key, String(describing: error))
                    userDefaults.removeObject(forKey: key)
                }
                return
            }

            // 不支持的类型：报错并清理
            os_log(.error, "SoloDataStore 不支持类型 %{public}@ key=%{public}@", String(describing: T.self), key)
            userDefaults.removeObject(forKey: key)
        }
    }

    /// 投影值,用于调用 `$property.remove()`
    public var projectedValue: SoloDataStore<T> {
        self
    }

    /// 从 `UserDefaults` 中删除此键
    public func remove() {
        userDefaults.removeObject(forKey: key)
    }
}

// MARK: - 辅助：解码 Data
private extension SoloDataStore {
    func decode(from data: Data) -> T? {
        guard let decodableType = T.self as? Decodable.Type else { return nil }
        do {
            let decoded = try soloSharedDecoder.decode(decodableType, from: data)
            return decoded as? T
        } catch {
            os_log(.error, "SoloDataStore 解码失败 key=%{public}@ error=%{public}@", key, String(describing: error))
            return nil
        }
    }
}

/// Optional 判断协议，替代 Mirror 反射检测 nil
private protocol AnyOptionalProtocol {
    var isNil: Bool { get }
}

extension Optional: AnyOptionalProtocol {
    var isNil: Bool {
        switch self {
        case .none: return true
        case .some: return false
        }
    }
}

// MARK: - 支持的类型
private protocol SoloStorable {}
extension Bool: SoloStorable {}
extension Int: SoloStorable {}
extension Int8: SoloStorable {}
extension Int16: SoloStorable {}
extension Int32: SoloStorable {}
extension Int64: SoloStorable {}
extension UInt: SoloStorable {}
extension UInt8: SoloStorable {}
extension UInt16: SoloStorable {}
extension UInt32: SoloStorable {}
extension UInt64: SoloStorable {}
extension Float: SoloStorable {}
extension Double: SoloStorable {}
extension String: SoloStorable {}
extension Date: SoloStorable {}
extension Data: SoloStorable {}
extension Array: SoloStorable where Element: SoloStorable {}
extension Dictionary: SoloStorable where Key == String, Value: SoloStorable {}
