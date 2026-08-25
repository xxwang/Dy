import Foundation

// MARK: - 类型与实例反射
public extension String {
    /// 通过类名字符串创建该类的实例(要求类继承自 `NSObject` 并有无参 `init()`)
    ///
    /// - Returns: 实例对象,若类不存在或无法初始化则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   let viewController = "MyViewController".dy_createFromClass() as? UIViewController
    ///   ```
    func dy_createFromClass() -> NSObject? {
        guard let aClass = NSClassFromString(self) as? NSObject.Type
        else {
            return nil
        }
        return aClass.init()
    }
}
