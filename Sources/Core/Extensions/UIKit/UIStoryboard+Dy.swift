import UIKit

// MARK: - 属性
public extension UIStoryboard {
    /// 获取应用程序的主 `UIStoryboard`(从`Info.plist`的 `UIMainStoryboardFile` 读取名称)
    static var dy_main: UIStoryboard? {
        guard let name = Bundle.main.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: .main)
    }
}

// MARK: - 常用方法
public extension UIStoryboard {
    /// 从当前 `Storyboard` 中实例化指定类型的视图控制器
    ///
    /// - Parameter viewControllerClass: 要实例化的 `UIViewController` 子类类型
    /// - Returns: 成功则返回对应类型的控制器,否则返回 `nil`
    func dy_viewController<T: UIViewController>(withClass viewControllerClass: T.Type) -> T? {
        let identifier = String(describing: viewControllerClass)
        return self.instantiateViewController(withIdentifier: identifier) as? T
    }

    /// 使用自定义 `Storyboard ID `实例化控制器
    ///
    /// - Parameters:
    ///   - type: 控制器类型(用于类型转换)
    ///   - identifier: `Storyboard` 中设置的 `Identifier`
    /// - Returns: 转换后的控制器实例,或 `nil`
    func dy_viewController<T: UIViewController>(ofType type: T.Type, withIdentifier identifier: String) -> T? {
        return self.instantiateViewController(withIdentifier: identifier) as? T
    }
}
