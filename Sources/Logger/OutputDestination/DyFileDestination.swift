import Foundation

// MARK: - 文件输出目标
public final class DyFileDestination {
    /// 文件句柄
    private let fileHandle: FileHandle
    /// 日期格式化
    private let dateFormatter: DateFormatter
    /// 写入队列
    private let queue = DispatchQueue(label: "logger.file.destination", qos: .utility)

    public init?(filePath: String) {
        // 确保目录存在
        let url = URL(fileURLWithPath: filePath)
        let dir = url.deletingLastPathComponent()
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)

        // 创建或追加文件
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil)
        }

        guard let handle = FileHandle(forWritingAtPath: filePath) else {
            return nil
        }

        self.fileHandle = handle
        self.fileHandle.seekToEndOfFile()

        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }

    deinit {
        fileHandle.closeFile()
    }
}

// MARK: - DyLogDestination
extension DyFileDestination: DyLogDestination {
    public func log(context: DyLogContext) {
        let timestampStr = dateFormatter.string(from: context.date)
        let message = context.items.map { item in
            "\(item)"
        }.joined(separator: ", ")
        let line = "[\(timestampStr)] [\(context.level.description)] [\(context.fileName):\(context.line)] \(message)\n"

        queue.async { [weak self] in
            guard let self, let data = line.data(using: .utf8) else { return }
            self.fileHandle.write(data)
        }
    }
}
