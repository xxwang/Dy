import SoloCore
import UIKit

// MARK: - 气泡弹窗控制器
open class SoloBubbleViewController: SoloViewController {
    private var sourceView: UIView?

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 公开方法
public extension SoloBubbleViewController {
    /// 显示气泡弹窗
    /// - Parameters:
    ///   - from: 父视图控制器
    ///   - sourceView: 气泡指向的源视图（必须提供）
    func show(from parent: UIViewController, sourceView: UIView) {
        self.sourceView = sourceView

        self
            .solo
            // 设置模态样式为气泡弹窗
            .modalPresentationStyle(.popover)
            // 设置是否禁止通过手势或点击背景关闭气泡弹窗
            .isModalInPresentation(shouldPreventDismissal())

        self.popoverPresentationController?
            .solo
            // 代理
            .delegate(self)
            // 允许的箭头方向
            .permittedArrowDirections(permittedArrowDirections())
            // 是否允许气泡覆盖源视图区域
            .canOverlapSourceViewRect(canOverlapSourceViewRect())
            // 气泡箭头指向的源视图
            .sourceView(sourceView)
            // 源视图内的定位矩形
            .sourceRect(sourceRect(for: sourceView))
            // 自定义背景类
            .popoverBackgroundViewClass(popoverBackgroundViewClass())

        parent.present(self, animated: true)
    }

    override var preferredContentSize: CGSize {
        get { self.bubbleContentSize() }
        set { super.preferredContentSize = newValue }
    }
}

// MARK: - 子类可重写配置
@objc extension SoloBubbleViewController {
    /// 返回气泡大小
    /// - Returns: 气泡大小
    open func bubbleContentSize() -> CGSize {
        return CGSize(width: 220, height: 220)
    }

    /// 是否禁止通过点击外部或手势关闭气泡
    /// - Returns: 默认 `false`（允许关闭）
    open func shouldPreventDismissal() -> Bool {
        return false
    }

    /// 允许的箭头方向
    /// - Returns: 默认 `.any`
    open func permittedArrowDirections() -> UIPopoverArrowDirection {
        return .any
    }

    /// 是否允许气泡覆盖源视图区域
    /// - Returns: 默认 `true`
    open func canOverlapSourceViewRect() -> Bool {
        return false
    }

    /// 气泡在源视图内的定位矩形
    /// - Parameter sourceView: 源视图
    /// - Returns: 默认 `sourceView.bounds`
    open func sourceRect(for sourceView: UIView) -> CGRect {
        return sourceView.bounds
    }

    /// 返回自定义背景类(继承自`UIPopoverBackgroundView`的类)
    /// - Returns: 默认 `nil`
    open func popoverBackgroundViewClass() -> (any UIPopoverBackgroundViewMethods.Type)? {
        return SoloBubbleBackgroundView.self
    }
}

// MARK: - UIPopoverPresentationControllerDelegate
extension SoloBubbleViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(
        for controller: UIPresentationController,
        traitCollection: UITraitCollection
    ) -> UIModalPresentationStyle {
        return .none
    }

    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
}

// MARK: - SoloBubbleBackgroundView
open class SoloBubbleBackgroundView: UIPopoverBackgroundView {
    // MARK: - 箭头位置（UIKit 驱动，基类存储）
    private var _arrowOffset: CGFloat = 0
    override open var arrowOffset: CGFloat {
        get { _arrowOffset }
        set { _arrowOffset = newValue; self.setNeedsLayout() }
    }

    private var _arrowDirection: UIPopoverArrowDirection = .any
    override open var arrowDirection: UIPopoverArrowDirection {
        get { _arrowDirection }
        set { _arrowDirection = newValue; self.setNeedsLayout() }
    }

    // MARK: - 绘制
    private let shapeLayer = CAShapeLayer()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.layer.addSublayer(self.shapeLayer)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.shapeLayer.frame = self.bounds
        self.shapeLayer.fillColor = Self.fillColor().cgColor
        self.shapeLayer.path = Self.makePath(
            in: self.bounds,
            arrowDirection: self.arrowDirection,
            arrowOffset: self.arrowOffset
        )
    }

    /// 生成背景路径（圆角矩形主体 + 箭头）；子类可重写定制形状
    open class func makePath(
        in bounds: CGRect,
        arrowDirection: UIPopoverArrowDirection,
        arrowOffset: CGFloat
    ) -> CGPath {
        let corner = bubbleCornerRadius()
        let arrowH = arrowHeight()
        let halfBase = arrowBase() / 2

        // 主体让出箭头所在边的空间
        var body = bounds
        switch arrowDirection {
        case .up: body.origin.y += arrowH; body.size.height -= arrowH
        case .down: body.size.height -= arrowH
        case .left: body.origin.x += arrowH; body.size.width -= arrowH
        case .right: body.size.width -= arrowH
        default: break
        }

        let path = UIBezierPath(roundedRect: body, cornerRadius: corner)

        // 在对应边追加箭头（位置 = 边中点 + arrowOffset）
        switch arrowDirection {
        case .up:
            let x = body.midX + arrowOffset
            path.move(to: CGPoint(x: x - halfBase, y: body.minY))
            path.addLine(to: CGPoint(x: x, y: body.minY - arrowH))
            path.addLine(to: CGPoint(x: x + halfBase, y: body.minY))
            path.close()
        case .down:
            let x = body.midX + arrowOffset
            path.move(to: CGPoint(x: x - halfBase, y: body.maxY))
            path.addLine(to: CGPoint(x: x, y: body.maxY + arrowH))
            path.addLine(to: CGPoint(x: x + halfBase, y: body.maxY))
            path.close()
        case .left:
            let y = body.midY + arrowOffset
            path.move(to: CGPoint(x: body.minX, y: y - halfBase))
            path.addLine(to: CGPoint(x: body.minX - arrowH, y: y))
            path.addLine(to: CGPoint(x: body.minX, y: y + halfBase))
            path.close()
        case .right:
            let y = body.midY + arrowOffset
            path.move(to: CGPoint(x: body.maxX, y: y - halfBase))
            path.addLine(to: CGPoint(x: body.maxX + arrowH, y: y))
            path.addLine(to: CGPoint(x: body.maxX, y: y + halfBase))
            path.close()
        default:
            break
        }
        return path.cgPath
    }
}

// MARK: - SoloBubbleBackgroundView子类可重写配置
@objc extension SoloBubbleBackgroundView {
    /// 气泡圆角半径
    open class func bubbleCornerRadius() -> CGFloat {
        return 12
    }

    /// 箭头底边宽度
    override open class func arrowBase() -> CGFloat {
        return 24
    }

    /// 箭头高度
    override open class func arrowHeight() -> CGFloat {
        return 12
    }

    /// 内容区域边距：气泡内容(被呈现的 view)距气泡边缘的内边距
    override open class func contentViewInsets() -> UIEdgeInsets {
        return .init(top: 12, left: 12, bottom: 12, right: 12)
    }

    /// 背景填充色
    open class func fillColor() -> UIColor {
        return .white
    }
}
