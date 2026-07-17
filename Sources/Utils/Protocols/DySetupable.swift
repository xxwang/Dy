import UIKit

// MARK: - 配置协议
public protocol DySetupable: AnyObject {
    /// 配置UI
    func setupUI()

    /// 绑定事件
    func bindEvents()

    /// 绑定视图模型
    func bindViewModel()

    /// 获取数据
    func fetchData()

    /// 更新(绑定)数据
    func updateData()
}

// MARK: - 默认实现
public extension DySetupable {
    /// 配置UI
    func setupUI() {}

    /// 绑定事件
    func bindEvents() {}

    /// 绑定视图模型
    func bindViewModel() {}

    /// 获取数据
    func fetchData() {}

    /// 更新(绑定)数据
    func updateData() {}
}
