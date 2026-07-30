import UIKit

// MARK: - 图片加载
public extension UIImageView {
    /// 从 `URL` 加载网络图片
    /// - Parameters:
    ///   - url: 图片 URL
    ///   - placeholder: 占位图
    ///   - contentMode: 内容模式
    ///   - completion: 完成回调(主线程)
    func dy_loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        completion: DyAction2<UIImage?, Error?>? = nil
    ) {
        self.contentMode = contentMode
        self.image = placeholder

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            if let error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
                return
            }

            guard
                let data,
                let image = UIImage(data: data),
                (response as? HTTPURLResponse)?.statusCode == 200
            else {
                let err = NSError(domain: "UIImageView.loadImage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                DispatchQueue.main.async {
                    completion?(nil, err)
                }
                return
            }

            DispatchQueue.main.async {
                self.image = image
                completion?(image, nil)
            }
        }
        task.resume()
    }
}

// MARK: - 链式设置属性
public extension UIImageView {
    /// 设置图像的`tintColor`(自动将图像转为模板模式)
    /// - Parameter color: 主色调
    /// - Returns: `Self`
    @discardableResult
    override func dy_tintColor(_ color: UIColor?) -> Self {
        if let image = self.image {
            self.image = image.withRenderingMode(.alwaysTemplate)
        }
        self.tintColor = color
        return self
    }

    /// 设置普通图片
    /// - Parameter image: 要设置的图片
    /// - Returns: `Self`
    @discardableResult
    func dy_image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }

    /// 设置高亮状态图片
    /// - Parameter image: 要设置的高亮图片
    /// - Returns: `Self`
    @discardableResult
    func dy_highlightedImage(_ image: UIImage?) -> Self {
        self.highlightedImage = image
        return self
    }

    /// 设置高亮状态
    /// - Parameter highlighted: 是否高亮
    /// - Returns: `Self`
    @discardableResult
    func dy_isHighlighted(_ highlighted: Bool) -> Self {
        self.isHighlighted = highlighted
        return self
    }

    /// 设置帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func dy_animationImages(_ images: [UIImage]?) -> Self {
        self.animationImages = images
        return self
    }

    /// 设置高亮状态帧动画图片数组
    /// - Parameter images: 图片数组
    /// - Returns: `Self`
    @discardableResult
    func dy_highlightedAnimationImages(_ images: [UIImage]?) -> Self {
        self.highlightedAnimationImages = images
        return self
    }

    /// 设置帧动画时长
    /// - Parameter duration: 动画时长(秒)
    /// - Returns: `Self`
    @discardableResult
    func dy_animationDuration(_ duration: TimeInterval) -> Self {
        self.animationDuration = duration
        return self
    }

    /// 设置帧动画重复次数
    /// - Parameter count: 重复次数,0 表示无限循环
    /// - Returns: `Self`
    @discardableResult
    func dy_animationRepeatCount(_ count: Int) -> Self {
        self.animationRepeatCount = count
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIImageView {
    /// 添加模糊背景
    /// - Parameter style: 模糊样式
    /// - Returns: `Self`
    @discardableResult
    func dy_blur(_ style: UIBlurEffect.Style = .light) -> Self {
        for subview in self.subviews where subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }

        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurView)
        return self
    }

    /// 移除模糊效果
    @discardableResult
    func dy_removeBlur() -> Self {
        for subview in self.subviews where subview is UIVisualEffectView {
            subview.removeFromSuperview()
        }
        return self
    }
}
