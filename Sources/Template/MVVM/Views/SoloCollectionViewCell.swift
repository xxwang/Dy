import UIKit
import Combine
import SoloCore

open class SoloCollectionViewCell: UICollectionViewCell {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - SoloSetupable
@objc extension SoloCollectionViewCell: SoloSetupable {}
