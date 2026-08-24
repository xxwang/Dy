import AVFoundation
import os.log
import UIKit
import UniformTypeIdentifiers

// MARK: - 属性
public extension URL {
    /// 检测应用是否能打开此 URL(需在` Info.plist` 中声明 `LSApplicationQueriesSchemes`)
    /// - Returns: 能打开返回 `true`,否则 `false`
    /// - ⚠️ 注意：从 iOS 9 开始,只能查询已白名单的 `scheme`(如 "`mailto`", "`tel`" 等需提前注册)
    var solo_canOpen: Bool {
        UIApplication.shared.canOpenURL(self)
    }

    /// 判断是否为 HTTPS 协议
    var solo_isHTTPS: Bool {
        self.scheme?.lowercased() == "https"
    }

    /// 解析查询参数为字典(重复 key 时后者覆盖前者)
    var solo_parameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else { return nil }
        return Dictionary(
            queryItems.compactMap { item in
                guard let value = item.value else { return nil }
                return (item.name, value)
            },
            uniquingKeysWith: { _, new in new }
        )
    }

    /// 获取主机名(域名)
    var solo_hostName: String? {
        self.host
    }

    /// 获取文件名(最后一个路径组件)
    var solo_filename: String {
        self.lastPathComponent
    }

    /// 获取文件扩展名
    var solo_fileExtension: String? {
        self.pathExtension.isEmpty ? nil : self.pathExtension
    }

    /// 返回一个将路径中 `～` 展开后的 `URL`
    var solo_expandingTildeInUrl: URL {
        URL(fileURLWithPath: self.path.solo_expandingTildeInPath)
    }

    /// 获取 MIME 类型(支持 iOS 14+ 和降级方案)
    var solo_mimeType: String? {
        if #available(iOS 14.0, *) {
            let ext = self.pathExtension.lowercased()
            return UTType(filenameExtension: ext)?.preferredMIMEType
        } else {
            // iOS <14 手动映射常见扩展名
            let mimeMap: [String: String] = [
                "jpg": "image/jpeg", "jpeg": "image/jpeg",
                "png": "image/png", "gif": "image/gif",
                "pdf": "application/pdf",
                "txt": "text/plain",
                "mp4": "video/mp4", "mov": "video/quicktime",
                "mp3": "audio/mpeg", "wav": "audio/wav",
            ]
            return mimeMap[self.pathExtension.lowercased()]
        }
    }

    /// 将 URL 指向的内容读取为 Data(⚠️ 仅建议用于本地文件！网络 URL 会阻塞线程)
    /// - ⚠️ 警告：对网络 URL 调用会同步下载并阻塞当前线程,可能导致卡顿或崩溃
    ///   请仅用于 `isFileURL == true` 的场景
    var solo_data: Data? {
        guard self.isFileURL else {
            os_log(.error, "⚠️ Warning: data called on non-file URL. This may block the thread.")
            return nil
        }
        return try? Data(contentsOf: self)
    }

    /// 将 URL 字符串 Base64 编码
    var solo_base64Encoded: String? {
        self.absoluteString.data(using: .utf8)?.base64EncodedString()
    }

    /// 获取本地文件大小(仅适用于文件 URL)
    var solo_fileSize: Int64? {
        guard self.isFileURL else { return nil }
        let attrs = try? FileManager.default.attributesOfItem(atPath: self.path)
        return attrs?[.size] as? Int64
    }

    /// 返回 URL 各组件组成的字典
    var solo_components: [String: String?] {
        [
            "scheme": self.scheme,
            "host": self.host,
            "path": self.path,
            "query": self.query,
            "fragment": self.fragment,
        ]
    }

    /// 获取路径组件列表(过滤掉 "/")
    var solo_pathComponentsList: [String] {
        self.pathComponents.filter { $0 != "/" }
    }
}

// MARK: - 方法
public extension URL {
    /// 删除指定查询参数
    func solo_removeQueryParameter(for key: String) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        components.queryItems = components.queryItems?.filter { $0.name != key }
        return components.url ?? self
    }

    /// 追加查询参数(非 mutating 版本)
    func solo_appendParameters(_ parameters: [String: String]) -> URL {
        guard var components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }
        let newItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components.queryItems = (components.queryItems ?? []) + newItems
        return components.url ?? self
    }

    /// 追加查询参数(mutating 版本)
    mutating func solo_appendParameters(_ parameters: [String: String]) {
        self = self.solo_appendParameters(parameters)
    }

    /// 获取指定查询参数的值
    func solo_queryValue(for key: String) -> String? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .first { $0.name == key }?
            .value
    }

    /// 删除所有路径组件,保留 scheme + host
    func solo_deleteAllPathComponents() -> URL {
        guard let host = self.host, let scheme = self.scheme else {
            return self
        }
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components.url ?? self
    }

    /// 删除所有路径组件(mutating)
    mutating func solo_deleteAllPathComponents() {
        self = self.solo_deleteAllPathComponents()
    }

    /// 移除 scheme(返回 "example.com/path?..." 形式)
    /// - ⚠️ 不返回 URL 类型(因无 scheme 的字符串不是合法 URL),改为返回 String？
    ///   但为保持 API 一致,仍尝试构造 URL(可能失败)
    func solo_droppedScheme() -> URL? {
        guard let host = self.host else { return nil }
        var result = host
        if !self.path.isEmpty, self.path != "/" {
            result += self.path
        }
        if let query = self.query {
            result += "?\(query)"
        }
        if let fragment = self.fragment {
            result += "#\(fragment)"
        }
        return URL(string: result)
    }

    /// 从视频 URL 异步生成指定时间的缩略图
    /// - Parameter time: 时间(秒)
    /// - Returns: UIImage?(失败返回 nil)
    func solo_thumbnail(from time: Float64 = 0) async -> UIImage? {
        let asset = AVURLAsset(url: self)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true // 自动旋转修正

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)

        return await withCheckedContinuation { continuation in
            if #available(iOS 16.0, *) {
                generator.generateCGImageAsynchronously(for: cmTime) { cgImage, _, error in
                    if let cgImage, error == nil {
                        continuation.resume(returning: UIImage(cgImage: cgImage))
                    } else {
                        // 可选：打印错误日志
                        continuation.resume(returning: nil)
                    }
                }
            } else {
                var actualTime = CMTime.zero
                do {
                    let cgImage = try generator.copyCGImage(at: cmTime, actualTime: &actualTime)
                    continuation.resume(returning: UIImage(cgImage: cgImage))
                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }
    }

    /// 路径组件追加
    func solo_appendingPathComponent(_ path: String) -> URL {
        if #available(iOS 16.0, *) {
            return self.appending(component: path)
        } else {
            return self.appendingPathComponent(path)
        }
    }
}
