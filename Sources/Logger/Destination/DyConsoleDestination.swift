import Foundation

// MARK: - 终端输出目标（支持颜色）
public final class DyConsoleDestination: DyLogDestination {
    /// 是否启用颜色
    public var enableColors: Bool
    /// 是否显示图标
    public var enableIcons: Bool
    /// 是否显示文件上下文
    public var showContext: Bool
    /// 日期格式
    public var dateFormatter: DateFormatter

    public init(
        enableColors: Bool = true,
        enableIcons: Bool = true,
        showContext: Bool = true
    ) {
        self.enableColors = enableColors
        self.enableIcons = enableIcons
        self.showContext = showContext

        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "HH:mm:ss.SSS"
    }

    public func log(level: DyLogLevel, message: String, context: DyLogContext, timestamp: Date) {
        let timestampStr = dateFormatter.string(from: timestamp)

        var output = ""

        if enableColors {
            let color = level.color.rawValue
            let reset = DyANSIColor.reset.rawValue
            let bold = DyANSIColor.bold.rawValue

            // 时间戳（白色）
            output += "\(DyANSIColor.white.rawValue)[\(timestampStr)]\(reset) "

            // 图标
            if enableIcons {
                output += "\(level.icon) "
            }

            // 日志级别（带颜色 + 加粗）
            let levelStr = String(format: "%-7@", level.description)
            output += "\(bold)\(color)[\(levelStr)]\(reset) "

            // 上下文信息（蓝色）
            if showContext {
                output += "\(DyANSIColor.blue.rawValue)\(context.fileName):\(context.line) \(context.function)\(reset) "
            }

            // 日志内容（带级别颜色）
            output += "\(color)\(message)\(reset)"
        } else {
            let levelStr = String(format: "%-7@", level.description)
            output += "[\(timestampStr)] [\(levelStr)] "
            if showContext {
                output += "\(context.fileName):\(context.line) \(context.function) "
            }
            output += message
        }

        print(output)
    }
}
