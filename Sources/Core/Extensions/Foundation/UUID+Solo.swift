import Foundation

extension UUID: SoloExtension {}

// MARK: - 自定义
public extension SoloWrapper where Base == UUID {
    /// 返回一个`UUID`字符串
    func toString() -> String {
        return base.uuidString
    }
}
