import UIKit
import os.log

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
        .dy
        .addAction(title: cancelTitle ?? "取消", style: .cancel)
        .addAction(title: confirmTitle ?? "确认", style: .default) { _ in
            confirmBlock?()
        }
        .show()
    }
}
