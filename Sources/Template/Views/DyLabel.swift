import UIKit

open class DyLabel: UILabel {
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func dy_label() -> DyLabel {
        DyLabel()
            .dy
            .lineBreakMode(.byCharWrapping)
            .build()
    }
}
