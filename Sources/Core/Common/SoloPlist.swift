import Foundation
import os.log

// MARK: - 用于读写 plist 文件的工具类
public final class SoloPlist: Sendable {
    /// 全局共享实例
    public static let shared = SoloPlist()

    /// 私有初始化,确保单例
    private init() {}
}

// MARK: - 读写
public extension SoloPlist {
    /// 从`URL`指向的`.plist`文件中读取数据
    /// - Parameter url: 指向`.plist`文件地址
    /// - Returns: `Any?`
    func read(from url: URL) -> Any? {
        guard url.pathExtension.lowercased() == "plist",
              FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            os_log(.error, "[Solo] SoloPlist 读取文件失败: %{public}@", error.localizedDescription)
            return nil
        }

        var format = PropertyListSerialization.PropertyListFormat.xml
        do {
            return try PropertyListSerialization.propertyList(
                from: data,
                options: .mutableContainersAndLeaves,
                format: &format
            )
        } catch {
            os_log(.error, "[Solo] SoloPlist 解析失败: %{public}@", error.localizedDescription)
            return nil
        }
    }

    /// 写入数据到指定`url`中
    /// - Parameters:
    ///   - data: 要写入的数据
    ///   - url: 文件所在地址
    /// - Returns: 是否写入成功
    @discardableResult
    func write(_ data: Any, to url: URL) -> Bool {
        guard url.pathExtension.lowercased() == "plist",
              isValid(data)
        else {
            return false
        }

        let plistData: Data
        do {
            plistData = try PropertyListSerialization.data(
                fromPropertyList: data,
                format: .xml,
                options: 0
            )
        } catch {
            os_log(.error, "[Solo] SoloPlist 序列化失败: %{public}@", error.localizedDescription)
            return false
        }

        do {
            try plistData.write(to: url, options: .atomic)
            return true
        } catch {
            os_log(.error, "[Solo] SoloPlist 写入失败: %{public}@", error.localizedDescription)
            return false
        }
    }
}

// MARK: - 工具
public extension SoloPlist {
    /// 验证数据是否是合格的`.plist`支持的数据
    /// - Parameter data: 数据
    /// - Returns: `Bool`
    func isValid(_ data: Any) -> Bool {
        return PropertyListSerialization.propertyList(data, isValidFor: .xml)
    }
}
