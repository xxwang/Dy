import UIKit

// MARK: - 属性
public extension UIViewController {
    /// 检查当前视图控制器是否已加载并显示在窗口上
    /// - Returns:`true`表示控制器已加载并且其视图在窗口中显示
    var dy_isVisible: Bool {
        self.isViewLoaded && self.view.window != nil && self.view.isHidden == false && self.view.alpha > 0.01
    }

    /// 获取导航栈中当前控制器的前一个控制器
    var dy_previousViewController: UIViewController? {
        guard let nav = self.navigationController,
              let index = nav.viewControllers.firstIndex(of: self),
              index > 0 else { return nil }
        return nav.viewControllers[index - 1]
    }
}
