import QuartzCore

// MARK: - 属性
public extension CATransform3D {
    /// 返回单位变换矩阵(无任何变换)
    /// 对应系统常量 `CATransform3DIdentity`
    /// - Returns: 单位 `CATransform3D` 矩阵 `[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]`
    static var dy_identity: CATransform3D {
        return CATransform3DIdentity
    }

    /// 判断当前变换是否为单位变换(即未发生任何变换)
    /// - Returns: 如果是单位矩阵,返回 `true`;否则返回 `false`
    var dy_isIdentity: Bool {
        return CATransform3DIsIdentity(self)
    }

    /// 尝试将当前 3D 变换转换为 2D 仿射变换
    /// - Returns: 若变换是仿射的,则返回对应的 `CGAffineTransform`;
    ///   否则返回 `CGAffineTransform.identity`(不会崩溃,但结果可能不符合预期)
    var dy_cgAffineTransform: CGAffineTransform {
        return CATransform3DGetAffineTransform(self)
    }

    /// 判断当前 3D 变换是否可以用 2D 仿射变换(`CGAffineTransform`)精确表示
    /// - Returns: 如果可以无损转为 2D 变换,返回 `true`;否则(如包含透视、非平面旋转等)返回 `false`
    var dy_isAffine: Bool {
        return CATransform3DIsAffine(self)
    }
}

// MARK: - 构造方法
public extension CATransform3D {
    /// 创建一个平移变换
    /// - Parameters:
    ///   - tx: 沿 X 轴的平移距离
    ///   - ty: 沿 Y 轴的平移距离
    ///   - tz: 沿 Z 轴的平移距离
    @inlinable
    init(tx: CGFloat, ty: CGFloat, tz: CGFloat) {
        self = CATransform3DMakeTranslation(tx, ty, tz)
    }

    /// 创建一个缩放变换
    /// - Parameters:
    ///   - sx: X 轴缩放比例(1.0 表示无缩放)
    ///   - sy: Y 轴缩放比例
    ///   - sz: Z 轴缩放比例
    @inlinable
    init(sx: CGFloat, sy: CGFloat, sz: CGFloat) {
        self = CATransform3DMakeScale(sx, sy, sz)
    }

    /// 创建一个绕任意轴的旋转变换
    /// - Parameters:
    ///   - angle: 旋转角度,单位为`弧度`(例如 `.pi / 2` 表示 90 度)
    ///   - x: 旋转轴向量的 X 分量(无需归一化,系统会自动处理)
    ///   - y: 旋转轴向量的 Y 分量
    ///   - z: 旋转轴向量的 Z 分量
    /// - Note: 若 `(x, y, z)` 为零向量,变换结果未定义
    @inlinable
    init(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) {
        self = CATransform3DMakeRotation(angle, x, y, z)
    }
}

// MARK: - 值语义变换方法(返回新实例,不修改原值)
public extension CATransform3D {
    /// 返回在当前变换基础上再应用平移后的新变换
    /// - Parameters:
    ///   - tx: X 轴平移量
    ///   - ty: Y 轴平移量
    ///   - tz: Z 轴平移量
    /// - Returns: 新的 `CATransform3D` 实例
    @inlinable
    func dy_translatedBy(tx: CGFloat, ty: CGFloat, tz: CGFloat) -> CATransform3D {
        return CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 返回在当前变换基础上再应用缩放后的新变换
    /// - Parameters:
    ///   - sx: X 轴缩放因子
    ///   - sy: Y 轴缩放因子
    ///   - sz: Z 轴缩放因子
    /// - Returns: 新的 `CATransform3D` 实例
    @inlinable
    func dy_scaledBy(sx: CGFloat, sy: CGFloat, sz: CGFloat) -> CATransform3D {
        return CATransform3DScale(self, sx, sy, sz)
    }

    /// 返回在当前变换基础上再应用旋转后的新变换
    /// - Parameters:
    ///   - angle: 旋转角度(弧度)
    ///   - x: 旋转轴 X 分量
    ///   - y: 旋转轴 Y 分量
    ///   - z: 旋转轴 Z 分量
    /// - Returns: 新的 `CATransform3D` 实例
    @inlinable
    func dy_rotated(angle: CGFloat, x: CGFloat, y: CGFloat, z: CGFloat) -> CATransform3D {
        return CATransform3DRotate(self, angle, x, y, z)
    }

    /// 返回当前变换与另一个变换连接(组合)后的新变换
    /// 组合顺序：先应用 `self`,再应用 `t2`(即 `result = t2 * self`)
    /// - Parameter t2: 要连接的另一个变换
    /// - Returns: 新的 `CATransform3D` 实例
    @inlinable
    func dy_concatenating(_ t2: CATransform3D) -> CATransform3D {
        return CATransform3DConcat(self, t2)
    }

    /// 返回当前变换的逆变换
    /// - Returns: 逆变换矩阵
    /// - Warning: 如果当前变换不可逆(如行列式为 0),结果未定义,可能导致渲染异常
    @inlinable
    func dy_inverted() -> CATransform3D {
        return CATransform3DInvert(self)
    }
}

// MARK: - 可变变换方法(就地修改自身)
public extension CATransform3D {
    /// 在当前变换基础上就地应用平移
    /// - Parameters:
    ///   - tx: X 轴平移量
    ///   - ty: Y 轴平移量
    ///   - tz: Z 轴平移量
    mutating func dy_translate(by tx: CGFloat, _ ty: CGFloat, _ tz: CGFloat) {
        self = CATransform3DTranslate(self, tx, ty, tz)
    }

    /// 在当前变换基础上就地应用缩放
    /// - Parameters:
    ///   - sx: X 轴缩放因子
    ///   - sy: Y 轴缩放因子
    ///   - sz: Z 轴缩放因子
    mutating func dy_scale(by sx: CGFloat, _ sy: CGFloat, _ sz: CGFloat) {
        self = CATransform3DScale(self, sx, sy, sz)
    }

    /// 在当前变换基础上就地应用旋转
    /// - Parameters:
    ///   - angle: 旋转角度(弧度)
    ///   - x: 旋转轴 X 分量
    ///   - y: 旋转轴 Y 分量
    ///   - z: 旋转轴 Z 分量
    mutating func dy_rotate(by angle: CGFloat, aroundAxis x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        self = CATransform3DRotate(self, angle, x, y, z)
    }

    /// 就地连接另一个变换
    /// - Parameter t2: 要连接的变换
    mutating func dy_concatenate(_ t2: CATransform3D) {
        self = CATransform3DConcat(self, t2)
    }

    /// 就地取当前变换的逆变换
    /// - Warning: 若变换不可逆,行为未定义
    mutating func dy_invert() {
        self = CATransform3DInvert(self)
    }
}

// MARK: - 全局相等性运算符
/// 支持直接比较两个 `CATransform3D` 是否相等
/// - Parameters:
///   - lhs: 左侧变换
///   - rhs: 右侧变换
/// - Returns: 如果所有矩阵元素相等,返回 `true`;否则返回 `false`
@inlinable
public func == (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
    return CATransform3DEqualToTransform(lhs, rhs)
}

/// 支持不等比较
/// - Parameters:
///   - lhs: 左侧变换
///   - rhs: 右侧变换
/// - Returns: 如果两个变换不相等,返回 `true`
@inlinable
public func != (lhs: CATransform3D, rhs: CATransform3D) -> Bool {
    return !(lhs == rhs)
}
