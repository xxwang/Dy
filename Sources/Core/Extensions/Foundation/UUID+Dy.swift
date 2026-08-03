import Foundation

extension UUID: DyExtension {}

// MARK: - 自定义
public extension DyWrapper where Base == UUID {
    /// 返回一个`UUID`字符串
    func toString() -> String {
        return base.uuidString
    }
}
