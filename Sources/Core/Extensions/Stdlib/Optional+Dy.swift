import Foundation

public protocol DyOptionalProtocol {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: DyOptionalProtocol {
    public var wrapped: Wrapped? {
        self
    }
}

extension Optional: DyExtension {}

// MARK: - 可选值自定义赋值运算符
infix operator ?=: AssignmentPrecedence
infix operator ??=: AssignmentPrecedence

public extension Optional {
    /// 仅当右侧可选值非 `nil` 时,将其解包并赋值给左侧
    ///
    ///     var target: String? = nil
    ///     let source: String? = "Hello"
    ///     target ?= source  // target = "Hello"
    ///     target ?= nil     // 保持不变
    @inlinable
    static func ?= (lhs: inout Self, rhs: Self) {
        if let rhsValue = rhs {
            lhs = rhsValue
        }
    }

    /// 仅当左侧为 `nil` 时,使用右侧闭包的结果进行赋值（惰性求值）
    ///
    ///     var cache: Int? = nil
    ///     cache ??= expensiveComputation() // 调用
    ///     cache ??= anotherComputation()   // 跳过,已有值
    @inlinable
    static func ??= (lhs: inout Self, rhs: @autoclosure () -> Self) {
        if lhs == nil {
            lhs = rhs()
        }
    }
}

// MARK: - 可选 RawRepresentable 类型与原始值的比较重载
public extension Optional where Wrapped: RawRepresentable, Wrapped.RawValue: Equatable {
    /// 允许直接比较 `Optional<Enum>` 与 `Optional<RawValue>` 是否相等
    ///
    ///     enum Status: String { case ok, fail }
    ///     let s: Status? = .ok
    ///     s == "ok"  // true
    @inlinable
    static func == (lhs: Self, rhs: Wrapped.RawValue?) -> Bool {
        lhs?.rawValue == rhs
    }

    /// 允许直接比较 `Optional<RawValue>` 与 `Optional<Enum>` 是否相等
    @inlinable
    static func == (lhs: Wrapped.RawValue?, rhs: Self) -> Bool {
        lhs == rhs?.rawValue
    }

    /// 允许直接比较 `Optional<Enum>` 与 `Optional<RawValue>` 是否不相等
    @inlinable
    static func != (lhs: Self, rhs: Wrapped.RawValue?) -> Bool {
        lhs?.rawValue != rhs
    }

    /// 允许直接比较 `Optional<RawValue>` 与 `Optional<Enum>` 是否不相等
    @inlinable
    static func != (lhs: Wrapped.RawValue?, rhs: Self) -> Bool {
        lhs != rhs?.rawValue
    }
}

// MARK: - 可选值状态判断
extension DyWrapper where Base: DyOptionalProtocol {
    /// 判断可选值是否为 nil
    var isNil: Bool {
        switch base.wrapped {
        case .none:
            return true
        case .some:
            return false
        }
    }

    /// 判断可选值是否不为 nil
    var isNotNil: Bool {
        return !self.isNil
    }
}

// MARK: - 可选集合的空值判断
extension DyWrapper where Base: DyOptionalProtocol, Base.Wrapped: Collection {
    /// 判断可选集合是否为 nil 或内容为空
    var isNilOrEmpty: Bool {
        base.wrapped?.isEmpty ?? true
    }
}

// MARK: - 可选值安全操作
extension DyWrapper where Base: DyOptionalProtocol {
    /// 如果可选值存在,则对其执行指定操作
    func run(_ body: (Base.Wrapped) -> Void) {
        if let value = base.wrapped {
            body(value)
        }
    }

    /// 强制解包可选值,若为 nil 则触发致命错误
    func unwrap(orFail message: @autoclosure () -> String = "Unexpected nil") -> Base.Wrapped {
        guard let value = base.wrapped else { fatalError(message()) }
        return value
    }

    /// 返回可选值,若为 nil 则使用指定的默认值
    func or(_ defaultValue: Base.Wrapped) -> Base.Wrapped {
        base.wrapped ?? defaultValue
    }

    /// 返回可选值,若为 nil 则通过闭包生成默认值（惰性求值）
    func or(fallback: () -> Base.Wrapped) -> Base.Wrapped {
        base.wrapped ?? fallback()
    }

    /// 若可选值为 nil,则抛出指定错误;否则返回解包后的值
    func or(throw error: Error) throws -> Base.Wrapped {
        guard let value = base.wrapped else { throw error }
        return value
    }

    /// 在可选值非空且满足指定条件时,返回该值;否则返回 nil
    func takeIf(_ predicate: (Base.Wrapped) -> Bool) -> Base.Wrapped? {
        guard let value = base.wrapped, predicate(value) else { return nil }
        return value
    }
}
