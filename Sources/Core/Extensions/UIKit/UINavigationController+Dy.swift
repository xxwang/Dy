import UIKit

// MARK: - 常用方法
public extension UINavigationController {
    /// 将导航栏设置为完全透明,并自定义标题和按钮颜色
    ///
    /// - Parameter tintColor: 导航栏按钮和标题的颜色,默认为 `.white`
    func dy_transparent(with tintColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: tintColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: tintColor]

        self.navigationBar.standardAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.compactAppearance = appearance

        self.navigationBar.tintColor = tintColor
        self.navigationBar.isTranslucent = true
    }
}

// MARK: - 链式设置属性
public extension UINavigationController {
    /// 设置导航控制器的代理
    ///
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UINavigationControllerDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置导航控制器交互手势识别器代理
    /// - Parameter delegate: 代理对象,传入 `nil` 可移除代理
    /// - Returns: `Self`
    @discardableResult
    func dy_interactivePopGestureRecognizerDelegate(_ delegate: (any UIGestureRecognizerDelegate)?) -> Self {
        self.interactivePopGestureRecognizer?.delegate = delegate
        return self
    }
}

// MARK: - 链式方法
public extension UINavigationController {
    /// 设置导航栏是否隐藏
    ///
    /// - Parameters:
    ///   - hidden: 是否隐藏导航栏
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func dy_navigationBarHidden(_ hidden: Bool, animated: Bool = false) -> Self {
        self.setNavigationBarHidden(hidden, animated: animated)
        return self
    }

    /// 替换整个视图控制器栈
    ///
    /// - Parameters:
    ///   - viewControllers: 新的视图控制器数组
    ///   - animated: 是否使用动画过渡默认为 `false`
    /// - Returns: `Self`
    @discardableResult
    func dy_viewControllers(_ viewControllers: [UIViewController], animated: Bool = false) -> Self {
        self.setViewControllers(viewControllers, animated: animated)
        return self
    }
}
