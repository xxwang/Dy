import UIKit
import Combine

open class DyTextView: UITextView {
    public var cancellables = Set<AnyCancellable>()
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func textView() -> DyTextView {
        DyTextView()
    }

    deinit {
        cancellables.removeAll()
    }
}
