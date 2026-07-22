import Foundation

// MARK: - DyLogger
public class DyLogger {
    public static let shared = DyLogger()
    private init() {}

    // MARK: - 属性

    /// 最低日志级别，低于此级别的日志将被忽略
    public var minimumLevel: DyLogLevel = .debug

    /// 所有输出目标
    private var destinations: [DyLogDestination] = []

    /// 串行队列，保证线程安全
    private let queue = DispatchQueue(label: "logger.queue", qos: .userInitiated)

    /// 添加输出目标
    @discardableResult
    public func addDestination(_ destination: DyLogDestination) -> DyLogger {
        destinations.append(destination)
        return self
    }

    /// 移除所有输出目标
    public func removeAllDestinations() {
        destinations.removeAll()
    }

    // MARK: - 核心日志方法
    public func log(
        _ level: DyLogLevel,
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        guard level >= minimumLevel else { return }

        let context = DyLogContext(file: file, function: function, line: line)
        let timestamp = Date()
        let msg = message()

        // 异步分发到各目标，避免阻塞主线程
        queue.async { [weak self] in
            guard let self else { return }
            for destination in self.destinations {
                destination.log(level: level, message: msg, context: context, timestamp: timestamp)
            }
        }
    }

    // MARK: - 便捷方法
    public func debug(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line)
    {
        log(.debug, message(), file: file, function: function, line: line)
    }

    public func info(_ message: @autoclosure () -> String,
                     file: String = #file,
                     function: String = #function,
                     line: Int = #line)
    {
        log(.info, message(), file: file, function: function, line: line)
    }

    public func warning(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
    {
        log(.warning, message(), file: file, function: function, line: line)
    }

    public func error(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line)
    {
        log(.error, message(), file: file, function: function, line: line)
    }

    public func fatal(_ message: @autoclosure () -> String,
                      file: String = #file,
                      function: String = #function,
                      line: Int = #line)
    {
        log(.fatal, message(), file: file, function: function, line: line)
    }
}

// MARK: - 全局便捷函数
public func dy_logDebug(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
{
    DyLogger.shared.debug(message(), file: file, function: function, line: line)
}

public func dy_logInfo(_ message: @autoclosure () -> String,
                       file: String = #file,
                       function: String = #function,
                       line: Int = #line)
{
    DyLogger.shared.info(message(), file: file, function: function, line: line)
}

public func dy_logWarning(_ message: @autoclosure () -> String,
                          file: String = #file,
                          function: String = #function,
                          line: Int = #line)
{
    DyLogger.shared.warning(message(), file: file, function: function, line: line)
}

public func dy_logError(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
{
    DyLogger.shared.error(message(), file: file, function: function, line: line)
}

public func dy_logFatal(_ message: @autoclosure () -> String,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line)
{
    DyLogger.shared.fatal(message(), file: file, function: function, line: line)
}
