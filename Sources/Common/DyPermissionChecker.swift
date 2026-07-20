import AdSupport
import AppTrackingTransparency
import AVFoundation
import Contacts
import CoreLocation
import HealthKit
import Photos
import UserNotifications
import UIKit

// MARK: - 权限类型
public enum DyPermissionType {
    /// 访问相册(照片库)
    case photoLibrary

    /// 使用相机
    case camera

    /// 使用麦克风
    case microphone

    /// 访问通讯录
    case contacts

    /// 读取或写入健康数据(需提供读/写类型配置)
    case health(DyHealthPermissionConfig)

    /// 请求广告追踪授权(IDFA)
    case adTracking

    /// 定位权限(使用时或始终)
    case location(LocationDyPermissionType)

    /// 推送通知权限(可自定义选项)
    case notification(options: UNAuthorizationOptions = [.alert, .sound, .badge])

    /// 定位权限的具体类型
    public enum LocationDyPermissionType {
        /// 仅在应用使用期间获取位置
        case whenInUse

        /// 始终获取位置(包括后台)
        case always
    }
}

// MARK: - 健康权限的读写配置
/// - Note: 必须至少包含一个读类型或写类型,否则请求无效
public struct DyHealthPermissionConfig {
    /// 要读取的健康数据类型集合
    public let readTypes: Set<HKObjectType>

    /// 要写入的健康样本类型集合
    public let writeTypes: Set<HKSampleType>

    /// 创建健康权限配置
    /// - Parameters:
    ///   - read: 要读取的健康类型(默认为空)
    ///   - write: 要写入的样本类型(默认为空)
    public init(read: Set<HKObjectType> = [], write: Set<HKSampleType> = []) {
        self.readTypes = read
        self.writeTypes = write
    }

    /// 判断配置是否有效(至少包含一个读或写类型)
    public var isValid: Bool {
        !readTypes.isEmpty || !writeTypes.isEmpty
    }
}

// MARK: - 权限状态与结果
public enum DyPermissionStatus {
    /// 尚未请求过权限
    case notDetermined

    /// 用户已拒绝或系统限制
    case denied

    /// 用户已授权
    case authorized
}

// MARK: - 权限请求的异步结果,包含授权状态及详细拒绝原因
public enum DyPermissionResult {
    /// 用户已授权
    case authorized

    /// 用户或系统拒绝了权限请求
    case denied(reason: DenialReason)
}

/// 权限被拒绝的具体原因
public enum DenialReason {
    /// 用户明确拒绝
    case userDenied

    /// 系统策略限制(如家长控制、设备管理)
    case systemRestricted

    /// 请求过程中发生错误(如 HealthKit 返回错误)
    case error(Error)
}

/// 权限请求完成回调
public typealias DyPermissionCompletion = @Sendable (DyPermissionResult) -> Void

// MARK: - 权限管理器
public final class DyPermissionChecker: NSObject {
    private let healthStore = HKHealthStore()

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    /// 仅保留最新一次位置请求的回调(避免多次请求混乱)
    private var latestLocationCallback: DyPermissionCompletion?

    /// 共享单例实例
    public static let shared = DyPermissionChecker()
    override private init() {
        super.init()
    }

    /// 检查指定权限的当前状态(仅支持可同步查询的权限)
    ///
    /// - Parameter type: 要检查的权限类型
    /// - Returns: 权限状态;若该权限不支持同步检查(如通知、健康),返回 `nil`
    public func checkStatus(for type: DyPermissionType) -> DyPermissionStatus? {
        switch type {
        case .photoLibrary: return checkPhotoLibraryStatus()
        case .camera: return checkCameraStatus()
        case .microphone: return checkMicrophoneStatus()
        case .contacts: return checkContactsStatus()
        case .health: return nil // 不支持同步检查
        case .adTracking: return checkAdTrackingStatus()
        case .location: return checkLocationStatus()
        case .notification: return nil // 必须异步查询
        }
    }

