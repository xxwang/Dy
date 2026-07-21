import Foundation

// MARK: - 获取类信息
public extension NSObject {
    /// 获取对象的类名
    var dy_className: String {
        let fullName = NSStringFromClass(type(of: self))
        return fullName.components(separatedBy: ".").last ?? fullName
    }

    /// 获取当前类的名称
    static var dy_className: String {
        NSStringFromClass(Self.self)
    }
}

// MARK: - 关联对象
public extension NSObject {
    /// 为当前对象关联一个值
    ///
    /// - Parameters:
    ///   - value: 要关联的值；传入 `nil` 可清除该关联
    ///   - key: 关联键，必须是唯一的内存地址（推荐使用静态全局变量的地址，如 `&myKey`）
    ///   - policy: 内存管理策略，默认为 `.OBJC_ASSOCIATION_RETAIN_NONATOMIC`
    /// - Note: 对于非对象类型（如 `Int`、`Bool`、结构体等），Swift 会自动桥接为 `NSNumber` 或 `NSValue`，
    ///         此时应确保使用兼容的 retain 策略（通常 `.RETAIN` 系列是安全的）
    func dy_setAssociatedObject(
        _ value: Any?,
        forKey key: UnsafeRawPointer,
        policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
    ) {
        objc_setAssociatedObject(self, key, value, policy)
    }

    /// 获取关联的值，并尝试转换为指定泛型类型
    ///
    /// - Parameter key: 关联键，必须与设置时使用的键一致
    /// - Returns: 若关联对象存在、非 `nil` 且可转换为类型 `T`，则返回该值；否则返回 `nil`
    func dy_getAssociatedObject<T>(forKey key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    /// 获取关联的原始对象（不进行类型转换）
    ///
    /// - Parameter key: 关联键，必须与设置时使用的键一致
    /// - Returns: 关联的原始对象（类型为 `Any?`），若无关联则返回 `nil`
    func dy_getAssociatedObject(forKey key: UnsafeRawPointer) -> Any? {
        objc_getAssociatedObject(self, key)
    }
}
