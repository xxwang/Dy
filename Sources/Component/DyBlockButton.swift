import UIKit
import DyCore

open class DyBlockButton: UIButton {
    /// 按钮点击处理回调
    var clickBlock: (DyAction1<DyBlockButton>)?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 工厂创建方法
    override open class func dy_button() -> DyBlockButton {
        DyBlockButton()
    }
}

extension DyBlockButton {
    /// 按钮点击处理
    @objc func clickHandler(_ sender: DyBlockButton) {
        if let block = self.clickBlock {
            block(sender)
        }
    }
}


// MARK: - 链式配置(自定义)
public extension DyWrapper where Base: DyBlockButton {
    /// 绑定点击处理回调
    /// - Parameter block: 点击处理回调
    /// - Returns: `Self`
    func clickBlock(_ block: @escaping (DyBlockButton) -> Void) -> Self {
        base.clickBlock = block
        base.removeTarget(self.base, action: #selector(DyBlockButton.clickHandler(_:)), for: .touchUpInside)
        base.addTarget(self.base, action: #selector(DyBlockButton.clickHandler(_:)), for: .touchUpInside)
        return self
    }
}

