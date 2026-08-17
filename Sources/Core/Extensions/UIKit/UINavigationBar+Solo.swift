import UIKit

// MARK: - 常用方法
public extension SoloWrapper where Base: UINavigationBar {
    /// 设置导航条为透明
    /// - Parameter tintColor: 导航条上的按钮和文字颜色,默认为白色
    func transparent(with tintColor: UIColor = .white) {
        self
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
    func colors(background: UIColor, text: UIColor) {
        self
            .isTranslucent(false)
            .backgroundColor(background)
            .barTintColor(background)
            .backgroundImage(UIImage())
            .tintColor(text)
            .titleTextAttributes([.foregroundColor: text])
    }
}
