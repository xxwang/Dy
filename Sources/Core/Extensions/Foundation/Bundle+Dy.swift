import StoreKit
import UIKit

// MARK: - 属性-基础信息(Info.plist)
public extension Bundle {
    /// 获取应用的版本号(CFBundleShortVersionString)
    /// - Returns: 例如 "2.1.0";若未设置则返回空字符串
    static var dy_appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    }

    /// 获取应用的构建版本号(CFBundleVersion)
    /// - Returns: 例如 "123";若未设置则返回空字符串
    static var dy_buildVersion: String {
        Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String ?? ""
    }

    /// 获取应用的 Bundle Identifier(如 com.example.MyApp)
    /// - Returns: 若未设置则返回空字符串
    static var dy_identifier: String {
        Bundle.main.bundleIdentifier ?? ""
    }

    /// 获取应用的可执行文件名(CFBundleExecutable),通常与 target 名相同
    /// - Returns: 例如 "MyApp";若未设置则返回空字符串
    static var dy_namespace: String {
        Bundle.main.infoDictionary?["CFBundleExecutable"] as? String ?? ""
    }

    /// 获取应用的可执行文件名(通过 kCFBundleExecutableKey)
    /// - Returns: 与 `namespace` 相同,保留以兼容旧逻辑
    static var dy_executableName: String {
        Bundle.main.infoDictionary?[kCFBundleExecutableKey as String] as? String ?? ""
    }

    /// 获取应用的Bundle 名称(通过 kCFBundleNameKey)
    /// - 注意：不同于 Display Name,这是工程中的基础名称
    /// - Returns: 例如 "MyApp";若未设置则返回空字符串
    static var dy_name: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    }

    /// 获取应用的显示名称(CFBundleDisplayName)
    /// - 如果未设置,则回退到 `name`
    /// - Returns: 用户在设备上看到的应用名称
    static var dy_displayName: String {
        (Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String) ?? self.dy_name
    }

    // MARK: 本地化与设备环境信息

    /// 获取应用支持的本地化语言列表(CFBundleLocalizations)
    /// - 注意：该字段在 Info.plist 中应为数组(Array of Strings)
    /// - Returns: 例如 ["en", "zh-Hans"];若未配置则返回空数组
    static var dy_localizations: [String] {
        (Bundle.main.infoDictionary?[String(kCFBundleLocalizationsKey)] as? [String]) ?? []
    }

    /// 生成一个自定义 User-Agent 字符串,用于网络请求标识
    /// - Example:
    ///   MyApp/2.1.0 (com.example.MyApp; Build/123; iPhone; iOS/17.5)
    /// - Returns: 符合常规格式的 User-Agent 字符串
    static var dy_userAgent: String {
        let appName = self.dy_displayName.replacingOccurrences(of: " ", with: "_")
        let bundleID = self.dy_identifier
        let appVersion = self.dy_appVersion
        let build = self.dy_buildVersion

        // 获取设备类型描述(如 "iPhone", "iPad")
        let deviceModel = UIDevice.current.model.replacingOccurrences(of: " ", with: "_")

        let system = "\(UIDevice.current.systemName)/\(UIDevice.current.systemVersion)"

        return "\(appName)/\(appVersion) (\(bundleID); Build/\(build); \(deviceModel); \(system))"
    }
}

// MARK: - Bundle 方法扩展：资源路径与图标获取
public extension Bundle {
    /// 获取 Bundle 中指定资源文件的本地路径
    /// - Parameters:
    ///   - fileName: 资源文件名(不含扩展名),可为 nil(用于无名资源)
    ///   - fileExtension: 文件扩展名(如 "json", "png"),可为 nil
    /// - Returns: 文件的绝对路径字符串;若未找到则返回 nil
    static func dy_filePath(for fileName: String?, with fileExtension: String? = nil) -> String? {
        Bundle.main.path(forResource: fileName, ofType: fileExtension)
    }

    /// 获取 Bundle 中指定资源文件的 URL
    /// - Parameters:
    ///   - fileName: 资源文件名(不含扩展名)
    ///   - fileExtension: 文件扩展名
    /// - Returns: 文件的 URL;若未找到则返回 nil
    static func dy_fileURL(for fileName: String?, with fileExtension: String? = nil) -> URL? {
        Bundle.main.url(forResource: fileName, withExtension: fileExtension)
    }

    /// 安全地获取主 App 图标文件名(不含扩展名)
    /// - Parameter bundle: 要查询的 Bundle,默认为主 Bundle
    /// - Returns: 图标文件名(如 "AppIcon60x60");若未配置图标则返回 nil
    /// - Note: 不会 crash,适合用于日志或调试
    static func dy_appIcon(in bundle: Bundle = .main) -> String? {
        guard
            let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last // 通常最后一个是最高的分辨率
        else {
            return nil
        }
        return lastIcon
    }
}
