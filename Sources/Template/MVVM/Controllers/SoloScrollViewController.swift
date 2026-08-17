import UIKit
import SoloCore

open class SoloScrollViewController: SoloViewController {
    /// `UIScrollView`
    open lazy var scrollView = UIScrollView.scrollView()
        .solo.delegate(self)
        .build()

    /// 内容视图
    open lazy var contentView = UIView.view()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SoloSetupable
@objc extension SoloScrollViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 滚动视图添加到导航栏下面 确保导航栏阴影可以正常显示
        if self.naview.superview != nil {
            self.view.insertSubview(
                self.scrollView,
                belowSubview: self.naview
            )
        } else {
            self.view.addSubview(self.scrollView)
        }

        // 内容容器
        self.contentView
            .solo
            .add2(self.scrollView)

        self.updateNaview()
    }
}

// MARK: - 支持子类重写的方法
@objc extension SoloScrollViewController {
    /// 更新导航栏位置及受影响的视图
    override open func updateNaview() {
        super.updateNaview()

        let topMargin = self.naview.isHidden ? 0 : SoloScreen.navBarTotalHeight
        self.scrollView
            .solo
            .frame(CGRect(
                x: 0,
                y: topMargin,
                width: self.view.solo.width,
                height: self.view.solo.height - topMargin
            ))

        // 内容容器
        self.contentView
            .solo
            .width(self.scrollView.solo.width)
            .height(max(self.scrollView.contentSize.height, self.scrollView.solo.height))
    }
}

// MARK: - UIScrollViewDelegate
@objc extension SoloScrollViewController: UIScrollViewDelegate {}
