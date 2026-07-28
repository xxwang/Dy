import Foundation

// MARK: - DyLogger
public class DyLogger {
    /// 最低日志级别，低于此级别的日志将被忽略。读取通过队列同步保证线程安全
    public var minimumLevel: DyLogLevel {
        get { queue.sync { _minimumLevel } }
        set { queue.sync { _minimumLevel = newValue } }
    }

    private var _minimumLevel: DyLogLevel = .debug

    /// 所有输出目标
    private var destinations: [DyLogDestination] = []
    /// 串行队列，保证所有读写操作的线程安全
    private let queue = DispatchQueue(label: "logger.queue", qos: .userInitiated)

    public static let shared = DyLogger()
    private init() {}
}

public extension DyLogger {
    /// 添加输出目标
    @discardableResult
    func addDestination(_ destination: DyLogDestination) -> DyLogger {
        queue.sync { destinations.append(destination) }
        return self
    }

    /// 移除所有输出目标
    func removeAllDestinations() {
        queue.sync { destinations.removeAll() }
    }

    /// 核心日志方法。低于 minimumLevel 的日志将被丢弃;
    /// 分发到各输出目标在串行队列中异步执行，不阻塞调用线程
    func log(file: String, function: String, line: Int, date: Date, level: DyLogLevel, items: [Any]) {
        // level 和 destinations 的访问都通过 queue 序列化，避免数据竞争
        self.queue.async { [weak self] in
            guard let self, level >= self._minimumLevel else { return }
            let context = DyLogContext(file: file, function: function, line: line, date: date, level: level, items: items)
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
