import Foundation
import CoreGraphics

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 类型转换
public extension SoloWrapper where Base == String {
    /// 将字符串转换为 `Bool`
    func toBool() -> Bool {
        let trimmed = base.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch trimmed {
        case "1", "t", "true", "y", "yes": return true
        case "0", "f", "false", "n", "no": return false
        default: return false
        }
    }

    /// 转换为 `Int`,失败时返回 `0`
    func toInt() -> Int {
        Int(base) ?? 0
    }

    /// 转换为 `Int64`,失败时返回 `0`
    func toInt64() -> Int64 {
        Int64(base) ?? 0
    }

    /// 转换为 `UInt`,失败时返回 `0`
    func toUInt() -> UInt {
        UInt(base) ?? 0
    }

    /// 转换为 `UInt64`,失败时返回 `0`
    func toUInt64() -> UInt64 {
        UInt64(base) ?? 0
    }

    /// 转换为 `Float`,失败时返回 `0.0`
    func toFloat() -> Float {
        Float(base) ?? 0
    }

    /// 转换为 `Double`,失败时返回 `0.0`
    func toDouble() -> Double {
        Double(base) ?? 0
    }

    /// 转换为 `CGFloat`,失败时返回 `0.0`
    func toCGFloat() -> CGFloat {
        CGFloat(Double(base) ?? 0)
    }

    /// 转换为 `NSNumber`
    func toNSNumber() -> NSNumber {
        NSNumber(value: Double(base) ?? 0)
    }

    /// 转换为 `NSDecimalNumber`
    func toNSDecimalNumber() -> NSDecimalNumber {
        NSDecimalNumber(string: base)
    }

    /// 转换为 `Decimal`
    func toDecimal() -> Decimal {
        return Decimal(string: base) ?? .zero
    }

    /// 将十六进制字符串（如 `"FF"` 或 `"#A1B2C3"`）转换为十进制 `Int`
    func toHexInt() -> Int {
        let clean = base.hasPrefix("#") ? String(base.dropFirst()) : base
        return Int(clean, radix: 16) ?? 0
    }

    /// 尝试将字符串解析为 `Unicode` 码点并转换为 `Character`
    func toCharacter() -> Character? {
        guard let intValue = Int(base),
              let scalar = UnicodeScalar(intValue) else { return nil }
        return Character(scalar)
    }

    /// 转换为字符数组
    func toCharacters() -> [Character] {
        Array(base)
    }

    /// 转换为 `UTF-8` 编码的 `Data`
    func toData() -> Data? {
        base.data(using: .utf8)
    }

    /// 尝试转换为 `URL`
    func toURL() -> URL? {
        URL(string: base)
    }

    /// 尝试转换为 `URLRequest`
    func toURLRequest() -> URLRequest? {
        guard let url = self.toURL() else { return nil }
        return URLRequest(url: url)
    }

    /// 转换为 `Notification.Name`
    func toNotificationName() -> Notification.Name {
        Notification.Name(base)
    }

    /// 转换为 `NSString`（桥接）
    func toNSString() -> NSString {
        base as NSString
    }

    /// 转换为 `NSAttributedString`
    func toNSAttributedString() -> NSAttributedString {
        NSAttributedString(string: base)
    }

    /// 转换为 `NSMutableAttributedString`
    func toNSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(string: base)
    }

    /// 将十六进制颜色字符串转换为 `UIColor`
    func toHexColor() -> UIColor {
        UIColor(hex: base)
    }

    /// 从资源名加载 `UIImage`
    func toImage() -> UIImage? {
        UIImage(named: base)
    }
}
