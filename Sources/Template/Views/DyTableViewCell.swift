import UIKit
import Combine

open class DyTableViewCell: UITableViewCell, DySetupable {
    public var cancellables = Set<AnyCancellable>()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.dy_selectionStyle(.none)
            .dy_backgroundColor(.clear)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
