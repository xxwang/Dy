import UIKit

// MARK: - 链式设置属性
public extension SoloWrapper where Base: UIImageView {
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

    /// 设置高亮状态
    /// - Parameter highlighted: 是否高亮
    /// - Returns: `Self`
    @discardableResult
    func isHighlighted(_ highlighted: Bool) -> Self {
        base.isHighlighted = highlighted
        return self
    }

    /// 设置帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func animationImages(_ images: [UIImage]?) -> Self {
        base.animationImages = images
        return self
    }

    /// 设置高亮状态帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func highlightedAnimationImages(_ images: [UIImage]?) -> Self {
        base.highlightedAnimationImages = images
        return self
    }

    /// 设置帧动画时长
    /// - Parameter duration: 动画时长(秒)
    /// - Returns: `Self`
    @discardableResult
    func animationDuration(_ duration: TimeInterval) -> Self {
        base.animationDuration = duration
        return self
    }

    /// 设置帧动画重复次数
    /// - Parameter count: 重复次数,0 表示无限循环
    /// - Returns: `Self`
    @discardableResult
    func animationRepeatCount(_ count: Int) -> Self {
        base.animationRepeatCount = count
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension SoloWrapper where Base: UIImageView {
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
