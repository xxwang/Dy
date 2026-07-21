import Foundation

// MARK: - 日志上下文
public struct DyLogContext {
    public let file: String
    public let function: String
    public let line: Int

    /// 仅保留文件名，去除完整路径
    public var fileName: String {
        (file as NSString).lastPathComponent
    }

    public init(file: String = #file, function: String = #function, line: Int = #line) {
        self.file = file
        self.function = function
        self.line = line
    }
}
