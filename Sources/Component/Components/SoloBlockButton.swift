import UIKit
import SoloCore

open class SoloBlockButton: UIButton {
    /// 按钮点击处理回调。子类可重写或在初始化后设置
    open var clickBlock: SoloAction1<SoloBlockButton>?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 工厂创建方法
    override open class func button() -> Self {
        Self(type: .custom)
    }
}

extension SoloBlockButton {
    /// 按钮点击处理
    @objc func clickHandler(_ sender: SoloBlockButton) {
        if let block = self.clickBlock {
            block(sender)
        }
    }
}

// MARK: - 链式配置(自定义)
public extension SoloWrapper where Base: SoloBlockButton {
    /// 绑定点击处理回调
    /// - Warning: 闭包被按钮**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 点击处理回调
    /// - Returns: `Self`
    func clickBlock(_ block: @escaping SoloAction1<SoloBlockButton>) -> Self {
        base.clickBlock = block
        base.removeTarget(base, action: #selector(SoloBlockButton.clickHandler(_:)), for: .touchUpInside)
        base.addTarget(base, action: #selector(SoloBlockButton.clickHandler(_:)), for: .touchUpInside)
        return self
    }
}
