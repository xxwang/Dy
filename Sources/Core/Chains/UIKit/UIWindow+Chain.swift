import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIWindow {
    /// 设置窗口的根视图控制器(root view controller)
    ///
    /// - Parameter rootViewController: 要设置为根视图控制器的 `UIViewController` 实例
    /// - Returns: `Self`
    @discardableResult
    func rootViewController(_ rootViewController: UIViewController) -> Self {
        base.rootViewController = rootViewController
        return self
    }

    /// 关联窗口到指定的 `UIWindowScene`
    ///
    /// - Parameter windowScene: 与窗口绑定的场景对象(通常来自 `UISceneDelegate`)
    /// - Returns: `Self`
    @discardableResult
    func windowScene(_ windowScene: UIWindowScene) -> Self {
        base.windowScene = windowScene
        return self
    }

    /// 设置是否允许窗口根据内容自动调整大小
    /// - Parameter fit: 是否启用自适应尺寸
    /// - Returns: `Self`
    @discardableResult
    func canResizeToFitContent(_ fit: Bool) -> Self {
        base.canResizeToFitContent = fit
        return self
    }

    /// 设置窗口层级
    /// - Parameter level: 窗口的显示层级（如普通、状态栏、警报等）
    /// - Returns: `Self`
    @discardableResult
    func windowLevel(_ level: UIWindow.Level) -> Self {
        base.windowLevel = level
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UIWindow {
    /// 将当前窗口设为应用的主窗口并显示出来
    /// - Returns: `Self`
    @discardableResult
    func makeKeyAndVisible() -> Self {
        base.makeKeyAndVisible()
        return self
    }

    /// 将当前窗口设为应用程序的主键窗口
    /// - Returns: `Self`
    @discardableResult
    func makeKey() -> Self {
        base.makeKey()
        return self
    }

    /// 向窗口分发指定的用户事件
    /// - Parameter event: 要发送的 UI 事件（如触摸、运动等）
    /// - Returns: `Self`
    @discardableResult
    func sendEvent(_ event: UIEvent) -> Self {
        base.sendEvent(event)
        return self
    }
}
