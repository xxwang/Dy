import UIKit

// MARK: - 链式设置属性
public extension UITabBarController {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置子控制器
    /// - Parameter viewControllers: 控制器数组
    /// - Returns: `Self`
    @discardableResult
    func dy_viewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        if animated {
            self.setViewControllers(viewControllers, animated: true)
        } else {
            self.viewControllers = viewControllers
        }
        return self
    }

    /// 设置选中索引
    /// - Parameter index: 需要选中的索引
    /// - Returns: `Self`
    @discardableResult
    func dy_selectedIndex(_ index: Int) -> Self {
        self.selectedIndex = index
        return self
    }
}
