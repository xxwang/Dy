import UIKit
import DyCore

open class DyScrollViewController: DyViewController {
    /// `UIScrollView`
    open lazy var scrollView = UIScrollView.dy_scrollView()
        .dy_delegate(self)

    /// 内容视图
    open lazy var contentView = UIView.dy_view()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyScrollViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 滚动视图添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.scrollView,
            belowSubview: self.naview
        )
        self.scrollView.dy_frame(.init(
            x: 0,
            y: DyScreen.navBarTotalHeight,
            width: self.view.dy_width,
            height: self.view.dy_height - DyScreen.navBarTotalHeight
        ))

        // 内容容器
        self.contentView.dy_size(self.scrollView.dy_size)
            .dy_addTo(self.scrollView)
    }

    /// 更新导航栏及受影响的其它view
    override open func updateNaview() {
        super.updateNaview()

        self.scrollView.dy_frame(CGRect(
            x: 0,
            y: DyScreen.navBarTotalHeight,
            width: self.view.dy_width,
            height: self.view.dy_height - DyScreen.navBarTotalHeight
        ))
    }
}

// MARK: - UIScrollViewDelegate
@objc extension DyScrollViewController: UIScrollViewDelegate {}
