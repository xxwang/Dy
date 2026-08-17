import CoreGraphics

// MARK: - 链式语法(系统)
public extension SoloWrapper where Base: CGMutablePath {
    /// 添加另一个路径到当前路径
    /// - Parameters:
    ///   - path: 要添加的路径
    ///   - transform: 应用于该路径的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func add(path: CGPath, withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addPath(path, transform: transform)
        return self
    }

    /// 添加一个矩形路径
    /// - Parameters:
    ///   - rect: 矩形区域
    ///   - transform: 应用于该矩形的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func add(rect: CGRect, withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addRect(rect, transform: transform)
        return self
    }

    /// 添加一个圆角矩形路径
    /// - Parameters:
    ///   - rect: 圆角矩形的边界框
    ///   - cornerWidth: 圆角的宽度(X 方向半径)
    ///   - cornerHeight: 圆角的高度(Y 方向半径)
    ///   - transform: 应用于该路径的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addRoundedRect(
        rect: CGRect,
        cornerWidth: CGFloat,
        cornerHeight: CGFloat,
        withTransform transform: CGAffineTransform = .identity
    ) -> Self {
        base.addRoundedRect(in: rect, cornerWidth: cornerWidth, cornerHeight: cornerHeight, transform: transform)
        return self
    }

    /// 添加多个矩形路径
    /// - Parameters:
    ///   - rects: 矩形数组
    ///   - transform: 应用于所有矩形的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func add(rects: [CGRect], withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addRects(rects, transform: transform)
        return self
    }

    /// 移动绘制起点(不绘制线段)
    /// - Parameters:
    ///   - point: 新的起始点坐标
    ///   - transform: 应用于该点的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func move(to point: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        base.move(to: point, transform: transform)
        return self
    }

    /// 从当前点绘制一条直线到指定点
    /// - Parameters:
    ///   - point: 目标点坐标
    ///   - transform: 应用于该线段的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addLine(to point: CGPoint, withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addLine(to: point, transform: transform)
        return self
    }

    /// 添加一条二次贝塞尔曲线
    /// - Parameters:
    ///   - endPoint: 曲线终点
    ///   - control: 控制点
    ///   - transform: 应用于该曲线的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addQuadCurve(
        to endPoint: CGPoint,
        control: CGPoint,
        withTransform transform: CGAffineTransform = .identity
    ) -> Self {
        base.addQuadCurve(to: endPoint, control: control, transform: transform)
        return self
    }

    /// 添加一条三次贝塞尔曲线
    /// - Parameters:
    ///   - endPoint: 曲线终点
    ///   - control1: 第一个控制点
    ///   - control2: 第二个控制点
    ///   - transform: 应用于该曲线的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addCurve(
        to endPoint: CGPoint,
        control1: CGPoint,
        control2: CGPoint,
        withTransform transform: CGAffineTransform = .identity
    ) -> Self {
        base.addCurve(to: endPoint, control1: control1, control2: control2, transform: transform)
        return self
    }

    /// 根据点数组依次绘制线段(点之间用直线连接)
    /// - Parameters:
    ///   - points: 点的数组(至少两个点)
    ///   - transform: 应用于所有点的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addLines(between points: [CGPoint], withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addLines(between: points, transform: transform)
        return self
    }

    /// 添加一个椭圆路径(内接于指定矩形)
    /// - Parameters:
    ///   - rect: 椭圆的包围矩形
    ///   - transform: 应用于该椭圆的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addEllipse(in rect: CGRect, withTransform transform: CGAffineTransform = .identity) -> Self {
        base.addEllipse(in: rect, transform: transform)
        return self
    }

    /// 添加一段相对弧线(基于当前位置)
    /// - Parameters:
    ///   - center: 圆心坐标
    ///   - radius: 半径
    ///   - startAngle: 起始角度(弧度)
    ///   - delta: 角度增量(正数为逆时针)
    /// - Returns: `Self`
    @discardableResult
    func addRelativeArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        delta: CGFloat
    ) -> Self {
        base.addRelativeArc(center: center, radius: radius, startAngle: startAngle, delta: delta)
        return self
    }

    /// 添加一段基于中心点的圆弧
    /// - Parameters:
    ///   - center: 圆心
    ///   - radius: 半径
    ///   - startAngle: 起始角度(弧度)
    ///   - endAngle: 结束角度(弧度)
    ///   - clockwise: 是否顺时针绘制
    ///   - transform: 应用于该弧线的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        clockwise: Bool,
        withTransform transform: CGAffineTransform = .identity
    ) -> Self {
        base.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise, transform: transform)
        return self
    }

    /// 添加一段与两条切线相切的圆弧
    /// - Parameters:
    ///   - tangent1End: 第一条切线的终点
    ///   - tangent2End: 第二条切线的终点
    ///   - radius: 弧的半径
    ///   - transform: 应用于该弧线的仿射变换,默认为 `.identity`
    /// - Returns: `Self`
    @discardableResult
    func addArc(
        tangent1End: CGPoint,
        tangent2End: CGPoint,
        radius: CGFloat,
        withTransform transform: CGAffineTransform = .identity
    ) -> Self {
        base.addArc(tangent1End: tangent1End, tangent2End: tangent2End, radius: radius, transform: transform)
        return self
    }
}
