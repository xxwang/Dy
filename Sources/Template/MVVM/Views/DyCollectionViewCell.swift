import UIKit
import Combine
import DyCore

open class DyCollectionViewCell: UICollectionViewCell {
    public var cancellables = Set<AnyCancellable>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - DySetupable
@objc extension DyCollectionViewCell: DySetupable {
    /// 配置UI
    open func setupUI() {}

    /// 绑定事件
    open func bindEvents() {}
}
