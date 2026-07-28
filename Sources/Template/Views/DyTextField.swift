import UIKit
import Combine

open class DyTextField: UITextField {
    public var cancellables = Set<AnyCancellable>()
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func dy_textField() -> DyTextField {
        DyTextField()
    }

    deinit {
        cancellables.removeAll()
    }
}
