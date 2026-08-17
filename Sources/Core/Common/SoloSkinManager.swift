import UIKit

// MARK: - 主题可响应协议
public protocol SoloSkinable: AnyObject {
    /// 更新主题样式
    func updateSkin()
}

// MARK: - 提供对全局皮肤管理器的快捷访问
@MainActor
public extension SoloSkinable where Self: UITraitEnvironment {
    /// 全局皮肤管理器实例,用于注册/移除观察者或触发刷新
    var skinManager: SoloSkinManager {
        SoloSkinManager.shared
    }
}

// MARK: - 皮肤管理器实现
/// 主题皮肤管理器，所有操作通过 ``@MainActor`` 串行化
@MainActor
public final class SoloSkinManager {
    /// 存储皮肤观察者的弱引用集合(自动清理已释放对象)
    private let observers = NSHashTable<AnyObject>.weakObjects()

    /// 全局共享实例
    public static let shared = SoloSkinManager()

    /// 私有初始化,确保单例
    private init() {}
}

// MARK: - 观察者管理
public extension SoloSkinManager {
    /// 注册一个皮肤观察者
    func register(observer: SoloSkinable) {
        observers.add(observer)
    }

    /// 移除一个皮肤观察者
    func remove(observer: SoloSkinable) {
        observers.remove(observer)
    }

    /// 刷新所有已注册观察者的皮肤样式
    func updateSkin() {
        let active = observers.allObjects.compactMap { $0 as? SoloSkinable }
        active.forEach { $0.updateSkin() }
    }
}
