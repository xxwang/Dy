import UIKit

// MARK: - 构造方法
public extension UIBezierPath {
    /// 使用两点创建一条直线路径
    /// - Parameters:
    ///   - from: 起点
    ///   - to: 终点
    convenience init(from: CGPoint, to: CGPoint) {
        self.init()
        move(to: from)
        addLine(to: to)
    }

    /// 使用多个点依次连线创建开放路径
    /// - Parameter points: 点数组,至少一个点
    convenience init(points: [CGPoint]) {
        self.init()
        guard let first = points.first else { return }
        move(to: first)
        for point in points.dropFirst() {
            addLine(to: point)
        }
    }

    /// 使用至少三个点创建闭合多边形路径
    /// - Parameter points: 点数组,需 ≥3 个点
    /// - Returns: 成功时返回路径,否则返回 `nil`
    convenience init?(polygonWithPoints points: [CGPoint]) {
        guard points.count >= 3 else { return nil }
        self.init()
        move(to: points[0])
        for point in points.dropFirst() {
            addLine(to: point)
        }
        close()
    }

    /// 创建指定尺寸的椭圆路径,可选居中
    /// - Parameters:
    ///   - size: 椭圆的宽高
    ///   - centered: 若为 `true`,椭圆中心位于原点 (0,0);否则左上角在 (0,0)
    convenience init(ovalOf size: CGSize, centered: Bool = false) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(ovalIn: CGRect(origin: origin, size: size))
    }

    /// 创建指定尺寸的矩形路径,可选居中
    /// - Parameters:
    ///   - size: 矩形的宽高
    ///   - centered: 若为 `true`,矩形中心位于原点 (0,0);否则左上角在 (0,0)
    convenience init(rectOf size: CGSize, centered: Bool = false) {
        let origin = centered ? CGPoint(x: -size.width / 2, y: -size.height / 2) : .zero
        self.init(rect: CGRect(origin: origin, size: size))
    }
}

// MARK: - 路径绘制
public extension UIBezierPath {
    /// 添加由三点定义的圆弧(通过外接圆)
    /// - Parameters:
    ///   - startPoint: 起始点
    ///   - middlePoint: 圆弧上的中间点(用于确定圆)
    ///   - endPoint: 终止点
    ///   - clockwise: 是否顺时针绘制
    func dy_addArc(
        from startPoint: CGPoint,
        through middlePoint: CGPoint,
        to endPoint: CGPoint,
        clockwise: Bool
    ) {
        guard let center = self.dy_calculateCircleCenter(
            pointA: startPoint,
            pointB: middlePoint,
            pointC: endPoint
        ) else {
            // 三点共线,无法构成圆 → 改为画直线
            self.move(to: startPoint)
            self.addLine(to: endPoint)
            return
        }

        let radius = self.dy_calculateRadius(center: center, point: startPoint)
        let startAngle = atan2(startPoint.y - center.y, startPoint.x - center.x)
        let endAngle = atan2(endPoint.y - center.y, endPoint.x - center.x)

        self.addArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
    }

    /// 添加以指定圆心和两点定义的圆弧
    /// - Parameters:
    ///   - center: 圆心
    ///   - start: 起始点
    ///   - end: 终止点
    ///   - clockwise: 是否顺时针绘制
    func dy_addArc(
        withCenter center: CGPoint,
        from start: CGPoint,
        to end: CGPoint,
        clockwise: Bool
    ) {
        let radius = self.dy_calculateRadius(center: center, point: start)
        let startAngle = atan2(start.y - center.y, start.x - center.x)
        let endAngle = atan2(end.y - center.y, end.x - center.x)
        self.addArc(
            withCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
    }

    /// 添加矩形子路径
    /// - Parameters:
    ///   - size: 矩形尺寸
    ///   - centered: 是否以当前点为中心绘制
    func dy_addRectangle(size: CGSize, centered: Bool = false) {
        let rect = centered
            ? CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
            : CGRect(origin: .zero, size: size)
        self.append(UIBezierPath(rect: rect))
    }

    /// 添加椭圆子路径
    /// - Parameters:
    ///   - size: 椭圆尺寸
    ///   - centered: 是否以当前点为中心绘制
    func dy_addEllipse(size: CGSize, centered: Bool = false) {
        let rect = centered
            ? CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height)
            : CGRect(origin: .zero, size: size)
        self.append(UIBezierPath(ovalIn: rect))
    }

