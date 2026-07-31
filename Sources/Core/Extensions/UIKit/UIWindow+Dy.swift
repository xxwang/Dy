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
