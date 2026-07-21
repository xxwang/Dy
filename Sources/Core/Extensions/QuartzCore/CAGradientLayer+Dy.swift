import QuartzCore
import UIKit

// MARK: - 便捷构造器
public extension CAGradientLayer {
    /// 创建并配置一个 `CAGradientLayer` 实例
    /// - Parameters:
    ///   - frame: 图层的初始 frame(默认 `.zero`)
    ///   - colors: 渐变颜色数组(必填,至少一个颜色)
    ///   - locations: 颜色位置数组(可选,若提供需与 `colors` 长度一致)
    ///   - startPoint: 渐变起点(归一化坐标,默认顶部中心 `(0.5, 0.0)`)
    ///   - endPoint: 渐变终点(归一化坐标,默认底部中心 `(0.5, 1.0)`)
    ///   - type: 渐变类型(默认 `.axial` 线性渐变)
    convenience init(
        frame: CGRect = .zero,
        colors: [UIColor],
        locations: [CGFloat]? = nil,
        startPoint: CGPoint = CGPoint(x: 0.5, y: 0.0),
        endPoint: CGPoint = CGPoint(x: 0.5, y: 1.0),
        type: CAGradientLayerType = .axial
    ) {
        self.init()
        guard !colors.isEmpty else {
            assertionFailure("CAGradientLayer requires at least one color.")
            return
        }
        self
            .dy
            .frame(frame)
            .colors(colors)
            .locations(locations)
            .startPoint(startPoint)
            .endPoint(endPoint)
            .type(type)
    }
}
