import Foundation

// MARK: - 日志输出目标协议
public protocol DyLogDestination {
    /// 目标唯一标识符，用于 removeDestination
    var identifier: String { get }
    /// 该目标的最低日志级别，低于此级别的日志不会被分发到此目标
    var minimumLevel: DyLogLevel { get }
    /// 输出日志
    func log(context: DyLogContext)
    /// 刷新缓冲的日志（文件目标等需要）
    func flush()
    /// 目标被移除时清理资源
    func teardown()
}

// MARK: - 默认实现
public extension DyLogDestination {
    var minimumLevel: DyLogLevel { .debug }
    func flush() {}
    func teardown() {}
}
