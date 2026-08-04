import Combine
import UIKit

// MARK: - UIStepper
public extension UIStepper {
    /// 当前步进值（可读当前值、可绑定写回）。
    var dy_valuePublisher: ControlProperty<Double> {
        ControlProperty(
            values: publisher(for: \.value, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.value = $0 }
        )
    }
}
