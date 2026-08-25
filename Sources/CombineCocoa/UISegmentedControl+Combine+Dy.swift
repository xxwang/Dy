import Combine
import UIKit

// MARK: - UISegmentedControl
public extension UISegmentedControl {
    /// 当前选中项索引（可读当前值、可绑定写回）。
    var dy_selectedSegmentIndexPublisher: ControlProperty<Int> {
        ControlProperty(
            values: publisher(for: \.selectedSegmentIndex, options: [.initial, .new]).eraseToAnyPublisher(),
            setter: { self.selectedSegmentIndex = $0 }
        )
    }
}
