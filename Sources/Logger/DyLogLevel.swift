import Foundation

// MARK: - 日志级别
public enum DyLogLevel: Int, Comparable, CustomStringConvertible {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    case fatal = 5

    public static func < (lhs: DyLogLevel, rhs: DyLogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public var description: String {
        switch self {
        case .verbose: return "VERBOSE"
        case .debug: return "DEBUG"
        case .info: return "INFO"
        case .warning: return "WARNING"
        case .error: return "ERROR"
        case .fatal: return "FATAL"
        }
    }
}

// MARK: - 日志级别与颜色的映射
public extension DyLogLevel {
    /// 每个日志级别对应的颜色方案
    var color: DyANSIColor {
        switch self {
        case .verbose: return .white
        case .debug: return .cyan
        case .info: return .green
        case .warning: return .yellow
        case .error: return .brightRed
        case .fatal: return .bgRed
        }
    }

    /// 图标前缀（可选，增强可读性）
    var icon: String {
        switch self {
        case .verbose: return "📝"
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .fatal: return "💀"
        }
    }
}
