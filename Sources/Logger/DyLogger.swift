import Foundation

// MARK: - DyLogger
public class DyLogger {
    /// 最低日志级别，低于此级别的日志将被忽略
    public var minimumLevel: DyLogLevel = .debug
    /// 所有输出目标
    private var destinations: [DyLogDestination] = []
    /// 串行队列，保证线程安全
    private let queue = DispatchQueue(label: "logger.queue", qos: .userInitiated)

    public static let shared = DyLogger()
    private init() {}
}

public extension DyLogger {
    /// 添加输出目标
    @discardableResult
    func addDestination(_ destination: DyLogDestination) -> DyLogger {
        // 与 `log()` 的串行队列访问保持同步，避免并发读写触发数组 COW crash
        queue.sync { destinations.append(destination) }
        return self
    }

    /// 移除所有输出目标
    func removeAllDestinations() {
        queue.sync { destinations.removeAll() }
    }

    /// 核心日志方法
    func log(file: String, function: String, line: Int, date: Date, level: DyLogLevel, items: [Any]) {
        guard level >= minimumLevel else { return }

        let context = DyLogContext(file: file, function: function, line: line, date: date, level: level, items: items)

        // 异步分发到各目标，避免阻塞主线程
        self.queue.async { [weak self] in
            guard let self else { return }
            for destination in self.destinations {
                destination.log(context: context)
            }
        }
    }
}

// MARK: - 便捷方法
public extension DyLogger {
    /// 调试
    func debug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .debug, items: items)
    }

    /// 正常打印
    func info(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .info, items: items)
    }

    /// 警告
    func warn(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .warn, items: items)
    }

    /// 错误
    func err(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .err, items: items)
    }

    /// 致命错误
    func fatal(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .fatal, items: items)
    }
}

// MARK: - 全局便捷函数
/// 调试
public func dy_logDebug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    DyLogger.shared.debug(items, file: file, function: function, line: line)
}

/// 正常打印
public func dy_logInfo(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    DyLogger.shared.info(items, file: file, function: function, line: line)
}

/// 警告
public func dy_logWarn(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    DyLogger.shared.warn(items, file: file, function: function, line: line)
}

/// 错误
public func dy_logErr(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    DyLogger.shared.err(items, file: file, function: function, line: line)
}

/// 致命错误
public func dy_logFatal(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    DyLogger.shared.fatal(items, file: file, function: function, line: line)
}
