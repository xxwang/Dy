import UIKit
import ObjectiveC

// MARK: - 主题可响应协议
public protocol DySkinable: AnyObject {
    /// 应用当前主题样式 (框架会确保此方法在主线程调用)
    func updateSkinUI()
}

/// 为所有遵循 `DySkinable` 且是 `UITraitEnvironment` 子类的对象 提供对全局皮肤管理器的快捷访问
public extension DySkinable where Self: UITraitEnvironment {
    /// 全局皮肤管理器实例,用于注册/移除观察者或触发刷新
    var skinManager: DySkinManager {
        DySkinManager.shared
    }
}

// MARK: - 全局换肤管理器
public final class DySkinManager {
    
    // 使用 NSHashTable 存储弱引用，防止循环引用导致内存泄漏
    private let observers = NSHashTable<AnyObject>.weakObjects()
    
    // 用于同步访问 observers 的并发队列
    private let queue = DispatchQueue(
        label: "com.dy.skin-manager.concurrent",
        attributes: .concurrent
    )
    
    public static let shared = DySkinManager()
    private init() {}
    
    /// 注册皮肤观察者 (写操作，使用 barrier 保证排他性)
    public func register(_ observer: DySkinable) {
        queue.async(flags: .barrier) { [weak self] in
            self?.observers.add(observer)
        }
    }
    
    /// 移除皮肤观察者 (写操作，使用 barrier)
    public func unregister(_ observer: DySkinable) {
        queue.async(flags: .barrier) { [weak self] in
            self?.observers.remove(observer)
        }
    }
    
    /// 触发全局皮肤刷新
    public func updateSkin() {
        // 在后台同步读取当前有效的观察者快照 (读操作，不阻塞其他读)
        var activeObservers: [DySkinable] = []
        queue.sync {
            activeObservers = observers.allObjects.compactMap { $0 as? DySkinable }
        }
        
        // 切换到主线程执行 UI 更新，确保 UIKit 安全
        DispatchQueue.main.async {
            activeObservers.forEach { $0.updateSkinUI() }
        }
    }
}

// MARK: - 生命周期自动绑定扩展
public extension DySkinable where Self: UIViewController {
    
    /// 绑定换肤生命周期
    /// 建议在 viewDidLoad 中调用
    func bindSkin() {
        // 注册到全局管理器
        self.skinManager.register(self)
        
        // 利用关联对象绑定一个 Token
        // 当VC被销毁时，Token也会随之释放，触发自动注销
        let token = SkinUnregisterToken(vc: self)
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.skinToken,
            token,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )
        
        // 立即应用一次当前主题，确保初始化样式正确
        self.updateSkinUI()
    }
}

// MARK: - 内部辅助类 (利用 ARC 机制实现自动注销)

/// 辅助 Token 类
/// 核心原理：当绑定的 VC 被释放时，这个 Token 也会被释放，
/// 从而在其 deinit 中自动将 VC 从全局管理器中移除。
private class SkinUnregisterToken {
    weak var vc: UIViewController?
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    deinit {
        // Token 销毁时，自动清理全局管理器中的引用
        if let skinable = vc as? DySkinable {
            DySkinManager.shared.unregister(skinable)
        }
    }
}

// 关联对象的 Key
private struct AssociatedKeys {
    static var skinToken: Void?
}
