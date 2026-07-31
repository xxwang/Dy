import UIKit
import DyCore

open class DyTableViewController: DyViewController {
    /// `UITableView`
    open lazy var tableView = UITableView.dy_tableView()
        .dy_dataSource(self)
        .dy_delegate(self)

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - DySetupable
@objc extension DyTableViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.tableView,
            belowSubview: self.naview
        )
        self.updateUI()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyTableViewController {
    /// 更新会受影响的UI
    override open func updateUI() {
        super.updateUI()

        let topMargin = self.naview.isHidden ? 0 : DyScreen.navBarTotalHeight
        self.tableView.dy_frame(CGRect(
            x: 0,
            y: topMargin,
            width: self.view.dy_width,
            height: self.view.dy_height - topMargin
        ))
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
@objc extension DyTableViewController: UITableViewDataSource, UITableViewDelegate {
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return DyTableViewCell()
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
