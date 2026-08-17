import UIKit
import Combine
import SoloCore

open class SoloView: UIView {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func view() -> Self {
        Self()
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - SoloSetupable
@objc extension SoloView: SoloSetupable {}
