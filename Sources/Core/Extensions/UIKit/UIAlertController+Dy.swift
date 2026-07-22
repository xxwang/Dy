import UIKit

// MARK: - 方法
public extension UIAlertController {
    /// 快速创建一个带有`取消`和`确认`按钮的`UIAlertController`
    /// - Parameters:
    ///   - title: 弹窗标题
    ///   - message: 提示内容
    ///   - cancelTitle: 取消按钮文字
    ///   - confirmTitle: 确认按钮文字
    ///   - confirmBlock: 用户点击“确认”后的回调
    static func dy_showConfirm(
        title: String? = "提示",
        message: String? = nil,
        cancel cancelTitle: String? = "取消",
        confirm confirmTitle: String? = "确认",
        confirmBlock: DyAction? = nil
    ) {
        UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        .dy_addAction(title: cancelTitle ?? "取消", style: .cancel)
        .dy_addAction(title: confirmTitle ?? "确认", style: .default) { _ in
            confirmBlock?()
        }
        .dy_show()
    }
}

// MARK: - 链式设置属性
public extension UIAlertController {
    /// 设置标题
    /// - Parameter title: 标题文本
    /// - Returns: `Self`
    @discardableResult
    func dy_title(_ title: String?) -> Self {
        self.title = title
        return self
    }

    /// 设置副标题(消息内容)
    /// - Parameter message: 消息文本
    /// - Returns: `Self`
    @discardableResult
    func dy_message(_ message: String?) -> Self {
        self.message = message
        return self
    }

    /// 添加一个已构建好的`UIAlertAction`
    /// - Parameter action: `UIAlertAction`实例
    /// - Returns: `Self`
    @discardableResult
    func dy_addAction(_ action: UIAlertAction) -> Self {
        self.addAction(action)
        return self
    }

    /// 快捷添加一个`UIAlertAction`(通过标题和回调)
    /// - Parameters:
    ///   - title: 按钮文字
    ///   - style: 按钮样式(`.default` / `.cancel` / `.destructive`)
    ///   - handler: 点击后的回调
    /// - Returns: `Self`
    @discardableResult
    func dy_addAction(
        title: String,
        style: UIAlertAction.Style = .default,
        handler: DyAction1<UIAlertAction>? = nil
    ) -> Self {
        let action = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(action)
        return self
    }

    /// 添加一个`UITextField`
    /// - Parameter configurationHandler: 配置 `UITextField` 的闭包
    /// - Returns: `Self`
    @discardableResult
    func dy_addTextField(configurationHandler: DyAction1<UITextField>? = nil) -> Self {
        self.addTextField(configurationHandler: configurationHandler)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIAlertController {
    /// 从指定的`viewController` 弹出`UIAlertController`
    /// - Parameters:
    ///   - viewController: 指定的来源控制器
    ///   - animated: 是否启用动画
    /// - Returns: `Self`
    @discardableResult
    func dy_show(from viewController: UIViewController? = nil, animated: Bool = true) -> Self {
        if let vc = viewController {
            DispatchQueue.main.async {
                if let presented = vc.presentedViewController, presented.isBeingPresented || presented.isBeingDismissed {
                    print("⚠️ [UIAlertController.show] 指定的 ViewController 正在处理其他弹窗,跳过本次弹窗")
                    return
                }
                vc.present(self, animated: animated)
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
                topVC.present(self, animated: animated)
            }
        }
        return self
    }
}
