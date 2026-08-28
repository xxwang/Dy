import DyCore
import UIKit

public class DyCustomized: DyExtension {
    public class vc {}
    public class nav {}
    public class app {}
}

// MARK: - 控制器
public extension DyCustomized.vc {
    /// 控制器背景颜色
    static var backgroundColor: UIColor?
}

// MARK: - 图片名称
public extension DyCustomized.nav {
    /// 导航栏背景颜色
    static var backgroundColor: UIColor?

    /// 返回按钮图标
    static var backImage: UIImage?
    /// 返回按钮高亮图标
    static var backHighlightedImage: UIImage?

    /// 标题字体
    static var titleFont: UIFont?
    /// 标题颜色
    static var titleColor: UIColor?

    /// 标题位置
    static var titlePosition: NaviewTitlePosition = .center
}

// MARK: - 应用
public extension DyCustomized.app {
    /// 应用图标资源名称
    static var appIconImage: UIImage?
}
