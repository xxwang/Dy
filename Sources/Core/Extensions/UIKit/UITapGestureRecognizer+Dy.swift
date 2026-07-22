import UIKit

// MARK: - 链式设置属性
public extension UITapGestureRecognizer {
    /// 设置触发点击手势所需的点击次数
    /// - Parameter count: 点击次数（如单击=1，双击=2），默认为 1
    /// - Returns: `Self`
    @discardableResult
    func dy_numberOfTapsRequired(_ count: Int) -> Self {
        self.numberOfTapsRequired = count
        return self
    }

    /// 设置触发点击手势所需的同时触摸点数量
    /// - Parameter count: 触摸点数量（如 1 指、2 指点击），默认为 1
    /// - Returns: `Self`
    @discardableResult
    func dy_numberOfTouchesRequired(_ count: Int) -> Self {
        self.numberOfTouchesRequired = count
        return self
    }

    /// 设置触发点击所需匹配的按钮掩码（用于外接鼠标或触控板）
    /// - Parameter mask: 按钮类型掩码（如主按钮、副按钮等）
    /// - Returns: `Self`
    @available(iOS 13.4, *)
    @discardableResult
    func dy_buttonMaskRequired(_ mask: UIEvent.ButtonMask) -> Self {
        self.buttonMaskRequired = mask
        return self
    }
}
