import Foundation

// MARK: - 终端颜色
public enum DyANSIColor: String {
    // 前景色
    case black = "\u{001B}[30m"
    case red = "\u{001B}[31m"
    case green = "\u{001B}[32m"
    case yellow = "\u{001B}[33m"
    case blue = "\u{001B}[34m"
    case magenta = "\u{001B}[35m"
    case cyan = "\u{001B}[36m"
    case white = "\u{001B}[37m"

    // 高亮前景色
    case brightRed = "\u{001B}[91m"
    case brightGreen = "\u{001B}[92m"
    case brightYellow = "\u{001B}[93m"
    case brightBlue = "\u{001B}[94m"
    case brightMagenta = "\u{001B}[95m"
    case brightCyan = "\u{001B}[96m"
    case brightWhite = "\u{001B}[97m"

    // 背景色
    case bgRed = "\u{001B}[41m"
    case bgYellow = "\u{001B}[43m"

    // 样式
    case bold = "\u{001B}[1m"
    case underline = "\u{001B}[4m"

    /// 重置
    case reset = "\u{001B}[0m"
}
