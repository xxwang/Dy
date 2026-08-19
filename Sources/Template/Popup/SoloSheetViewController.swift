import UIKit
import SoloCore

// MARK: - 底部抽屉控制器
@available(iOS 15.0, *)
open class SoloSheetViewController: SoloViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 子类可重写
@available(iOS 15.0, *)
@objc extension SoloSheetViewController {
    /// 显示底部抽屉
    /// - Parameter parent: 父视图控制器
    open func show(from parent: UIViewController) {
        self
            .solo
            // 设置模态样式为底部抽屉
            .modalPresentationStyle(.pageSheet)
            // 设置是否禁止通过手势或点击背景关闭抽屉
            .isModalInPresentation(shouldPreventDismissal())

        self.sheetPresentationController?
            .solo
            // 抽屉档位
            .detents(sheetDetents())
            // 是否显示顶部小横条
            .prefersGrabberVisible(prefersGrabberVisible())
            // 设置最大不暗化档位（小于此档位背景变暗）
            .largestUndimmedDetentIdentifier(largestUndimmedDetentIdentifier())
            // 紧凑高度下是否从底部边缘附着
            .prefersEdgeAttachedInCompactHeight(prefersEdgeAttachedInCompactHeight())

        parent.present(self, animated: true)
    }

    /// 是否禁止用户通过下拉或点击背景关闭抽屉
    /// - Returns: 默认 `false`（允许关闭）
    open func shouldPreventDismissal() -> Bool {
        return false
    }

    /// 返回抽屉支持的档位
    /// - Returns: 默认 `[.medium(), .large()]`
    ///    iOS16可以自定义高度
    ///
    ///        .custom(identifier: .init("custom100"), resolver: { context in
    ///            return 100
    ///        })
    open func sheetDetents() -> [UISheetPresentationController.Detent] {
        return [.medium(), .large()]
    }

    /// 是否显示顶部小横条（grabber）
    /// - Returns: 默认 `true`
    open func prefersGrabberVisible() -> Bool {
        return true
    }

    /// 最大不暗化档位（小于此档位背景变暗）
    /// - Returns: 默认 `.medium`
    open func largestUndimmedDetentIdentifier() -> UISheetPresentationController.Detent.Identifier? {
        return .medium
    }

    /// 紧凑高度下是否从底部边缘附着（如 iPhone 竖屏）
    /// - Returns: 默认 `true`
    open func prefersEdgeAttachedInCompactHeight() -> Bool {
        return true
    }
}

// MARK: - UISheetPresentationControllerDelegate
@available(iOS 15.0, *)
extension SoloSheetViewController: UISheetPresentationControllerDelegate {
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
}
