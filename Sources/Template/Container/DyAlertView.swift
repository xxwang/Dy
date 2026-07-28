import UIKit
import Combine
import DyCore

/// 居中弹窗
open class DyAlertView: UIView {
    public var cancellables = Set<AnyCancellable>()

    /// 遮罩层
    private lazy var shadeView = UIView.dy_view()

    /// 内容容器
    lazy var contentContainer = UIView.dy_view()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        cancellables.removeAll()
    }
}

public extension DyAlertView {
    override func layoutSubviews() {
        super.layoutSubviews()

        // 设置遮罩与弹窗一样大
        self.shadeView.frame = self.bounds

        // 设置内容容器中心点
        self.contentContainer.center = self.dy_middle
    }
}

// MARK: - 公共方法
@objc extension DyAlertView {
    /// 显示弹窗
    open func show(in container: UIView? = nil) {
        let container = container ?? UIWindow.dy_keyWindow ?? UIWindow.dy_windows.first
        guard let container else { return }
        container.addSubview(self)

        // 设置约束填充父视图
        self.dy_fillSuperview()

        // 设置初始化状态
        self.shadeView.alpha = 0.01
        self.contentContainer.alpha = 0.01
        self.contentContainer.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)

        // 执行淡入+缩放动画
        UIView.animate(withDuration: self.animationDuration(), delay: 0, options: .curveEaseOut) {
            self.shadeView.alpha = 0.75
            self.contentContainer.alpha = 1
            self.contentContainer.transform = .identity
        }
    }

    /// 关闭弹窗
    open func dismiss() {
        // 执行淡出+缩放动画
        UIView.animate(withDuration: self.animationDuration(), delay: 0, options: .curveEaseIn) {
            self.shadeView.alpha = 0.01
            self.contentContainer.alpha = 0.01
            self.contentContainer.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - 子类可重写方法
@objc extension DyAlertView {
    /// 设置UI (子类重写该方法)在子类中应该在该方法中,设置contentContainer的size
    func setupUI() {
        // 配置弹窗基础属性
        self.dy_addSubviews([
            self.shadeView,
            self.contentContainer,
        ])

        // 配置遮罩层初始状态
        self.shadeView.dy_frame(self.bounds)
            .dy_backgroundColor(self.shadeBackgroundColor())
            .dy_isUserInteractionEnabled(self.isTapOutsideToDismiss())

        // 配置内容容器
        self.contentContainer.dy_backgroundColor(self.contentContainerBackgroundColor())
            .dy_maskedCorners(.dy_all)
            .dy_cornerRadius(self.contentContainerCornerRadius())
            .dy_masksToBounds(true)

        // 设置遮罩点击手势
        self.shadeView.dy_onTapGestureRecognizer { [weak self] tap in
            guard let self, self.isTapOutsideToDismiss() else { return }
            self.dismiss()
        }
    }

    /// 设置内容容器的圆角半径
    /// - Returns: 圆角值（单位：pt）
    open func contentContainerCornerRadius() -> CGFloat {
        return 12
    }

    /// 设置内容容器背景颜色
    /// - Returns: 自定义内容容器颜色
    open func contentContainerBackgroundColor() -> UIColor {
        return .white
    }

    /// 设置是否允许点击遮罩关闭
    /// - Returns: `true` 允许点击关闭，`false` 禁止
    open func isTapOutsideToDismiss() -> Bool {
        return true
    }

    /// 设置遮罩颜色
    /// - Returns: 自定义遮罩颜色
    open func shadeBackgroundColor() -> UIColor {
        return UIColor(hex: "#080808")
    }

    /// 设置动画时长
    /// - Returns: 动画持续时间（秒）
    open func animationDuration() -> TimeInterval {
        return 0.25
    }
}
