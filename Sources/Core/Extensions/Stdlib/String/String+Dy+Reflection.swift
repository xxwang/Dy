import Foundation

// MARK: - 类型与实例反射
public extension DyWrapper where Base == String {
    /// 通过类名字符串创建该类的实例(要求类继承自 `NSObject` 并有无参 `init()`)
    ///
    /// - Returns: 实例对象,若类不存在或无法初始化则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let viewController = "MyViewController".dy.createFromClass() as? UIViewController
    ///   ```
    func createFromClass() -> NSObject? {
        guard let aClass = NSClassFromString(base) as? NSObject.Type
        else {
            return nil
        }
        return aClass.init()
    }
}
