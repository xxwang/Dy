import UIKit
import Combine

open class SoloLabel: UILabel {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func label() -> Self {
        Self()
            .solo
            .lineBreakMode(.byTruncatingTail)
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
