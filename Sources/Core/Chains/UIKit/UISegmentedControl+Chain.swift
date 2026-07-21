import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UISegmentedControl {
    /// 设置选中的分段索引
    /// - Parameter index: 分段索引(设为 `UISegmentedControl.noSegment` 可取消选中)
    /// - Returns: `Self`
    @discardableResult
    func selectedSegmentIndex(_ index: Int) -> Self {
        base.selectedSegmentIndex = index
        return self
    }

    /// 设置背景图片(针对指定状态)
    /// - Parameters:
    ///   - image: 背景图片(可为 `nil` 以移除)
    ///   - state: 控件状态(如 `.normal`, `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func backgroundImage(_ image: UIImage?, for state: UIControl.State) -> Self {
        base.setBackgroundImage(image, for: state, barMetrics: .default)
        return self
    }

    /// 设置分段之间的分割线图片
    /// - Parameters:
    ///   - image: 分割线图片
    ///   - leftSegmentState: 左侧分段状态
    ///   - rightSegmentState: 右侧分段状态
    /// - Returns: `Self`
    @discardableResult
    func dividerImage(_ image: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State) -> Self {
        base.setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: .default)
        return self
    }

    /// 设置是否为瞬时模式(按下即触发,不保持选中状态)
    /// - Parameter isMomentary: 是否瞬时
    /// - Returns: `Self`
    @discardableResult
    func isMomentary(_ isMomentary: Bool) -> Self {
        base.isMomentary = isMomentary
        return self
    }

    /// 设置是否根据内容自动调整分段宽度
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func apportionsSegmentWidthsByContent(_ enabled: Bool) -> Self {
        base.apportionsSegmentWidthsByContent = enabled
        return self
    }

    /// 设置指定分段的宽度
    /// - Parameters:
    ///   - width: 宽度(设为 `0` 表示自动)
    ///   - index: 分段索引
    /// - Returns: `Self`
    @discardableResult
    func width(_ width: CGFloat, forSegmentAt index: Int) -> Self {
        base.setWidth(width, forSegmentAt: index)
        return self
    }

    /// 设置`tintColor`(影响选中状态颜色、指示器等)
    /// - Parameter color: 主色调
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 设置分段标题的文本属性(如字体、颜色)
    /// - Parameters:
    ///   - attributes: 文本属性字典
    ///   - state: 控件状态(如 `.normal`, `.selected`)
    /// - Returns: `Self`
    @discardableResult
    func titleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for state: UIControl.State) -> Self {
        base.setTitleTextAttributes(attributes, for: state)
        return self
    }

    /// 启用或禁用指定分段
    /// - Parameters:
    ///   - isEnabled: 是否启用
    ///   - index: 分段索引
    /// - Returns: `Self`
    @discardableResult
    func enabled(_ isEnabled: Bool, forSegmentAt index: Int) -> Self {
        base.setEnabled(isEnabled, forSegmentAt: index)
        return self
    }
}
