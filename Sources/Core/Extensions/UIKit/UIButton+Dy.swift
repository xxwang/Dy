import UIKit

// MARK: - 属性
public extension UIButton {
    /// 关联属性键
    fileprivate enum DyKeys {
        /// 扩展点击区域大小
        static var expandSizeKey: UInt8 = 0
    }

    /// 按钮的常用状态
    var dy_allStates: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
}

// MARK: - 扩大按钮点击区域
extension UIButton {
    /// 重写点触及范围检测
    /// - Parameter point: 当前触摸点的坐标
    /// - Parameter event: 当前的触摸事件
    /// - Returns: 如果触摸点在扩展的区域内,则返回 `true`,否则返回 `false`
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let expandedRect = self.dy_expandedRect()
        // 如果没有扩展范围,则使用原始范围
        if expandedRect.equalTo(bounds) {
            return super.point(inside: point, with: event)
        } else {
            return expandedRect.contains(point)
        }
    }

    /// 获取扩展的点击区域,如果没有设置扩展范围,则使用按钮的原始大小
    func dy_expandedRect() -> CGRect {
        if let expandSize: CGFloat = self.dy_GetAO(forKey: &DyKeys.expandSizeKey) {
            return CGRect(
                x: bounds.origin.x - expandSize,
                y: bounds.origin.y - expandSize,
                width: bounds.size.width + 2 * expandSize,
                height: bounds.size.height + 2 * expandSize
            )
        }
        return self.bounds
    }

    /// 扩大按钮的点击区域
    /// - Parameter size: 向四周扩展的像素大小
    /// - Returns: `Self`
    @discardableResult
    func dy_expandClickArea(_ size: CGFloat = 10) -> Self {
        self.dy_SetAO(size, forKey: &UIButton.DyKeys.expandSizeKey)
        return self
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下按钮标题的`CGSize`
    /// - Parameter maxWidth: 最大行宽度
    /// - Returns: 标题的`size`
    func dy_viewSize(maxWidth: CGFloat? = nil) -> CGSize {
        let maxWidth = maxWidth ?? DyScreen.screenWidth
        return if let currentAttributedTitle = self.currentAttributedTitle {
            currentAttributedTitle.dy_viewSize(maxWidth: maxWidth)
        } else {
            self.titleLabel?.dy_viewSize(maxWidth: maxWidth) ?? .zero
        }
    }
}
