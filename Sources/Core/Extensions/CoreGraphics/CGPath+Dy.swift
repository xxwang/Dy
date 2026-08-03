import CoreGraphics

extension CGPath: DyExtension {}

public extension DyWrapper where Base == CGPath {
    /// 创建当前路径的可变副本
    func toMutable() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(base)
        return copy
    }
}
