import Foundation
import os.log

// MARK: - 文件系统操作
public extension String {
    /// 删除指定路径的文件或目录
    ///
    /// - Returns: 成功删除或路径不存在时返回 `true`;删除失败返回 `false`
    ///
    /// - Note: 若路径不存在,视为"已删除",返回 `true`
    func dy_deleteFileOrDirectory() -> Bool {
        guard FileManager.default.fileExists(atPath: self) else { return true }
        do {
            try FileManager.default.removeItem(atPath: self)
            return true
        } catch {
            #if DEBUG
                os_log(.error, "⚠️ 删除失败 [%{public}@]: %{public}@", self, error.localizedDescription)
            #endif
            return false
        }
    }

    /// 创建多级目录(确保父目录存在)
    ///
    /// - Parameter basePath: 基础路径,默认为当前用户主目录(`NSHomeDirectory()`)
    /// - Returns: 是否成功创建目录(若已存在也返回 `true`)
    ///
    /// - Example:
    ///   ```swift
    ///   "Documents/MyApp/Cache".dy_createDirectories()
    ///   ```
    func dy_createDirectories(in basePath: String = NSHomeDirectory()) -> Bool {
        let fullPath: String = if self.starts(with: "/") || self.starts(with: "~") {
            // 绝对路径或用户路径,直接使用
            self.replacingOccurrences(of: "~", with: NSHomeDirectory())
        } else {
            // 相对路径,拼接到 basePath
            (basePath as NSString).appendingPathComponent(self)
        }

        // 如果路径以 "/" 结尾,视为目录;否则取其父目录
        let directoryPath: String = if fullPath.hasSuffix("/") {
            fullPath
        } else {
            (fullPath as NSString).deletingLastPathComponent
        }

        // 确保目录存在
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(
                    atPath: directoryPath,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                return true
            } catch {
                #if DEBUG
                    os_log(.error, "⚠️ 创建目录失败 [%{public}@]: %{public}@", directoryPath, error.localizedDescription)
                #endif
                return false
            }
        }
        return true
    }
}
