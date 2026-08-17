import UIKit
import Combine
import SoloCore

open class SoloCollectionReusableView: UICollectionReusableView {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func collectionReusableView() -> Self {
        Self()
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - SoloSetupable
@objc extension SoloCollectionReusableView: SoloSetupable {}
