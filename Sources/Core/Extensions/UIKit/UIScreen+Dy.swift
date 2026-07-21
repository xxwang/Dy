import UIKit

// MARK: - 截屏与录屏监测
public extension UIScreen {
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
    ///   - 仅监听主屏幕(`UIScreen.main`)
    static func dy_startMonitoring(
        onScreenshot: DyAction? = nil,
        onScreenRecordingStart: DyAction? = nil,
        onScreenRecordingStop: DyAction? = nil
    ) {
        ScreenCaptureMonitor.shared.start(
            onScreenshot: onScreenshot,
            onRecordingStart: onScreenRecordingStart,
            onRecordingStop: onScreenRecordingStop
        )
    }

    /// 停止监听截屏和录屏事件
    static func dy_stopMonitoring() {
        ScreenCaptureMonitor.shared.stop()
    }
}

// MARK: - 屏幕捕获监控器(主线程隔离)
private final class ScreenCaptureMonitor {
    static let shared = ScreenCaptureMonitor()

    private var isMonitoring = false
    private var screenshotObserver: NSObjectProtocol?
    private var captureObserver: NSObjectProtocol?

    private var onScreenshot: DyAction?
    private var onRecordingStart: DyAction?
    private var onRecordingStop: DyAction?

    private init() {}

    func dy_start(
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
            MainActor.assumeIsolated {
                self.onScreenshot?()
            }
        }

        // 监听录屏(iOS 11+)
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                MainActor.assumeIsolated {
                    self.onRecordingStart?()
                }
            }

            captureObserver = NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self else { return }
                MainActor.assumeIsolated {
                    if UIScreen.main.isCaptured {
                        self.onRecordingStart?()
                    } else {
                        self.onRecordingStop?()
                    }
                }
            }
        }

        isMonitoring = true
    }

    func dy_stop() {
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
