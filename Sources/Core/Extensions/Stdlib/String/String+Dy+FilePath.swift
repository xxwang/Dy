import Foundation

// MARK: - 文件路径基础操作(基于 NSString 的 POSIX 路径处理)
/// 提供与 `NSString` 路径 API 对应的 Swift 风格扩展
/// 这些方法适用于标准 POSIX 路径(如 "/a/b/c.txt"),不适用于 URL 字符串
public extension String {
    /// 返回路径的最后一个组件
    ///
    /// - Example:
    ///   ```swift
    ///   "/user/docs/file.txt".dy_lastPathComponent // "file.txt"
    ///   "/".dy_lastPathComponent                     // "/"
    ///   ```
    var dy_lastPathComponent: String {
        (self as NSString).lastPathComponent
    }

    /// 返回路径的扩展名(不含前导点)
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy_pathExtension     // "txt"
    ///   "/file.tar.gz".dy_pathExtension  // "gz"
    ///   "/file".dy_pathExtension         // ""
    ///   ```
    var dy_pathExtension: String {
        (self as NSString).pathExtension
    }

    /// 返回删除最后一个路径组件后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c".dy_deletingLastPathComponent // "/a/b"
    ///   "/a".dy_deletingLastPathComponent     // "/"
    ///   ```
    var dy_deletingLastPathComponent: String {
        (self as NSString).deletingLastPathComponent
    }

    /// 返回删除路径扩展名后的路径
    ///
    /// - Example:
    ///   ```swift
    ///   "/file.txt".dy_deletingPathExtension // "/file"
    ///   "/file".dy_deletingPathExtension     // "/file"
    ///   ```
    var dy_deletingPathExtension: String {
        (self as NSString).deletingPathExtension
    }

    /// 返回路径的所有组件数组(包含根目录 "/")
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b/c.txt".dy_pathComponents // ["/", "a", "b", "c.txt"]
    ///   ```
    var dy_pathComponents: [String] {
        (self as NSString).pathComponents
    }

    /// 在当前路径后追加一个路径组件,自动处理路径分隔符
    ///
    /// - Parameter component: 要追加的路径组件(不应以 `/` 开头)
    /// - Returns: 拼接后的新路径字符串
    ///
    /// - Example:
    ///   ```swift
    ///   "/a/b".dy_appendingPathComponent("c.txt") // "/a/b/c.txt"
    ///   ```
    func dy_appendingPathComponent(_ component: String) -> String {
        (self as NSString).appendingPathComponent(component)
    }

    /// 为当前路径添加扩展名(自动添加前导点)
    ///
    /// - Parameter ext: 扩展名(不应包含点)
    /// - Returns: 添加扩展名后的新路径;若原路径为空或为绝对根路径,则可能返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   "file".dy_appendingPathExtension("txt") // "file.txt"
    ///   ```
    func dy_appendingPathExtension(_ ext: String) -> String? {
        (self as NSString).appendingPathExtension(ext)
    }

    /// 返回将 `~` 展开为用户主目录后的路径字符串
    var dy_expandingTildeInPath: String {
        (self as NSString).expandingTildeInPath
    }
}
