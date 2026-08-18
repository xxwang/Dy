import UIKit
import Combine
import SoloCore

open class SoloTableViewCell: UITableViewCell {
    public var cancellables = Set<AnyCancellable>()

    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - SoloSetupable
@objc extension SoloTableViewCell: SoloSetupable {
    /// 配置UI
    open func setupUI() {
        self.solo
            .selectionStyle(.none)
            .backgroundColor(.clear)
    }

    /// 绑定事件
    open func bindEvents() {}
}
