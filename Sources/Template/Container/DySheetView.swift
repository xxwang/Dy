import UIKit
import DyCore

// MARK: - 底部弹出面板
open class DySheetView: UIView {
    /// 遮罩层
    private lazy var shadeView = UIView.dy_view()

    /// 内容容器（从底部弹出的部分）
    public lazy var contentContainer = UIView.dy_view()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 初始化与布局
public extension DySheetView {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - 公共方法
@objc extension DySheetView {
    /// 显示底部弹窗
    open func show(in container: UIView? = nil) {
        let container = container ?? UIWindow.dy_keyWindow
        guard let container else { return }
        container.addSubview(self)

        // 设置弹窗尺寸
        self.dy_frame(container.bounds)

        // 遮罩层
        self.shadeView.dy_frame(container.bounds)

        // 内容容器
        self.contentContainer.dy_left((container.dy_width - self.contentContainer.dy_width) / 2)
            .dy_top(self.dy_height - self.contentContainer.dy_height)

        // 设置初始化状态
        self.shadeView.alpha = 0.01
        self.contentContainer.alpha = 0.01
        self.contentContainer.transform = CGAffineTransform(translationX: 0, y: self.contentContainer.dy_height)

        // 从底部滑入
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseOut) {
            self.shadeView.alpha = 0.75
            self.contentContainer.alpha = 1
            self.contentContainer.transform = .identity
        }
    }

    /// 关闭弹窗
    open func dismiss() {
        // 滑出动画
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseIn) {
            self.shadeView.alpha = 0.01
            self.contentContainer.alpha = 0.01
            self.contentContainer.transform = CGAffineTransform(translationX: 0, y: self.dy_height)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}

// MARK: - 子类可重写方法
@objc extension DySheetView {
    /// 设置UI (子类重写该方法)在子类中应该在该方法中,设置contentContainer的size
    open func setupUI() {
        // 添加子视图
        self.dy_addSubviews([
            self.shadeView,
            self.contentContainer,
        ])

        // 配置遮罩
        self.shadeView.dy_backgroundColor(shadeBackgroundColor())
            .dy_isUserInteractionEnabled(isTapOutsideToDismiss())

        // 配置内容容器
        self.contentContainer.dy_backgroundColor(contentContainerBackgroundColor())
            .dy_maskedCorners([.dy_topLeft, .dy_topRight])
            .dy_cornerRadius(contentContainerCornerRadius())
            .dy_masksToBounds(true)

        // 遮罩点击关闭
        self.shadeView.dy_onTapGestureRecognizer { [weak self] _ in
            guard let self, self.isTapOutsideToDismiss() else { return }
            self.dismiss()
        }
    }

    /// 内容容器圆角（默认只作用于顶部）
    open func contentContainerCornerRadius() -> CGFloat {
        return 16
    }

    /// 内容容器背景色
    open func contentContainerBackgroundColor() -> UIColor {
        return .white
    }

    /// 是否允许点击遮罩关闭
    open func isTapOutsideToDismiss() -> Bool {
        return true
    }

    /// 遮罩背景色
    open func shadeBackgroundColor() -> UIColor {
        return UIColor(hex: "#080808")
    }

    /// 动画时长
    open func animationDuration() -> TimeInterval {
        return 0.25
    }
}
