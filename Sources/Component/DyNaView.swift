import UIKit
import DyCore

open class DyNaView: UIView {
    /// 返回按钮点击回调
    open var backBlock: (() -> Void)?

    /// 状态栏占位区域(不可交互,仅用于布局)
    open lazy var statusBar = UIView.dy_view()
        .dy
        .backgroundColor(.clear)
        .build()

    /// 标题容器(包含返回按钮和标题)
    open lazy var navigationBar = UIView.dy_view()
        .dy
        .backgroundColor(.clear)
        .build()

    /// 底部分割线(默认半透明黑线)
    open lazy var lineView = UIView.dy_view()
        .dy
        .backgroundColor(.black.dy_alpha(0.25))
        .build()

    /// 返回按钮(UIButton)
    open lazy var backButton = UIButton.dy_button()
        .dy
        .addTarget(self, action: #selector(onBackAction))
        .build()

    /// 标题标签
    open lazy var titleLabel = UILabel.dy_label()
        .dy
        .textAlignment(.center)
        .lineBreakMode(.byTruncatingTail)
        .build()

    /// 背景图片视图(按需添加,初始不创建)
    var backgroundImageView: UIImageView?

    /// 渐变层(可选)
    var gradientLayer: CAGradientLayer?

    override public init(frame: CGRect) {
        super.init(frame: frame)

        self
            .dy
            .backgroundColor(.white)
            .isUserInteractionEnabled(true)

        // 添加核心子视图(顺序决定层级)
        self
            .dy
            .addSubviews([
                self.statusBar,
                self.navigationBar,
                self.lineView,
            ])

        self.navigationBar
            .dy
            .addSubviews([
                self.backButton,
                self.titleLabel,
            ])
    }

    @available(*, unavailable, message: "Use init(frame:) instead.")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported.")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        // 状态栏：顶部,高度由系统定义
        statusBar.frame = CGRect(
            x: 0,
            y: 0,
            width: bounds.width,
            height: DyScreen.statusBarHeight
        )

        // 标题栏：紧接状态栏下方
        navigationBar.frame = CGRect(
            x: 0,
            y: statusBar.frame.maxY,
            width: bounds.width,
            height: DyScreen.navigationBarHeight
        )

        // 分割线：位于整个导航栏底部
        lineView.frame = CGRect(
            x: 0,
            y: bounds.height - 0.5,
            width: bounds.width,
            height: 0.5
        )

        // 返回按钮：左侧安全区域或 10pt 内边距
        let buttonSize: CGFloat = 40
        let buttonX = max(10, DyScreen.safeAreaLeft)
        backButton.frame = CGRect(
            x: buttonX,
            y: (navigationBar.bounds.height - buttonSize) / 2,
            width: buttonSize,
            height: buttonSize
        )

        // 标题：居中于标题栏,避开返回按钮
        let availableWidth = bounds.width - backButton.frame.maxX - 10
        let titleSize = titleLabel.sizeThatFits(CGSize(width: availableWidth, height: navigationBar.bounds.height))
        titleLabel.frame = CGRect(
            x: (bounds.width - titleSize.width) / 2,
            y: (navigationBar.bounds.height - titleSize.height) / 2,
            width: min(titleSize.width, availableWidth),
            height: titleSize.height
        )

        // 背景图：铺满整个导航栏
        backgroundImageView?.frame = bounds

        // 渐变层：同步 bounds
        gradientLayer?.frame = bounds
    }

    /// 返回按钮点击处理
    @objc private func onBackAction() {
        self.backBlock?()
    }
}

// MARK: - 工厂方法
public extension DyNaView {
    /// 创建一个带有默认样式的导航栏实例
    ///
    /// - Returns: 配置好的 `DyNaView`
    ///
    /// - Example:
    ///   ```swift
    ///   let navBar = DyNaView.naview()
    ///       .dy_title("首页")
    ///       .dy_backAction { /* 返回逻辑 */ }
    ///   ```
    static func naview() -> DyNaView {
        let naView = DyNaView()
            .dy
            .size(CGSize(
                width: DyScreen.screenWidth,
                height: DyScreen.navBarTotalHeight
            ))
            .showLine(true)
            .showShadow(false)
            .titleColor(.black)
            .titleFont(.systemFont(ofSize: 18, weight: .medium))

        // 设置默认返回图标(假设资源存在)
        if let image = UIImage(named: "navbar_back", in: .module, compatibleWith: nil) {
            naView.backImage(image, for: .normal)
            naView.backImage(image, for: .highlighted)
        }

        return naView.build()
    }
}

// MARK: - 链式设置
public extension DyWrapper where Base: DyNaView {
    /// 设置标题文本
    @discardableResult
    func title(_ title: String?) -> Self {
        base.titleLabel.text = title
        self.setNeedsLayout()
        return self
    }

    /// 设置标题字体
    @discardableResult
    func titleFont(_ font: UIFont) -> Self {
        base.titleLabel.font = font
        self.setNeedsLayout()
        return self
    }

    /// 设置标题颜色
    @discardableResult
    func titleColor(_ color: UIColor) -> Self {
        base.titleLabel.textColor = color
        return self
    }

    /// 设置返回按钮图片(支持不同状态)
    @discardableResult
    func backImage(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        base.backButton.setImage(image, for: state)
        return self
    }

    /// 控制返回按钮是否显示
    @discardableResult
    func showBackButton(_ isShow: Bool) -> Self {
        base.backButton.isHidden = !isShow
        return self
    }

    /// 设置返回按钮点击回调
    @discardableResult
    func backAction(_ handler: (() -> Void)?) -> Self {
        base.backBlock = handler
        return self
    }

    /// 控制底部分割线是否显示
    @discardableResult
    func showLine(_ isShow: Bool) -> Self {
        base.lineView.isHidden = !isShow
        return self
    }

    /// 控制导航栏阴影(模拟系统导航栏阴影)
    @discardableResult
    func showShadow(_ isShow: Bool) -> Self {
        base.layer.shadowColor = UIColor(hex: "#DBDADA").dy_alpha(0.25).cgColor
        base.layer.shadowRadius = 0
        base.layer.shadowOffset = CGSize(width: 0, height: 1)
        base.layer.shadowOpacity = isShow ? 1 : 0
        base.layer.shadowPath = UIBezierPath(rect: base.bounds).cgPath
        return self
    }

    /// 设置背景图片(自动插入底层,铺满整个导航栏)
    @discardableResult
    func backgroundImage(_ image: UIImage?) -> Self {
        if let imageView = base.backgroundImageView {
            imageView.image = image
            imageView.isHidden = (image == nil)
        } else if let image {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleToFill
            base.insertSubview(imageView, at: 0)
            base.backgroundImageView = imageView
            self.setNeedsLayout()
        }
        return self
    }

    /// 设置渐变背景(覆盖纯色和图片)
    @discardableResult
    func backgroundGradient(_ colors: [UIColor]) -> Self {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map(\.cgColor)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = base.bounds
        gradient.zPosition = -1

        base.gradientLayer?.removeFromSuperlayer()
        base.layer.insertSublayer(gradient, at: 0)
        base.gradientLayer = gradient

        // 清除其他背景
        base.backgroundColor = .clear
        base.backgroundImageView?.removeFromSuperview()
        base.backgroundImageView = nil

        return self
    }

    /// 隐藏状态栏占位(例如在 modal 页面中)
    @discardableResult
    func isHideStatusBar(_ hidden: Bool) -> Self {
        base.statusBar.isHidden = hidden
        self.setNeedsLayout()
        return self
    }
}
