import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UINavigationController {
    /// 设置导航控制器的代理
    ///
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UINavigationControllerDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置导航控制器交互手势识别器代理
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func interactivePopGestureRecognizerDelegate(_ delegate: (any UIGestureRecognizerDelegate)?) -> Self {
        base.interactivePopGestureRecognizer?.delegate = delegate
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UINavigationController {
    /// 设置导航栏是否隐藏
    ///
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func navigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        base.setNavigationBarHidden(hidden, animated: animated)
        return self
    }

    /// 替换整个视图控制器栈
    ///
    /// - Parameters:
    ///   - viewControllers: 新的视图控制器数组
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func viewControllers(_ viewControllers: [UIViewController], animated: Bool = false) -> Self {
        base.setViewControllers(viewControllers, animated: animated)
        return self
    }
}
