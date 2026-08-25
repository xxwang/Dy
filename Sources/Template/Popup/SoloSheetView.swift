import UIKit
import Combine
import SoloCore

// MARK: - 底部弹出面板
open class SoloSheetView: UIView {
    public var cancellables = Set<AnyCancellable>()
    /// 遮罩层
    private lazy var shadeView = SoloView.view()

    /// 内容容器（从底部弹出的部分）
    public lazy var contentView = SoloView.view()

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

// MARK: - 初始化与布局
public extension SoloSheetView {
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

// MARK: - 公共方法
@objc extension SoloSheetView {
    /// 显示底部弹窗
    open func show(in container: UIView? = nil) {
        let container = container ?? UIWindow.solo_keyWindow ?? UIWindow.solo_windows.first
        guard let container else { return }
        container.addSubview(self)

        self
            .solo
            // 设置弹窗尺寸
            .frame(container.bounds)

        // 遮罩层
        self.shadeView
            .solo
            .frame(container.bounds)

        // 内容容器
        self.contentView
            .solo
            .left((container.solo_width - self.contentView.solo_width) / 2)
            .top(self.solo_height - self.contentView.solo_height)

        // 设置初始化状态
        self.shadeView.alpha = 0.01
        self.contentView.alpha = 0.01
        self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.solo_height)

        // 从底部滑入
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseOut) {
            self.shadeView.alpha = 0.75
            self.contentView.alpha = 1
            self.contentView.transform = .identity
        }
    }

    /// 关闭弹窗
    open func dismiss() {
        // 滑出动画
        UIView.animate(withDuration: animationDuration(), delay: 0, options: .curveEaseIn) {
            self.shadeView.alpha = 0.01
            self.contentView.alpha = 0.01
            self.contentView.transform = CGAffineTransform(translationX: 0, y: self.contentView.solo_height)
        } completion: { [weak self] _ in
            self?.removeFromSuperview()
        }
    }
}

// MARK: - SoloSetupable
@objc extension SoloSheetView: SoloSetupable {
    /// 设置UI (子类重写该方法)在子类中应该在该方法中,设置contentView的size
    open func setupUI() {
        // 添加子视图
        self
            .solo
            .addSubviews([
                self.shadeView,
                self.contentView,
            ])

        // 配置遮罩
        self.shadeView
            .solo
            .backgroundColor(shadeBackgroundColor())
            .isUserInteractionEnabled(isTapOutsideToDismiss())

        // 配置内容容器
        self.contentView
            .solo
            .backgroundColor(contentViewBackgroundColor())
            .maskedCorners([.solo_topLeft, .solo_topRight])
            .cornerRadius(contentViewCornerRadius())
            .masksToBounds(true)

        // 遮罩点击关闭
        self.shadeView
            .solo
            .onTapGestureRecognizer { [weak self] _ in
                guard let self, self.isTapOutsideToDismiss() else { return }
                self.dismiss()
            }
    }
}

// MARK: - 子类可重写方法
@objc extension SoloSheetView {
    /// 内容容器圆角（默认只作用于顶部）
    open func contentViewCornerRadius() -> CGFloat {
        return 16
    }

    /// 内容容器背景色
    open func contentViewBackgroundColor() -> UIColor {
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
