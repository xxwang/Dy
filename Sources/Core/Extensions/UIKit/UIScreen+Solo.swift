import UIKit

// MARK: - 屏幕捕获监控器(主线程隔离)
private final class SoloScreenCaptureMonitor {
    static let shared = SoloScreenCaptureMonitor()

    private var isMonitoring = false
    private var screenshotObserver: NSObjectProtocol?
    private var captureObserver: NSObjectProtocol?

    private var onScreenshot: SoloAction?
    private var onRecordingStart: SoloAction?
    private var onRecordingStop: SoloAction?

    private init() {}

    func start(
        onScreenshot: SoloAction?,
        onRecordingStart: SoloAction?,
        onRecordingStop: SoloAction?
    ) {
        guard !isMonitoring else {
            debugPrint("⚠️ UIScreen.startMonitoring 已在监听中,忽略重复调用")
            return
        }

        self.onScreenshot = onScreenshot
        self.onRecordingStart = onRecordingStart
        self.onRecordingStop = onRecordingStop

        // 监听截屏
        screenshotObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.userDidTakeScreenshotNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.onScreenshot?()
        }

        // 监听录屏(iOS 11+)
        if #available(iOS 11.0, *) {
            if SoloScreen.isCaptured {
                self.onRecordingStart?()
            }

            captureObserver = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                if SoloScreen.isCaptured {
                    self.onRecordingStart?()
                } else {
                    self.onRecordingStop?()
                }
            }
        }

        isMonitoring = true
    }

    func stop() {
        if let observer = screenshotObserver {
            NotificationCenter.default.removeObserver(observer)
            screenshotObserver = nil
        }
        if let observer = captureObserver {
            NotificationCenter.default.removeObserver(observer)
            captureObserver = nil
        }

        onScreenshot = nil
        onRecordingStart = nil
        onRecordingStop = nil
        isMonitoring = false
    }
}

// MARK: - 截屏与录屏监测
public extension SoloWrapper where Base: UIScreen {
    /// 开始监听截屏和录屏事件
    ///
    /// - Parameters:
    ///   - onScreenshot: 用户触发系统截屏时回调
    ///   - onScreenRecordingStart: 开始录屏/投屏/镜像时回调
    ///   - onScreenRecordingStop: 停止录屏/投屏/镜像时回调
    ///
    /// - Note:
    ///   - 自动在主线程执行,支持从任意线程调用
    ///   - 多次调用不会重复注册
    ///   - 仅监听主屏幕,自动适配 iOS 16+ Scene API
    static func startMonitoring(
        onScreenshot: SoloAction? = nil,
        onScreenRecordingStart: SoloAction? = nil,
        onScreenRecordingStop: SoloAction? = nil
    ) {
        SoloScreenCaptureMonitor.shared.start(
            onScreenshot: onScreenshot,
            onRecordingStart: onScreenRecordingStart,
            onRecordingStop: onScreenRecordingStop
        )
    }

    /// 停止监听截屏和录屏事件
    static func stopMonitoring() {
        SoloScreenCaptureMonitor.shared.stop()
    }
}
