import UIKit

// MARK: - 配置协议
public protocol SoloSetupable: AnyObject {
    /// 配置UI
    func setupUI()

    /// 绑定事件
    func bindEvents()

    /// 绑定视图模型
    func bindViewModel()

    /// 获取数据
    func fetchData()

    /// 绑定数据
    func bindData()
}

// MARK: - 默认实现
public extension SoloSetupable {
    /// 配置UI
    func setupUI() {}

    /// 绑定事件
    func bindEvents() {}

    /// 绑定视图模型
    func bindViewModel() {}

    /// 获取数据
    func fetchData() {}

    /// 绑定数据
    func bindData() {}
}
