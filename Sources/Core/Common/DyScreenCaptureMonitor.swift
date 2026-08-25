import UIKit
import os.log

// MARK: - 屏幕捕获监控器
public final class DyScreenCaptureMonitor {
    public static let shared = DyScreenCaptureMonitor()

    private var isMonitoring = false
    private var screenshotObserver: NSObjectProtocol?
    private var captureObserver: NSObjectProtocol?

    private var onScreenshot: DyAction?
    private var onRecordingStart: DyAction?
    private var onRecordingStop: DyAction?

    private init() {}
}

public extension DyScreenCaptureMonitor {
    func start(
        onScreenshot: DyAction?,
        onRecordingStart: DyAction?,
        onRecordingStop: DyAction?
    ) {
        guard !isMonitoring else {
            os_log("⚠️ UIScreen.startMonitoring 已在监听中,忽略重复调用")
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
