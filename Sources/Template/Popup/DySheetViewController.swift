import UIKit
import DyCore

// MARK: - 底部抽屉控制器
@available(iOS 15.0, *)
open class DySheetViewController: DyViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 公开方法
@available(iOS 15.0, *)
public extension DySheetViewController {
    /// 显示底部抽屉
    /// - Parameter parent: 父视图控制器
    func show(from parent: UIViewController) {
        self.dy_modalPresentationStyle(.pageSheet) // 设置模态样式为底部抽屉
            .dy_isModalInPresentation(shouldPreventDismissal()) // 设置是否禁止通过手势或点击背景关闭抽屉

        self.sheetPresentationController?
            .dy_detents(sheetDetents()) // 抽屉档位
            .dy_prefersGrabberVisible(prefersGrabberVisible()) // 是否显示顶部小横条
            .dy_largestUndimmedDetentIdentifier(largestUndimmedDetentIdentifier() ?? .medium) // 设置最大不暗化档位（小于此档位背景变暗）
            .dy_prefersEdgeAttachedInCompactHeight(prefersEdgeAttachedInCompactHeight()) // 紧凑高度下是否从底部边缘附着

        parent.present(self, animated: true)
    }
}

// MARK: - 子类可重写配置
@available(iOS 15.0, *)
@objc extension DySheetViewController {
    /// 是否禁止用户通过下拉或点击背景关闭抽屉
    /// - Returns: 默认 `false`（允许关闭）
    open func shouldPreventDismissal() -> Bool {
        return false
    }

    /// 返回抽屉支持的档位
    /// - Returns: 默认 `[.medium(), .large()]`
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
