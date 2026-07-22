import UIKit

// MARK: - 链式设置属性
public extension UISlider {
    /// 设置滑块的当前值
    ///
    /// - Parameter value: 要设置的值若超出 `[minimumValue, maximumValue]` 范围,
    ///   系统会自动将其限制在有效区间内
    /// - Returns: `Self`
    @discardableResult
    func dy_value(_ value: Float) -> Self {
        self.value = value
        return self
    }

    /// 设置滑块的最小值
    ///
    /// - Parameter minimumValue: 最小值(默认为 `0.0`)
    /// - Returns: `Self`
    @discardableResult
    func dy_minimumValue(_ minimumValue: Float) -> Self {
        self.minimumValue = minimumValue
        return self
    }

    /// 设置滑块的最大值
    ///
    /// - Parameter maximumValue: 最大值(默认为 `1.0`)
    /// - Returns: `Self`
    @discardableResult
    func dy_maximumValue(_ maximumValue: Float) -> Self {
        self.maximumValue = maximumValue
        return self
    }

    /// 设置显示在滑块最小值位置的图像(通常在左侧)
    ///
    /// - Parameter image: 要显示的图像,传入 `nil` 可移除
    /// - Returns: `Self`
    @discardableResult
    func dy_minimumValueImage(_ image: UIImage?) -> Self {
        self.minimumValueImage = image
        return self
    }

    /// 设置显示在滑块最大值位置的图像(通常在右侧)
    ///
    /// - Parameter image: 要显示的图像,传入 `nil` 可移除
    /// - Returns: `Self`
    @discardableResult
    func dy_maximumValueImage(_ image: UIImage?) -> Self {
        self.maximumValueImage = image
        return self
    }

    /// 设置滑块是否连续发送值变更事件
    ///
    /// - Parameter isContinuous:
    ///   - `true`(默认)：拖动过程中持续触发 `valueChanged` 事件
    ///   - `false`：仅在拖动结束时触发一次事件
    /// - Returns: `Self`
    @discardableResult
    func dy_isContinuous(_ isContinuous: Bool) -> Self {
        self.isContinuous = isContinuous
        return self
    }

    /// 设置滑块“已滑过”部分(最小值侧)轨道的颜色
    ///
    /// - Parameter color: 轨道颜色,传入 `nil` 使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func dy_minimumTrackTintColor(_ color: UIColor?) -> Self {
        self.minimumTrackTintColor = color
        return self
    }

    /// 设置滑块“未滑过”部分(最大值侧)轨道的颜色
    ///
    /// - Parameter color: 轨道颜色,传入 `nil` 使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func dy_maximumTrackTintColor(_ color: UIColor?) -> Self {
        self.maximumTrackTintColor = color
        return self
    }

    /// 设置滑块拖动手柄(`thumb`)的颜色
    ///
    /// - Parameter color: 手柄颜色,传入 `nil` 使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func dy_thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
}
