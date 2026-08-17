import Foundation

// MARK: - SoloLogger
public final class SoloLogger {
    /// 最低日志级别，低于此级别的日志将被忽略。读取通过队列同步保证线程安全
    public var minimumLevel: SoloLogLevel {
        get { queue.sync { _minimumLevel } }
        set { queue.sync { _minimumLevel = newValue } }
    }

    private var _minimumLevel: SoloLogLevel = .debug

    /// 所有输出目标
    private var destinations: [SoloLogDestination] = []
    /// 串行队列，保证所有读写操作的线程安全
    private let queue = DispatchQueue(label: "logger.queue", qos: .userInitiated)

    public static let shared = SoloLogger()
    private init() {}
}

public extension SoloLogger {
    /// 添加输出目标
    @discardableResult
    func addDestination(_ destination: SoloLogDestination) -> SoloLogger {
        queue.sync { destinations.append(destination) }
        return self
    }

    /// 根据标识符移除指定输出目标
    @discardableResult
    func removeDestination(identifier: String) -> Bool {
        queue.sync {
            if let idx = destinations.firstIndex(where: { $0.identifier == identifier }) {
                destinations[idx].teardown()
                destinations.remove(at: idx)
                return true
            }
            return false
        }
    }

    /// 移除所有输出目标
    func removeAllDestinations() {
        queue.sync {
            for dest in destinations {
                dest.teardown()
            }
            destinations.removeAll()
        }
    }

    /// 核心日志方法。在入队前先快速检查全局 minimumLevel（避免不必要的队列操作）；
    /// 入队后再按每个目标各自的 minimumLevel 分发。
    func log(file: String, function: String, line: Int, date: Date, level: SoloLogLevel, items: [Any]) {
        // 快速路径：全局级别过滤，避免浪费队列调度
        if level < minimumLevel {
            return
        }

        self.queue.async { [weak self] in
            guard let self else { return }
            let context = SoloLogContext(file: file, function: function, line: line, date: date, level: level, items: items)
            for destination in self.destinations {
                guard level >= destination.minimumLevel else { continue }
                destination.log(context: context)
            }
        }
    }
}

// MARK: - 便捷方法
public extension SoloLogger {
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
    func error(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .error, items: items)
    }

    /// 致命错误
    func fatal(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
        self.log(file: file, function: function, line: line, date: Date(), level: .fatal, items: items)
    }
}

// MARK: - 全局便捷函数
/// 调试
public func solo_logDebug(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    SoloLogger.shared.debug(items, file: file, function: function, line: line)
}

/// 正常打印
public func solo_logInfo(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    SoloLogger.shared.info(items, file: file, function: function, line: line)
}

/// 警告
public func solo_logWarn(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    SoloLogger.shared.warn(items, file: file, function: function, line: line)
}

/// 错误
public func solo_logError(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    SoloLogger.shared.error(items, file: file, function: function, line: line)
}

/// 致命错误
public func solo_logFatal(_ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    SoloLogger.shared.fatal(items, file: file, function: function, line: line)
}
