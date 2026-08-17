import UIKit

extension UIInterfaceOrientation: SoloExtension {}

// MARK: - 自定义
public extension SoloWrapper where Base == UIInterfaceOrientation {
    /// 是否为横屏方向(`left` 或 `right`)
    var isLandscape: Bool {
        base == .landscapeLeft || base == .landscapeRight
    }

    /// 转换为 `UIInterfaceOrientationMask`(用于判断支持性)
    var toInterfaceOrientationMask: UIInterfaceOrientationMask {
        switch base {
        case .portrait: return .portrait
        case .portraitUpsideDown: return .portraitUpsideDown
        case .landscapeLeft: return .landscapeLeft
        case .landscapeRight: return .landscapeRight
        case .unknown: return []
        default: return []
        }
    }
}
