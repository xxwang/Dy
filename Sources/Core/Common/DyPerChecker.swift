import AdSupport
import AppTrackingTransparency
import AVFoundation
import Contacts
import CoreLocation
import Photos
import UserNotifications

// MARK: - 权限状态
public enum DyPerStatus {
    /// 尚未请求过权限
    case notDetermined
    /// 用户已拒绝或系统限制
    case denied
    /// 用户已授权
    case authorized
}

// MARK: - 权限请求结果
public enum DyPerReqResult {
    /// 用户已授权
    case authorized
    /// 用户或系统拒绝了权限请求
    case denied(reason: DyDenialReason)
}

// MARK: - 权限拒绝原因
public enum DyDenialReason {
    /// 用户明确拒绝
    case userDenied
    /// 系统策略限制(如家长控制、设备管理)
    case systemRestricted
    /// 请求过程中发生错误
    case error(Error)
}

// MARK: - 权限类型
public enum DyPerReqType {
    /// 相册
    case photoLibrary
    /// 相机
    case camera
    /// 麦克风
    case microphone
    /// 通讯录
    case contacts
    /// 广告追踪
    case adTracking
    /// 位置
    case location(LocationDyPerReqType)
    /// 通知
    case notification(options: UNAuthorizationOptions)

    /// 位置权限请求类型
    public enum LocationDyPerReqType {
        /// 使用时
        case whenInUse
        /// 一直
        case always
    }
}

// MARK: - 权限管理器
public final class DyPerChecker: NSObject {
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    /// 仅保留最新一次位置请求的回调(定位结果通过 CLLocationManagerDelegate 异步返回)
    private var latestLocationCallback: DyAction1<DyPerReqResult>?
    private let locationCallbackLock = NSLock()

    public static let shared = DyPerChecker()
    override private init() {
        super.init()
    }
}

// MARK: - 统一权限入口(对外公开 API)
public extension DyPerChecker {
    /// 查询指定权限的当前授权状态。
    /// - Parameters:
    ///   - type: 权限类型。
    ///   - completion: 可选回调。
    ///     - 相册/相机/麦克风/通讯录/广告追踪/定位:有同步查询 API,会**同步**在回调中给出真实状态;
    ///     - 通知:无同步查询 API,同步返回值只能保守返回 `.notDetermined`,真实状态通过此回调**异步返回**(主线程)。
    ///     - 不传则忽略该回调。
    /// - Returns: 同步可得的状态(通知恒为 `.notDetermined`,真实值见 `completion`)。
    /// - Note: 不做任何缓存——用户可在系统设置里随时更改权限,每次都查系统真实值,避免返回过期状态。
    @discardableResult
    func checkStatus(for type: DyPerReqType, completion: DyAction1<DyPerStatus>? = nil) -> DyPerStatus {
        switch type {
        case .photoLibrary:
            let s = checkPhotoLibrary(); completion?(s); return s
        case .camera:
            let s = checkCamera(); completion?(s); return s
        case .microphone:
            let s = checkMicrophone(); completion?(s); return s
        case .contacts:
            let s = checkContacts(); completion?(s); return s
        case .adTracking:
            let s = checkAdTracking(); completion?(s); return s
        case .location:
            let s = checkLocation(); completion?(s); return s
        case let .notification(options):
            // 通知无同步 API,真实状态只能异步获取
            checkNotificationSettings(for: options) { completion?($0) }
            return .notDetermined
        }
    }

    /// 请求指定权限(异步,回调在主线程执行)
    /// - Parameters:
    ///   - type: 权限类型
    ///   - completion: 完成回调,返回授权结果或拒绝原因
    func request(_ type: DyPerReqType, completion: @escaping DyAction1<DyPerReqResult>) {
        switch type {
        case .photoLibrary: requestPhotoLibrary(completion: completion)
        case .camera: requestCamera(completion: completion)
        case .microphone: requestMicrophone(completion: completion)
        case .contacts: requestContacts(completion: completion)
        case .adTracking: requestAdTracking(completion: completion)
        case let .location(loc): requestLocation(type: loc, completion: completion)
        case let .notification(options): requestNotification(options: options, completion: completion)
        }
    }
}

