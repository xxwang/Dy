import Foundation
import os.log

// MARK: - 字符串写入
public extension FileManager {
    /// 将字符串以 UTF-8 编码写入指定路径的文件(覆盖原内容)
    ///
    /// 如果目标路径包含 `～`,会自动展开为当前用户的主目录(如 `～/Documents` → `/Users/name/Documents`)
    /// 若目标目录不存在,写入会失败(不会自动创建父目录)
    ///
    /// - Parameters:
    ///   - string: 要写入的字符串内容
    ///   - path: 目标文件的路径(支持 `～`)
    /// - Returns: 成功写入返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_writeString(_ string: String, to path: String) -> Bool {
        self.solo_writeString(string, to: URL(fileURLWithPath: path))
    }

    /// 将字符串以 UTF-8 编码写入指定 URL 的文件(覆盖原内容)
    ///
    /// 该方法内部会自动展开路径中的 `～`(如果存在)
    /// 若目标目录不存在,写入会失败
    ///
    /// - Parameters:
    ///   - string: 要写入的字符串内容
    ///   - url: 目标文件的 URL
    /// - Returns: 成功写入返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_writeString(_ string: String, to url: URL) -> Bool {
        do {
            try string.write(to: url.solo_expandingTildeInUrl, atomically: true, encoding: .utf8)
            return true
        } catch {
            os_log(.error, "[Solo] FileManager writeString 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 在指定路径的文件末尾追加字符串内容(UTF-8 编码)
    ///
    /// 如果文件不存在,会先创建新文件并写入内容
    /// 路径中的 `～` 会被自动展开
    ///
    /// - Parameters:
    ///   - string: 要追加的字符串
    ///   - path: 目标文件路径(支持 `～`)
    /// - Returns: 成功追加返回 `true`,否则返回 `false`
    ///
    /// - Example:
    ///   ```swift
    ///   _ = FileManager.solo_appendString("New log entry\n", to: "～/Documents/app.log")
    ///   ```
    @discardableResult
    static func solo_appendString(_ string: String, to path: String) -> Bool {
        self.solo_appendString(string, to: URL(fileURLWithPath: path))
    }

    /// 在指定 URL 的文件末尾追加字符串内容(UTF-8 编码)
    ///
    /// 如果文件不存在,会先创建新文件并写入内容
    /// 内部自动处理 `～` 展开
    ///
    /// - Parameters:
    ///   - string: 要追加的字符串
    ///   - url: 目标文件 URL
    /// - Returns: 成功追加返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_appendString(_ string: String, to url: URL) -> Bool {
        let fullURL = url.solo_expandingTildeInUrl
        if !FileManager.default.fileExists(atPath: fullURL.path) {
            return self.solo_writeString(string, to: fullURL)
        }

        guard let data = string.data(using: .utf8) else { return false }

        do {
            let fileHandle = try FileHandle(forWritingTo: fullURL)
            defer { fileHandle.closeFile() }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            return true
        } catch {
            os_log(.error, "[Solo] FileManager appendString 失败: %{public}@", error.localizedDescription)
            return false
        }
    }
}

// MARK: - Data 写入
public extension FileManager {
    /// 将 `Data` 写入指定路径的文件(覆盖原内容)
    ///
    /// 路径中的 `～` 会被自动展开为用户主目录
    /// 不会自动创建父目录;若目录不存在,写入失败
    ///
    /// - Parameters:
    ///   - data: 要写入的二进制数据
    ///   - path: 目标文件路径(支持 `～`)
    /// - Returns: 成功写入返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_writeData(_ data: Data, to path: String) -> Bool {
        self.solo_writeData(data, to: URL(fileURLWithPath: path))
    }

    /// 将 `Data` 写入指定 URL 的文件(覆盖原内容)
    ///
    /// 内部自动展开路径中的 `～`
    ///
    /// - Parameters:
    ///   - data: 要写入的二进制数据
    ///   - url: 目标文件 URL
    /// - Returns: 成功写入返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_writeData(_ data: Data, to url: URL) -> Bool {
        do {
            try data.write(to: url.solo_expandingTildeInUrl, options: .atomic)
            return true
        } catch {
            os_log(.error, "[Solo] FileManager writeData 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 在指定路径的文件末尾追加 `Data`
    ///
    /// 如果文件不存在,会先创建新文件并写入数据
    /// 路径中的 `～` 会被自动展开
    ///
    /// - Parameters:
    ///   - data: 要追加的二进制数据
    ///   - path: 目标文件路径(支持 `～`)
    /// - Returns: 成功追加返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_appendData(_ data: Data, to path: String) -> Bool {
        self.solo_appendData(data, to: URL(fileURLWithPath: path))
    }

    /// 在指定 URL 的文件末尾追加 `Data`
    ///
    /// 如果文件不存在,会先创建新文件并写入数据
    /// 自动处理 `～` 展开
    ///
    /// - Parameters:
    ///   - data: 要追加的二进制数据
    ///   - url: 目标文件 URL
    /// - Returns: 成功追加返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_appendData(_ data: Data, to url: URL) -> Bool {
        let fullURL = url.solo_expandingTildeInUrl
        if !FileManager.default.fileExists(atPath: fullURL.path) {
            return self.solo_writeData(data, to: fullURL)
        }

        do {
            let fileHandle = try FileHandle(forWritingTo: fullURL)
            defer { fileHandle.closeFile() }
            fileHandle.seekToEndOfFile()
            fileHandle.write(data)
            return true
        } catch {
            os_log(.error, "[Solo] FileManager appendData 失败: %{public}@", error.localizedDescription)
            return false
        }
    }
}

