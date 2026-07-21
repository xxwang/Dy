import Foundation

// MARK: - 日志输出目标协议
public protocol DyLogDestination {
    func log(level: DyLogLevel, message: String, context: DyLogContext, timestamp: Date)
}
