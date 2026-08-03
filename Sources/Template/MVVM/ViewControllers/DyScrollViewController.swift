import UIKit
import DyCore

open class DyScrollViewController: DyViewController {
    /// `UIScrollView`
    open lazy var scrollView = UIScrollView.scrollView()
        .dy
        .delegate(self)
        .build()

    /// 内容视图
    open lazy var contentView = UIView.view()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - DySetupable
@objc extension DyScrollViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 滚动视图添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.scrollView,
            belowSubview: self.naview
        )

        // 内容容器
        self.contentView
            .dy
            .add2(self.scrollView)

        self.updateNaview()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyScrollViewController {
    /// 更新导航栏位置及受影响的视图
    override open func updateNaview() {
        super.updateNaview()

        let topMargin = self.naview.isHidden ? 0 : DyScreen.navBarTotalHeight
        self.scrollView
            .dy
            .frame(CGRect(
                x: 0,
                y: topMargin,
                width: self.view.dy_width,
                height: self.view.dy_height - topMargin
            ))

        // 内容容器
        self.contentView
            .dy
            .width(self.scrollView.dy_width)
            .height(max(self.scrollView.contentSize.height, self.scrollView.dy_height))
    }
}

// MARK: - UIScrollViewDelegate
@objc extension DyScrollViewController: UIScrollViewDelegate {}
