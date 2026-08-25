import UIKit

// MARK: - 常用方法
public extension UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条上的按钮和文字颜色,默认为白色
    func solo_transparent(with tintColor: UIColor = .white) {
        self
            .solo
            .isTranslucent(true)
            .backgroundColor(.clear)
            .backgroundImage(UIImage())
            .barTintColor(.clear)
            .tintColor(tintColor)
            .shadowImage(UIImage())
            .titleTextAttributes([.foregroundColor: tintColor])
    }

    /// 设置导航条背景和文字颜色
    /// - Parameters:
    ///   - background: 背景颜色
    ///   - text: 文字颜色
    func solo_colors(background: UIColor, text: UIColor) {
        self
            .solo
            .isTranslucent(false)
            .backgroundColor(background)
            .barTintColor(background)
            .backgroundImage(UIImage())
            .tintColor(text)
            .titleTextAttributes([.foregroundColor: text])
    }
}
