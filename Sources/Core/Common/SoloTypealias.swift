import Foundation

// MARK: - 无返回值
public typealias SoloAction = () -> Void
public typealias SoloAction1<T1> = (T1) -> Void
public typealias SoloAction2<T1, T2> = (T1, T2) -> Void
public typealias SoloAction3<T1, T2, T3> = (T1, T2, T3) -> Void
public typealias SoloAction4<T1, T2, T3, T4> = (T1, T2, T3, T4) -> Void
public typealias SoloAction5<T1, T2, T3, T4, T5> = (T1, T2, T3, T4, T5) -> Void

// MARK: - 有返回值
public typealias SoloFunc<R> = () -> R
public typealias SoloFunc1<T1, R> = (T1) -> R
public typealias SoloFunc2<T1, T2, R> = (T1, T2) -> R
public typealias SoloFunc3<T1, T2, T3, R> = (T1, T2, T3) -> R
public typealias SoloFunc4<T1, T2, T3, T4, R> = (T1, T2, T3, T4) -> R
public typealias SoloFunc5<T1, T2, T3, T4, T5, R> = (T1, T2, T3, T4, T5) -> R

// MARK: - 其它
public typealias SoloPair<T1, T2> = SoloModel2<T1, T2>
