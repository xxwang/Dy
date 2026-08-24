import CoreGraphics

// MARK: - 类型转换
public extension CGMutablePath {
    /// 将当前可变路径转换为不可变的 `CGPath`
    func solo_cGPath() -> CGPath {
        self
    }
}
