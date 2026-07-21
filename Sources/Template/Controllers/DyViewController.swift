import UIKit
import Combine
import DyComponent

open class DyViewController: UIViewController, DySetupable {
    public var cancellables = Set<AnyCancellable>()

    /// 是否允许侧滑返回
    open var canSideBack = true

    /// 导航栏
    open lazy var naview = DyNaView.naview()
        .dy
        .backAction {
            self.onBackActionHandler()
        }
        .build()

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyViewController {
    /// 控制器初始化样式
    open func initUI() {
        self
            .dy
            // 设置界面样式
            .overrideUserInterfaceStyle(.light)

        self.view
            .dy
            // 控制器背景色
            .backgroundColor(.white)

        // 添加导航条
        self.naview
            .dy
            .isHidden(self.navigationController == nil)
            .add2(self.view)
            .frame(.init(
                x: 0,
                y: 0,
                width: DyScreen.screenWidth,
                height: DyScreen.navigationBarTotalHeight
            ))
    }

    /// 更新导航栏及受影响的其它view
    open func updateNaview() {
        self.naview
            .dy
            .frame(.init(
                x: 0,
                y: 0,
                width: DyScreen.screenWidth,
                height: DyScreen.navigationBarTotalHeight
            ))
    }

    /// 返回方法
    open func onBackActionHandler() {
        let count = self.navigationController?.children.count ?? 0
        if count > 1 {
            self.dy.pop()
        } else {
            self.dy.dismiss()
        }
    }
}

// MARK: - 控制器属性
extension DyViewController {
    /// 屏幕是否可以旋转
    override open var shouldAutorotate: Bool {
        false
    }

    /// 屏幕方向
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .portrait
    }

    /// 是否隐藏状态栏
    override open var prefersStatusBarHidden: Bool {
        return false
    }

    /// 状态栏样式
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    /// 监听屏幕旋转
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
}

// MARK: - UIViewController生命周期
extension DyViewController {
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: UIGestureRecognizerDelegate
@objc extension DyViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if (self.navigationController?.children.count ?? 0) > 1 {
            return canSideBack
        }
        return false
    }
}