// MARK: - 通知权限
private extension DyPerChecker {
    /// 异步获取通知设置状态。
    /// - Note: `UNUserNotificationCenter` 没有同步查询 API,结果只能通过 completion 回传(已在主线程)。
    ///   按传入的 `options` 逐项校验 alert/sound/badge/criticalAlert/carPlay 设置是否均已开启,
    ///   任一未开启即视为 `.denied`。
    func checkNotificationSettings(for options: UNAuthorizationOptions, completion: @escaping DyAction1<DyPerStatus>) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            let status: DyPerStatus
            switch settings.authorizationStatus {
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .denied
            case .authorized, .ephemeral, .provisional:
                // 临时授权(.ephemeral)与 provisional 授权均视为已授权
                let ok = (!options.contains(.alert) || settings.alertSetting == .enabled)
                    && (!options.contains(.sound) || settings.soundSetting == .enabled)
                    && (!options.contains(.badge) || settings.badgeSetting == .enabled)
                    && (!options.contains(.criticalAlert) || settings.criticalAlertSetting == .enabled)
                    && (!options.contains(.carPlay) || settings.carPlaySetting == .enabled)
                status = ok ? .authorized : .denied
            @unknown default:
                status = .denied
            }
            DispatchQueue.main.async { completion(status) }
        }
    }

    /// 请求通知授权。`error` 不为 nil 视为请求出错,否则以 `granted` 判定成败。
    func requestNotification(options: UNAuthorizationOptions, completion: @escaping DyAction1<DyPerReqResult>) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            let result: DyPerReqResult = error.map { .denied(reason: .error($0)) }
                ?? (granted ? .authorized : .denied(reason: .userDenied))
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 相册权限
private extension DyPerChecker {
    /// 查询相册授权状态。
    /// - Note: iOS 14+ 使用 `authorizationStatus(for: .readWrite)`;旧版本使用旧 API。
    ///   `.limited`(用户仅选了部分照片)也视为已授权。
    func checkPhotoLibrary() -> DyPerStatus {
        let status: PHAuthorizationStatus = {
            if #available(iOS 14, *) {
                return PHPhotoLibrary.authorizationStatus(for: .readWrite)
            }
            return PHPhotoLibrary.authorizationStatus()
        }()
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized, .limited: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求相册权限。iOS 14+ 使用 `requestAuthorization(for: .readWrite, handler:)`。
    /// - Note: 系统回调可能在非主线程触发,这里统一派发到主线程后再回调。
    func requestPhotoLibrary(completion: @escaping DyAction1<DyPerReqResult>) {
        let handler: DyAction1<PHAuthorizationStatus> = { status in
            let result: DyPerReqResult = {
                switch status {
                case .authorized, .limited: return .authorized
                case .denied, .notDetermined, .restricted: return .denied(reason: .userDenied)
                @unknown default: return .denied(reason: .userDenied)
                }
            }()
            DispatchQueue.main.async { completion(result) }
        }
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: handler)
        } else {
            PHPhotoLibrary.requestAuthorization(handler)
        }
    }
}

