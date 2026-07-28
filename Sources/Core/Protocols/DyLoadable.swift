import UIKit

public protocol DyLoadable {}

extension UIView: DyLoadable {}
extension UIViewController: DyLoadable {}

public extension DyLoadable where Self: UIView {
    /// 从 `XIB` 加载视图(自动使用类名作为 `XIB` 名,去除模块前缀)
    ///
    /// - Parameters:
    ///   - nibName: `XIB` 文件名(不含 `.xib`),默认为类名
    ///   - bundle: 资源 `Bundle`,默认为类所在 `Bundle`
    /// - Returns: 加载的视图实例
    static func loadView(
        nibName: String? = nil,
        bundle: Bundle? = nil
    ) -> Self {
        let name = nibName ?? DyHelper.className(Self.self)
        let targetBundle = bundle ?? Bundle(for: Self.self)

        guard let views = targetBundle.loadNibNamed(name, owner: nil, options: nil) else {
            fatalError("""
            ❌ [Dy] 无法加载 XIB '\(name)'
            检查：XIB 是否存在并已加入 Target
            Bundle: \(targetBundle.bundlePath)
            """)
        }

        if let view = views.first(where: { type(of: $0) == Self.self }) as? Self {
            return view
        }
        if let view = views.first(where: { $0 is Self }) as? Self {
            return view
        }

        let types = views.map { String(describing: type(of: $0)) }.joined(separator: ", ")
        fatalError("""
        ❌ [Dy] XIB '\(name)' 无类型 '\(Self.self)' 的视图
        可用类型: [\(types)]请检查根视图类设置
        """)
    }
}

public extension DyLoadable where Self: UIViewController {
    /// 从 `Storyboard` 加载控制器(自动使用类名作为 `Storyboard ID`)
    ///
    /// - Parameters:
    ///   - storyboardName: `Storyboard` 名(默认 `Main`)
    ///   - bundle: 资源 `Bundle`(默认为类所在 `Bundle`)
    ///   - identifier: 控制器 ID(默认为类名)
    /// - Returns: 加载的控制器实例
    static func loadViewController(
        from storyboardName: String = "Main",
        bundle: Bundle? = nil,
        identifier: String? = nil
    ) -> Self {
        let storyboardId = identifier ?? DyHelper.className(self)
        let targetBundle = bundle ?? Bundle(for: self)

        let storyboard = UIStoryboard(name: storyboardName, bundle: targetBundle)

        guard let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as? Self else {
            fatalError("""
            ❌ [Dy] 无法从 Storyboard '\(storyboardName)' 加载 ID '\(storyboardId)' 的控制器
            检查：Storyboard ID 和 Custom Class 是否正确
            Bundle: \(targetBundle.bundlePath)
            """)
        }

        return controller
    }
}
