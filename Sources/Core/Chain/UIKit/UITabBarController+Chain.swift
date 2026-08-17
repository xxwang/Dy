import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: UITabBarController {
    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UITabBarControllerDelegate) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置子控制器
    /// - Parameter viewControllers: 控制器数组
    /// - Returns: `Self`
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController]?, animated: Bool = false) -> Self {
        if animated {
            base.setViewControllers(viewControllers, animated: true)
        } else {
            base.viewControllers = viewControllers
        }
        return self
    }

    /// 设置选中索引
    /// - Parameter index: 需要选中的索引
    /// - Returns: `Self`
    @discardableResult
    func selectedIndex(_ index: Int) -> Self {
        base.selectedIndex = index
        return self
    }
}
