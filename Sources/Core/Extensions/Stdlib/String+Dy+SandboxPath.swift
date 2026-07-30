import Foundation

// MARK: - 沙盒路径解析：返回完整路径字符串(String)
/// 这些方法将当前字符串视为`相对于指定沙盒目录的子路径`,
/// 并解析为完整的文件系统路径(String)
///
/// ⚠️ 重要：
/// - `输入必须是相对路径`,例如 `"data.txt"` 或 `"subdir/config.json"`
/// - `不要传入包含目录前缀的路径`(如 `"Documents/data.txt"`),
///   否则会导致路径重复(如 `.../Documents/Documents/data.txt`)
/// - 这些是`方法`而非属性,因为结果依赖运行时环境(沙盒目录位置)
public extension String {
    /// 将当前字符串作为相对路径,解析为 Documents 目录下的绝对路径
    ///
    /// - Returns: 完整的文件系统路径字符串
    /// - Throws: 不会抛出错误,但若无法获取 Documents 目录会触发断言失败(仅调试模式)
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "user_data.json".dy_pathInDocuments()
    ///   // → "/var/mobile/Containers/Data/Application/.../Documents/user_data.json"
    ///   ```
    func dy_pathInDocuments() -> String {
        DyPath.shared.path(inDocuments: self)
    }

    /// 将当前字符串作为相对路径,解析为 Caches 目录下的绝对路径
    ///
    /// - Caches 目录用于存放可再生的缓存数据,系统可能在存储空间不足时清除
    func dy_pathInCaches() -> String {
        DyPath.shared.path(inCaches: self)
    }

    /// 将当前字符串作为相对路径,解析为临时目录(tmp)下的绝对路径
    ///
    /// - 临时目录用于短期存储,应用重启后内容可能被清除
    func dy_pathInTemporaryDirectory() -> String {
        DyPath.shared.path(inTemp: self)
    }

    /// 将当前字符串作为相对路径,解析为 Application Support 目录下的绝对路径
    ///
    /// - Application Support 目录用于存放应用支持文件,`会被 iCloud 备份`
    /// - 首次使用时建议确保父目录存在(可通过 `FileManager` 创建)
    func dy_pathInApplicationSupport() -> String {
        DyPath.shared.path(inApplicationSupport: self)
    }
}

// MARK: - 沙盒路径解析：返回 URL
/// 返回对应沙盒目录��文件的 `URL`Apple 推荐使用 `URL` 而非 `String` 表示文件路径,
/// 因其能正确处理 Unicode、特殊字符、编码等问题
///
/// 这些是`计算属性`,因为 `URL` 构建过程稳定且无副作用(仅依赖当前字符串和系统目录)
public extension String {
    /// Documents 目录中对应文件的 URL
    func dy_urlInDocuments() -> URL {
        DyPath.shared.url(inDocuments: self)
    }

    /// Caches 目录中对应文件的 URL
    func dy_urlInCaches() -> URL {
        DyPath.shared.url(inCaches: self)
    }

    /// 临时目录(tmp)中对应文件的 URL
    func dy_urlInTemporary() -> URL {
        DyPath.shared.url(inTemp: self)
    }

    /// Application Support 目录中对应文件的 URL
    func dy_urlInApplicationSupport() -> URL {
        DyPath.shared.url(inApplicationSupport: self)
    }
}
