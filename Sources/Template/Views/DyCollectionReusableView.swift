import UIKit
import Combine

open class DyCollectionReusableView: UICollectionReusableView, DySetupable {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func dy_collectionReusableView() -> DyCollectionReusableView {
        DyCollectionReusableView()
    }

    deinit {
        cancellables.removeAll()
    }
}
