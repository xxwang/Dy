import Foundation
import CoreGraphics

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 类型转换
public extension String {
    /// 将字符串转换为 `Bool`
    func dy_toBool() -> Bool {
        let trimmed = self.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`,失败时返回 `0`
    func dy_toInt() -> Int {
        Int(self) ?? 0
    }

    /// 转换为 `Int64`,失败时返回 `0`
    func dy_toInt64() -> Int64 {
        Int64(self) ?? 0
    }

    /// 转换为 `UInt`,失败时返回 `0`
    func dy_toUInt() -> UInt {
        UInt(self) ?? 0
    }

    /// 转换为 `UInt64`,失败时返回 `0`
    func dy_toUInt64() -> UInt64 {
        UInt64(self) ?? 0
    }

    /// 转换为 `Float`,失败时返回 `0.0`
    func dy_toFloat() -> Float {
        Float(self) ?? 0
    }

    /// 转换为 `Double`,失败时返回 `0.0`
    func dy_toDouble() -> Double {
        Double(self) ?? 0
    }

    /// 转换为 `CGFloat`,失败时返回 `0.0`
    func dy_toCGFloat() -> CGFloat {
        CGFloat(Double(self) ?? 0)
    }

    /// 转换为 `NSNumber`
    func dy_toNSNumber() -> NSNumber {
        NSNumber(value: Double(self) ?? 0)
    }

    /// 转换为 `NSDecimalNumber`
    func dy_toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: self)
    }

    /// 转换为 `Decimal`
    func dy_toDecimal() -> Decimal {
        return Decimal(string: self) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    func dy_toHexInt() -> Int {
        let clean = self.hasPrefix("#") ? String(self.dropFirst()) : self
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    func dy_toCharacter() -> Character? {
        guard let intValue = Int(self),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    func dy_toCharacters() -> [Character] {
        Array(self)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    func dy_toData() -> Data? {
        self.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    func dy_toURL() -> URL? {
        URL(string: self)
    }

    /// 尝试转换为 `URLRequest`
    func dy_toURLRequest() -> URLRequest? {
        guard let url = self.dy_toURL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    func dy_toNotificationName() -> Notification.Name {
        Notification.Name(self)
    }

    /// 转换为 `NSString`（桥接）
    func dy_toNSString() -> NSString {
        self as NSString
    }

    /// 转换为 `NSAttributedString`
    func dy_toNSAttributedString() -> NSAttributedString {
        NSAttributedString(string: self)
    }

    /// 转换为 `NSMutableAttributedString`
    func dy_toNSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: self)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    func dy_toHexColor() -> UIColor {
        UIColor(hex: self)
    }

    /// 从资源名加载 `UIImage`
    func dy_toImage() -> UIImage? {
        UIImage(named: self)
    }
}
