import DyCore
import UIKit

// MARK: - 气泡弹窗控制器
open class DyBubbleViewController: DyViewController {
    private var sourceView: UIView?

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 公开方法
public extension DyBubbleViewController {
    /// 显示气泡弹窗
    /// - Parameters:
    ///   - from: 父视图控制器
    ///   - sourceView: 气泡指向的源视图（必须提供）
    func show(from parent: UIViewController, sourceView: UIView) {
        self.sourceView = sourceView

        self.dy
            // 设置模态样式为气泡弹窗
            .modalPresentationStyle(.popover)
            // 设置是否禁止通过手势或点击背景关闭气泡弹窗
            .isModalInPresentation(shouldPreventDismissal())

        self.popoverPresentationController?.dy
            // 代理
            .delegate(self)
            // 允许的箭头方向
            .permittedArrowDirections(permittedArrowDirections())
            // 是否允许气泡覆盖源视图区域
            .canOverlapSourceViewRect(canOverlapSourceViewRect())
            // 气泡箭头指向的源视图
            .sourceView(sourceView)
            // 源视图内的定位矩形
            .sourceRect(sourceRect(for: sourceView))
            // 自定义背景类
            .popoverBackgroundViewClass(popoverBackgroundViewClass())

        parent.present(self, animated: true)
    }
}

// MARK: - 子类可重写配置
@objc extension DyBubbleViewController {
    /// 是否禁止通过点击外部或手势关闭气泡
    /// - Returns: 默认 `false`（允许关闭）
    open func shouldPreventDismissal() -> Bool {
        return false
    }

    /// 允许的箭头方向
    /// - Returns: 默认 `.any`
    open func permittedArrowDirections() -> UIPopoverArrowDirection {
        return .any
    }

    /// 是否允许气泡覆盖源视图区域
    /// - Returns: 默认 `true`
    open func canOverlapSourceViewRect() -> Bool {
        return true
    }

    /// 气泡在源视图内的定位矩形
    /// - Parameter sourceView: 源视图
    /// - Returns: 默认 `sourceView.bounds`
    open func sourceRect(for sourceView: UIView) -> CGRect {
        return sourceView.bounds
    }

    /// 返回自定义背景类
    /// - Returns: 默认 `nil`
    open func popoverBackgroundViewClass() -> (any UIPopoverBackgroundViewMethods.Type)? {
        return nil
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension DyBubbleViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }
}
