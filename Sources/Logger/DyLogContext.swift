import Foundation

/// 日志上下文——携带单条日志的元信息（文件、行号、级别、内容等）。
/// 定义为 `struct` 而非 `class`，避免堆分配和引用计数开销；在高频日志场景下性能更优
public struct DyLogContext {
    /// 所在文件
    public let file: String
    /// 所在方法
    public let function: String
    /// 所在行号
    public let line: Int
    /// 日志日期
    public let date: Date
    /// 日志级别
    public let level: DyLogLevel
    /// 日志内容
    public let items: [Any]

    /// 仅保留文件名，去除完整路径
    public var fileName: String {
        (file as NSString).lastPathComponent
    }

    public init(file: String, function: String, line: Int, date: Date, level: DyLogLevel, items: [Any]) {
        self.file = file
        self.function = function
        self.line = line
        self.date = date
        self.level = level
        self.items = items
    }
}
