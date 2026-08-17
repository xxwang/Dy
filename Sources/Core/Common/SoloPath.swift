import Foundation
import os.log

/// 沙盒路径管理工具
public final class SoloPath: Sendable {
    /// 应用主目录路径
    public let homePath: String = NSHomeDirectory()

    /// 临时目录路径
    public let tempPath: String = NSTemporaryDirectory()

    public static let shared = SoloPath()
    private init() {}
}

// MARK: - 目录路径
public extension SoloPath {
    /// `Documents` 目录路径(用于用户可见文件,会被 iCloud 备份)
    var documentsPath: String {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {
            assertionFailure("Failed to resolve Documents directory")
            return homePath
        }
        return path
    }

    /// `Library` 目录路径
    var libraryPath: String {
        guard let path = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first else {
            assertionFailure("Failed to resolve Library directory")
            return homePath
        }
        return path
    }

    /// `Caches` 目录路径(用于可再生缓存,系统可能清除)
    var cachesPath: String {
        guard let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            assertionFailure("Failed to resolve Caches directory")
            return homePath
        }
        return path
    }

    /// `Application Support` 目录路径(用于应用支持文件,会被备份)
    var applicationSupportPath: String {
        guard let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first else {
            assertionFailure("Failed to resolve Application Support directory")
            return homePath
        }
        return path
    }
}

// MARK: - 目录URL
public extension SoloPath {
    /// `Documents` 目录 URL
    var documentsURL: URL {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            assertionFailure("Cannot resolve Documents directory.")
            return URL(fileURLWithPath: documentsPath)
        }
        return url
    }

    /// `Library` 目录 URL
    var libraryURL: URL {
        guard let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            assertionFailure("Cannot resolve Library directory.")
            return URL(fileURLWithPath: libraryPath)
        }
        return url
    }

    /// `Caches` 目录 URL
    var cachesURL: URL {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            assertionFailure("Cannot resolve Caches directory.")
            return URL(fileURLWithPath: cachesPath)
        }
        return url
    }

    /// `Application Support` 目录 URL
    var applicationSupportURL: URL {
        guard let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            assertionFailure("Cannot resolve Application Support directory.")
            return URL(fileURLWithPath: applicationSupportPath)
        }
        return url
    }

    /// 临时目录 URL
    var tempURL: URL {
        URL(fileURLWithPath: tempPath, isDirectory: true)
    }
}

// MARK: - 路径构建
public extension SoloPath {
    /// 在 `Documents` 目录下构建完整路径
    /// - Parameter relativePath: 相对路径组件(如 `"data/file.txt"`)
    /// - Returns: 绝对路径字符串
    /// - Note: 仅做路径拼接，**不会**创建父目录。如需写入文件请先调用 `createParentDirectoryIfNeeded(at:)` 或 `createFile(at:)`。
    func path(inDocuments relativePath: String) -> String {
        buildPath(in: documentsPath, relativePath: relativePath)
    }

    /// 在 `Library` 目录下构建完整路径
    func path(inLibrary relativePath: String) -> String {
        buildPath(in: libraryPath, relativePath: relativePath)
    }

    /// 在 `Caches` 目录下构建完整路径
    func path(inCaches relativePath: String) -> String {
        buildPath(in: cachesPath, relativePath: relativePath)
    }

    /// 在 `Application Support` 目录下构建完整路径
    func path(inApplicationSupport relativePath: String) -> String {
        buildPath(in: applicationSupportPath, relativePath: relativePath)
    }

    /// 在临时目录下构建完整路径
    func path(inTemp relativePath: String) -> String {
        buildPath(in: tempPath, relativePath: relativePath)
    }

    /// 内部通用路径拼接
    /// - Note: 路径构建属于纯计算，不做任何 I/O（如创建目录），以保持 String 与 URL 两类方法行为一致。
    private func buildPath(in base: String, relativePath: String) -> String {
        (base as NSString).appendingPathComponent(relativePath)
    }
}

// MARK: - URL构建
public extension SoloPath {
    /// 在 `Documents` 目录下构建文件 URL
    /// - Parameter relativePath: 相对路径组件
    /// - Returns: 文件 URL
    func url(inDocuments relativePath: String) -> URL {
        documentsURL.appendingPathComponent(relativePath)
    }

    /// 在 `Library` 目录下构建文件 URL
    func url(inLibrary relativePath: String) -> URL {
        libraryURL.appendingPathComponent(relativePath)
    }

    /// 在 `Caches` 目录下构建文件 URL
    func url(inCaches relativePath: String) -> URL {
        cachesURL.appendingPathComponent(relativePath)
    }

    /// 在 `Application Support` 目录下构建文件 URL
    /// - Parameter relativePath: 相对路径组件
    /// - Returns: 文件 URL
    /// - Note: 仅做路径拼接，**不会**创建父目录。写入前请先调用 `createParentDirectoryIfNeeded(at:)`。
    func url(inApplicationSupport relativePath: String) -> URL {
        applicationSupportURL.appendingPathComponent(relativePath)
    }

    /// 在临时目录下构建文件 URL
    func url(inTemp relativePath: String) -> URL {
        tempURL.appendingPathComponent(relativePath)
    }
}

// MARK: - 文件操作
public extension SoloPath {
    /// 确保路径的父目录存在(若不存在则创建)
    /// - Parameter filePath: 文件完整路径(用于提取父目录)
    /// - Returns: 是否成功(已存在或创建成功)
    @discardableResult
    func createParentDirectoryIfNeeded(at filePath: String) -> Bool {
        let parentDir = (filePath as NSString).deletingLastPathComponent
        if !FileManager.default.fileExists(atPath: parentDir) {
            do {
                try FileManager.default.createDirectory(
                    atPath: parentDir,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                return true
            } catch {
                os_log(.error, "SoloPath: 创建目录失败 %{public}@: %{public}@", parentDir, error.localizedDescription)
                return false
            }
        }
        return true
    }

    /// 创建空文件(自动创建父目录)
    /// - Parameter path: 文件完整路径
    /// - Returns: 是否创建成功
    @discardableResult
    func createFile(at path: String) -> Bool {
        createParentDirectoryIfNeeded(at: path)
        return FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
    }

    /// 检查路径是否存在
    /// - Parameter path: 文件或目录路径
    /// - Returns: 是否存在
    func exists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path)
    }

    /// 删除文件或目录
    /// - Parameter path: 路径
    /// - Returns: 是否删除成功
    @discardableResult
    func remove(at path: String) -> Bool {
        if !exists(at: path) {
            return true
        }
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            os_log(.error, "SoloPath: 删除失败 %{public}@: %{public}@", path, error.localizedDescription)
            return false
        }
    }
}
