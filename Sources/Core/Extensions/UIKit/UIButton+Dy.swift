import UIKit

/// 关联属性键:记录每个 `UIControl.Event` 上一次添加的 `UIAction`,便于更新时先移除旧的
var dy_registeredActionsKey: UInt8 = 0

// MARK: - 属性
public extension UIButton {
    /// 按钮的常用状态
    var dy_allStates: [UIControl.State] {
        return [.normal, .selected, .highlighted, .disabled]
    }
}

// MARK: - 计算按钮尺寸
public extension UIButton {
    /// 获取指定宽度下按钮标题的`CGSize`
    /// - Parameter maxWidth: 最大行宽度
    /// - Returns: 标题的`size`
    func dy_size(maxWidth: CGFloat? = nil) -> CGSize {
        let maxWidth = maxWidth ?? DyScreen.screenWidth
        return if let currentAttributedTitle = self.currentAttributedTitle {
            currentAttributedTitle.dy_size(maxWidth: maxWidth)
        } else {
            self.titleLabel?.dy_size(maxWidth: maxWidth) ?? .zero
        }
    }
}

// MARK: - 扩大按钮点击区域
extension UIButton {
    /// 关联属性键(使用稳定内存地址作为 key)
    public enum Keys {
        /// 扩展点击区域大小
        static var dy_expandSizeKey: UInt8 = 0
    }

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
        if let expandSize: CGFloat = self.dy_getAssociatedObject(forKey: &Keys.dy_expandSizeKey) {
            return CGRect(
                x: bounds.origin.x - expandSize,
                y: bounds.origin.y - expandSize,
                width: bounds.size.width + 2 * expandSize,
                height: bounds.size.height + 2 * expandSize
            )
        }
        return self.bounds
    }
}
