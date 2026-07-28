import Foundation
import os.log

public final class DyConsoleDestination {
    /// 子系统标识，用于在 Console.app 中过滤
    public let identifier: String = "console"

    /// 目标最低日志级别
    public var minimumLevel: DyLogLevel

    /// 显示图标
    public private(set) var enableIcons: Bool

    /// 显示文件上下文
    public private(set) var showContext: Bool

    /// 子系统名称
    public private(set) var subsystem: String

    /// 日期格式化器（唯一写入口在 init，之后只读，线程安全）
    private let dateFormatter: DateFormatter

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
    ///   - minimumLevel: 最低日志级别，默认 .debug
    ///   - enableIcons: 是否显示图标
    ///   - showContext: 是否显示文件上下文
    public init(
        subsystem: String = Bundle.main.bundleIdentifier ?? "com.dylogger",
        minimumLevel: DyLogLevel = .debug,
        enableIcons: Bool = true,
        showContext: Bool = true
    ) {
        self.subsystem = subsystem
        self.minimumLevel = minimumLevel
        self.enableIcons = enableIcons
        self.showContext = showContext

        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }

    /// 线程安全地更新显示选项
    public func configure(enableIcons: Bool? = nil, showContext: Bool? = nil, subsystem: String? = nil) {
        lock.lock()
        if let v = enableIcons {
            self.enableIcons = v
        }
        if let v = showContext {
            self.showContext = v
        }
        if let v = subsystem {
            self.subsystem = v
        }
        lock.unlock()
    }
}

// MARK: - DyLogDestination
extension DyConsoleDestination: DyLogDestination {
    public func log(context: DyLogContext) {
        lock.lock()
        let icons = enableIcons
        let ctx = showContext
        lock.unlock()

        let dateStr = dateFormatter.string(from: context.date)

        var output = ""
        output += "[\(dateStr)] "

        if icons {
            output += "\(context.level.icon) "
        }

        output += "[\(context.level.description)] "

        if ctx {
            output += "[\(context.fileName):\(context.line)] \(context.function) | "
        }

        let message = context.items.map { "\($0)" }.joined(separator: ", ")
        output += message

        let category = context.fileName
        let osLog = getOrCreateOSLog(category: category)

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
}

// MARK: - 私有方法
private extension DyConsoleDestination {
    func getOrCreateOSLog(category: String) -> OSLog {
        lock.lock()
        defer { lock.unlock() }

        if let cached = logCache[category] {
            return cached
        }

        let osLog = OSLog(subsystem: subsystem, category: category)
        logCache[category] = osLog
        cacheOrder.append(category)
        if cacheOrder.count > maxCacheCount {
            let oldest = cacheOrder.removeFirst()
            logCache.removeValue(forKey: oldest)
        }
        return osLog
    }
}
