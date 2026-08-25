import Foundation
import os.log

/// 沙盒路径管理工具
public final class DyPath {
    /// 应用主目录路径
    public let homeDirPath: String = NSHomeDirectory()
    /// 临时目录路径
    public let tempDirPath: String = NSTemporaryDirectory()

    /// `Documents` 目录路径(用于用户可见文件,会被 iCloud 备份)
    public lazy var documentsDirPath = Self.resolvePath(.documentDirectory)
    /// `Library` 目录路径
    public lazy var libraryDirPath = Self.resolvePath(.libraryDirectory)
    /// `Caches` 目录路径(用于可再生缓存,系统可能清除)
    public lazy var cachesDirPath = Self.resolvePath(.cachesDirectory)
    /// `Application Support` 目录路径(用于应用支持文件,会被备份)
    public lazy var applicationSupportDirPath = Self.resolvePath(.applicationSupportDirectory)

    /// `Documents` 目录 URL
    public lazy var documentsDirURL = Self.resolveURL(.documentDirectory)
    /// `Library` 目录 URL
    public lazy var libraryDirURL = Self.resolveURL(.libraryDirectory)
    /// `Caches` 目录 URL
    public lazy var cachesDirURL = Self.resolveURL(.cachesDirectory)
    /// `Application Support` 目录 URL
    public lazy var applicationSupportDirURL = Self.resolveURL(.applicationSupportDirectory)

    public static let shared = DyPath()
    private init() {}
}

// MARK: - 工具
public extension DyPath {
    /// 解析路径字符串
    /// - Parameter directory: `SearchPathDirectory`枚举
    /// - Returns: 路径字符串
    static func resolvePath(_ directory: FileManager.SearchPathDirectory) -> String {
        NSSearchPathForDirectoriesInDomains(directory, .userDomainMask, true).first ?? NSHomeDirectory()
    }

    /// 解析路径`URL`
    /// - Parameter directory: `SearchPathDirectory`枚举
    /// - Returns: 路径`URL`
    static func resolveURL(_ directory: FileManager.SearchPathDirectory) -> URL {
        FileManager.default.urls(for: directory, in: .userDomainMask).first ?? URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
    }
}

// MARK: - 路径构建
public extension DyPath {
    /// 在 `Documents` 目录下构建完整路径
    /// - Parameter relativePath: 相对路径组件(如 `"data/file.txt"`)
    /// - Returns: 绝对路径字符串
    /// - Note: 仅做路径拼接，**不会**创建父目录。如需写入文件请先调用 `createParentDirectoryIfNeeded(at:)` 或 `createFile(at:)`。
    func path(inDocuments relativePath: String) -> String {
        buildPath(in: documentsDirPath, relativePath: relativePath)
    }

    /// 在 `Library` 目录下构建完整路径
    func path(inLibrary relativePath: String) -> String {
        buildPath(in: libraryDirPath, relativePath: relativePath)
    }

    /// 在 `Caches` 目录下构建完整路径
    func path(inCaches relativePath: String) -> String {
        buildPath(in: cachesDirPath, relativePath: relativePath)
    }

    /// 在 `Application Support` 目录下构建完整路径
    func path(inApplicationSupport relativePath: String) -> String {
        buildPath(in: applicationSupportDirPath, relativePath: relativePath)
    }

    /// 在临时目录下构建完整路径
    func path(inTemp relativePath: String) -> String {
        buildPath(in: tempDirPath, relativePath: relativePath)
    }

    /// 内部通用路径拼接
    /// - Note: 路径构建属于纯计算，不做任何 I/O（如创建目录），以保持 String 与 URL 两类方法行为一致。
    private func buildPath(in base: String, relativePath: String) -> String {
        (base as NSString).appendingPathComponent(relativePath)
    }
}

// MARK: - URL构建
public extension DyPath {
    /// 在 `Documents` 目录下构建文件 URL
    /// - Parameter relativePath: 相对路径组件
    /// - Returns: 文件 URL
    func url(inDocuments relativePath: String) -> URL {
        documentsDirURL.appendingPathComponent(relativePath)
    }

    /// 在 `Library` 目录下构建文件 URL
    func url(inLibrary relativePath: String) -> URL {
        libraryDirURL.appendingPathComponent(relativePath)
    }

    /// 在 `Caches` 目录下构建文件 URL
    func url(inCaches relativePath: String) -> URL {
        cachesDirURL.appendingPathComponent(relativePath)
    }

    /// 在 `Application Support` 目录下构建文件 URL
    /// - Parameter relativePath: 相对路径组件
    /// - Returns: 文件 URL
    /// - Note: 仅做路径拼接，**不会**创建父目录。写入前请先调用 `createParentDirectoryIfNeeded(at:)`。
    func url(inApplicationSupport relativePath: String) -> URL {
        applicationSupportDirURL.appendingPathComponent(relativePath)
    }

    /// 在临时目录下构建文件 URL
    func url(inTemp relativePath: String) -> URL {
        if #available(iOS 16.0, *) {
            let tempDirUrl = URL(filePath: tempDirPath, directoryHint: .isDirectory)
            return tempDirUrl.appendingPathComponent(relativePath)
        } else {
            let tempDirUrl = URL(fileURLWithPath: tempDirPath, isDirectory: true)
            return tempDirUrl.appendingPathComponent(relativePath)
        }
    }
}

// MARK: - 文件操作
public extension DyPath {
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
                os_log(.error, "DyPath: 创建目录失败 %{public}@: %{public}@", parentDir, error.localizedDescription)
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
            os_log(.error, "DyPath: 删除失败 %{public}@: %{public}@", path, error.localizedDescription)
            return false
        }
    }
}
