import Foundation

public class DyLogContext {
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