    /// 异步请求指定权限
    ///
    /// - Parameters:
    ///   - type: 要请求的权限类型
    ///   - completion: 请求完成回调,返回授权结果
    public func request(_ type: DyPermissionType, completion: @escaping DyPermissionCompletion) {
        switch type {
        case .photoLibrary:
            requestPhotoLibraryPermission(completion: completion)
        case .camera:
            requestCameraPermission(completion: completion)
        case .microphone:
            requestMicrophonePermission(completion: completion)
        case .contacts:
            requestContactsPermission(completion: completion)
        case let .health(config):
            if #available(iOS 8.0, *) {
                guard config.isValid else {
                    DispatchQueue.main.async {
                        completion(.denied(reason: .error(NSError(domain: "DyPermission", code: -1, userInfo: [NSLocalizedDescriptionKey: "Health permission config is empty"]))))
                    }
                    return
                }
                requestHealthPermission(config: config, completion: completion)
            } else {
                DispatchQueue.main.async {
                    completion(.denied(reason: .systemRestricted))
                }
            }
        case .adTracking:
            if #available(iOS 14, *) {
                requestAdTrackingPermission(completion: completion)
            } else {
                // iOS < 14 无 ATT 弹窗,但广告标识符可用(除非用户关闭)
                let granted = ASIdentifierManager.shared().isAdvertisingTrackingEnabled
                DispatchQueue.main.async {
                    completion(granted ? .authorized : .denied(reason: .userDenied))
                }
            }
        case let .location(locationType):
            requestLocationPermission(type: locationType, completion: completion)
        case let .notification(options):
            requestNotificationPermission(options: options, completion: completion)
        }
    }

    /// 异步获取通知权限的详细设置状态(用于判断具体选项是否启用)
    ///
    /// - Parameters:
    ///   - options: 要检查的通知选项(如 `.badge`, `.sound`)
    ///   - completion: 返回组合后的权限状态(若所有指定选项均启用则为 `.authorized`)
    public func checkNotificationSettings(
        for options: UNAuthorizationOptions,
        completion: @escaping (DyPermissionStatus) -> Void
    ) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            var status: DyPermissionStatus = .denied

            switch settings.authorizationStatus {
            case .notDetermined:
                status = .notDetermined
            case .denied:
                status = .denied
            case .authorized, .ephemeral, .provisional:
                let hasAlert = !options.contains(.alert) || settings.alertSetting == .enabled
                let hasSound = !options.contains(.sound) || settings.soundSetting == .enabled
                let hasBadge = !options.contains(.badge) || settings.badgeSetting == .enabled
                let hasCritical = !options.contains(.criticalAlert) || settings.criticalAlertSetting == .enabled
                let hasCarPlay = !options.contains(.carPlay) || settings.carPlaySetting == .enabled

                status = (hasAlert && hasSound && hasBadge && hasCritical && hasCarPlay) ? .authorized : .denied
            @unknown default:
                status = .denied
            }

            DispatchQueue.main.async { completion(status) }
        }
    }
}

