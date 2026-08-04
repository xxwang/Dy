import UIKit

// MARK: - 命名空间
public protocol DyExtension {
    associatedtype WrapperType
    var dy: WrapperType { get }
}

// MARK: - 提供命名空间入口
public extension DyExtension {
    /// 实例命名空间入口
    var dy: DyWrapper<Self> {
        DyWrapper(self)
    }

    /// 类型命名空间入口
    static var dy: DyWrapper<Self>.Type {
        DyWrapper<Self>.self
    }
}

// MARK: - 配置包装器
public final class DyWrapper<Base> {
    /// 被包装的原始实例
    public var base: Base

    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - 值类型与引用类型通用的方法
public extension DyWrapper {
    /// 获取配置完成的实例
    @discardableResult
    func build() -> Base {
        self.base
    }

    /// 对当前值的副本执行操作,并返回修改后的副本
    /// 适用于值类型(如 `struct`、`enum`、`Array` 等),不会影响原始值
    ///
    /// - Parameter block: 接收一个可变副本的闭包
    /// - Returns: 修改后的副本
    ///
    /// - Example:
    /// ```
    /// let point = CGPoint(x: 10, y: 20)
    ///     .dy
    ///     .with {
    ///         $0.x += 5
    ///         $0.y *= 2
    ///     }
    /// point 现在是 (15, 40),原始值未被修改(因为是值类型)
    /// ```
    @inlinable
    func with(_ block: (inout Base) throws -> Void) rethrows -> Base {
        var copy = base
        try block(&copy)
        return copy
    }

    /// 对当前值执行操作,不返回新值(仅用于副作用,如打印、验证等)
    ///
    /// - Parameter block: 接收当前值的闭包
    ///
    /// - Example:
    /// ```
    /// [1, 2, 3]
    ///     .dy
    ///     .do { print("数组内容:\($0)") }
    ///     .dy
    ///     .with { arr in
    ///         arr.append(4)
    ///     }
    /// ```
    @inlinable
    func `do`(_ block: (Base) throws -> Void) rethrows {
        try block(base)
    }
}

// MARK: - 作用于引用类型
public extension DyWrapper where Base: AnyObject {
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
