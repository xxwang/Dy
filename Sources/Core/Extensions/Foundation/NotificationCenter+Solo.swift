import UIKit

// MARK: - 发送通知
public extension NotificationCenter {
    /// 发送一个通知
    /// - Parameter name: 通知名称
    static func solo_post(_ name: Notification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }

    /// 发送一个通知
    /// - Parameter name: 通知名称
    static func solo_post(_ name: String) {
        NotificationCenter.default.post(name: .init(name), object: nil)
    }

    /// 发送一个带 `userInfo` 的通知
    /// - Parameters:
    ///   - name: 通知名称
    ///   - userInfo: 附加数据字典
    static func solo_post(_ name: String, userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: .init(name), object: nil, userInfo: userInfo)
    }
}
