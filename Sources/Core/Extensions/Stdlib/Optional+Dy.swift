import Foundation

// MARK: - 可选值自定义赋值运算符
infix operator ?=: AssignmentPrecedence
infix operator ??=: AssignmentPrecedence

public extension Optional {
    /// 仅当右侧可选值非 `nil` 时,将其解包并赋值给左侧
    ///
    /// - Note: 相当于 `if let rhs = rhs { lhs = rhs }`
    /// - Example:
    ///   ```swift
    ///   var target: String? = nil
    ///   let source: String? = "Hello"
    ///   target ?= source  // target = "Hello"
    ///   let empty: String? = nil
    ///   target ?= empty   // target 保持不变
    ///   ```
    @inlinable
    static func ?= (lhs: inout Self, rhs: Self) {
        if let rhsValue = rhs {
            lhs = rhsValue
        }
    }

    /// 仅当左侧为 `nil` 时,使用右侧闭包的结果进行赋值（惰性求值）
    ///
    /// - Note: 右侧表达式仅在 `lhs == nil` 时求值
    /// - Example:
    ///   ```swift
    ///   var cache: Int? = nil
    ///   cache ??= expensiveComputation() // 调用 expensiveComputation()
    ///   cache ??= anotherComputation()   // 不再调用,因为 cache 已有值
    ///   ```
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
    /// - Parameters:
    ///   - lhs: 可选枚举值
    ///   - rhs: 可选原始值
    /// - Returns: 若两者 `rawValue` 相等（或同为 `nil`）,则返回 `true`
    @inlinable
    static func == (lhs: Self, rhs: Wrapped.RawValue?) -> Bool {
        lhs?.rawValue == rhs
    }

    /// 允许直接比较 `Optional<RawValue>` 与 `Optional<Enum>` 是否相等
    ///
    /// - Parameters:
    ///   - lhs: 可选原始值
    ///   - rhs: 可选枚举值
    /// - Returns: 若两者 `rawValue` 相等（或同为 `nil`）,则返回 `true`
    @inlinable
    static func == (lhs: Wrapped.RawValue?, rhs: Self) -> Bool {
        lhs == rhs?.rawValue
    }

    /// 判断 `Optional<Enum>` 与 `Optional<RawValue>` 是否不相等
    ///
    /// - Parameters:
    ///   - lhs: 可选枚举值
    ///   - rhs: 可选原始值
    /// - Returns: 若 `rawValue` 不等或仅一方为 `nil`,则返回 `true`
    @inlinable
    static func != (lhs: Self, rhs: Wrapped.RawValue?) -> Bool {
        lhs?.rawValue != rhs
    }

    /// 判断 `Optional<RawValue>` 与 `Optional<Enum>` 是否不相等
    ///
    /// - Parameters:
    ///   - lhs: 可选原始值
    ///   - rhs: 可选枚举值
    /// - Returns: 若 `rawValue` 不等或仅一方为 `nil`,则返回 `true`
    @inlinable
    static func != (lhs: Wrapped.RawValue?, rhs: Self) -> Bool {
        lhs != rhs?.rawValue
    }
}

extension Optional: DyExtension {}

// MARK: - 可选值安全操作方法
public extension Optional {
    /// 判断可选值是否为 `nil`
    ///
    /// - Returns: 若为 `nil` 返回 `true`,否则 `false`
    var isNil: Bool {
        base == nil
    }

    /// 判断可选值是否不为 `nil`
    ///
    /// - Returns: 若有值返回 `true`,否则 `false`
    var isNotNil: Bool {
        base != nil
    }

    /// 如果可选值存在,则对其执行指定操作
    ///
    /// - Parameter body: 接收解包后值的闭包,仅在值非 `nil` 时调用
    /// - Example:
    ///   ```swift
    ///   let name: String? = "Alice"
    ///   name.dy.run { print("Hello, $0)") } // Hello, Alice
    ///   ```
    func run(_ body: DyAction1<Wrapped>) {
        if let value = self {
            body(value)
        }
    }

    /// 强制解包可选值,若为 `nil` 则触发致命错误
    ///
    /// - Warning: 仅用于调试或能**绝对保证非空**的场景,生产环境慎用
    /// - Parameter message: 自定义错误信息（使用 `@autoclosure` 延迟求值）
    /// - Returns: 解包后的非空值
    /// - Example:
    ///   ```swift
    ///   let value: Int? = nil
    ///   let unwrapped = value.dy.unwrap(orFail: "Value must not be nil!") // 触发 fatalError
    ///   ```
    func unwrap(orFail message: @autoclosure DyFunc<String> = "Unexpected nil") -> Wrapped {
        guard let value = self else { fatalError(message()) }
        return value
    }

    /// 返回可选值,若为 `nil` 则使用指定的默认值
    ///
    /// - Parameter defaultValue: 默认值（直接传入,非惰性求值）
    /// - Returns: 非空值
    /// - Example:
    ///   ```swift
    ///   let name: String? = nil
    ///   let displayName = name.dy.or("Guest") // "Guest"
    ///   ```
    func or(_ defaultValue: Wrapped) -> Wrapped {
        self ?? defaultValue
    }

    /// 返回可选值,若为 `nil` 则通过闭包生成默认值（惰性求值）
    ///
    /// - Parameter fallback: 仅在值为 `nil` 时调用的闭包,用于生成默认值
    /// - Returns: 非空值
    /// - Example:
    ///   ```swift
    ///   let config: String? = nil
    ///   let setting = config.dy.or { loadDefaultConfig() } // 仅当 config 为 nil 时调用 loadDefaultConfig()
    ///   ```
    func or(fallback: DyFunc<Wrapped>) -> Wrapped {
        self ?? fallback()
    }

    /// 若可选值为 `nil`,则抛出指定错误;否则返回解包后的值
    ///
    /// - Parameter error: 要抛出的错误实例
    /// - Returns: 解包后的非空值
    /// - Throws: 指定的错误（当值为 `nil` 时）
    /// - Example:
    ///   ```swift
    ///   enum AppError: Error { case missingValue }
    ///   let input: String? = nil
    ///   let result = try input.dy.or(throw: AppError.missingValue) // 抛出 AppError.missingValue
    ///   ```
    func or(throw error: Error) throws -> Wrapped {
        guard let value = self else { throw error }
        return value
    }

    /// 在可选值非空且满足指定条件时,返回该值;否则返回 `nil`
    ///
    /// - Parameter predicate: 判断值是否符合条件的闭包
    /// - Returns: 满足条件的原值,或 `nil`
    /// - Example:
    ///   ```swift
    ///   let number: Int? = 5
    ///   let positive = number.dy.takeIf { $0 > 0 } // Optional(5)
    ///   let negative = number.dy.takeIf { $0 < 0 } // nil
    ///   ```
    func takeIf(_ predicate: DyFunc1<Wrapped, Bool>) -> Wrapped? {
        guard let value = self, predicate(value) else { return nil }
        return value
    }
}

// MARK: - 可选集合的空值判断扩展
public extension DyWrapper where Base == (any Collection)? {
    /// 判断可选集合是否为 `nil` 或内容为空
    ///
    /// - Returns: 若值为 `nil` 或调用 `isEmpty` 返回 `true`,则结果为 `true`
    /// - Example:
    ///   ```swift
    ///   let arr1: [Int]? = nil
    ///   let arr2: [Int]? = []
    ///   print(arr1.dy.isNilOrEmpty) // true
    ///   print(arr2.dy.isNilOrEmpty) // true
    ///   ```
    var isNilOrEmpty: Bool {
        base?.isEmpty ?? true
    }
}
