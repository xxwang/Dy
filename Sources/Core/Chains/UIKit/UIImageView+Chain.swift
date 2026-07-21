import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIImageView {
    /// 设置图像的`tintColor`(自动将图像转为模板模式)
    /// - Parameter color: 主色调
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        if let image = base.image {
            base.image = image.withRenderingMode(.alwaysTemplate)
        }
        base.tintColor = color
        return self
    }

    /// 设置普通图片
    /// - Parameter image: 要设置的图片
    /// - Returns: `Self`
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        base.image = image
        return self
    }

    /// 设置高亮状态图片
    /// - Parameter image: 要设置的高亮图片
    /// - Returns: `Self`
    @discardableResult
    func highlightedImage(_ image: UIImage?) -> Self {
        base.highlightedImage = image
        return self
    }
}

// MARK: - 方法(自定义)
public extension DyWrapper where Base: UIImageView {
    /// 添加模糊背景
    /// - Parameter style: 模糊样式
    /// - Returns: `Self`
    @discardableResult
    func blur(_ style: UIBlurEffect.Style = .light) -> Self {
        for subview in base.subviews where subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }

        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = base.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        base.addSubview(blurView)
        return self
    }

    /// 移除模糊效果
    @discardableResult
    func removeBlur() -> Self {
        for subview in base.subviews where subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }
        return self
    }
}
