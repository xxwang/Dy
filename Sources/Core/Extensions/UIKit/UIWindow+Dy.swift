import UIKit

// MARK: - UIWindow相关
public extension DyWrapper where Base: UIWindow {
    /// 获取当前应用中最合适的主窗口
    static var keyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }?
            .windows
            .first { !$0.isHidden && $0.isKeyWindow }
    }

    /// 获取所有有效的、非隐藏的 `UIWindow` 实例
    static var windows: [UIWindow] {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .filter { !$0.isHidden }
    }
}

// MARK: - UIViewController相关
public extension DyWrapper where Base: UIWindow {
    /// 获取当前最顶层的可见视图控制器
    /// - Returns: 最顶层的 `UIViewController`
    ///
    static var topViewController: UIViewController? {
        return self.findTopViewController(from: self.keyWindow?.rootViewController, depth: 0)
    }

    /// 递归查找最顶层控制器
    /// - Parameters:
    ///   - base: 开始控制器
    ///   - depth: 深度
    /// - Returns: `UIViewController?`
    static func findTopViewController(from root: UIViewController?, depth: Int) -> UIViewController? {
        guard depth < 10, let root else { return root }

        if let nav = root as? UINavigationController {
            return self.findTopViewController(from: nav.visibleViewController, depth: depth + 1)
        }

        if let tab = root as? UITabBarController {
            return self.findTopViewController(from: tab.selectedViewController, depth: depth + 1)
        }

        if let split = root as? UISplitViewController {
            if let detail = split.viewControllers.last,
               split.isCollapsed == false
            {
                return self.findTopViewController(from: detail, depth: depth + 1)
            }
            return self.findTopViewController(from: split.viewControllers.first, depth: depth + 1)
        }

        if let presented = root.presentedViewController {
            return self.findTopViewController(from: presented, depth: depth + 1)
        }

        return root
    }
}
