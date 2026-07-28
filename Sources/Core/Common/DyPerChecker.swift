import AdSupport
import AppTrackingTransparency
import AVFoundation
import Contacts
import CoreLocation
import HealthKit
import Photos
import UserNotifications
import UIKit

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
    /// 定位管理对象
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    }()

    /// 仅保留最新一次位置请求的回调，通过 lock 保护
    private var latestLocationCallback: DyAction1<DyPerReqResult>?
    private let locationCallbackLock = NSLock()

    public static let shared = DyPerChecker()
    override private init() {
        super.init()
    }
}

// MARK: - 通知
public extension DyPerChecker {
    /// 异步获取通知权限的详细设置状态
    func checkNotificationSettings(for options: UNAuthorizationOptions, completion: @escaping DyAction1<DyPerStatus>) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            var status: DyPerStatus = .denied
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

    /// 请求通知权限
    func requestNotificationPer(options: UNAuthorizationOptions, completion: @escaping DyAction1<DyPerReqResult>) {
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            let result: DyPerReqResult = {
                if let error {
                    return .denied(reason: .error(error))
                }
                return granted ? .authorized : .denied(reason: .userDenied)
            }()
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 相册权限
public extension DyPerChecker {
    /// 获取相册权限状态
    func checkPhotoLibraryStatus() -> DyPerStatus {
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

    /// 请求相册权限
    func requestPhotoLibraryPer(completion: @escaping DyAction1<DyPerReqResult>) {
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

// MARK: - 相机
private extension DyPerChecker {
    /// 获取相机权限状态
    func checkCameraStatus() -> DyPerStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求相机权限
    func requestCameraPer(completion: @escaping DyAction1<DyPerReqResult>) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            let result: DyPerReqResult = granted ? .authorized : .denied(reason: .userDenied)
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 麦克风
public extension DyPerChecker {
    /// 获取麦克风权限状态
    func checkMicrophoneStatus() -> DyPerStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求麦克风权限
    func requestMicrophonePer(completion: @escaping DyAction1<DyPerReqResult>) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            let result: DyPerReqResult = granted ? .authorized : .denied(reason: .userDenied)
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 通讯录
private extension DyPerChecker {
    /// 获取通讯录权限状态
    func checkContactsStatus() -> DyPerStatus {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        switch status {
        case .notDetermined: return .notDetermined
        case .denied, .limited, .restricted: return .denied
        case .authorized: return .authorized
        @unknown default: return .denied
        }
    }

    /// 请求通讯录权限
    func requestContactsPerm(completion: @escaping DyAction1<DyPerReqResult>) {
        CNContactStore().requestAccess(for: .contacts) { granted, error in
            let result: DyPerReqResult = {
                if let error {
                    return .denied(reason: .error(error))
                }
                return granted ? .authorized : .denied(reason: .userDenied)
            }()
            DispatchQueue.main.async { completion(result) }
        }
    }
}

// MARK: - 广告追踪(IDFA)
private extension DyPerChecker {
    /// 获取广告追踪权限状态
    func checkAdTrackingStatus() -> DyPerStatus {
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

    /// 请求广告追踪权限
    func requestAdTrackingPer(completion: @escaping DyAction1<DyPerReqResult>) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                let result: DyPerReqResult = {
                    switch status {
                    case .authorized: return .authorized
                    case .denied, .notDetermined, .restricted: return .denied(reason: .userDenied)
                    @unknown default: return .denied(reason: .userDenied)
                    }
                }()
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
    /// 获取定位权限状态
    func checkLocationStatus() -> DyPerStatus {
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

    /// 请求定位权限
    func requestLocationPer(type: DyPerReqType.LocationDyPerReqType, completion: @escaping DyAction1<DyPerReqResult>) {
        locationCallbackLock.lock()
        self.latestLocationCallback = completion
        locationCallbackLock.unlock()
        switch type {
        case .always:
            locationManager.requestAlwaysAuthorization()
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - 统一权限入口(公共 API)
public extension DyPerChecker {
    /// 查询指定权限的当前授权状态(同步)
    /// - Parameter type: 权限类型
    /// - Returns: 权限状态
    func checkStatus(for type: DyPerReqType) -> DyPerStatus {
        switch type {
        case .photoLibrary: return checkPhotoLibraryStatus()
        case .camera: return checkCameraStatus()
        case .microphone: return checkMicrophoneStatus()
        case .contacts: return checkContactsStatus()
        case .adTracking: return checkAdTrackingStatus()
        case .location: return checkLocationStatus()
        case .notification: return .notDetermined
        }
    }

    /// 请求指定权限(异步回调主线程)
    /// - Parameters:
    ///   - type: 权限类型
    ///   - completion: 完成回调,在主线程执行
    func request(_ type: DyPerReqType, completion: @escaping DyAction1<DyPerReqResult>) {
        switch type {
        case .photoLibrary:
            requestPhotoLibraryPer(completion: completion)
        case .camera:
            requestCameraPer(completion: completion)
        case .microphone:
            requestMicrophonePer(completion: completion)
        case .contacts:
            requestContactsPerm(completion: completion)
        case .adTracking:
            requestAdTrackingPer(completion: completion)
        case let .location(locType):
            requestLocationPer(type: locType, completion: completion)
        case let .notification(options):
            requestNotificationPer(options: options, completion: completion)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension DyPerChecker: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let granted = (status == .authorizedWhenInUse || status == .authorizedAlways)
        let result: DyPerReqResult = granted ? .authorized : .denied(reason: .userDenied)
        locationCallbackLock.lock()
        latestLocationCallback?(result)
        latestLocationCallback = nil
        locationCallbackLock.unlock()
    }
}
