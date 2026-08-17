import CoreGraphics
import QuartzCore

extension CGAffineTransform: SoloExtension {}

// MARK: - 类型转换
public extension SoloWrapper where Base == CGAffineTransform {
    /// 将当前的 2D 仿射变换转换为等效的 3D 变换矩阵(`CATransform3D`)
    func toCATransform3D() -> CATransform3D {
        CATransform3DMakeAffineTransform(base)
    }
}
