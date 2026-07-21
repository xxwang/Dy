import UIKit

open class DyButton: UIButton {
    /// 取消按住高亮
    override open var isHighlighted: Bool {
        didSet {
            super.isHighlighted = isHighlighted
        }
    }

    override open class func dy_button() -> DyButton {
        DyButton(type: .custom)
            .dy
            .isHighlighted(false)
            .build()
    }
}
