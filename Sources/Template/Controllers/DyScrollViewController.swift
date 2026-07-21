import UIKit
import Dy

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

// MARK: - 支持子类重写的方法
@objc extension DyScrollViewController {
    /// 控制器初始化样式
    override open func initUI() {
        super.initUI()

        // 滚动视图添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.scrollView,
            belowSubview: self.naview
        )
        self.scrollView
            .dy
            .frame(.init(
                x: 0,
                y: DyScreen.navigationBarTotalHeight,
                width: self.view.width,
                height: self.view.height - DyScreen.navigationBarTotalHeight
            ))

        // 内容容器
        self.contentView
            .dy
            .size(self.scrollView.size)
            .add2(self.scrollView)
    }

    /// 更新导航栏及受影响的其它view
    override open func updateNaview() {
        super.updateNaview()

        self.scrollView
            .dy
            .frame(CGRect(
                x: 0,
                y: DyScreen.navigationBarTotalHeight,
                width: self.view.width,
                height: self.view.height - DyScreen.navigationBarTotalHeight
            ))
    }
}

// MARK: - UIScrollViewDelegate
@objc extension DyScrollViewController: UIScrollViewDelegate {}
