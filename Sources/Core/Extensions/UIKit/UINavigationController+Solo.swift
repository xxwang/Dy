import UIKit

// MARK: - 常用方法
public extension SoloWrapper where Base: UINavigationController {
    /// 将导航栏设置为完全透明,并自定义标题和按钮颜色
    ///
    /// - Parameter tintColor: 导航栏按钮和标题的颜色,默认为 `.white`
    func transparent(with tintColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: tintColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: tintColor]

        base.navigationBar.standardAppearance = appearance
        base.navigationBar.scrollEdgeAppearance = appearance
        base.navigationBar.compactAppearance = appearance

        base.navigationBar.tintColor = tintColor
        base.navigationBar.isTranslucent = true
    }
}
