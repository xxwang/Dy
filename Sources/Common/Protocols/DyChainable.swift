import Foundation

// MARK: - 内部引用包装器
/// 用于在链式调用中共享同一个对象的引用，避免值类型的频繁拷贝
private final class DyRef<T> {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}

// MARK: - 链式构建器
@dynamicMemberLookup
public struct DyBuilder<Subject> {
    private let ref: DyRef<Subject>

    /// 使用给定的对象初始化构建器
    public init(subject: Subject) {
        self.ref = DyRef(subject)
    }

    /// 私有初始化器，复用内部引用
    private init(ref: DyRef<Subject>) {
        self.ref = ref
    }

    /// 完成链式配置，返回最终的对象
    public func build() -> Subject {
        ref.value
    }

    /// 动态成员查找：支持 `.propertyName(newValue)` 语法
    public subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<Subject, Value>
    ) -> (Value) -> DyBuilder<Subject> {
        { [ref] newValue in
            ref.value[keyPath: keyPath] = newValue
            return DyBuilder(ref: ref)
        }
    }

    /// 执行一个副作用操作（无返回值），并继续链式调用
    /// 常用于调用方法、设置代理等
    @discardableResult
    public func apply(_ block: (Subject) -> Void) -> DyBuilder<Subject> {
        block(ref.value)
        return DyBuilder(ref: ref)
    }

    /// 执行一个计算操作（有返回值），并中断链式调用
    /// 适用于从当前对象提取或计算某个值
    public func get<R>(_ block: (Subject) -> R) -> R {
        block(ref.value)
    }
}

// MARK: - 入口协议
public protocol DyChainable: AnyObject {
    /// 返回一个 `DyBuilder` 实例，用于链式配置
    var builder: DyBuilder<Self> { get }
}

/// 默认实现：为任何符合 `Dyable` 的类型提供 `.builder` 属性
public extension DyChainable {
    var builder: DyBuilder<Self> {
        DyBuilder(subject: self)
    }
}

// MARK: - 全局默认扩展
/// 为所有 Class 类型（包括 NSObject 和纯 Swift Class）自动提供链式构建能力
extension DyChainable where Self: AnyObject {}
