import QuartzCore
import UIKit

// MARK: - 属性
public extension CAShapeLayer {
    /// 设置绘制路径
    /// - Parameter path: 要绘制的 `CGPath`(可由 `UIBezierPath` 转换而来)
    /// - Returns: `Self`
    @discardableResult
    func dy_path(_ path: CGPath) -> Self {
        self.path = path
        return self
    }

    /// 设置图层内容缩放比例(适配 Retina 屏幕)
    /// - Parameter scale: 缩放因子,默认为主屏幕 scale
    /// - Important: 若不设置,高分辨率设备上路径可能模糊
    /// - Returns: `Self`
    @discardableResult
    func dy_contentsScale(_ scale: CGFloat = DyScreen.screenScale) -> Self {
        self.contentsScale = scale
        return self
    }

    /// 设置填充颜色(使用 `UIColor`)
    /// - Parameter color: 填充色;传 `nil` 可清除填充
    /// - Returns: `Self`
    @discardableResult
    func dy_fillColor(_ color: UIColor?) -> Self {
        self.fillColor = color?.cgColor
        return self
    }

    /// 设置填充颜色(使用 `CGColor`)
    /// - Parameter color: 填充色;传 `nil` 可清除填充
    /// - Returns: `Self`
    @discardableResult
    func dy_fillColor(_ color: CGColor?) -> Self {
        self.fillColor = color
        return self
    }

    /// 设置描边(笔触)颜色(使用 `UIColor`)
    /// - Parameter color: 描边色;传 `nil` 可清除描边
    /// - Returns: `Self`
    @discardableResult
    func dy_strokeColor(_ color: UIColor?) -> Self {
        self.strokeColor = color?.cgColor
        return self
    }

    /// 设置描边(笔触)颜色(使用 `CGColor`)
    /// - Parameter color: 描边色;传 `nil` 可清除描边
    /// - Returns: `Self`
    @discardableResult
    func dy_strokeColor(_ color: CGColor?) -> Self {
        self.strokeColor = color
        return self
    }

    /// 设置线宽
    /// - Parameter width: 线宽(必须 ≥ 0,默认 `1.0`)
    /// - Returns: `Self`
    @discardableResult
    func dy_lineWidth(_ width: CGFloat) -> Self {
        self.lineWidth = max(width, 0)
        return self
    }

    /// 设置最大斜接长度(用于尖角连接)
    /// - Parameter miterLimit: 斜接限制(必须 ≥ 0,默认 `10.0`)
    ///   当斜接长度超过此值时,会转为 `bevel` 连接
    /// - Returns: `Self`
    @discardableResult
    func dy_miterLimit(_ miterLimit: CGFloat) -> Self {
        self.miterLimit = max(miterLimit, 0)
        return self
    }

    /// 设置线帽样式(路径端点外观)
    /// - Parameter lineCap:
    ///   - `.butt`：平头(默认)
    ///   - `.round`：圆头
    ///   - `.square`：方头(延伸半个线宽)
    /// - Returns: `Self`
    @discardableResult
    func dy_lineCap(_ lineCap: CAShapeLayerLineCap) -> Self {
        self.lineCap = lineCap
        return self
    }

    /// 设置线条连接样式(路径拐角外观)
    /// - Parameter lineJoin:
    ///   - `.miter`：尖角(受 `miterLimit` 限制)
    ///   - `.round`：圆角
    ///   - `.bevel`：斜切
    /// - Returns: `Self`
    @discardableResult
    func dy_lineJoin(_ lineJoin: CAShapeLayerLineJoin) -> Self {
        self.lineJoin = lineJoin
        return self
    }

    /// 设置虚线模板(使用 `CGFloat` 数组,更符合 Swift 习惯)
    /// - Parameter pattern: 虚线模式,格式为 `[onLength, offLength, onLength, ...]`
    ///   例如：`[5, 3]` 表示 5pt 实线 + 3pt 空隙,循环重复
    /// - Note: 数组长度应为偶数,且所有值 ≥ 0
    /// - Returns: `Self`
    @discardableResult
    func dy_lineDashPattern(_ pattern: [CGFloat]) -> Self {
        self.lineDashPattern = pattern.map { NSNumber(value: $0) }
        return self
    }

    /// 设置虚线相位(起始偏移)
    /// - Parameter phase: 虚线起始偏移量(单位：point)
    /// - Returns: `Self`
    @discardableResult
    func dy_lineDashPhase(_ phase: CGFloat) -> Self {
        self.lineDashPhase = phase
        return self
    }

    /// 设置路径填充规则
    /// - Parameter fillRule:
    ///   - `.nonZero`：非零环绕规则(默认)
    ///   - `.evenOdd`：奇偶规则(适用于镂空图形)
    /// - Returns: `Self`
    @discardableResult
    func dy_fillRule(_ fillRule: CAShapeLayerFillRule) -> Self {
        self.fillRule = fillRule
        return self
    }

    /// 设置描边起始位置(用于绘制动画)
    /// - Parameter start: 起始比例,范围 `[0.0, 1.0]`(默认 `0.0`)
    ///   `0.0` = 路径起点,`1.0` = 路径终点
    /// - Returns: `Self`
    @discardableResult
    func dy_strokeStart(_ start: CGFloat) -> Self {
        self.strokeStart = min(max(start, 0), 1)
        return self
    }

    /// 设置描边结束位置(用于绘制动画)
    /// - Parameter end: 结束比例,范围 `[0.0, 1.0]`(默认 `1.0`)
    /// - Returns: `Self`
    @discardableResult
    func dy_strokeEnd(_ end: CGFloat) -> Self {
        self.strokeEnd = min(max(end, 0), 1)
        return self
    }

    /// 设置是否翻转几何坐标系(Y 轴方向)
    /// - Parameter isFlipped: `true` 时 Y 轴向下为正(UIKit 默认),`false` 向上为正(Quartz 默认)
    /// - Note: 大多数情况下应保持 `true` 以匹配 UIKit
    /// - Returns: `Self`
    @discardableResult
    func dy_isGeometryFlipped(_ isFlipped: Bool) -> Self {
        self.isGeometryFlipped = isFlipped
        return self
    }
}
