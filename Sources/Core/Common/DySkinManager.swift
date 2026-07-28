import UIKit

// MARK: - 主题可响应协议
public protocol DySkinable: AnyObject {
    /// 更新主题样式
    func updateSkin()
}

// MARK: - 提供对全局皮肤管理器的快捷访问
public extension DySkinable where Self: UITraitEnvironment {
    /// 全局皮肤管理器实例,用于注册/移除观察者或触发刷新
    var skinManager: DySkinManager {
        DySkinManager.shared
    }
}

// MARK: - 皮肤管理器实现
/// 主题皮肤管理器，刷新操作必须在主线程执行，因此标注为 ``@MainActor``
@MainActor
public final class DySkinManager {
    /// 存储皮肤观察者的弱引用集合(自动清理已释放对象)
    private let observers = NSHashTable<AnyObject>.weakObjects()

    /// 用于同步访问 `observers` 的并发队列
    private let queue = DispatchQueue(
        label: "com.dy.skin-manager",
        attributes: .concurrent
    )

    /// 全局共享实例
    public static let shared = DySkinManager()

    /// 私有初始化,确保单例
    private init() {}
}

// MARK: - DySkinProvider 协议实现
public extension DySkinManager {
    /// 注册一个皮肤观察者
    /// - Parameter observer: 遵循 `DySkinable` 的对象
    func register(observer: DySkinable) {
        queue.sync(flags: .barrier) {
            observers.add(observer)
        }
    }

    /// 移除一个皮肤观察者
    /// - Parameter observer: 要移除的对象
    func remove(observer: DySkinable) {
        queue.sync(flags: .barrier) {
            self.observers.remove(observer)
        }
    }

    /// 刷新所有已注册观察者的皮肤样式
    ///
    /// - 第一步：在后台同步读取当前有效的观察者列表(不阻塞主线程)
    /// - 第二步：将 `updateUI()` 调用派发到主线程,确保 UI 更新安全
    func updateSkin() {
        var activeObservers: [DySkinable] = []
        queue.sync {
            activeObservers = observers.allObjects.compactMap { $0 as? DySkinable }
        }

        DispatchQueue.main.async {
            activeObservers.forEach { $0.updateSkin() }
        }
    }
}