// MARK: - 相册权限
extension DyPermissionChecker {
    /// 检查相册权限的当前授权状态
    private func checkPhotoLibraryStatus() -> DyPermissionStatus {
        let status: PHAuthorizationStatus = {
            if #available(iOS 14, *) {
                return PHPhotoLibrary.authorizationStatus(for: .readWrite)
            } else {
                return PHPhotoLibrary.authorizationStatus()
            }
        }()

        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized, .limited: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求相册访问权限
    private func requestPhotoLibraryPermission(completion: @escaping DyPermissionCompletion) {
        let handler: (PHAuthorizationStatus) -> Void = { status in
            let result: DyPermissionResult = {
                switch status {
                case .authorized, .limited: return .authorized
                case .denied, .restricted: return .denied(reason: .userDenied)
                case .notDetermined: return .denied(reason: .userDenied)
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

// MARK: - 相机 & 麦克风
extension DyPermissionChecker {
    /// 检查相机权限状态
    private func checkCameraStatus() -> DyPermissionStatus {
        return checkAVMediaType(.video)
    }

    /// 请求相机权限
    private func requestCameraPermission(completion: @escaping DyPermissionCompletion) {
        requestAVMediaType(.video, completion: completion)
    }

    /// 检查麦克风权限状态
    private func checkMicrophoneStatus() -> DyPermissionStatus {
        return checkAVMediaType(.audio)
    }

    /// 请求麦克风权限
    private func requestMicrophonePermission(completion: @escaping DyPermissionCompletion) {
        requestAVMediaType(.audio, completion: completion)
    }

    /// 检查指定 AVMediaType(音频/视频)的权限状态
    private func checkAVMediaType(_ mediaType: AVMediaType) -> DyPermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求指定 AVMediaType(音频/视频)的访问权限
    private func requestAVMediaType(_ mediaType: AVMediaType, completion: @escaping DyPermissionCompletion) {
        AVCaptureDevice.requestAccess(for: mediaType) { granted in
            let result: DyPermissionResult = granted ? .authorized : .denied(reason: .userDenied)
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 通讯录
extension DyPermissionChecker {
    /// 检查通讯录权限状态
    private func checkContactsStatus() -> DyPermissionStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .limited, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求通讯录访问权限
    private func requestContactsPermission(completion: @escaping DyPermissionCompletion) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            let result: DyPermissionResult = {
                if let error {
                    return .denied(reason: .error(error))
                }
                return granted ? .authorized : .denied(reason: .userDenied)
            }()
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 健康数据
extension DyPermissionChecker {
    /// 请求 HealthKit 读写权限
    private func requestHealthPermission(
        config: DyHealthPermissionConfig,
        completion: @escaping DyPermissionCompletion
    ) {
        healthStore.requestAuthorization(toShare: config.writeTypes, read: config.readTypes) { success, error in
            let result: DyPermissionResult = {
                if let error {
                    return .denied(reason: .error(error))
                }
                return success ? .authorized : .denied(reason: .userDenied)
            }()
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 广告追踪(IDFA)
extension DyPermissionChecker {
    /// 检查广告追踪授权状态
    private func checkAdTrackingStatus() -> DyPermissionStatus {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .notDetermined: return .notDetermined
            case .denied, .restricted: return .denied
            case .authorized: return .authorized
            @unknown default: return .denied
            }
        } else {
            return ASIdentifierManager.shared().isAdvertisingTrackingEnabled ? .authorized : .denied
        }
    }

    /// 请求广告追踪授权
    private func requestAdTrackingPermission(completion: @escaping DyPermissionCompletion) {
        ATTrackingManager.requestTrackingAuthorization { status in
            let result: DyPermissionResult = {
                switch status {
                case .authorized: return .authorized
                case .denied, .restricted: return .denied(reason: .userDenied)
                case .notDetermined: return .denied(reason: .userDenied)
                @unknown default: return .denied(reason: .userDenied)
                }
            }()
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 定位权限
extension DyPermissionChecker {
    /// 检查定位权限的当前状态
    private func checkLocationStatus() -> DyPermissionStatus {
        let status: CLAuthorizationStatus = {
            if #available(iOS 14, *) {
                return locationManager.authorizationStatus
            } else {
                return CLLocationManager.authorizationStatus()
            }
        }()

        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorizedAlways, .authorizedWhenInUse: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求定位权限(根据类型选择“使用时”或“始终”)
    private func requestLocationPermission(
        type: DyPermissionType.LocationDyPermissionType,
        completion: @escaping DyPermissionCompletion
    ) {
        latestLocationCallback = completion
        switch type {
        case .always: locationManager.requestAlwaysAuthorization()
        case .whenInUse: locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DyPermissionChecker: @MainActor CLLocationManagerDelegate {
    /// 监听定位权限变更事件,并调用对应的回调
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let granted = (status == .authorizedWhenInUse || status == .authorizedAlways)
        let result: DyPermissionResult = granted ? .authorized : .denied(reason: .userDenied)
        latestLocationCallback?(result)
        latestLocationCallback = nil // 清空回调,防止重复触发
    }
}

// MARK: - 通知权限
extension DyPermissionChecker {
    /// 请求推送通知权限
    private func requestNotificationPermission(
        options: UNAuthorizationOptions,
        completion: @escaping DyPermissionCompletion
    ) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            let result: DyPermissionResult = {
                if let error {
                    return .denied(reason: .error(error))
                }
                return granted ? .authorized : .denied(reason: .userDenied)
            }()
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}

