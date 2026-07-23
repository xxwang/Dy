import Foundation

public class DyLogContext {
    /// 所在文件
    public let file: String
    /// 所在方法
    public let function: String
    /// 所在行号
    public let line: Int
    /// 日志日期
    public let timestamp: Date
    /// 日志级别
    public let level: DyLogLevel
    /// 日志内容
    public let message: String

    /// 仅保留文件名，去除完整路径
    public var fileName: String {
        (file as NSString).lastPathComponent
    }

    public init(file: String,
                function: String,
                line: Int,
                timestamp: Date,
                level: DyLogLevel,
                message: String)
    {
        self.file = file
        self.function = function
        self.line = line
        self.timestamp = timestamp
        self.level = level
        self.message = message
    }
}
