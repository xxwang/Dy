import Foundation

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
