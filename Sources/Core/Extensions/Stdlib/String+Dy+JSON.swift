import Foundation

// MARK: - JSON
public extension String {
    /// 将字符串解析为 JSON 并格式化输出(美化缩进)
    /// - Note: 同时将 JSON 中的转义斜杠 `\/` 替换为 `/`
    /// - Returns: `成功`:格式化后的JSON字符串 `失败`:返回原字符串
    func dy_format() -> String {
        guard let data = self.dy_toData() else { return self }

        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]
            )
            return String(data: prettyData, encoding: .utf8)?
                .replacingOccurrences(of: "\\/", with: "/") ?? self
        } catch {
            return self
        }
    }
}
