import UIKit
import Combine

open class SoloButton: UIButton {
    public var cancellables = Set<AnyCancellable>()
    override open class func button() -> Self {
        Self(type: .custom)
            .solo
            .isHighlighted(false)
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
