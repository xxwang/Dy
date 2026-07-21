import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIViewController {
    /// 强制覆盖用户界面样式(亮色/暗色模式)
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        base.overrideUserInterfaceStyle = style
        return self
    }

    /// 设置模态呈现样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        base.modalPresentationStyle = style
        return self
    }

    /// 设置内容大小
    /// - Parameter size: 内容大小
    /// - Returns: `Self`
    @discardableResult
    func preferredContentSize(_ size: CGSize) -> Self {
        base.preferredContentSize = size
        return self
    }

    /// 设置是否禁止通过手势或点击背景关闭抽屉
    /// - Parameter isModalInPresentation: `true` 表示强制模态（不可关闭），`false` 表示允许关闭（默认）
    /// - Returns: `Self`
    @discardableResult
    func isModalInPresentation(_ isModalInPresentation: Bool) -> Self {
        base.isModalInPresentation = isModalInPresentation
        return self
    }
}

// MARK: - 自定义
@MainActor
public extension DyWrapper where Base: UIViewController {
    /// 安全地将子控制器添加到指定容器视图
    ///
    /// - Parameters:
    ///   - child: 要添加的子视图控制器
    ///   - containerView: 容器视图(必须已加入视图层级,否则子视图不可见)
    ///
    /// - 注意：自动完成完整的子控制器生命周期调用：
    ///   `addChild(_:)` → `addSubview(_:)` → `didMove(toParent:)`
    @discardableResult
    func addChild(_ child: UIViewController, to containerView: UIView) -> Self {
        base.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: base)
        return self
    }

    /// 从父控制器中安全移除自身(包括视图和生命周期回调)
    ///
    /// - 注意：仅当 `parent != nil` 时执行移除操作
    ///   自动完成：`willMove(toParent: nil)` → `removeFromSuperview()` → `removeFromParent()`
    @discardableResult
    func removeFromParent() -> Self {
        guard base.parent != nil else { return self }
        base.willMove(toParent: nil)
        base.view.removeFromSuperview()
        base.removeFromParent()
        return self
    }
}
