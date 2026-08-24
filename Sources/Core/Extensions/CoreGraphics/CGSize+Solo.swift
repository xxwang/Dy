import CoreGraphics
import UIKit

// MARK: - 属性
public extension CGSize {
    /// 宽高比(width / height)
    var solo_aspectRatio: CGFloat {
        guard self.height != 0 else { return 0 }
        return self.width / self.height
    }

    /// 较长的一边(max(width, height))
    var solo_longestSide: CGFloat {
        max(self.width, self.height)
    }

    /// 较短的一边(min(width, height))
    var solo_shortestSide: CGFloat {
        min(self.width, self.height)
    }
}

// MARK: - 方法
public extension CGSize {
    /// 对宽高进行四舍五入
    func solo_rounded() -> CGSize {
        CGSize(width: Darwin.round(self.width), height: Darwin.round(self.height))
    }

    /// 将尺寸限制在最大尺寸内
    func solo_clamped(to maxSize: CGSize) -> CGSize {
        CGSize(
            width: min(self.width, maxSize.width),
            height: min(self.height, maxSize.height)
        )
    }
}

// MARK: - 缩放
public extension CGSize {
    /// 按宽高比缩放,使内容`完全适配`目标区域(不超出)
    func solo_aspectFit(to targetSize: CGSize) -> CGSize {
        guard self.width > 0, self.height > 0, targetSize.width > 0, targetSize.height > 0 else {
            return .zero
        }
        let scale = min(targetSize.width / self.width, targetSize.height / self.height)
        return CGSize(width: self.width * scale, height: self.height * scale)
    }

    /// 按宽高比缩放,使内容`完全覆盖`目标区域(可能超出)
    func solo_aspectFill(to targetSize: CGSize) -> CGSize {
        guard self.width > 0, self.height > 0 else { return .zero }
        let scale = max(targetSize.width / self.width, targetSize.height / self.height)
        return CGSize(width: self.width * scale, height: self.height * scale)
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
