import CoreGraphics

// MARK: - 向量属性
public extension DyWrapper where Base == CGPoint {
    /// 向量长度(到原点的距离)
    var length: CGFloat {
        sqrt(base.x * base.x + base.y * base.y)
    }

    /// 向量长度的平方
    var lengthSquared: CGFloat {
        base.x * base.x + base.y * base.y
    }

    /// 单位向量(归一化)若长度为 0,返回 `.zero`
    var normalized: CGPoint {
        let len = self.length
        guard len > 0 else { return .zero }
        return base / len
    }

    /// 与另一个向量的点积(dot product)
    func dot(_ other: CGPoint) -> CGFloat {
        base.x * other.x + base.y * other.y
    }
}

// MARK: - 计算
public extension DyWrapper where Base == CGPoint {
    /// 计算到另一点的欧几里得距离
    /// - Parameter point: 目标点
    /// - Returns: 非负距离值
    func distance(to point: CGPoint) -> CGFloat {
        let dx = point.x - base.x
        let dy = point.y - base.y
        return sqrt(dx * dx + dy * dy)
    }

    /// 计算到另一点的距离平方(避免开方,用于高效比较)
    /// - Parameter point: 目标点
    /// - Returns: 距离的平方
    func distanceSquared(to point: CGPoint) -> CGFloat {
        let dx = point.x - base.x
        let dy = point.y - base.y
        return dx * dx + dy * dy
    }

    /// 返回当前点与另一点的中点
    func midpoint(to other: CGPoint) -> CGPoint {
        CGPoint(x: (base.x + other.x) / 2, y: (base.y + other.y) / 2)
    }
}

// MARK: - 运算符重载
public extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func += (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs + rhs
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func -= (lhs: inout CGPoint, rhs: CGPoint) {
        lhs = lhs - rhs
    }

    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x * scalar, y: point.y * scalar)
    }

    static func * (scalar: CGFloat, point: CGPoint) -> CGPoint {
        point * scalar
    }

    static func *= (point: inout CGPoint, scalar: CGFloat) {
        point = point * scalar
    }

    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        CGPoint(x: point.x / scalar, y: point.y / scalar)
    }

    static func /= (point: inout CGPoint, scalar: CGFloat) {
        point = point / scalar
    }
}
