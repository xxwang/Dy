import Foundation

// MARK: - 文件路径基础操作(基于 NSString 的 POSIX 路径处理)
/// 提供与 `NSString` 路径 API 对应的 Swift 风格扩展
/// 这些方法适用于标准 POSIX 路径(如 "/a/b/c.txt"),不适用于 URL 字符串
public extension DyWrapper where Base == String {
    /// 返回路径的最后一个组件
    ///
    /// - Example:
    ///   ```swift
    ///   "/user/docs/file.txt".dy.lastPathComponent // "file.txt"
    ///   "/".dy.lastPathComponent                     // "/"
    ///   ```
    var lastPathComponent: String {
        (base as NSString).lastPathComponent
    }

    /// 返回路径的扩展名(不含前导点)
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy.pathExtension     // "txt"
    ///   "/file.tar.gz".dy.pathExtension  // "gz"
    ///   "/file".dy.pathExtension         // ""
    ///   ```
    var pathExtension: String {
        (base as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c".dy.deletingLastPathComponent // "/a/b"
    ///   "/a".dy.deletingLastPathComponent     // "/"
    ///   ```
    var deletingLastPathComponent: String {
        (base as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展名后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy.deletingPathExtension // "/file"
    ///   "/file".dy.deletingPathExtension     // "/file"
    ///   ```
    var deletingPathExtension: String {
        (base as NSString).deletingPathExtension
    }

    /// 返回路径的所有组件数组(包含根目录 "/")
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c.txt".dy.pathComponents // ["/", "a", "b", "c.txt"]
    ///   ```
    var pathComponents: [String] {
        (base as NSString).pathComponents
    }

    /// 在当前路径后追加一个路径组件,自动处理路径分隔符
    ///
    /// - Parameter component: 要追加的路径组件(不应以 `/` 开头)
    /// - Returns: 拼接后的新路径字符串
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b".dy.appendingPathComponent("c.txt") // "/a/b/c.txt"
    ///   ```
    func appendingPathComponent(_ component: String) -> String {
        (base as NSString).appendingPathComponent(component)
    }

    /// 为当前路径添加扩展名(自动添加前导点)
    ///
    /// - Parameter ext: 扩展名(不应包含点)
    /// - Returns: 添加扩展名后的新路径;若原路径为空或为绝对根路径,则可能返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   "file".dy.appendingPathExtension("txt") // "file.txt"
    ///   ```
    func appendingPathExtension(_ ext: String) -> String? {
        (base as NSString).appendingPathExtension(ext)
    }

    /// 返回将 `~` 展开为用户主目录后的路径字符串
    var expandingTildeInPath: String {
        (base as NSString).expandingTildeInPath
    }
}
