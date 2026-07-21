import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UISwitch {
    /// 设置开关的开启/关闭状态
    ///
    /// - Parameter isOn: `true` 表示开启,`false` 表示关闭
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func isOn(_ isOn: Bool) -> Self {
        base.isOn = isOn
        return self
    }

    /// 设置开关处于“开启”状态时的背景颜色(即轨道颜色)
    ///
    /// - Parameter color: 开启时的颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func onTintColor(_ color: UIColor?) -> Self {
        base.onTintColor = color
        return self
    }

    /// 设置开关处于“关闭”状态时的背景颜色(即轨道颜色)
    /// 对应 `UIView.tintColor` 属性(继承自父类)
    ///
    /// - Parameter color: 关闭时的颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 设置滑块`thumb`的颜色
    ///
    /// - Parameter color: 滑块颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func thumbTintColor(_ color: UIColor?) -> Self {
        base.thumbTintColor = color
        return self
    }
}

// MARK: - 方法(自定义)
public extension DyWrapper where Base: UISwitch {
    /// 切换当前开关状态(开 ↔ 关),可选带动画
    ///
    /// - Parameter animated: 是否启用切换动画默认为 `true`
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func toggle(_ animated: Bool = true) -> Self {
        base.setOn(!base.isOn, animated: animated)
        return self
    }
}
