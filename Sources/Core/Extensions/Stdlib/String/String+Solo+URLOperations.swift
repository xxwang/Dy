import Foundation

// MARK: - URL 操作扩展
public extension SoloWrapper where Base == String {
    /// 将字符串转义为 POSIX shell 安全的单引号形式
    /// 规则：用单引号包裹,内部单引号用 '\'' 转义
    var shellEscaped: String {
        // 替换每个 ' 为 '\''
        let escaped = base.replacingOccurrences(of: "'", with: "'\\''")
        return "'\(escaped)'"
    }

    /// 从字符串中提取所有有效的 URL 链接
    ///
    /// 使用系统 `NSDataDetector` 自动识别文本中的超链接(包括 http/https 等)
    /// 返回 `URL` 对象数组,保留原始编码信息,便于后续安全操作
    ///
    /// - Returns: 所有匹配到的 `URL` 对象数组;若无匹配,返回空数组 `[]`
    ///
    /// - Example:
    ///   ```swift
    ///   let text = "Visit https://apple.com or mailto:support@example.com"
    ///   let urls = text.solo.urls
    ///   print(urls.map { $0.absoluteString }) // ["https://apple.com", "mailto:support@example.com"]
    ///   ```
    var urls: [URL] {
        // NSDataDetector 是轻量级的,每次创建开销小,且线程安全
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return [] // 极罕见情况,返回空数组比崩溃更安全
        }

        let range = NSRange(location: 0, length: base.utf16.count)
        let matches = detector.matches(in: base, options: [], range: range)

        return matches.compactMap { result in
            result.url // 自动过滤 nil
        }
    }

    /// 解析当前字符串作为 URL 的查询参数(query string),返回每个键对应的所有值
    ///
    /// - 自动对 percent-encoded 的键和值进行解码(如 `%20` → 空格)
    /// - 支持重复键(如 `?tag=a&tag=b` → `["tag": ["a", "b"]]`)
    /// - 若字符串不是有效 URL 或无查询参数,返回空字典
    ///
    /// - Returns: `[String: [String]]`,每个键对应一个字符串数组(至少包含一个元素)
    ///
    /// - Example:
    ///   ```swift
    ///   let url = "https://example.com?name=John%20Doe&hobby=reading&hobby=coding"
    ///   let params = url.solo.queryParameters
    ///   print(params["name"] ?? [])      // ["John Doe"]
    ///   print(params["hobby"] ?? [])     // ["reading", "coding"]
    ///   ```
    var queryParameters: [String: [String]] {
        guard let components = URLComponents(string: base),
              let queryItems = components.queryItems,
              !queryItems.isEmpty
        else {
            return [:]
        }

        var parameters: [String: [String]] = [:]

        for item in queryItems {
            // 自动解码 percent-encoded 字符串
            let key = item.name.removingPercentEncoding ?? item.name
            let value = item.value?.removingPercentEncoding ?? ""

            if var existing = parameters[key] {
                existing.append(value)
                parameters[key] = existing
            } else {
                parameters[key] = [value]
            }
        }

        return parameters
    }

    /// 解析查询参数,仅保留每个键的第一个值(忽略重复键)
    ///
    /// - 适用于大多数简单场景(如表单提交)
    /// - 同样会自动解码 percent-encoded 内容
    ///
    /// - Returns: `[String: String]`,每个键对应第一个出现的值
    ///
    /// - Example:
    ///   ```swift
    ///   let url = "https://example.com?name=Alice&name=Bob"
    ///   let firstParams = url.solo.firstQueryParameters
    ///   print(firstParams["name"] ?? "") // "Alice"
    ///   ```
    var firstQueryParameters: [String: String] {
        let multiParams = self.queryParameters
        var singleParams: [String: String] = [:]
        for (key, values) in multiParams {
            singleParams[key] = values.first ?? ""
        }
        return singleParams
    }
}
