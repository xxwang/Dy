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

    override open class func dy_tabBar() -> DyTabBar {
        DyTabBar().dy_isTranslucent(false)
            .dy_backgroundColor(.clear)
            .dy_shadowImage(UIImage(color: .clear) ?? UIImage())
    }

    deinit {
        cancellables.removeAll()
    }
}
