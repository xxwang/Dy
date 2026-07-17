import Foundation

// MARK: - 无返回值
public typealias DyAction = () -> Void
public typealias DyAction1<T1> = (T1) -> Void
public typealias DyAction2<T1, T2> = (T1, T2) -> Void
public typealias DyAction3<T1, T2, T3> = (T1, T2, T3) -> Void
public typealias DyAction4<T1, T2, T3, T4> = (T1, T2, T3, T4) -> Void
public typealias DyAction5<T1, T2, T3, T4, T5> = (T1, T2, T3, T4, T5) -> Void

// MARK: - 有返回值
public typealias DyFunc<R> = () -> R
public typealias DyFunc1<T1, R> = (T1) -> R
public typealias DyFunc2<T1, T2, R> = (T1, T2) -> R
public typealias DyFunc3<T1, T2, T3, R> = (T1, T2, T3) -> R
public typealias DyFunc4<T1, T2, T3, T4, R> = (T1, T2, T3, T4) -> R
public typealias DyFunc5<T1, T2, T3, T4, T5, R> = (T1, T2, T3, T4, T5) -> R
