import UIKit
import Combine
import DyCore

@available(iOS 14.0, *)
open class DyCollectionViewListCell: UICollectionViewListCell {
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

// MARK: - DySetupable
@available(iOS 14.0, *)
@objc extension DyCollectionViewListCell: DySetupable {}
