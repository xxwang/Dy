import Foundation

// MARK: - 日志输出目标协议
public protocol DyLogDestination {
    func log(context: DyLogContext)
}
