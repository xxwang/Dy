import CoreGraphics

// MARK: - 构造方法
public extension CGVector {
    /// 根据角度(弧度)和长度创建一个向量
    /// - Parameters:
    ///   - angle: 从正 X 轴逆时针旋转的角度(单位：弧度)
    ///   - magnitude: 向量的长度
    init(angle: CGFloat, magnitude: CGFloat) {
        self.init(dx: magnitude * cos(angle), dy: magnitude * sin(angle))
    }
}

// MARK: - 属性
public extension CGVector {
    /// 向量相对于正 X 轴的旋转角度(弧度),范围为 [-π, π]
    var dy_angle: CGFloat {
        atan2(self.dy, self.dx)
    }

    /// 向量的长度(模长)
    var dy_magnitude: CGFloat {
        sqrt(self.dx * self.dx + self.dy * self.dy)
    }

    /// 向量长度的平方(避免开方,用于高效比较)
    var dy_magnitudeSquared: CGFloat {
        self.dx * self.dx + self.dy * self.dy
    }

    /// 返回单位向量(长度为 1 的方向向量)若原向量长度为 0,则返回 `.zero`
    var dy_normalized: CGVector {
        let length = self.dy_magnitude
        guard length > 0 else { return .zero }
        return self / length
    }
}

// MARK: - 向量运算
public extension CGVector {
    /// 计算与另一个向量的点积(Dot Product)
    /// 点积可用于判断夹角、投影等
    /// - Parameter other: 另一个向量
    /// - Returns: 两个向量的点积(标量)
    func dy_dot(_ other: CGVector) -> CGFloat {
        self.dx * other.dx + self.dy * other.dy
    }
}

// MARK: - 运算符重载
public extension CGVector {
    /// 加法
    static func + (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
    }

    static func += (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs + rhs
    }

    /// 减法
    static func - (lhs: CGVector, rhs: CGVector) -> CGVector {
        CGVector(dx: lhs.dx - rhs.dx, dy: lhs.dy - rhs.dy)
    }

    static func -= (lhs: inout CGVector, rhs: CGVector) {
        lhs = lhs - rhs
    }

    /// 标量乘法
    static func * (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx * scalar, dy: vector.dy * scalar)
    }

    static func * (scalar: CGFloat, vector: CGVector) -> CGVector {
        vector * scalar
    }

    static func *= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector * scalar
    }

    /// 标量除法
    static func / (vector: CGVector, scalar: CGFloat) -> CGVector {
        CGVector(dx: vector.dx / scalar, dy: vector.dy / scalar)
    }

    static func /= (vector: inout CGVector, scalar: CGFloat) {
        vector = vector / scalar
    }

    /// 取反(方向相反,长度不变)
    static prefix func - (vector: CGVector) -> CGVector {
        CGVector(dx: -vector.dx, dy: -vector.dy)
    }
}
