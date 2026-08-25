import UIKit
import SoloCore

open class SoloTableViewController: SoloViewController {
    /// 控制`UITableView`的样式(通过子类重写)
    open var tableViewStyle: UITableView.Style {
        return .grouped
    }

    /// `UITableView`
    open lazy var tableView = UITableView.tableView(tableViewStyle)
        .solo.dataSource(self)
        .delegate(self)
        .build()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SoloSetupable
@objc extension SoloTableViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        if self.naview.superview != nil {
            self.view.insertSubview(
                self.tableView,
                belowSubview: self.naview
            )
        } else {
            self.view.addSubview(self.tableView)
        }
        self.updateNaview()
    }
}

// MARK: - 支持子类重写的方法
@objc extension SoloTableViewController {
    /// 更新导航栏位置及受影响的视图
    override open func updateNaview() {
        super.updateNaview()

        let topMargin = self.naview.isHidden ? 0 : SoloScreen.navBarTotalHeight
        self.tableView
            .solo
            .frame(CGRect(
                x: 0,
                y: topMargin,
                width: self.view.solo_width,
                height: self.view.solo_height - topMargin
            ))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
@objc extension SoloTableViewController: UITableViewDataSource, UITableViewDelegate {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return SoloTableViewCell()
    }

    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }

    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    open func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    open func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {}

    open func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        nil
    }
}
