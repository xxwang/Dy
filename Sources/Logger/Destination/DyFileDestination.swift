import Foundation

// MARK: - 文件输出目标
public final class DyFileDestination: DyLogDestination {
    private let fileHandle: FileHandle
    private let dateFormatter: DateFormatter
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

    public func log(level: DyLogLevel, message: String, context: DyLogContext, timestamp: Date) {
        let timestampStr = dateFormatter.string(from: timestamp)
        let levelStr = String(format: "%-7@", level.description)
        let line = "[\(timestampStr)] [\(levelStr)] [\(context.fileName):\(context.line)] \(message)\n"

        queue.async { [weak self] in
            guard let self, let data = line.data(using: .utf8) else { return }
            self.fileHandle.write(data)
        }
    }
}
