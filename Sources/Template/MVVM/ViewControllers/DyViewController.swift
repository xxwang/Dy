import UIKit
import Combine
import DyComponent

open class DyViewController: UIViewController {
    public var cancellables = Set<AnyCancellable>()

    /// 是否允许侧滑返回
    open var canSideBack = true

    /// 导航栏
    open lazy var naview = DyNaView.naview()
        .dy_backAction { [weak self] in
            guard let self else { return }
            self.onBackActionHandler()
        }

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

    deinit {
        cancellables.removeAll()
    }
}

// MARK: - DySetupable
@objc extension DyViewController: DySetupable {
    /// 配置UI
    open func setupUI() {
        self
            // 设置界面样式
            .dy_overrideUserInterfaceStyle(.light)

        self.view
            // 控制器背景色
            .dy_backgroundColor(.white)

        // 添加导航条
        self.naview
            .dy_frame(CGRect(
                x: 0,
                y: 0,
                width: DyScreen.screenWidth,
                height: DyScreen.navBarTotalHeight
            ))
            .dy_isHidden(true)
            .dy_add2(self.view)
    }

    /// 绑定事件
    open func bindEvents() {}

    /// 绑定视图模型
    open func bindViewModel() {}

    /// 获取数据
    open func fetchData() {}

    /// 绑定数据
    open func bindData() {}
}

// MARK: - 支持子类重写的方法
@objc extension DyViewController {
    /// 更新导航栏位置及受影响的视图
    open func updateNaview() {
        self.naview.dy_frame(CGRect(
            x: 0,
            y: 0,
            width: DyScreen.screenWidth,
            height: DyScreen.navBarTotalHeight
        ))
    }

    /// 返回方法
    open func onBackActionHandler() {
        let count = self.navigationController?.children.count ?? 0
        if count > 1 {
            self.dy_pop()
        } else {
            self.dy_dismiss()
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
    /// 侧滑手势原始代理(用于退出页面时还原,避免覆盖其它控制器/协调器设置的代理)
    private enum Keys {
        static var originalPopDelegate: UInt8 = 0
    }

    private var dy_originalPopDelegate: UIGestureRecognizerDelegate? {
        get { self.dy_getAssociatedObject(forKey: &Keys.originalPopDelegate) as? UIGestureRecognizerDelegate }
        set { self.dy_setAssociatedObject(newValue, forKey: &Keys.originalPopDelegate) }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 接管侧滑手势代理,但先记录原始代理以便退出时还原
        if let gesture = self.navigationController?.interactivePopGestureRecognizer, gesture.delegate !== self {
            if dy_originalPopDelegate == nil {
                dy_originalPopDelegate = gesture.delegate
            }
            gesture.delegate = self
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 仅当代理仍指向自身时才还原为原始代理,避免误清空其它控制器设置的代理
        if let gesture = self.navigationController?.interactivePopGestureRecognizer, gesture.delegate === self {
            gesture.delegate = dy_originalPopDelegate
        }
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
