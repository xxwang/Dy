import UIKit
import DyCore

open class DyNavigationController: UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

// MARK: - DySetupable
@objc extension DyNavigationController: DySetupable {
    /// 控制器初始化样式
    open func setupUI() {
        self.dy_overrideUserInterfaceStyle(self.topViewController?.overrideUserInterfaceStyle ?? .light) // 设置导航控制器样式
            .dy_navigationBarHidden(true) // 隐藏导航条
            .dy_delegate(self) // 设置代理
            .dy_interactivePopGestureRecognizerDelegate(self) // 设置交互手势识别器代理

        self.view.dy_backgroundColor(.white)
    }
}

// MARK: - 控制器设置
@objc extension DyNavigationController {
    // MARK: - 屏幕旋转
    override open var shouldAutorotate: Bool {
        self.topViewController?.shouldAutorotate ?? false
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        self.topViewController?.supportedInterfaceOrientations ?? .portrait
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        self.topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    // MARK: - 状态栏
    override open var childForStatusBarStyle: UIViewController? {
        self.topViewController
    }

    override open var childForStatusBarHidden: UIViewController? {
        self.topViewController
    }

    override open var prefersStatusBarHidden: Bool {
        self.topViewController?.prefersStatusBarHidden ?? false
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        self.topViewController?.preferredStatusBarStyle ?? .default
    }

    // MARK: - 控制器入栈
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        // 非栈顶控制器(要入栈的控制器不是栈顶控制器, 隐藏TabBar)
        if !children.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }

        super.pushViewController(viewController, animated: animated)
    }

    // MARK: - 控制器出栈
    override open func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }
}

// MARK: - UINavigationControllerDelegate
@objc extension DyNavigationController: UINavigationControllerDelegate {
    /// 栈顶控制器即将显示
    open func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {}

    /// 栈顶控制器已经显示
    open func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {}
}

// MARK: UIGestureRecognizerDelegate
@objc extension DyNavigationController: UIGestureRecognizerDelegate {
    /// 是否可以侧滑返回
    open func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        // 如果有遵守UIGestureRecognizerDelegate
        if let lastChildren = children.last as? UIGestureRecognizerDelegate {
            return lastChildren.gestureRecognizerShouldBegin?(gestureRecognizer) ?? false
        }

        // 如果是DyViewController类或子类
        if let lastChildren = children.last as? DyViewController {
            return lastChildren.canSideBack
        }

        if viewControllers.count <= 1 {
            return false
        }

        return true
    }
}
