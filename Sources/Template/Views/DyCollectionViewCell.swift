import UIKit
import Combine

open class DyCollectionViewCell: UICollectionViewCell, DySetupable {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }
}
