import UIKit

// MARK: - 发送通知
public extension DyWrapper where Base: NotificationCenter {
    /// 发送一个通知
    /// - Parameter name: 通知名称
    func post(_ name: Notification.Name) {
        base.post(name: name, object: nil)
    }

    /// 发送一个通知
    /// - Parameter name: 通知名称
    func post(_ name: String) {
        base.post(name: .init(name), object: nil)
    }

    /// 发送一个带 `userInfo` 的通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - userInfo: 附加数据字典
    func post(_ name: String,
              userInfo: [AnyHashable: Any]?)
    {
        base.post(name: .init(name), object: nil, userInfo: userInfo)
    }
}