    /// 添加圆形子路径
    /// - Parameters:
    ///   - radius: 圆半径
    ///   - centered: 是否以当前点为中心绘制
    func dy_addCircle(radius: CGFloat, centered: Bool = false) {
        let diameter = radius * 2
        let rect = centered
            ? CGRect(x: -radius, y: -radius, width: diameter, height: diameter)
            : CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
        self.append(UIBezierPath(ovalIn: rect))
    }

    /// 添加三次贝塞尔曲线
    /// - Parameters:
    ///   - to: 终点
    ///   - controlPoint1: 第一控制点
    ///   - controlPoint2: 第二控制点
    func dy_addCubicCurve(to: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.addCurve(to: to, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    /// 添加带箭头的直线
    /// - Parameters:
    ///   - from: 起点
    ///   - to: 终点
    ///   - headSize: 箭头长度
    ///   - headAngle: 箭头张开角度(默认 30°)
    func dy_addArrow(from: CGPoint, to: CGPoint, headSize: CGFloat, headAngle: CGFloat = .pi / 6) {
        self.move(to: from)
        self.addLine(to: to)

        let angle = atan2(to.y - from.y, to.x - from.x)
        let leftAngle = angle + headAngle
        let rightAngle = angle - headAngle

        let left = CGPoint(
            x: to.x - headSize * cos(leftAngle),
            y: to.y - headSize * sin(leftAngle)
        )
        let right = CGPoint(
            x: to.x - headSize * cos(rightAngle),
            y: to.y - headSize * sin(rightAngle)
        )

        self.move(to: to)
        self.addLine(to: left)
        self.move(to: to)
        self.addLine(to: right)
    }

    /// 添加正多边形(如三角形、五角星基底等)
    /// - Parameters:
    ///   - sides: 边数(≥3)
    ///   - radius: 外接圆半径
    ///   - centered: 是否以 (0,0) 为中心
    func dy_addRegularPolygon(sides: Int, radius: CGFloat, centered: Bool = false) {
        guard sides >= 3, radius > 0 else { return }

        let center = centered ? CGPoint.zero : self.currentPoint
        let angleIncrement = 2 * .pi / CGFloat(sides)

        for i in 0 ..< sides {
            let angle = angleIncrement * CGFloat(i) - .pi / 2 // 从顶部开始
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            let point = CGPoint(x: x, y: y)

            if i == 0 {
                self.move(to: point)
            } else {
                self.addLine(to: point)
            }
        }
        self.close()
    }

    /// 添加由点序列构成的闭合形状
    /// - Parameter points: 点数组(至少 3 个点)
    func dy_addClosedShape(from points: [CGPoint]) {
        guard points.count >= 3 else { return }
        self.move(to: points[0])
        for point in points.dropFirst() {
            self.addLine(to: point)
        }
        self.close()
    }
}

// MARK: - 几何计算辅助方法
private extension UIBezierPath {
    /// 通过三点计算外接圆圆心
    /// - Returns: 圆心坐标,若三点共线则返回 `nil`
    func dy_calculateCircleCenter(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGPoint? {
        // 使用行列式法求解圆心,避免斜率无穷大问题
        let a = pointB.x - pointA.x
        let b = pointB.y - pointA.y
        let c = pointC.x - pointA.x
        let d = pointC.y - pointA.y
        let e = a * (pointA.x + pointB.x) + b * (pointA.y + pointB.y)
        let f = c * (pointA.x + pointC.x) + d * (pointA.y + pointC.y)
        let g = 2 * (a * (pointC.y - pointB.y) - b * (pointC.x - pointB.x))

        guard Swift.abs(g) > .ulpOfOne else { return nil } // 三点共线

        let centerX = (d * e - b * f) / g
        let centerY = (a * f - c * e) / g
        return CGPoint(x: centerX, y: centerY)
    }

    /// 计算两点间距离(即半径)
    func dy_calculateRadius(center: CGPoint, point: CGPoint) -> CGFloat {
        return hypot(point.x - center.x, point.y - center.y)
    }
}
