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
        self.dy_frame(frame)
            .dy_colors(colors)
            .dy_locations(locations)
            .dy_startPoint(startPoint)
            .dy_endPoint(endPoint)
            .dy_type(type)
    }
}

// MARK: - 链式属性设置
public extension CAGradientLayer {
    /// 设置渐变类型
    /// - Parameter type: 渐变类型
    ///   - `.axial`：线性渐变(默认)
    ///   - `.radial`：径向渐变(iOS 12+)
    /// - Returns: `Self`
    @discardableResult
    func dy_type(_ type: CAGradientLayerType) -> Self {
        self.type = type
        return self
    }

    /// 设置渐变颜色数组
    /// - Parameter colors: 颜色数组(至少包含一个颜色)
    /// - Important: 若数组为空,将被忽略以避免崩溃
    /// - Returns: `Self`
    @discardableResult
    func dy_colors(_ colors: [UIColor]) -> Self {
        guard !colors.isEmpty else { return self }
        self.colors = colors.map(\.cgColor)
        return self
    }

    /// 设置每个颜色在渐变中的位置
    /// - Parameter locations: 位置数组,每个值应在 `[0.0, 1.0]` 范围内,
    ///   且必须与 `colors` 数量一致(若提供)
    /// - Note: 若传入 `nil` 或空数组,系统将自动生成均匀分布的位置
    /// - Warning: 若 `locations.count != colors.count`,行为未定义(可能崩溃)
    /// - Returns: `Self`
    @discardableResult
    func dy_locations(_ locations: [CGFloat]?) -> Self {
        guard let locations, !locations.isEmpty else {
            self.locations = nil
            return self
        }

        self.locations = locations.map {
            NSNumber(value: $0)
        }
        return self
    }

    /// 设置渐变起始点(归一化坐标)
    /// - Parameter startPoint: 起始点,默认 `(0.5, 0.0)` 表示顶部中心
    /// - Note: 坐标系原点在左上角,`(0,0)` = 左上,`(1,1)` = 右下
    /// - Returns: `Self`
    @discardableResult
    func dy_startPoint(_ startPoint: CGPoint) -> Self {
        self.startPoint = startPoint
        return self
    }

    /// 设置渐变结束点(归一化坐标)
    /// - Parameter endPoint: 结束点,默认 `(0.5, 1.0)` 表示底部中心
    /// - Returns: `Self`
    @discardableResult
    func dy_endPoint(_ endPoint: CGPoint) -> Self {
        self.endPoint = endPoint
        return self
    }

    /// 设置图层的时间缩放因子(继承自 `CALayer`)
    /// - Parameter speed: 时间缩放倍率默认为 `1.0`
    ///   - `speed = 2.0`：动画播放速度加快 2 倍
    ///   - `speed = 0.0`：暂停所有隐式/显式动画
    /// - Note: 此属性不影响静态渐变外观,仅影响动画
    /// - Returns: `Self`
    @discardableResult
    func dy_speed(_ speed: Float) -> Self {
        self.speed = speed
        return self
    }
}
