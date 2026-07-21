import CoreGraphics

public extension CGPath {
    /// 创建当前路径的可变副本
    func dy_toCGMutablePath() -> CGMutablePath {
        let copy = CGMutablePath()
        copy.addPath(self)
        return copy
    }
}
