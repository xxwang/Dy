import Foundation
import os.log

public final class DyConsoleDestination {
    /// 子系统标识，用于在 Console.app 中过滤
    public var subsystem: String
    /// 是否显示图标
    public var enableIcons: Bool
    /// 是否显示文件上下文
    public var showContext: Bool
    /// 日期格式
    public var dateFormatter: DateFormatter

    /// `os_log` 缓存（按`category`缓存，避免重复创建）
    private var logCache: [String: OSLog] = [:]
    /// 缓存插入顺序，配合 `maxCacheCount` 实现 FIFO 上限控制
    private var cacheOrder: [String] = []
    /// `logCache` 最大条目数，防止无限增长
    private let maxCacheCount = 64
    private let lock = NSLock()

    /// 初始化
    /// - Parameters:
    ///   - subsystem: 子系统标识，通常使用 Bundle Identifier
    ///   - enableIcons: 是否显示图标
    ///   - showContext: 是否显示文件上下文
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
}

// MARK: - DyLogDestination
extension DyConsoleDestination: DyLogDestination {
    public func log(context: DyLogContext) {
        let dateStr = dateFormatter.string(from: context.date)

        // 构建最终消息
        var output = ""

        // 日志时间
        output += "[\(dateStr)] "

        // 图标
        if enableIcons {
            output += "\(context.level.icon) "
        }

        // 日志级别
        output += "[\(context.level.description)] "

        // 上下文信息
        if showContext {
            output += "[\(context.fileName):\(context.line)] \(context.function) | "
        }

        // 日志内容
        let message = context.items.map { item in
            "\(item)"
        }.joined(separator: ", ")
        output += message

        // 获取对应 category 的 OSLog
        let category = context.fileName
        let osLog = getOrCreateOSLog(category: category)

        // 根据级别调用对应的 os_log 方法
        switch context.level {
        case .debug:
            os_log(.debug, log: osLog, "%{public}@", output)
        case .info:
            os_log(.info, log: osLog, "%{public}@", output)
        case .warn:
            os_log(.default, log: osLog, "%{public}@", output)
        case .err:
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
        cacheOrder.append(category)
        // 超过上限时移除最早创建的条目，避免缓存无限增长
        if cacheOrder.count > maxCacheCount {
            let oldest = cacheOrder.removeFirst()
            logCache.removeValue(forKey: oldest)
        }
        return osLog
    }
}
