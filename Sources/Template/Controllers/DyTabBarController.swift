import UIKit
import Combine

open class DyTabBarController: UITabBarController {
    public var cancellables = Set<AnyCancellable>()

    override open func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyTabBarController {
    /// 控制器初始化样式
    open func setupUI() {
        self.dy_delegate(self) // 设置代理
            .dy_overrideUserInterfaceStyle(self.selectedViewController?.overrideUserInterfaceStyle ?? .light) // 设置UI样式

        self.view.dy_backgroundColor(.white) // 控制器背景色
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - 控制器设置
@objc extension DyTabBarController {
    /// 是否接收屏幕旋转
    override open var shouldAutorotate: Bool {
        return self.selectedViewController?.shouldAutorotate ?? false
    }

    /// 屏幕支持的方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }

    /// 子控制器状态栏样式
    override open var childForStatusBarStyle: UIViewController? {
        return self.selectedViewController
    }

    /// 子控制器状态栏是否隐藏
    override open var childForStatusBarHidden: UIViewController? {
        return self.selectedViewController
    }

    /// 是否隐藏状态栏
    override open var prefersStatusBarHidden: Bool {
        return self.selectedViewController?.prefersStatusBarHidden ?? false
    }

    /// 状态栏样式
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return self.selectedViewController?.preferredStatusBarStyle ?? .default
    }

    /// 安全区域发生变化
    override open func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }

    /// 即将发生转场
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {}
}

// MARK: UITabBarControllerDelegate
@objc extension DyTabBarController: UITabBarControllerDelegate {
    /// 即将选中
    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true
    }

    /// 已经选中
    open func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}

    /// 屏幕支持的方向
    open func tabBarControllerSupportedInterfaceOrientations(_ tabBarController: UITabBarController) -> UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? .portrait
    }
}

// MARK: - UITabBarDelegate
@objc extension DyTabBarController {
    override open func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {}

    override open func tabBar(_ tabBar: UITabBar, willBeginCustomizing items: [UITabBarItem]) {}

    override open func tabBar(_ tabBar: UITabBar, didBeginCustomizing items: [UITabBarItem]) {}

    override open func tabBar(_ tabBar: UITabBar, willEndCustomizing items: [UITabBarItem], changed: Bool) {}

    override open func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {}
}