// MARK: - 相机权限
private extension DyPerChecker {
    /// 查询相机授权状态。
    func checkCamera() -> DyPerStatus {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求相机权限。系统回调在非主线程,统一派发到主线程后回调。
    func requestCamera(completion: @escaping DyAction1<DyPerReqResult>) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            let result: DyPerReqResult = granted ? .authorized : .denied(reason: .userDenied)
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 麦克风权限
private extension DyPerChecker {
    /// 查询麦克风授权状态。
    func checkMicrophone() -> DyPerStatus {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求麦克风权限。系统回调在非主线程,统一派发到主线程后回调。
    func requestMicrophone(completion: @escaping DyAction1<DyPerReqResult>) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            let result: DyPerReqResult = granted ? .authorized : .denied(reason: .userDenied)
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 通讯录权限
private extension DyPerChecker {
    /// 查询通讯录授权状态。
    /// - Note: 通讯录的 `.limited` 表示「受限/部分」授权(如仅可访问部分联系人组),此处按拒绝处理。
    func checkContacts() -> DyPerStatus {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .notDetermined: return .notDetermined
        case .denied, .limited, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求通讯录权限。
    func requestContacts(completion: @escaping DyAction1<DyPerReqResult>) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            let result: DyPerReqResult = error.map { .denied(reason: .error($0)) }
                ?? (granted ? .authorized : .denied(reason: .userDenied))
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 广告追踪权限(IDFA)
private extension DyPerChecker {
    /// 查询广告追踪(IDFA)授权状态。
    /// - Note: iOS 14+ 使用 ATT(`ATTrackingManager`);旧版本使用 `isAdvertisingTrackingEnabled`。
    func checkAdTracking() -> DyPerStatus {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .notDetermined: return .notDetermined
            case .denied, .restricted: return .denied
            case .authorized: return .authorized
            @unknown default: return .denied
            }
        }
        return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? .authorized : .denied
    }

    /// 请求广告追踪授权。iOS 14+ 弹 ATT 弹窗;旧版本直接读取 `isAdvertisingTrackingEnabled` 并异步回调。
    func requestAdTracking(completion: @escaping DyAction1<DyPerReqResult>) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let result: DyPerReqResult = (status == .authorized)
                    ? .authorized : .denied(reason: .userDenied)
                DispatchQueue.main.async { completion(result) }
            }
        } else {
            let granted = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
            DispatchQueue.main.async { completion(granted ? .authorized : .denied(reason: .userDenied)) }
        }
    }
}

// MARK: - 定位权限
private extension DyPerChecker {
    /// 查询定位授权状态。
    func checkLocation() -> DyPerStatus {
        let status: CLAuthorizationStatus = {
            if #available(iOS 14, *) {
                return locationManager.authorizationStatus
            }
            return CLLocationManager.authorizationStatus()
        }()
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求定位授权。
    /// - Note: 定位通过 `CLLocationManagerDelegate` 异步返回结果。若用户**此前已授权或已拒绝**,
    ///   系统不会再弹窗、也不会触发 delegate 回调,此时必须在此直接回调并 return,否则调用方会永久等不到 completion。
    ///   只有 `.notDetermined` 才进入 delegate 等待路径。
    func requestLocation(type: DyPerReqType.LocationDyPerReqType, completion: @escaping DyAction1<DyPerReqResult>) {
        let current: CLAuthorizationStatus = {
            if #available(iOS 14, *) {
                return locationManager.authorizationStatus
            }
            return CLLocationManager.authorizationStatus()
        }()
        guard current == .notDetermined else {
            DispatchQueue.main.async { completion(self.locationResult(for: current)) }
            return
        }
        locationCallbackLock.lock()
        latestLocationCallback = completion
        locationCallbackLock.unlock()
        switch type {
        case .always: locationManager.requestAlwaysAuthorization()
        case .whenInUse: locationManager.requestWhenInUseAuthorization()
        }
    }

    /// 将系统定位授权状态映射为 `DyPerReqResult`。
    /// - Note: `.restricted`(如家长控制)映射为 `systemRestricted`,与用户主动拒绝区分开。
    func locationResult(for status: CLAuthorizationStatus) -> DyPerReqResult {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        case .restricted: return .denied(reason: .systemRestricted)
        default: return .denied(reason: .userDenied)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DyPerChecker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        finishLocationAuth(status)
    }

    @available(iOS 14.0, *)
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        finishLocationAuth(manager.authorizationStatus)
    }

    private func finishLocationAuth(_ status: CLAuthorizationStatus) {
        locationCallbackLock.lock()
        latestLocationCallback?(locationResult(for: status))
        latestLocationCallback = nil
        locationCallbackLock.unlock()
    }
}
