import UIKit
import Combine

open class DyControl: UIControl {
    open var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func control() -> Self {
        Self()
            .dy
            .isHighlighted(false)
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
