import Foundation

// MARK: - 属性
public extension URLRequest {
    /// 将 `URLRequest` 转换为安全的、可执行的 `cURL` 命令字符串
    ///
    /// - Returns: 可直接在终端运行的 `cURL` 命令;若 URL 无效则返回空字符串
    ///
    /// - Important:
    ///   - 自动转义 header 和 body 中的特殊字符,防止 shell 注入
    ///   - 二进制 body 会显示警告并跳过
    ///   - Cookie 头会转换为 `-b` 参数
    ///
    /// - Example:
    ///   ```swift
    ///   var request = URLRequest(url: URL(string: "https://httpbin.org/post")!)
    ///   request.httpMethod = "POST"
    ///   request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    ///   request.httpBody = #"{"name": "Alice's \"quote\""}"#.data(using: .utf8)
    ///   print(request.dy_cURL)
    ///   ```
    var dy_cURL: String {
        guard let url = self.url else { return "" }

        var parts: [String] = []

        // 基础命令 + URL(URL 用双引号包裹更安全)
        var base = "curl"
        if self.httpMethod == "HEAD" {
            base += " --head"
        }
        // 对 URL 进行最小转义：空格和特殊字符用双引号包裹
        let urlStr = url.absoluteString.contains(" ") ? "\"\(url.absoluteString)\"" : url.absoluteString
        parts.append(base)
        parts.append(urlStr)

        // HTTP 方法(非 GET/HEAD)
        if let method = self.httpMethod, method != "GET", method != "HEAD" {
            parts.append("-X \(method)")
        }

        // Headers(排除 Cookie)
        var cookies: [String] = []
        if let headers = self.allHTTPHeaderFields {
            for (key, value) in headers {
                if key.lowercased() == "cookie" {
                    cookies.append(value)
                } else {
                    let header = "\(key):\(value)"
                    parts.append("-H \(header.dy_shellEscaped)")
                }
            }
        }

        // Cookies
        if !cookies.isEmpty {
            let cookieString = cookies.joined(separator: "; ")
            parts.append("-b \(cookieString.dy_shellEscaped)")
        }

        // HTTP Body
        if let bodyData = self.httpBody {
            // 尝试作为 UTF-8 文本
            if let bodyString = String(data: bodyData, encoding: .utf8) {
                // 检查是否为表单数据(避免双重编码)
                let isForm = self.value(forHTTPHeaderField: "Content-Type")?
                    .lowercased()
                    .hasPrefix("application/x-www-form-urlencoded") == true

                if isForm {
                    // 表单数据：使用 --data-urlencode 不合适,直接 -d(已转义)
                    parts.append("--data-raw \(bodyString.dy_shellEscaped)")
                } else {
                    // 普通文本/JSON：使用 --data-raw 避免 cURL 自动设置 Content-Type
                    parts.append("--data-raw \(bodyString.dy_shellEscaped)")
                }
            } else {
                // 二进制数据：无法安全表示,提示警告
                parts.append("# WARNING: Binary body (omitted for safety)")
            }
        }

        // 格式化输出(每部分一行,用 \ 换行)
        return parts.joined(separator: " \\\n\t")
    }
}

// MARK: - 构造方法
public extension URLRequest {
    /// 使用 URL 字符串安全初始化 `URLRequest`
    ///
    /// - Parameter string: URL 字符串
    /// - Returns: 成功返回 `URLRequest`,否则返回 `nil`
    init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }
}
