import UIKit

// MARK: - 属性
public extension UIViewController {
    /// 检查当前视图控制器是否已加载并显示在窗口上
    /// - Returns:`true`表示控制器已加载并且其视图在窗口中显示
    var solo_isVisible: Bool {
        self.isViewLoaded && self.view.window != nil && self.view.isHidden == false && self.view.alpha > 0.01
    }

    /// 获取导航栈中当前控制器的前一个控制器
    var solo_previousViewController: UIViewController? {
        guard let nav = self.navigationController,
              let index = nav.viewControllers.firstIndex(of: self),
              index > 0 else { return nil }
        return nav.viewControllers[index - 1]
    }
}

// MARK: - 页面跳转
public extension UIViewController {
    /// 以`Modal`形式显示控制器
    /// - Parameters:
    ///   - viewController: 要显示的控制器
    ///   - fullScreen: 是否以全屏模式展示(默认为`true`)
    ///   - animated: 是否动画(默认为`true`)
    ///   - completion: 完成回调(可选)
    func solo_present(
        _ viewController: UIViewController,
        fullScreen: Bool = true,
        animated: Bool = true,
        completion: SoloAction? = nil
    ) {
        if fullScreen {
            viewController.modalPresentationStyle = .fullScreen
        }
        self.present(viewController, animated: animated, completion: completion)
    }

    /// 将控制器 `Push` 到导航栈
    ///
    /// - Parameters:
    ///   - viewController: 要 Push 的控制器
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Note: 若当前控制器未嵌入 `UINavigationController`,此操作无效果
    func solo_push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 导航栈操作
public extension UIViewController {
    /// 返回到导航栈的根控制器
    func solo_popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    /// 返回上一级控制器
    func solo_pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    /// 替换当前栈顶控制器(先移除自己,再 `push` 新控制器)
    ///
    /// - Parameters:
    ///   - viewController: 新的栈顶控制器
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Usage: 常用于登录后替换欢迎页,或表单提交后跳转结果页
    func solo_replaceTop(with viewController: UIViewController, animated: Bool = true) {
        guard let nav = self.navigationController, !nav.viewControllers.isEmpty else { return }
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
    func solo_popThenPush(_ count: Int, newViewController: UIViewController, animated: Bool = true) {
        guard let nav = self.navigationController, count > 0 else { return }
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
    func solo_popTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) -> Bool {
        guard let nav = self.navigationController else { return false }
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
    func solo_pop(count: Int, animated: Bool = true) {
        guard let nav = self.navigationController, count > 0 else { return }
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
    func solo_close(animated: Bool = true) {
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            nav.popViewController(animated: animated)
        } else if self.presentingViewController != nil {
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
    func solo_dismissAllModals(animated: Bool = true) {
        var top: UIViewController = self
        while let presenter = top.presentingViewController {
            top = presenter
        }
        top.dismiss(animated: animated)
    }

    /// 关闭当前模态层
    /// - Parameters:
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    func solo_dismiss(animated: Bool = true, completion: SoloAction? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
}
