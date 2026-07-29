import Combine
import UIKit

// MARK: - 绑定运算符

precedencegroup BindingPrecedence {
    associativity: right
    higherThan: AssignmentPrecedence
}

infix operator <<<: BindingPrecedence

// MARK: - ControlProperty

/// 控件属性发布者（可读、可写）。
///
/// - 订阅时**立即重放当前值**，此后在属性变化（用户操作或代码赋值）时持续发出；
/// - 通过 `bind(to:)` 或 `<<<` 运算符可将上游 publisher 的值写回控件，实现双向绑定。
///
/// 例（双向绑定）：
/// ```swift
/// // 读：用户输入 -> viewModel
/// textField.dy_textPublisher
///     .compactMap { $0 }
///     .sink { viewModel.name = $0 }
///     .store(in: &cancellables)
///
/// // 写：viewModel -> 控件
/// viewModel.$name <<< textField.dy_textPublisher   // 或 textField.dy_textPublisher.bind(to: viewModel.$name)
/// ```
public struct ControlProperty<Value>: Publisher {
    public typealias Output = Value
    public typealias Failure = Never

    private let values: AnyPublisher<Value, Never>
    private let setter: (Value) -> Void

    public func receive<S: Subscriber>(subscriber: S)
        where S.Failure == Failure, S.Input == Output
    {
        values.receive(subscriber: subscriber)
    }

    init(values: AnyPublisher<Value, Never>, setter: @escaping (Value) -> Void) {
        self.values = values
        self.setter = setter
    }

    /// 将上游 publisher 的值写回控件（绑定）。
    /// - Parameter source: 发送 `Value` 的 publisher（`Failure` 须为 `Never`）。
    /// - Returns: 可取消的订阅，用于释放绑定。
    public func bind(to source: AnyPublisher<Value, Never>) -> Cancellable {
        source.sink { [setter] value in
            setter(value)
        }
    }
}

/// 绑定运算符：`property <<< source` 等价于 `property.bind(to: source)`。
public func <<< <V, P: Publisher>(property: ControlProperty<V>, source: P) -> Cancellable
    where P.Output == V, P.Failure == Never
{
    property.bind(to: source.eraseToAnyPublisher())
}
