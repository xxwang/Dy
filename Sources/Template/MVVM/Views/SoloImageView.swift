import UIKit
import Combine

open class SoloImageView: UIImageView {
    public var cancellables = Set<AnyCancellable>()

    override public required init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func imageView() -> Self {
        Self(frame: .zero)
            .solo
            .contentMode(.scaleAspectFit)
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
