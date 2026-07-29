import Foundation

// MARK: - 用于读写 plist 文件的工具类
public final class DyPlist: @unchecked Sendable {
    /// 全局共享实例
    public static let shared = DyPlist()

    /// 私有初始化,确保单例
    private init() {}
}

// MARK: - 读写
public extension DyPlist {
    /// 从`URL`指向的`.plist`文件中读取数据
    /// - Parameter url: 指向`.plist`文件地址
    /// - Returns: `Any?`
    func read(from url: URL) -> Any? {
        guard url.pathExtension.lowercased() == "plist",
              FileManager.default.fileExists(atPath: url.path),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        var format = PropertyListSerialization.PropertyListFormat.xml
        return try? PropertyListSerialization.propertyList(
            from: data,
            options: .mutableContainersAndLeaves,
            format: &format
        )
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

        guard let plistData = try? PropertyListSerialization.data(
            fromPropertyList: data,
            format: .xml,
            options: 0
        ) else { return false }

        return (try? plistData.write(to: url, options: .atomic)) != nil
    }
}

// MARK: - 工具
public extension DyPlist {
    /// 验证数据是否是合格的`.plist`支持的数据
    /// - Parameter data: 数据
    /// - Returns: `Bool`
    func isValid(_ data: Any) -> Bool {
        return PropertyListSerialization.propertyList(data, isValidFor: .xml)
    }
}
