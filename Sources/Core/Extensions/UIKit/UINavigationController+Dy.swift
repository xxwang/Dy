import UIKit

// MARK: - 常用方法
public extension UINavigationController {
    /// 将导航栏设置为完全透明,并自定义标题和按钮颜色
    ///
    /// - Parameter tintColor: 导航栏按钮和标题的颜色,默认为 `.white`
    func dy_transparent(with tintColor: UIColor = .white) {
        let appearance = self.navigationBar.standardAppearance
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
