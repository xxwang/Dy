import CoreGraphics

extension CGPath: SoloExtension {}

public extension SoloWrapper where Base == CGPath {
    /// 创建当前路径的可变副本
    func toMutable() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(base)
        return copy
    }
}
