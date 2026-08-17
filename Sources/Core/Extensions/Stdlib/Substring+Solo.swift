import Foundation

extension Substring: SoloExtension {}

// MARK: - 类型转换
public extension SoloWrapper where Base == Substring {
    /// 将当前子字符串转换为 `String`
    func toString() -> String {
        return String(base)
    }
}
