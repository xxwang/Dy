import UIKit
import Combine

open class DyButton: UIButton {
    public var cancellables = Set<AnyCancellable>()
    override open class func button() -> DyButton {
        DyButton(type: .custom).dy_isHighlighted(false)
    }

    deinit {
        cancellables.removeAll()
    }
}
