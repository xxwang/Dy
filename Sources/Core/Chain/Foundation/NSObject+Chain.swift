import Foundation

extension NSObject: DyExtension {}

// MARK: - 链式方法
public extension DyWrapper where Base: NSObject {
    /// 对当前对象执行操作,并返回自身,支持链式调用
    /// 适用于引用类型(如 `NSObject` 子类、`UIView` 等)
    ///
    /// - Parameter block: 配置当前对象的闭包
    /// - Returns: 当前对象本身(`self`)
    ///
    /// - Example:
    /// ```
    /// let label = UILabel()
    /// .dy
    /// .then {
    ///     $0.text = "Hello"
    ///     $0.textColor = .red
    ///     $0.textAlignment = .center
    /// }
    /// ```
    @inlinable
    func then(_ block: (Base) throws -> Void) rethrows -> Self {
        try block(base)
        return self
    }
}
