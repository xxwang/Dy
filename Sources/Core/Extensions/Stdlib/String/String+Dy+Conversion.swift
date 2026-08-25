import Foundation
import CoreGraphics

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 类型转换
public extension String {
    /// 将字符串转换为 `Bool`
    func dy_bool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`,失败时返回 `0`
    func dy_int() -> Int {
        Int(self) ?? 0
    }

    /// 转换为 `Int64`,失败时返回 `0`
    func dy_int64() -> Int64 {
        Int64(self) ?? 0
    }

    /// 转换为 `UInt`,失败时返回 `0`
    func dy_uInt() -> UInt {
        UInt(self) ?? 0
    }

    /// 转换为 `UInt64`,失败时返回 `0`
    func dy_uInt64() -> UInt64 {
        UInt64(self) ?? 0
    }

    /// 转换为 `Float`,失败时返回 `0.0`
    func dy_float() -> Float {
        Float(self) ?? 0
    }

    /// 转换为 `Double`,失败时返回 `0.0`
    func dy_double() -> Double {
        Double(self) ?? 0
    }

    /// 转换为 `CGFloat`,失败时返回 `0.0`
    func dy_cGFloat() -> CGFloat {
        CGFloat(Double(self) ?? 0)
    }

    /// 转换为 `NSNumber`
    func dy_nSNumber() -> NSNumber {
        NSNumber(value: Double(self) ?? 0)
    }

    /// 转换为 `NSDecimalNumber`
    func dy_nSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self)
    }

    /// 转换为 `Decimal`
    func dy_decimal() -> Decimal {
        return Decimal(string: self) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    func dy_hexInt() -> Int {
        let clean = self.hasPrefix("#") ? String(self.dropFirst()) : self
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    func dy_character() -> Character? {
        guard let intValue = Int(self),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    func dy_characters() -> [Character] {
        Array(self)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    func dy_data() -> Data? {
        self.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    func dy_uRL() -> URL? {
        URL(string: self)
    }

    /// 尝试转换为 `URLRequest`
    func dy_URLRequest() -> URLRequest? {
        guard let url = self.dy_uRL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    func dy_notificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 转换为 `NSString`（桥接）
    func dy_nSString() -> NSString {
        self as NSString
    }

    /// 转换为 `NSAttributedString`
    func dy_nSAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    func dy_nSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    func dy_hexColor() -> UIColor {
        UIColor(hex: self)
    }

    /// 从资源名加载 `UIImage`
    func dy_uIImage() -> UIImage? {
        UIImage(named: self)
    }
}
