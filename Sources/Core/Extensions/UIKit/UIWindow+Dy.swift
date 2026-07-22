import UIKit

// MARK: - UIWindow相关
public extension UIWindow {
    /// 获取当前应用中最合适的主窗口
    static var dy_keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { !$0.isHidden && $0.isKeyWindow }
    }

    /// 获取所有有效的、非隐藏的 `UIWindow` 实例
    static var dy_windows: [UIWindow] {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .filter { !$0.isHidden }
    }
}

// MARK: - UIViewController相关
public extension UIWindow {
    /// 获取当前最顶层的可见视图控制器
    /// - Returns: 最顶层的 `UIViewController`
    ///
    static var dy_topViewController: UIViewController? {
        return self.dy_findTopViewController(from: self.dy_keyWindow?.rootViewController, depth: 0)
    }

    /// 递归查找最顶层控制器
    /// - Parameters:
    ///   - base: 开始控制器
    ///   - depth: 深度
    /// - Returns: `UIViewController?`
    static func dy_findTopViewController(from base: UIViewController?, depth: Int) -> UIViewController? {
        guard depth < 10, let base else { return base }

        if let nav = base as? UINavigationController {
            return self.dy_findTopViewController(from: nav.visibleViewController, depth: depth + 1)
        }

        if let tab = base as? UITabBarController {
            return self.dy_findTopViewController(from: tab.selectedViewController, depth: depth + 1)
        }

        if let split = base as? UISplitViewController {
            if let detail = split.viewControllers.last,
               split.isCollapsed == false
            {
                return self.dy_findTopViewController(from: detail, depth: depth + 1)
            }
            return self.dy_findTopViewController(from: split.viewControllers.first, depth: depth + 1)
        }

        if let presented = base.presentedViewController {
            return self.dy_findTopViewController(from: presented, depth: depth + 1)
        }

        return base
    }
}

// MARK: - 链式设置属性
public extension UIWindow {
    /// 设置窗口的根视图控制器(root view controller)
    ///
    /// - Parameter rootViewController: 要设置为根视图控制器的 `UIViewController` 实例
    /// - Returns: `Self`
    @discardableResult
    func dy_rootViewController(_ rootViewController: UIViewController) -> Self {
        self.rootViewController = rootViewController
        return self
    }

    /// 关联窗口到指定的 `UIWindowScene`
    ///
    /// - Parameter windowScene: 与窗口绑定的场景对象(通常来自 `UISceneDelegate`)
    /// - Returns: `Self`
    @discardableResult
    func dy_windowScene(_ windowScene: UIWindowScene) -> Self {
        self.windowScene = windowScene
        return self
    }

    /// 设置是否允许窗口根据内容自动调整大小
    /// - Parameter fit: 是否启用自适应尺寸
    /// - Returns: `Self`
    @discardableResult
    func dy_canResizeToFitContent(_ fit: Bool) -> Self {
        self.canResizeToFitContent = fit
        return self
    }

    /// 设置窗口层级
    /// - Parameter level: 窗口的显示层级（如普通、状态栏、警报等）
    /// - Returns: `Self`
    @discardableResult
    func dy_windowLevel(_ level: UIWindow.Level) -> Self {
        self.windowLevel = level
        return self
    }
}

// MARK: - 链式方法
public extension UIWindow {
    /// 将当前窗口设为应用的主窗口并显示出来
    /// - Returns: `Self`
    @discardableResult
    func dy_makeKeyAndVisible() -> Self {
        self.makeKeyAndVisible()
        return self
    }

    /// 将当前窗口设为应用程序的主键窗口
    /// - Returns: `Self`
    @discardableResult
    func dy_makeKey() -> Self {
        self.makeKey()
        return self
    }

    /// 向窗口分发指定的用户事件
    /// - Parameter event: 要发送的 UI 事件（如触摸、运动等）
    /// - Returns: `Self`
    @discardableResult
    func dy_sendEvent(_ event: UIEvent) -> Self {
        self.sendEvent(event)
        return self
    }
}
