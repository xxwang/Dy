import Combine
import UIKit

// MARK: - UISwitch

public extension UISwitch {
    /// 开关状态（可读当前值、可绑定写回）。
    var dy_isOnPublisher: ControlProperty<Bool> {
        ControlProperty(
            values: publisher(for: \.isOn, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.isOn = $0 }
        )
    }
}
