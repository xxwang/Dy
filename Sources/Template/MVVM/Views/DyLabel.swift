import UIKit
import Combine

open class DyLabel: UILabel {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func label() -> DyLabel {
        DyLabel().dy_lineBreakMode(.byTruncatingTail)
    }

    deinit {
        cancellables.removeAll()
    }
}
