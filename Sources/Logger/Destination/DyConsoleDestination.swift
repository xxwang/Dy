import Foundation
import os.log

public final class DyXcodeDestination: DyLogDestination {
    /// 子系统标识，用于在 Console.app 中过滤
    public var subsystem: String
    /// 是否显示图标
    public var enableIcons: Bool
    /// 是否显示文件上下文
    public var showContext: Bool
    /// 日期格式
    public var dateFormatter: DateFormatter

    // MARK: - os_log 缓存（按 category 缓存，避免重复创建）
    private var logCache: [String: OSLog] = [:]
    private let lock = NSLock()

    // MARK: - 初始化

    /// - Parameters:
    ///   - subsystem: 子系统标识，通常使用 Bundle Identifier
    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "com.dylogger",
        enableIcons: Bool = true,
        showContext: Bool = true
    ) {
        self.subsystem = subsystem
        self.enableIcons = enableIcons
        self.showContext = showContext

        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }

    // MARK: - DyLogDestination

    public func log(level: DyLogLevel, message: String, context: DyLogContext, timestamp: Date) {
        let timestampStr = dateFormatter.string(from: timestamp)

        // 构建最终消息
        var output = ""

        // 时间戳（白色）
        output += "[\(timestampStr)]"

        // 图标
        if enableIcons {
            output += "\(level.icon) "
        }

        // 日志级别
        output += "[\(level.description)]"

        // 上下文信息
        if showContext {
            output += "[\(context.fileName):\(context.line)] \(context.function) | "
        }

        // 日志内容
        output += message

        // 获取对应 category 的 OSLog
        let category = context.fileName
        let osLog = getOrCreateOSLog(category: category)

        // 根据级别调用对应的 os_log 方法
        switch level {
        case .debug:
            os_log(.debug, log: osLog, "%{public}@", output)
        case .info:
            os_log(.info, log: osLog, "%{public}@", output)
        case .warning:
            os_log(.default, log: osLog, "%{public}@", output)
        case .error:
            os_log(.error, log: osLog, "%{public}@", output)
        case .fatal:
            os_log(.fault, log: osLog, "%{public}@", output)
        }
    }

    // MARK: - 私有方法
    private func getOrCreateOSLog(category: String) -> OSLog {
        lock.lock()
        defer { lock.unlock() }

        if let cached = logCache[category] {
            return cached
        }

        let osLog = OSLog(subsystem: subsystem, category: category)
        logCache[category] = osLog
        return osLog
    }
}
