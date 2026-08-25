import UIKit
import Combine

open class DyButton: UIButton {
    public var cancellables = Set<AnyCancellable>()
    override open class func button() -> Self {
        Self(type: .custom)
            .dy
            .isHighlighted(false)
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
