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
        destinations.append(destination)
        return self
    }

    /// 移除所有输出目标
    func removeAllDestinations() {
        destinations.removeAll()
    }

    /// 核心日志方法
    func log(context: DyLogContext) {
        guard context.level >= minimumLevel else { return }

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
    func debug(_ message: @autoclosure () -> String,
               file: String = #file,
               function: String = #function,
               line: Int = #line)
    {
        let context = DyLogContext(
            file: file,
            function: function,
            line: line,
            timestamp: Date(),
            level: .debug,
            message: message()
        )
        self.log(context: context)
    }

    /// 正常打印
    func info(_ message: @autoclosure () -> String,
              file: String = #file,
              function: String = #function,
              line: Int = #line)
    {
        let context = DyLogContext(
            file: file,
            function: function,
            line: line,
            timestamp: Date(),
            level: .info,
            message: message()
        )
        self.log(context: context)
    }

    /// 警告
    func warn(_ message: @autoclosure () -> String,
              file: String = #file,
              function: String = #function,
              line: Int = #line)
    {
        let context = DyLogContext(
            file: file,
            function: function,
            line: line,
            timestamp: Date(),
            level: .warning,
            message: message()
        )
        self.log(context: context)
    }

    /// 错误
    func err(_ message: @autoclosure () -> String,
             file: String = #file,
             function: String = #function,
             line: Int = #line)
    {
        let context = DyLogContext(
            file: file,
            function: function,
            line: line,
            timestamp: Date(),
            level: .error,
            message: message()
        )
        self.log(context: context)
    }

    /// 致命错误
    func fatal(_ message: @autoclosure () -> String,
               file: String = #file,
               function: String = #function,
               line: Int = #line)
    {
        let context = DyLogContext(
            file: file,
            function: function,
            line: line,
            timestamp: Date(),
            level: .fatal,
            message: message()
        )
        self.log(context: context)
    }
}

// MARK: - 全局便捷函数
/// 调试
public func dy_logDebug(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
{
    DyLogger.shared.debug(message(), file: file, function: function, line: line)
}

/// 正常打印
public func dy_logInfo(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line)
{
    DyLogger.shared.info(message(), file: file, function: function, line: line)
}

/// 警告
public func dy_logWarn(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line)
{
    DyLogger.shared.warn(message(), file: file, function: function, line: line)
}

/// 错误
public func dy_logErr(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line)
{
    DyLogger.shared.err(message(), file: file, function: function, line: line)
}

/// 致命错误
public func dy_logFatal(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
{
    DyLogger.shared.fatal(message(), file: file, function: function, line: line)
}
