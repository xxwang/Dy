import UIKit

open class DyTextField: UITextField {
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func dy_textField() -> DyLabel {
        DyTextField()
    }
}
