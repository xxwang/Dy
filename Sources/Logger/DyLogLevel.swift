import Foundation

// MARK: - 日志级别
public enum DyLogLevel: Int, Comparable, CustomStringConvertible {
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case fatal = 5

    public static func < (lhs: DyLogLevel, rhs: DyLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    /// 图标前缀（可选，增强可读性）
    var icon: String {
        switch self {
        case .debug: return "👻"
        case .info: return "🌸"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .fatal: return "☠️"
        }
    }

    public var description: String {
        switch self {
        case .debug: return "调试"
        case .info: return "正常"
        case .warning: return "警告"
        case .error: return "错误"
        case .fatal: return "致命"
        }
    }
}
