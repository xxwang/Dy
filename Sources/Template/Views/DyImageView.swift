import UIKit
import Combine

open class DyImageView: UIImageView {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func dy_imageView() -> DyImageView {
        DyImageView(frame: .zero)
            .dy
            .contentMode(.scaleAspectFit)
            .build()
    }
}
