import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGSize {
    /// 宽高比(width / height)
    var dy_aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }

    /// 较长的一边(max(width, height))
    var dy_longestSide: CGFloat {
        max(width, height)
    }

    /// 较短的一边(min(width, height))
    var dy_shortestSide: CGFloat {
        min(width, height)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 对宽高进行四舍五入
    func dy_rounded() -> CGSize {
        CGSize(width: round(width), height: round(height))
    }

    /// 将尺寸限制在最大尺寸内
    func dy_clamped(to maxSize: CGSize) -> CGSize {
        CGSize(
            width: min(width, maxSize.width),
            height: min(height, maxSize.height)
        )
    }
}

// MARK: - 缩放
public extension CGSize {
    /// 按宽高比缩放,使内容`完全适配`目标区域(不超出)
    func dy_aspectFit(to targetSize: CGSize) -> CGSize {
        guard width > 0, height > 0, targetSize.width > 0, targetSize.height > 0 else {
            return .zero
        }
        let scale = min(targetSize.width / width, targetSize.height / height)
        return CGSize(width: width * scale, height: height * scale)
    }

    /// 按宽高比缩放,使内容`完全覆盖`目标区域(可能超出)
    func dy_aspectFill(to targetSize: CGSize) -> CGSize {
        guard width > 0, height > 0 else { return .zero }
        let scale = max(targetSize.width / width, targetSize.height / height)
        return CGSize(width: width * scale, height: height * scale)
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
        CGSize(width: lhs.width / scalar, height: lhs.height / scalar)
    }

    static func /= (lhs: inout CGSize, scalar: CGFloat) {
        lhs = lhs / scalar
    }

    static func / (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width / rhs.width, height: lhs.height / rhs.height)
    }
}
