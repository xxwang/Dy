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
public extension SoloWrapper where Base == String {
    /// 将当前字符串作为相对路径,解析为 Documents 目录下的绝对路径
    ///
    /// - Returns: 完整的文件系统路径字符串
    /// - Throws: 不会抛出错误,但若无法获取 Documents 目录会触发断言失败(仅调试模式)
    ///
    /// - Example:
    ///   ```swift
    ///   let path = "user_data.json".solo.pathInDocuments()
    ///   // → "/var/mobile/Containers/Data/Application/.../Documents/user_data.json"
    ///   ```
    func pathInDocuments() -> String {
        SoloPath.shared.path(inDocuments: base)
    }

    /// 将当前字符串作为相对路径,解析为 Caches 目录下的绝对路径
    ///
    /// - Caches 目录用于存放可再生的缓存数据,系统可能在存储空间不足时清除
    func pathInCaches() -> String {
        SoloPath.shared.path(inCaches: base)
    }

    /// 将当前字符串作为相对路径,解析为临时目录(tmp)下的绝对路径
    ///
    /// - 临时目录用于短期存储,应用重启后内容可能被清除
    func pathInTemporaryDirectory() -> String {
        SoloPath.shared.path(inTemp: base)
    }

    /// 将当前字符串作为相对路径,解析为 Application Support 目录下的绝对路径
    ///
    /// - Application Support 目录用于存放应用支持文件,`会被 iCloud 备份`
    /// - 首次使用时建议确保父目录存在(可通过 `FileManager` 创建)
    func pathInApplicationSupport() -> String {
        SoloPath.shared.path(inApplicationSupport: base)
    }
}

// MARK: - 沙盒路径解析：返回 URL
/// 返回对应沙盒目录中文件的 `URL`Apple 推荐使用 `URL` 而非 `String` 表示文件路径,
/// 因其能正确处理 Unicode、特殊字符、编码等问题
///
/// 这些是`计算属性`,因为 `URL` 构建过程稳定且无副作用(仅依赖当前字符串和系统目录)
public extension SoloWrapper where Base == String {
    /// Documents 目录中对应文件的 URL
    func urlInDocuments() -> URL {
        SoloPath.shared.url(inDocuments: base)
    }

    /// Caches 目录中对应文件的 URL
    func urlInCaches() -> URL {
        SoloPath.shared.url(inCaches: base)
    }

    /// 临时目录(tmp)中对应文件的 URL
    func urlInTemporary() -> URL {
        SoloPath.shared.url(inTemp: base)
    }

    /// Application Support 目录中对应文件的 URL
    func urlInApplicationSupport() -> URL {
        SoloPath.shared.url(inApplicationSupport: base)
    }
}