// MARK: - 文件与目录操作
public extension FileManager {
    /// 文件属性结构体,封装常见文件元数据
    struct SoloFileAttributes {
        /// 文件字节大小
        public let size: UInt64
        /// 文件创建时间
        public let creationDate: Date
        /// 文件最后修改时间
        public let modificationDate: Date

        /// 从 `FileManager` 返回的属性字典初始化
        /// - Parameter attributes: 来自 `attributesOfItem(atPath:)` 的字典
        init?(attributes: [FileAttributeKey: Any]) {
            guard
                let size = attributes[.size] as? UInt64,
                let creationDate = attributes[.creationDate] as? Date,
                let modificationDate = attributes[.modificationDate] as? Date
            else { return nil }
            self.size = size
            self.creationDate = creationDate
            self.modificationDate = modificationDate
        }
    }

    /// 创建目录(包括中间缺失的父目录)
    ///
    /// 路径中的 `～` 会被自动展开
    ///
    /// - Parameter path: 要创建的目录路径(支持 `～`)
    /// - Returns: 成功创建返回 `true`,若目录已存在也返回 `true`;其他错误返回 `false`
    @discardableResult
    static func solo_createDirectory(at path: String) -> Bool {
        do {
            try FileManager.default.createDirectory(
                atPath: path.solo_expandingTildeInPath,
                withIntermediateDirectories: true,
                attributes: nil
            )
            return true
        } catch {
            os_log(.error, "[Solo] FileManager createDirectory 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 在指定路径创建一个新文件,并写入初始数据
    ///
    /// 路径中的 `～` 会被自动展开
    /// 注意：此方法`不会自动创建父目录`若父目录不存在,创建会失败
    ///
    /// - Parameters:
    ///   - path: 文件路径(支持 `～`)
    ///   - data: 初始文件内容(可为 `nil` 表示空文件)
    /// - Returns: 成功创建返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_createFile(at path: String, data: Data) -> Bool {
        FileManager.default.createFile(
            atPath: path.solo_expandingTildeInPath,
            contents: data,
            attributes: nil
        )
    }

    /// 复制文件或目录
    ///
    /// 源和目标路径中的 `～` 都会被自动展开
    /// 若目标已存在,操作会失败
    ///
    /// - Parameters:
    ///   - sourcePath: 源路径
    ///   - destinationPath: 目标路径
    /// - Returns: 成功复制返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_copyItem(from sourcePath: String, to destinationPath: String) -> Bool {
        do {
            try FileManager.default.copyItem(
                atPath: sourcePath.solo_expandingTildeInPath,
                toPath: destinationPath.solo_expandingTildeInPath
            )
            return true
        } catch {
            os_log(.error, "[Solo] FileManager copyItem 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 移动或重命名文件/目录
    ///
    /// 路径中的 `～` 会被自动展开
    ///
    /// - Parameters:
    ///   - sourcePath: 源路径
    ///   - destinationPath: 目标路径
    /// - Returns: 成功移动返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_moveItem(from sourcePath: String, to destinationPath: String) -> Bool {
        do {
            try FileManager.default.moveItem(
                atPath: sourcePath.solo_expandingTildeInPath,
                toPath: destinationPath.solo_expandingTildeInPath
            )
            return true
        } catch {
            os_log(.error, "[Solo] FileManager moveItem 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 删除指定路径的文件或目录
    ///
    /// 路径中的 `～` 会被自动展开
    /// 若路径不存在,操作会失败(返回 `false`)
    ///
    /// - Parameter path: 要删除的路径
    /// - Returns: 成功删除返回 `true`,否则返回 `false`
    @discardableResult
    static func solo_removeItem(at path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path.solo_expandingTildeInPath)
            return true
        } catch {
            os_log(.error, "[Solo] FileManager removeItem 失败: %{public}@", error.localizedDescription)
            return false
        }
    }

    /// 读取指定路径文件的全部内容为 `Data`
    ///
    /// - Parameter path: 文件路径(支持 `～`)
    /// - Returns: 成功时返回 `Data`,失败或文件不存在时返回 `nil`
    static func solo_contents(at path: String) -> Data? {
        FileManager.default.contents(atPath: path.solo_expandingTildeInPath)
    }

    /// 获取指定路径文件的属性(大小、创建时间、修改时间)
    ///
    /// - Parameter path: 文件路径(支持 `～`)
    /// - Returns: 成功时返回 `SoloFileAttributes` 实例,失败返回 `nil`
    static func solo_attributes(ofItemAt path: String) -> SoloFileAttributes? {
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: path.solo_expandingTildeInPath)
            return SoloFileAttributes(attributes: attributes)
        } catch {
            os_log(.error, "[Solo] FileManager attributes 失败: %{public}@", error.localizedDescription)
            return nil
        }
    }

    /// 检查指定路径是否存在文件或目录
    ///
    /// - Parameter path: 路径(支持 `～`)
    /// - Returns: 存在返回 `true`,否则返回 `false`
    static func solo_itemExists(at path: String) -> Bool {
        FileManager.default.fileExists(atPath: path.solo_expandingTildeInPath)
    }

    /// 检查指定路径是否为目录
    ///
    /// - Parameter path: 路径(支持 `～`)
    /// - Returns: 是目录且存在时返回 `true`,否则返回 `false`
    static func solo_isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = FileManager.default.fileExists(atPath: path.solo_expandingTildeInPath, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    /// 比较两个文件的内容是否完全相同
    ///
    /// - Parameters:
    ///   - path1: 第一个文件路径
    ///   - path2: 第二个文件路径
    /// - Returns: 内容完全一致返回 `true`,否则返回 `false`
    static func solo_contentsEqual(atPath path1: String, andPath path2: String) -> Bool {
        FileManager.default.contentsEqual(
            atPath: path1.solo_expandingTildeInPath,
            andPath: path2.solo_expandingTildeInPath
        )
    }

    /// 获取指定目录下的直接子项路径列表(不递归)
    ///
    /// 返回的是`绝对路径字符串数组`,每个路径都已展开 `～`
    ///
    /// - Parameter path: 目录路径(支持 `～`)
    /// - Returns: 子项路径列表,失败时返回空数组
    static func solo_contentsOfDirectory(at path: String) -> [String] {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: path.solo_expandingTildeInPath)
            let baseURL = URL(fileURLWithPath: path.solo_expandingTildeInPath)
            return items.map { baseURL.appendingPathComponent($0).path }
        } catch {
            os_log(.error, "[Solo] FileManager contentsOfDirectory 失败: %{public}@", error.localizedDescription)
            return []
        }
    }

    /// 递归获取指定目录下所有子项的路径(深度优先)
    ///
    /// 返回的是`绝对路径字符串数组`,每个路径都已展开 `～`
    ///
    /// - Parameter path: 目录路径(支持 `～`)
    /// - Returns: 所有子项路径列表,失败时返回空数组
    static func solo_recursiveContentsOfDirectory(at path: String) -> [String] {
        do {
            let subpaths = try FileManager.default.subpathsOfDirectory(atPath: path.solo_expandingTildeInPath)
            let baseURL = URL(fileURLWithPath: path.solo_expandingTildeInPath)
            return subpaths.map { baseURL.appendingPathComponent($0).path }
        } catch {
            os_log(.error, "[Solo] FileManager recursiveContentsOfDirectory 失败: %{public}@", error.localizedDescription)
            return []
        }
    }

    /// 将路径中的 `～` 展开为当前用户的主目录
    ///
    /// - Parameter path: 输入路径(如 `"～/Documents"`)
    /// - Returns: 展开后的绝对路径(如 `"/Users/name/Documents"`)
    static func solo_expandingTilde(in path: String) -> String {
        path.solo_expandingTildeInPath
    }

    /// 获取指定文件的字节大小
    ///
    /// - Parameter path: 文件路径(支持 `～`)
    /// - Returns: 文件大小(字节),若文件不存在或无法读取则返回 `0`
    static func solo_fileSize(at path: String) -> UInt64 {
        self.solo_attributes(ofItemAt: path)?.size ?? 0
    }

    /// 获取指定文件的创建日期
    ///
    /// - Parameter path: 文件路径(支持 `～`)
    /// - Returns: 创建日期,若失败返回 `nil`
    static func solo_fileCreationDate(at path: String) -> Date? {
        self.solo_attributes(ofItemAt: path)?.creationDate
    }
}
