import UIKit

// MARK: - 触觉反馈工具
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
}

// MARK: - 触觉反馈方法
public extension DyHaptic {
    /// 触发触觉反馈
    /// - Parameter haptic: 触觉反馈类型
    func haptic(_ feedback: DyFeedback) {
        switch feedback {
        case let .impact(style): // 触觉反馈

            let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
            impactFeedbackGenerator.prepare()
            impactFeedbackGenerator.impactOccurred()

        case .selectionChanged: // 选择变化反馈

            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()

        case let .notification(feedbackType): // 通知反馈

            let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
            notificationFeedbackGenerator.prepare()
            notificationFeedbackGenerator.notificationOccurred(feedbackType)
        }
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
