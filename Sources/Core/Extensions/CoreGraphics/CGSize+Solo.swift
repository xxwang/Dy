import CoreGraphics
import UIKit

extension CGSize: SoloExtension {}

// MARK: - 属性
public extension SoloWrapper where Base == CGSize {
    /// 宽高比(width / height)
    var aspectRatio: CGFloat {
        guard base.height != 0 else { return 0 }
        return base.width / base.height
    }

    /// 较长的一边(max(width, height))
    var longestSide: CGFloat {
        max(base.width, base.height)
    }

    /// 较短的一边(min(width, height))
    var shortestSide: CGFloat {
        min(base.width, base.height)
    }
}

// MARK: - 方法
public extension SoloWrapper where Base == CGSize {
    /// 对宽高进行四舍五入
    func rounded() -> CGSize {
        CGSize(width: Darwin.round(base.width), height: Darwin.round(base.height))
    }

    /// 将尺寸限制在最大尺寸内
    func clamped(to maxSize: CGSize) -> CGSize {
        CGSize(
            width: min(base.width, maxSize.width),
            height: min(base.height, maxSize.height)
        )
    }
}

// MARK: - 缩放
public extension SoloWrapper where Base == CGSize {
    /// 按宽高比缩放,使内容`完全适配`目标区域(不超出)
    func aspectFit(to targetSize: CGSize) -> CGSize {
        guard base.width > 0, base.height > 0, targetSize.width > 0, targetSize.height > 0 else {
            return .zero
        }
        let scale = min(targetSize.width / base.width, targetSize.height / base.height)
        return CGSize(width: base.width * scale, height: base.height * scale)
    }

    /// 按宽高比缩放,使内容`完全覆盖`目标区域(可能超出)
    func aspectFill(to targetSize: CGSize) -> CGSize {
        guard base.width > 0, base.height > 0 else { return .zero }
        let scale = max(targetSize.width / base.width, targetSize.height / base.height)
        return CGSize(width: base.width * scale, height: base.height * scale)
    }
}

// MARK: - 运算符重载
public extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }

    static func += (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }

    static func -= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs - rhs
    }

    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    static func *= (lhs: inout CGSize, rhs: CGSize) {
        lhs = lhs * rhs
    }

    static func * (lhs: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: lhs.width * scalar, height: lhs.height * scalar)
    }

    static func * (scalar: CGFloat, rhs: CGSize) -> CGSize {
        rhs * scalar
    }

    static func *= (lhs: inout CGSize, scalar: CGFloat) {
        lhs = lhs * scalar
    }

    static func / (lhs: CGSize, scalar: CGFloat) -> CGSize {
        guard scalar != 0 else { return .zero }
        return CGSize(width: lhs.width / scalar, height: lhs.height / scalar)
    }

    static func /= (lhs: inout CGSize, scalar: CGFloat) {
        lhs = lhs / scalar
    }

    static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
        guard rhs.width != 0, rhs.height != 0 else { return .zero }
        return CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }
}
