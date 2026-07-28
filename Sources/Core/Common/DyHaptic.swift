import UIKit

// MARK: - 触觉反馈工具
/// 触觉反馈管理器。必须在主线程使用，因此标注为 ``@MainActor``
@MainActor
public final class DyHaptic {
    /// 触觉反馈类型
    public enum DyFeedback {
        /// 触觉反馈
        case impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
        /// 选择变化反馈
        case selectionChanged
        /// 通知反馈
        case notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
    }

    public static let shared = DyHaptic()
    private init() {}

    // 缓存 generator 实例，避免每次触觉反馈都新建 + `prepare()` 的开销（Apple 也建议复用）。
    private let impactLock = NSLock()
    private var impactGenerators: [Int: UIImpactFeedbackGenerator] = [:]
    private let selectionGenerator = UISelectionFeedbackGenerator()
    private let notificationGenerator = UINotificationFeedbackGenerator()
}

// MARK: - 触觉反馈方法
public extension DyHaptic {
    /// 触发触觉反馈
    /// - Parameter haptic: 触觉反馈类型
    func haptic(_ feedback: DyFeedback) {
        switch feedback {
        case let .impact(style): // 触觉反馈
            impactGenerator(for: style).impactOccurred()

        case .selectionChanged: // 选择变化反馈
            selectionGenerator.selectionChanged()

        case let .notification(feedbackType): // 通知反馈
            notificationGenerator.notificationOccurred(feedbackType)
        }
    }

    /// 获取（并按 style 缓存）冲击反馈 generator；仅在首次创建时 `prepare()` 一次
    private func impactGenerator(for style: UIImpactFeedbackGenerator.FeedbackStyle) -> UIImpactFeedbackGenerator {
        let key = style.rawValue
        impactLock.lock()
        defer { impactLock.unlock() }
        if let existing = impactGenerators[key] {
            return existing
        }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        impactGenerators[key] = generator
        return generator
    }

    /// 触发轻量冲击反馈
    func lightImpact() {
        self.haptic(.impact(.light))
    }

    /// 触发中等冲击反馈(默认常用)
    func mediumImpact() {
        self.haptic(.impact(.medium))
    }

    /// 触发强冲击反馈
    func heavyImpact() {
        self.haptic(.impact(.heavy))
    }

    /// 触发刚性冲击反馈
    func rigidImpact() {
        self.haptic(.impact(.rigid))
    }

    /// 触发软性冲击反馈
    func softImpact() {
        self.haptic(.impact(.soft))
    }

    /// 触发选择变化反馈
    func selectionChanged() {
        self.haptic(.selectionChanged)
    }

    /// 触发通知反馈(成功/警告/错误)
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        self.haptic(.notification(type))
    }
}
