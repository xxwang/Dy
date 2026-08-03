import CoreGraphics

// MARK: - 构造方法
public extension CGRect {
    /// 使用中心点和尺寸初始化矩形
    /// - Parameters:
    ///   - center: 矩形的中心坐标
    ///   - size: 矩形的尺寸
    init(center: CGPoint, size: CGSize) {
        self.init(
            origin: CGPoint(
                x: center.x - size.width / 2,
                y: center.y - size.height / 2
            ),
            size: size
        )
    }

    /// 使用锚点位置和尺寸初始化矩形
    /// - Parameters:
    ///   - anchorPoint: 归一化锚点 (0～1),如 (0,0)=左上, (1,1)=右下
    ///   - size: 矩形尺寸
    ///   - position: 锚点在坐标系中的绝对位置
    init(anchorPoint: CGPoint, size: CGSize, at position: CGPoint) {
        self.init(
            origin: CGPoint(
                x: position.x - size.width * anchorPoint.x,
                y: position.y - size.height * anchorPoint.y
            ),
            size: size
        )
    }
}

// MARK: - 属性
public extension DyWrapper where Base == CGRect {
    /// 矩形的中心点(基于 origin + size 计算)
    var center: CGPoint {
        CGPoint(x: base.midX, y: base.midY)
    }

    /// 矩形自身的中心偏移量(基于自身 bounds 坐标系)
    /// 主要用于锚点计算,通常不直接使用
    var localCenter: CGPoint {
        CGPoint(x: base.width / 2, y: base.height / 2)
    }
}

// MARK: - 变换
public extension DyWrapper where Base == CGRect {
    /// 返回以指定锚点缩放至目标尺寸的新矩形
    ///
    /// 锚点 `(0, 0)` 表示左上角,`(1, 1)` 表示右下角
    ///
    /// - Parameters:
    ///   - to: 目标尺寸
    ///   - anchorPoint: 归一化锚点,默认为中心 `(0.5, 0.5)`
    /// - Returns: 缩放后的矩形
    ///
    /// - Example:
    ///     ```swift
    ///     let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
    ///     let resized = rect.dy.resizing(to: CGSize(width: 150, height: 150), anchorPoint: CGPoint(x: 0, y: 1))
    ///     // Result: CGRect(x: 0, y: -50, width: 150, height: 150)
    ///     ```
    func resizing(to size: CGSize, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        let deltaWidth = size.width - base.width
        let deltaHeight = size.height - base.height
        let newOrigin = CGPoint(
            x: base.minX - deltaWidth * anchorPoint.x,
            y: base.minY - deltaHeight * anchorPoint.y
        )
        return CGRect(origin: newOrigin, size: size)
    }

    /// 按比例缩放矩形,以指定锚点为中心
    /// - Parameters:
    ///   - scale: 缩放因子(1.0 = 原尺寸)
    ///   - anchorPoint: 归一化锚点
    /// - Returns: 缩放后的矩形
    func scaled(by scale: CGFloat, anchorPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)) -> CGRect {
        self.resizing(
            to: CGSize(width: base.width * scale, height: base.height * scale),
            anchorPoint: anchorPoint
        )
    }
}
