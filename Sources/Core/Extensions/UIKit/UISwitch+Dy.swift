import UIKit

// MARK: - 链式设置属性
public extension UISwitch {
    /// 设置开关的开启/关闭状态
    ///
    /// - Parameter isOn: `true` 表示开启,`false` 表示关闭
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_isOn(_ isOn: Bool) -> Self {
        self.isOn = isOn
        return self
    }

    /// 设置开关处于“开启”状态时的背景颜色(即轨道颜色)
    ///
    /// - Parameter color: 开启时的颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_onTintColor(_ color: UIColor?) -> Self {
        self.onTintColor = color
        return self
    }

    /// 设置开关处于“关闭”状态时的背景颜色(即轨道颜色)
    /// 对应 `UIView.tintColor` 属性(继承自父类)
    ///
    /// - Parameter color: 关闭时的颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    override func dy_tintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    /// 设置滑块`thumb`的颜色
    ///
    /// - Parameter color: 滑块颜色,传入 `nil` 将使用系统默认色
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_thumbTintColor(_ color: UIColor?) -> Self {
        self.thumbTintColor = color
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UISwitch {
    /// 切换当前开关状态(开 ↔ 关),可选带动画
    ///
    /// - Parameter animated: 是否启用切换动画默认为 `true`
    /// - Returns: 当前实例(支持链式调用)
    @discardableResult
    func dy_toggle(_ animated: Bool = true) -> Self {
        self.setOn(!self.isOn, animated: animated)
        return self
    }
}
