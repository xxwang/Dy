import UIKit

// MARK: - 常用方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条上的按钮和文字颜色,默认为白色
    func dy_transparent(with tintColor: UIColor = .white) {
        self.dy_isTranslucent(true)
            .dy_backgroundColor(.clear)
            .dy_backgroundImage(UIImage())
            .dy_barTintColor(.clear)
            .dy_tintColor(tintColor)
            .dy_shadowImage(UIImage())
            .dy_titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background: 背景颜色
    ///   - text: 文字颜色
    func dy_colors(background: UIColor, text: UIColor) {
        self.dy_isTranslucent(false)
            .dy_backgroundColor(background)
            .dy_barTintColor(background)
            .dy_backgroundImage(UIImage())
            .dy_tintColor(text)
            .dy_titleTextAttributes([.foregroundColor: text])
    }
}
