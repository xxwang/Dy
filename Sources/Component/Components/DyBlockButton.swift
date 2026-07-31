import UIKit
import DyCore

open class DyBlockButton: UIButton {
    /// 按钮点击处理回调。子类可重写或在初始化后设置
    open var clickBlock: DyAction1<DyBlockButton>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 工厂创建方法
    override open class func button() -> DyBlockButton {
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
public extension DyBlockButton {
    /// 绑定点击处理回调
    /// - Warning: 闭包被按钮**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 点击处理回调
    /// - Returns: `Self`
    func dy_clickBlock(_ block: @escaping DyAction1<DyBlockButton>) -> Self {
        self.clickBlock = block
        self.removeTarget(self, action: #selector(DyBlockButton.clickHandler(_:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(DyBlockButton.clickHandler(_:)), for: .touchUpInside)
        return self
    }
}
