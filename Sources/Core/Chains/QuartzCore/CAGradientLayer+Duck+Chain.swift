import QuartzCore
import UIKit

// MARK: - 属性
public extension DyWrapper where Base: CAGradientLayer {
    /// 设置渐变类型
    /// - Parameter type: 渐变类型
    ///   - `.axial`：线性渐变(默认)
    ///   - `.radial`：径向渐变(iOS 12+)
    /// - Returns: `Self`
    @discardableResult
    func type(_ type: CAGradientLayerType) -> Self {
        base.type = type
        return self
    }

    /// 设置渐变颜色数组
    /// - Parameter colors: 颜色数组(至少包含一个颜色)
    /// - Important: 若数组为空,将被忽略以避免崩溃
    /// - Returns: `Self`
    @discardableResult
    func colors(_ colors: [UIColor]) -> Self {
        guard !colors.isEmpty else { return self }
        base.colors = colors.map(\.cgColor)
        return self
    }

    /// 设置每个颜色在渐变中的位置
    /// - Parameter locations: 位置数组,每个值应在 `[0.0, 1.0]` 范围内,
    ///   且必须与 `colors` 数量一致(若提供)
    /// - Note: 若传入 `nil` 或空数组,系统将自动生成均匀分布的位置
    /// - Warning: 若 `locations.count != colors.count`,行为未定义(可能崩溃)
    /// - Returns: `Self`
    @discardableResult
    func locations(_ locations: [CGFloat]?) -> Self {
        guard let locations, !locations.isEmpty else {
            base.locations = nil
            return self
        }

        base.locations = locations.map {
            NSNumber(value: $0)
        }
        return self
    }

    /// 设置渐变起始点(归一化坐标)
    /// - Parameter startPoint: 起始点,默认 `(0.5, 0.0)` 表示顶部中心
    /// - Note: 坐标系原点在左上角,`(0,0)` = 左上,`(1,1)` = 右下
    /// - Returns: `Self`
    @discardableResult
    func startPoint(_ startPoint: CGPoint) -> Self {
        base.startPoint = startPoint
        return self
    }

    /// 设置渐变结束点(归一化坐标)
    /// - Parameter endPoint: 结束点,默认 `(0.5, 1.0)` 表示底部中心
    /// - Returns: `Self`
    @discardableResult
    func endPoint(_ endPoint: CGPoint) -> Self {
        base.endPoint = endPoint
        return self
    }

    /// 设置图层的时间缩放因子(继承自 `CALayer`)
    /// - Parameter speed: 时间缩放倍率默认为 `1.0`
    ///   - `speed = 2.0`：动画播放速度加快 2 倍
    ///   - `speed = 0.0`：暂停所有隐式/显式动画
    /// - Note: 此属性不影响静态渐变外观,仅影响动画
    /// - Returns: `Self`
    @discardableResult
    func speed(_ speed: Float) -> Self {
        base.speed = speed
        return self
    }
}
