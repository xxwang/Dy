import CoreGraphics

extension CGMutablePath: DyExtension {}

// MARK: - 类型转换
public extension DyWrapper where Base: CGMutablePath {
    /// 将当前可变路径转换为不可变的 `CGPath`
    func toCGPath() -> CGPath {
        base
    }
}
