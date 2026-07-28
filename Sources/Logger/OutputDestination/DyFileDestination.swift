import Foundation
import os.log

// MARK: - 文件输出目标
public final class DyFileDestination {
    /// 目标唯一标识符
    public let identifier: String

    /// 最低日志级别
    public var minimumLevel: DyLogLevel

    /// 日志文件路径
    public let filePath: String

    /// 最大文件大小（字节），超过此大小将轮转。0 表示不限制
    public let maxFileSize: Int

    /// 轮转时保留的历史文件数
    public let maxRotatedFiles: Int

    /// 文件句柄
    private var fileHandle: FileHandle

    /// 日期格式化
    private let dateFormatter: DateFormatter

    /// 写入队列
    private let queue = DispatchQueue(label: "logger.file.destination", qos: .utility)

    private let sizeLock = NSLock()
    private var currentSize: Int = 0

    public init?(
        filePath: String,
        identifier: String = "file",
        minimumLevel: DyLogLevel = .debug,
        maxFileSize: Int = 0,
        maxRotatedFiles: Int = 3
    ) {
        self.identifier = identifier
        self.minimumLevel = minimumLevel
        self.filePath = filePath
        self.maxFileSize = maxFileSize
        self.maxRotatedFiles = maxRotatedFiles

        let url = URL(fileURLWithPath: filePath)
        let dir = url.deletingLastPathComponent()

        // 确保目录存在
        do {
            try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        } catch {
            os_log(.error, "DyFileDestination: 创建目录失败 %{public}@: %{public}@", dir.path, error.localizedDescription)
            return nil
        }

        // 创建文件（如不存在）
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil)
        }

        guard let handle = FileHandle(forWritingAtPath: filePath) else {
            os_log(.error, "DyFileDestination: 无法打开文件 %{public}@", filePath)
            return nil
        }

        self.fileHandle = handle
        self.fileHandle.seekToEndOfFile()

        // 读取当前文件大小
        if let attrs = try? FileManager.default.attributesOfItem(atPath: filePath) {
            self.currentSize = (attrs[.size] as? Int) ?? 0
        }

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
        let dateStr = dateFormatter.string(from: context.date)
        let message = context.items.map { "\($0)" }.joined(separator: ", ")
        let line = "[\(dateStr)] [\(context.level.description)] [\(context.fileName):\(context.line)] \(message)\n"

        queue.async { [weak self] in
            guard let self, let data = line.data(using: .utf8) else { return }
            self.fileHandle.write(data)
            self.trackSize(data.count)
        }
    }

    public func flush() {
        queue.sync {
            self.fileHandle.synchronizeFile()
        }
    }

    public func teardown() {
        queue.sync {
            self.fileHandle.synchronizeFile()
            self.fileHandle.closeFile()
        }
    }
}

// MARK: - 轮转
private extension DyFileDestination {
    func trackSize(_ byteCount: Int) {
        guard maxFileSize > 0 else { return }
        sizeLock.lock()
        currentSize += byteCount
        sizeLock.unlock()

        if currentSize >= maxFileSize {
            rotateLogFile()
        }
    }

    func rotateLogFile() {
        queue.async { [weak self] in
            guard let self else { return }

            self.fileHandle.closeFile()

            // 轮转历史文件: file.log → file.1.log, file.1.log → file.2.log ...
            for i in stride(from: self.maxRotatedFiles - 1, through: 1, by: -1) {
                let oldPath = self.rotatedPath(index: i)
                let newPath = self.rotatedPath(index: i + 1)
                try? FileManager.default.removeItem(atPath: newPath)
                try? FileManager.default.moveItem(atPath: oldPath, toPath: newPath)
            }

            // 当前文件 → .1
            let backup = self.rotatedPath(index: 1)
            try? FileManager.default.removeItem(atPath: backup)
            try? FileManager.default.moveItem(atPath: self.filePath, toPath: backup)

            // 重新打开当前文件写入
            FileManager.default.createFile(atPath: self.filePath, contents: nil)
            if let newHandle = FileHandle(forWritingAtPath: self.filePath) {
                self.fileHandle = newHandle
            }

            self.sizeLock.lock()
            self.currentSize = 0
            self.sizeLock.unlock()
        }
    }

    func rotatedPath(index: Int) -> String {
        let url = URL(fileURLWithPath: filePath)
        let stem = url.deletingPathExtension().lastPathComponent
        let ext = url.pathExtension
        let dir = url.deletingLastPathComponent()
        return dir.appendingPathComponent("\(stem).\(index)\(ext.isEmpty ? "" : "." + ext)").path
    }
}
