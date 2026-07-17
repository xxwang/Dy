import UIKit

/// 应用专属的 UI 外观与默认行为配置中心
public final class DyAppearance: Sendable {
    public static let shared = DyAppearance()
    private init() {}
}

public extension DyAppearance {
    /// 初始化应用的全局 UI 默认行为
    ///
    /// 此方法会一次性应用推荐的外观设置,包括：
    /// - Parameters:
    ///   - userInterfaceStyle: 强制使用的界面主题默认 `.light`
    ///   - scrollInContentInsetAdjustmentBehavior: 滚动内容内边距调整行为默认 `.never`(避免自动偏移)
    func setup(
        userInterfaceStyle: UIUserInterfaceStyle = .light,
        scrollInContentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior = .never
    ) {
        // 强制界面主题(light/dark)
        self.setupView(userInterfaceStyle)

        // 滚动视图内边距行为
        self.setupScrollView(scrollInContentInsetAdjustmentBehavior)

        // 表格视图自动高度与布局
        self.setupTableView()

        // 导航栏统一样式
        self.setupNavigationBar()
    }
}

// MARK: - 全局配置(通过 UIAppearance 代理)
public extension DyAppearance {
    /// 强制整个 App 使用指定的界面主题(忽略系统设置)
    ///
    /// - Parameter userInterfaceStyle: 要强制使用的主题(`.light` / `.dark`)
    func setupView(_ userInterfaceStyle: UIUserInterfaceStyle) {
        UIView.appearance().overrideUserInterfaceStyle = userInterfaceStyle
    }

    /// 为所有 `UITableView` 应用推荐的默认布局行为：
    /// - 自动计算行高、节头/节尾高度
    /// - 禁用内容内边距自动调整(避免与 Safe Area 冲突)
    /// - 移除 iOS 15+ 默认的 section header 顶部额外内边距
    func setupTableView() {
        let tableView = UITableView.appearance()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.contentInsetAdjustmentBehavior = .never

        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }

    /// 设置所有 `UIScrollView` 及其子类(如 `UITableView`, `UICollectionView`)
    /// 的内容内边距自动调整行为
    ///
    /// - Parameter behavior: 内边距调整策略推荐使用 `.never` 以获得更可控的布局
    func setupScrollView(_ contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior) {
        UIScrollView.appearance().contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
    }

    /// 应用统一的导航栏全局样式
    ///
    /// - Parameters:
    ///   - translucent: 是否启用半透明效果建议设为 `false` 以避免布局跳动
    ///   - titleColor: 导航标题文字颜色
    ///   - titleFont: 导航标题字体
    ///   - backgroundColor: 背景色若为 `nil`,使用不透明系统背景色
    ///   - shadowColor: 底部阴影线颜色设为 `.clear` 可完全隐藏分割线
    func setupNavigationBar(
        translucent: Bool = false,
        titleColor: UIColor = .black,
        titleFont: UIFont = .systemFont(ofSize: 16, weight: .bold),
        backgroundColor: UIColor? = nil,
        shadowColor: UIColor = .clear
    ) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = shadowColor
        // 禁用模糊,确保背景色纯净
        appearance.backgroundEffect = nil
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: titleFont,
        ]

        if let backgroundColor {
            appearance.backgroundColor = backgroundColor
        }

        let navBar = UINavigationBar.appearance()
        navBar.isTranslucent = translucent
        navBar.standardAppearance = appearance
        // 确保滚动到顶部时样式一致
        navBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - UIView
public extension UIView {
    /// 配置单个视图外观
    func setupView(_ userInterfaceStyle: UIUserInterfaceStyle) {
        self.overrideUserInterfaceStyle = userInterfaceStyle
    }
}

// MARK: - UIScrollView
public extension UIScrollView {
    /// 配置单个滚动视图
    func setupScrollView(_ contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior) {
        self.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
    }
}

// MARK: - UITableView
public extension UITableView {
    /// 配置单个表格视图
    func setupTableView() {
        self.rowHeight = UITableView.automaticDimension
        self.sectionHeaderHeight = UITableView.automaticDimension
        self.sectionFooterHeight = UITableView.automaticDimension
        self.contentInsetAdjustmentBehavior = .never

        if #available(iOS 15.0, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
}
