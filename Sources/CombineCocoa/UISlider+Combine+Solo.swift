import Combine
import UIKit

// MARK: - UISlider
public extension UISlider {
    /// 滑块当前值（可读当前值、可绑定写回）。
    var solo_valuePublisher: ControlProperty<Float> {
        ControlProperty(
            values: publisher(for: \.value, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.value = $0 }
        )
    }
}
