import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIAlertController {
    /// 设置标题
    /// - Parameter title: 标题文本
    /// - Returns: `Self`
    @discardableResult
    func title(_ title: String?) -> Self {
        base.title = title
        return self
    }

    /// 设置副标题(消息内容)
    /// - Parameter message: 消息文本
    /// - Returns: `Self`
    @discardableResult
    func message(_ message: String?) -> Self {
        base.message = message
        return self
    }

    /// 添加一个已构建好的`UIAlertAction`
    /// - Parameter action: `UIAlertAction`实例
    /// - Returns: `Self`
    @discardableResult
    func addAction(_ action: UIAlertAction) -> Self {
        base.addAction(action)
        return self
    }

    /// 快捷添加一个`UIAlertAction`(通过标题和回调)
    /// - Parameters:
    ///   - title: 按钮文字
    ///   - style: 按钮样式(`.default` / `.cancel` / `.destructive`)
    ///   - handler: 点击后的回调
    /// - Returns: `Self`
    @discardableResult
    func addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        base.addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameter configurationHandler: 配置 `UITextField` 的闭包
    /// - Returns: `Self`
    @discardableResult
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil) -> Self {
        base.addTextField(configurationHandler: configurationHandler)
        return self
    }
}

// MARK: - 方法(自定义)
public extension DyWrapper where Base: UIAlertController {
    /// 从指定的`viewController` 弹出`UIAlertController`
    /// - Parameters:
    ///   - viewController: 指定的来源控制器
    ///   - animated: 是否启用动画
    /// - Returns: `Self`
    @discardableResult
    func show(from viewController: UIViewController? = nil, animated: Bool = true) -> Self {
        if let vc = viewController {
            DispatchQueue.main.async {
                if let presented = vc.presentedViewController, presented.isBeingPresented || presented.isBeingDismissed {
                    print("⚠️ [UIAlertController.show] 指定的 ViewController 正在处理其他弹窗,跳过本次弹窗")
                    return
                }
                vc.present(self.base, animated: animated)
            }
        } else {
            DispatchQueue.main.async {
                guard let topVC = UIWindow.dy_topViewController else {
                    print("⚠️ [UIAlertController.show] 无法找到顶层 ViewController,弹窗未显示")
                    return
                }

                if let presented = topVC.presentedViewController, presented.isBeingPresented || presented.isBeingDismissed {
                    print("⚠️ [UIAlertController.show] 当前已有视图控制器正在展示或消失,跳过本次弹窗")
                    return
                }
                topVC.present(self.base, animated: animated)
            }
        }
        return self
    }
}
