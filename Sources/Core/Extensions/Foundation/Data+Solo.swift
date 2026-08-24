import UIKit

// MARK: - 属性
public extension Data {
    /// 根据文件头(Magic Number)推断资源的文件扩展名
    ///
    /// - Returns: 推断出的扩展名(如 `.png`, `.jpeg`),若无法识别或数据为空则返回 `.default`
    /// - Supported formats:
    ///   - PNG: `89 50 4E 47`
    ///   - JPEG: `FF D8`
    ///   - GIF: `47 49 46`
    ///   - TIFF: `49 49` (little-endian) 或 `4D 4D` (big-endian)
    /// - Example:
    ///   ```swift
    ///   let pngHeader = Data([0x89, 0x50, 0x4E, 0x47])
    ///   print(pngHeader.solo_extension)  // ".png"
    ///   ```
    var solo_extension: String {
        guard !self.isEmpty else { return ".default" }

        switch self[0] {
        case 0xFF where self.count >= 2 && self[1] == 0xD8:
            return ".jpeg"
        case 0x89 where self.count >= 4 && self[1] == 0x50 && self[2] == 0x4E && self[3] == 0x47:
            return ".png"
        case 0x47 where self.count >= 3 && self[1] == 0x49 && self[2] == 0x46:
            return ".gif"
        case 0x49 where self.count >= 2 && self[1] == 0x49: // "II" - little-endian TIFF
            return ".tiff"
        case 0x4D where self.count >= 2 && self[1] == 0x4D: // "MM" - big-endian TIFF
            return ".tiff"
        default:
            return ".default"
        }
    }
}

// MARK: - 类型转换
public extension Data {
    /// 将 `Data` 转换为字节数组 `[UInt8]`
    ///
    /// - Returns: 由 `Data` 中每个字节组成的数组
    /// - Example:
    ///   ```swift
    ///   let data = Data([0x01, 0x02, 0x03])
    ///   let bytes = data.solo_bytes()  // [1, 2, 3]
    ///   ```
    func solo_bytes() -> [UInt8] {
        return [UInt8](self)
    }

    /// 将 `Data` 转换为大写的十六进制字符串(每字节占两位)
    ///
    /// - Returns: 十六进制字符串,如 `"A1B2"`;若 `Data` 为空,则返回空字符串
    /// - Example:
    ///   ```swift
    ///   let data = Data([0xA1, 0xB2])
    ///   print(data.solo_hexString())  // "A1B2"
    ///   ```
    func solo_hexString() -> String {
        return self.map { String(format: "%02X", $0) }.joined()
    }

    /// 尝试将 `Data` 转换为 `UIImage`
    ///
    /// - Returns: 若数据是有效的图像格式(如 PNG、JPEG),则返回 `UIImage`;否则返回 `nil`
    /// - Note: 不包含缓存逻辑,频繁调用建议自行缓存结果
    func solo_uIImage() -> UIImage? {
        return UIImage(data: self)
    }
}

// MARK: - base64 编码与解码
public extension Data {
    /// 将当前 `Data` 进行 self64 编码,返回编码后的 `Data`
    ///
    /// - Returns: self64 编码结果(UTF-8 字符串的二进制形式),失败时返回 `nil`(极少见)
    /// - Example:
    ///   ```swift
    ///   let original = "Hello".data(using: .utf8)!
    ///   let encoded = original.solo_encodebase64()  // Data of "SGVsbG8="
    ///   ```
    func solo_encodebase64() -> Data? {
        return self.base64EncodedData()
    }

    /// 将当前 `Data` 视为 self64 编码的原始字节,尝试解码为原始数据
    ///
    /// - Returns: 解码后的原始 `Data`,若格式无效则返回 `nil`
    /// - Warning: 此方法假设 `self` 是 self64 字符串的 UTF-8 字节表示`一般应从字符串解码,而非 Data`
    /// - Example(不推荐常规使用):
    ///   ```swift
    ///   let self64Bytes = "SGVsbG8=".data(using: .utf8)!
    ///   let decoded = self64Bytes.solo_decodebase64()  // Data of "Hello"
    ///   ```
    /// - Recommendation: 更常见的做法是 `Data(base64Encoded: base64String)`
    func solo_decodebase64() -> Data? {
        return Data(base64Encoded: self)
    }
}

// MARK: - 数据切片
public extension Data {
    /// 从指定位置截取一段子数据
    ///
    /// - Parameters:
    ///   - start: 起始字节索引(从 0 开始)
    ///   - len: 要截取的字节数
    /// - Returns: 截取的子 `Data`;若范围越界或参数无效,则返回 `nil`
    /// - Example:
    ///   ```swift
    ///   let data = Data([1, 2, 3, 4, 5])
    ///   if let sub = data.solo_subData(start: 1, len: 3) {
    ///       print(sub.bytes)  // [2, 3, 4]
    ///   }
    ///   ```
    func solo_subData(start: Int, len: Int) -> Data? {
        guard start >= 0, len >= 0, start + len <= self.count else { return nil }
        return self.subdata(in: start ..< (start + len))
    }
}

// MARK: - 字符串与JSON转换
public extension Data {
    /// 将 `Data` 按指定编码转换为字符串
    ///
    /// - Parameter encoding: 字符串编码,默认为 `.utf8`
    /// - Returns: 解码后的字符串,若无法解码则返回 `nil`
    /// - Example:
    ///   ```swift
    ///   let data = "Swift".data(using: .utf8)!
    ///   let str = data.solo_string()  // "Swift"
    ///   ```
    func solo_string(encoding: String.Encoding = .utf8) -> String? {
        return String(data: self, encoding: encoding)
    }

    /// 将 `Data` 解析为 JSON 对象
    ///
    /// - Parameters:
    ///   - type: 期望的 JSON 类型(如 `[String: Any].self`, `[[String: Any]].self` 等),默认为 `[String: Any]`
    ///   - options: JSON 解析选项(如 `.mutableContainers`)
    /// - Returns: 解析成功的 JSON 对象,失败时返回 `nil`
    /// - Throws: 内部已捕获异常,不会抛出错误
    /// - Example:
    ///   ```swift
    ///   let json = """
    ///   {"name": "Alice", "age": 30}
    ///   """.data(using: .utf8)!
    ///
    ///   if let dict: [String: Any] = json.solo_object() {
    ///       print(dict["name"] as? String ?? "")  // "Alice"
    ///   }
    ///   ```
    func solo_object<T>(for type: T.Type = [String: Any].self, options: JSONSerialization.ReadingOptions = []) -> T? {
        return try? JSONSerialization.jsonObject(with: self, options: options) as? T
    }
}
