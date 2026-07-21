import UIKit

// MARK: - 页面跳转
@MainActor
public extension DyWrapper where Base: UIViewController {
    /// 以`Modal`形式显示控制器
    /// - Parameters:
    ///   - viewController: 要显示的控制器
    ///   - fullScreen: 是否以全屏模式展示(默认为`true`)
    ///   - animated: 是否动画(默认为`true`)
    ///   - completion: 完成回调(可选)
    func present(
        _ viewController: UIViewController,
        fullScreen: Bool = true,
        animated: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        base.present(viewController, animated: animated, completion: completion)
    }

    /// 将控制器 `Push` 到导航栈
    ///
    /// - Parameters:
    ///   - viewController: 要 Push 的控制器
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Note: 若当前控制器未嵌入 `UINavigationController`,此操作无效果
    func push(_ viewController: UIViewController, animated: Bool = true) {
        base.navigationController?.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 导航栈操作
@MainActor
public extension DyWrapper where Base: UIViewController {
    /// 返回到导航栈的根控制器
    func popToRoot(animated: Bool = true) {
        base.navigationController?.popToRootViewController(animated: animated)
    }

    /// 返回上一级控制器
    func pop(animated: Bool = true) {
        base.navigationController?.popViewController(animated: animated)
    }

    /// 替换当前栈顶控制器(先移除自己,再 `push` 新控制器)
    ///
    /// - Parameters:
    ///   - viewController: 新的栈顶控制器
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Usage: 常用于登录后替换欢迎页,或表单提交后跳转结果页
    func replaceTop(with viewController: UIViewController, animated: Bool = true) {
        guard let nav = base.navigationController, !nav.viewControllers.isEmpty else { return }
        var vcs = nav.viewControllers
        vcs[vcs.count - 1] = viewController
        nav.setViewControllers(vcs, animated: animated)
    }

    /// 弹出 N 个控制器后,Push 一个新控制器
    ///
    /// - Parameters:
    ///   - count: 要弹出的控制器数量(必须 ≥ 1)
    ///   - newViewController: 要 Push 的新控制器
    ///   - animated: 是否启用动画默认为 `true`
    func popThenPush(_ count: Int, newViewController: UIViewController, animated: Bool = true) {
        guard let nav = base.navigationController, count > 0 else { return }
        let currentCount = nav.viewControllers.count
        let keepCount = max(1, currentCount - count)
        var vcs = Array(nav.viewControllers.prefix(keepCount))
        vcs.append(newViewController)
        nav.setViewControllers(vcs, animated: animated)
    }

    /// 返回到导航栈中`最近出现`的指定类型控制器(从栈顶向栈底查找)
    ///
    /// - Parameters:
    ///   - type: 目标控制器类型(如 `HomeViewController.self`)
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Returns: 是否成功找到并返回到目标控制器
    ///
    /// - Note: 使用 `last(where:)` 实现,因此返回的是`最靠近栈顶`的匹配项
    @discardableResult
    func popTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) -> Bool {
        guard let nav = base.navigationController else { return false }
        if let target = nav.viewControllers.last(where: { $0 is T }) {
            nav.popToViewController(target, animated: animated)
            return true
        }
        return false
    }

    /// 弹出指定数量的控制器(安全处理边界)
    ///
    /// - Parameters:
    ///   - count: 要弹出的数量(必须 > 0)
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Note: 若 `count >= 栈深度`,则返回到根控制器
    func pop(count: Int, animated: Bool = true) {
        guard let nav = base.navigationController, count > 0 else { return }
        let total = nav.viewControllers.count
        if count >= total {
            nav.popToRootViewController(animated: animated)
        } else {
            let targetIndex = total - count - 1
            let target = nav.viewControllers[targetIndex]
            nav.popToViewController(target, animated: animated)
        }
    }

    /// 智能关闭当前控制器：
    /// - 若在导航栈中且不是根 → pop
    /// - 若是以 modal 方式呈现 → dismiss
    /// - 否则尝试 dismiss 自身(兜底)
    func close(animated: Bool = true) {
        if let nav = base.navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else if base.presentingViewController != nil {
            self.dismiss(animated: animated)
        } else {
            self.dismiss(animated: animated)
        }
    }

    /// 关闭所有模态层,回到最底层的根视图控制器
    ///
    /// - Parameters:
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Usage: 例如用户登出时,清除所有弹窗回到登录页
    func dismissAllModals(animated: Bool = true) {
        var top: UIViewController = base
        while let presenter = top.presentingViewController {
            top = presenter
        }
        top.dismiss(animated: animated)
    }

    /// 关闭当前模态层
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func dismiss(animated: Bool = true, completion: DyAction? = nil) {
        base.dismiss(animated: animated, completion: completion)
    }
}
