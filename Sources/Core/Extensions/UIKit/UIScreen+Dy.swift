import UIKit

// MARK: - 屏幕捕获监控器(主线程隔离)
private final class DyScreenCaptureMonitor {
    static let shared = DyScreenCaptureMonitor()

    private var isMonitoring = false
    private var screenshotObserver: NSObjectProtocol?
    private var captureObserver: NSObjectProtocol?

    private var onScreenshot: DyAction?
    private var onRecordingStart: DyAction?
    private var onRecordingStop: DyAction?

    private init() {}

    func start(
        onScreenshot: DyAction?,
        onRecordingStart: DyAction?,
        onRecordingStop: DyAction?
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
            if DyScreen.isCaptured {
                self.onRecordingStart?()
            }

            captureObserver = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                if DyScreen.isCaptured {
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
public extension DyWrapper where Base: UIScreen {
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
        onScreenshot: DyAction? = nil,
        onScreenRecordingStart: DyAction? = nil,
        onScreenRecordingStop: DyAction? = nil
    ) {
        DyScreenCaptureMonitor.shared.start(
            onScreenshot: onScreenshot,
            onRecordingStart: onScreenRecordingStart,
            onRecordingStop: onScreenRecordingStop
        )
    }

    /// 停止监听截屏和录屏事件
    static func stopMonitoring() {
        DyScreenCaptureMonitor.shared.stop()
    }
}
