import UIKit
import Combine

open class DyTabBar: UITabBar {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class func tabBar() -> Self {
        Self()
            .dy
            .isTranslucent(false)
            .backgroundColor(.clear)
            .shadowImage(UIImage(color: .clear) ?? UIImage())
            .build()
    }

    deinit {
        cancellables.removeAll()
    }
}
