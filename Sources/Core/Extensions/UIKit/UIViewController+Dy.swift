import UIKit

// MARK: - 属性
public extension UIViewController {
    /// 检查当前视图控制器是否已加载并显示在窗口上
    /// - Returns:`true`表示控制器已加载并且其视图在窗口中显示
    var dy_isVisible: Bool {
        self.isViewLoaded && self.view.window != nil && self.view.isHidden == false && self.view.alpha > 0.01
    }

    /// 获取导航栈中当前控制器的前一个控制器
    var dy_previousViewController: UIViewController? {
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
    func dy_present(
        _ viewController: UIViewController,
        fullScreen: Bool = true,
        animated: Bool = true,
        completion: DyAction? = nil
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
    func dy_push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

// MARK: - 导航栈操作
public extension UIViewController {
    /// 返回到导航栈的根控制器
    func dy_popToRoot(animated: Bool = true) {
        self.navigationController?.popToRootViewController(animated: animated)
    }

    /// 返回上一级控制器
    func dy_pop(animated: Bool = true) {
        self.navigationController?.popViewController(animated: animated)
    }

    /// 替换当前栈顶控制器(先移除自己,再 `push` 新控制器)
    ///
    /// - Parameters:
    ///   - viewController: 新的栈顶控制器
    ///   - animated: 是否启用动画默认为 `true`
    ///
    /// - Usage: 常用于登录后替换欢迎页,或表单提交后跳转结果页
    func dy_replaceTop(with viewController: UIViewController, animated: Bool = true) {
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
    func dy_popThenPush(_ count: Int, newViewController: UIViewController, animated: Bool = true) {
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
    func dy_popTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) -> Bool {
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
    func dy_pop(count: Int, animated: Bool = true) {
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
    func dy_close(animated: Bool = true) {
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
    func dy_dismissAllModals(animated: Bool = true) {
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
    func dy_dismiss(animated: Bool = true, completion: DyAction? = nil) {
        self.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - 链式设置属性
public extension UIViewController {
    /// 强制覆盖用户界面样式(亮色/暗色模式)
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func dy_overrideUserInterfaceStyle(_ style: UIUserInterfaceStyle) -> Self {
        self.overrideUserInterfaceStyle = style
        return self
    }

    /// 设置模态呈现样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func dy_modalPresentationStyle(_ style: UIModalPresentationStyle) -> Self {
        self.modalPresentationStyle = style
        return self
    }

    /// 设置内容大小
    /// - Parameter size: 内容大小
    /// - Returns: `Self`
    @discardableResult
    func dy_preferredContentSize(_ size: CGSize) -> Self {
        self.preferredContentSize = size
        return self
    }

    /// 设置是否禁止通过手势或点击背景关闭抽屉
    /// - Parameter isModalInPresentation: `true` 表示强制模态（不可关闭），`false` 表示允许关闭（默认）
    /// - Returns: `Self`
    @discardableResult
    func dy_isModalInPresentation(_ isModalInPresentation: Bool) -> Self {
        self.isModalInPresentation = isModalInPresentation
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIViewController {
    /// 安全地将子控制器添加到指定容器视图
    ///
    /// - Parameters:
    ///   - child: 要添加的子视图控制器
    ///   - containerView: 容器视图(必须已加入视图层级,否则子视图不可见)
    ///
    /// - 注意：自动完成完整的子控制器生命周期调用：
    ///   `addChild(_:)` → `addSubview(_:)` → `didMove(toParent:)`
    @discardableResult
    func dy_addChild(_ child: UIViewController, to containerView: UIView) -> Self {
        self.addChild(child)
        containerView.addSubview(child.view)
        child.didMove(toParent: self)
        return self
    }

    /// 从父控制器中安全移除自身(包括视图和生命周期回调)
    ///
    /// - 注意：仅当 `parent != nil` 时执行移除操作
    ///   自动完成：`willMove(toParent: nil)` → `removeFromSuperview()` → `removeFromParent()`
    @discardableResult
    func dy_removeFromParent() -> Self {
        guard self.parent != nil else { return self }
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        return self
    }
}
