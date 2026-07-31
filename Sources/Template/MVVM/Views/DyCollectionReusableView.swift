import UIKit
import Combine
import DyCore

open class DyCollectionReusableView: UICollectionReusableView {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func collectionReusableView() -> DyCollectionReusableView {
        DyCollectionReusableView()
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - DySetupable
@objc extension DyCollectionReusableView: DySetupable {}
