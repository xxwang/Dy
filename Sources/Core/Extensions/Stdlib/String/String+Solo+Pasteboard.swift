import Foundation

#if canImport(UIKit)
    import UIKit
#endif

// MARK: - 剪贴板
public extension String {
    /// 将字符串复制到系统剪贴板
    ///
    /// - Note: 在 iOS 上使用 `UIPasteboard`,在 macOS 上使用 `NSPasteboard`
    func solo_copyToPasteboard() {
        #if os(iOS)
            UIPasteboard.general.string = self
        #elseif os(macOS)
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(base, forType: .string)
        #endif
    }
}
