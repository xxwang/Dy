import UIKit
import AdSupport
import AppTrackingTransparency

/// 提供常用辅助信息
public final class DyHelper: @unchecked Sendable {
    public static let shared = DyHelper()
    private init() {}
}

// MARK: - 设备环境
public extension DyHelper {
    /// 当前是否运行在模拟器中
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }

    /// 当前是否处于 `DEBUG` 编译模式
    var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }

    /// 当前设备是否为 `iPad`
    var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    /// 当前设备是否为 `iPhone`
    var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// 当前是否为 `iPhone X `系列或后续全面屏设备(底部有安全区)
    ///
    /// 判断依据：`key window` 的 `safeAreaInsets.bottom > 0`
    /// 注意：在 `iPad` 或非全面屏设备上返回 `false`
    var isIPhoneXSeries: Bool {
        let bottomInset = UIWindow.dy_keyWindow?.safeAreaInsets.bottom ?? 0

        return isPhone && bottomInset > 0
    }
}

// MARK: - 标识符(Identifiers)
public extension DyHelper {
    /// 设备厂商标识符(IDFV)：同一开发商下所有 App 共享,卸载重装会变化
    var identifierForVendor: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }

    /// 广告标识符(IDFA)：仅在用户授权广告追踪后可用(iOS 14+ 需显式请求权限)
    var advertisingIdentifier: String? {
        if #available(iOS 14, *) {
            guard ATTrackingManager.trackingAuthorizationStatus == .authorized else { return nil }
        } else {
            guard ASIdentifierManager.shared().isAdvertisingTrackingEnabled else { return nil }
        }
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }
}

// MARK: - 系统与设备基本信息
public extension DyHelper {
    /// iOS 系统版本号(如 "17.2")
    var systemVersion: String {
        return UIDevice.current.systemVersion
    }

    /// 设备上次启动的时间点(Date 类型)
    /// - 注意：不是 uptime 时长,而是绝对时间
    var lastBootTime: Date {
        let uptime = ProcessInfo.processInfo.systemUptime
        return Date(timeIntervalSinceNow: -uptime)
    }

    /// 设备型号类别(如 "iPhone", "iPad")
    var model: String {
        return UIDevice.current.model
    }

    /// 操作系统名称(如 "iOS")
    var systemName: String {
        return UIDevice.current.systemName
    }

    /// 用户设置的设备名称(如 "张三的 iPhone")
    var name: String {
        return UIDevice.current.name
    }

    /// 应用首选语言(安全访问,避免崩溃)
    var preferredLocalization: String {
        return Bundle.main.preferredLocalizations.first ?? "en"
    }

    /// 本地化设备型号(如 "iPhone")
    var localizedModel: String {
        return UIDevice.current.localizedModel
    }

    /// CPU 物理核心数(通过 sysctl 查询)
    var cpuCoreCount: Int {
        var ncpu: UInt32 = 0
        var len = MemoryLayout.size(ofValue: ncpu)
        let result = sysctlbyname("hw.ncpu", &ncpu, &len, nil, 0)
        return result == 0 ? Int(ncpu) : 0
    }
}

// MARK: - 设备安全与能力检测
public extension DyHelper {
    /// 检测设备是否可能已越狱(仅检查常见路径,不写文件)
    /// ⚠️ 仅供调试/日志使用,App Store 审核可能因“探测系统完整性”被拒
    var isJailbroken: Bool {
        if DyHelper.shared.isSimulator {
            return false
        }

        let paths = [
            "/Applications/Cydia.app",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/stash",
            "/usr/sbin/sshd",
            "/etc/apt/sources.list.d/cydia.list",
        ]
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
    }

    /// 检查设备是否支持拨打电话(通过 tel scheme 判断)
    var canPlacePhoneCalls: Bool {
        guard let url = URL(string: "tel:123") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }
}

// MARK: - 屏幕方向
public extension DyHelper {
    /// 获取当前界面方向
    var interfaceOrientation: UIInterfaceOrientation {
        let activeScene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return activeScene?.interfaceOrientation ?? .unknown
    }

    /// 当前界面是否处于横屏状态
    var isLandscape: Bool {
        return self.interfaceOrientation.isLandscape
    }

    /// 判断指定方向是否被当前 App 支持
    func isSupportedOrientation(_ orientation: UIInterfaceOrientation) -> Bool {
        let supported = UIApplication.shared.supportedInterfaceOrientations(for: nil)
        return supported.contains(orientation.dy_interfaceOrientationMask)
    }
}

// MARK: - 辅助方法
public extension DyHelper {
    /// 获取去掉模块前缀的类名（如 "MyApp.MyClass" → "MyClass"）
    static func className(_ type: (some Any).Type) -> String {
        String(reflecting: type).components(separatedBy: ".").last ?? String(describing: type)
    }
}
