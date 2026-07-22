import UIKit

// MARK: - 链式设置属性
public extension UIRefreshControl {
    /// 设置富文本标题
    /// - Parameters:
    ///   - title: 标题文本
    ///   - attributes: 富文本属性(如字体、颜色)
    /// - Returns: `Self`
    @discardableResult
    func dy_title(_ title: String, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        self.attributedTitle = NSAttributedString(string: title, attributes: attributes)
        return self
    }

    /// 设置刷新控件的主色调(影响 `spinner` 和文字颜色)
    /// - Parameter color: 主色调
    /// - Returns: `Self`
    @discardableResult
    override func dy_tintColor(_ color: UIColor?) -> Self {
        self.tintColor = color
        return self
    }

    /// 绑定刷新事件回调
    /// - Parameters:
    ///   - target: 目标对象
    ///   - action: 回调方法(需带 `@objc` 标记)
    /// - Returns: `Self`
    @discardableResult
    func dy_addTarget(_ target: Any?, action: Selector) -> Self {
        self.addTarget(target, action: action, for: .valueChanged)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UIRefreshControl {
    /// 开始刷新
    /// - Parameters:
    ///   - scrollView: 所属的 UIScrollView(如 UITableView / UICollectionView)
    ///   - animated: 是否动画滚动到刷新位置
    ///   - triggerRefreshHandler: 是否立即触发 `.valueChanged` 事件(默认 false)
    /// - Returns: `Self`
    @discardableResult
    func dy_startRefreshing(in scrollView: UIScrollView, animated: Bool, triggerRefreshHandler: Bool = false) -> Self {
        if self.superview == nil || self.superview !== scrollView {
            scrollView.refreshControl = self
        }

        self.beginRefreshing()

        // 仅当当前未处于刷新偏移状态时,才调整 contentOffset
        let refreshOffset = -self.frame.height
        if scrollView.contentOffset.y > refreshOffset {
            let newOffset = CGPoint(x: scrollView.contentOffset.x, y: refreshOffset)
            scrollView.setContentOffset(newOffset, animated: animated)
        }

        if triggerRefreshHandler {
            self.sendActions(for: .valueChanged)
        }
        return self
    }

    /// 停止刷新
    /// - Parameter animated: 是否以动画方式恢复原始滚动位置
    /// - Returns: `Self`
    @discardableResult
    func dy_stopRefreshing(animated: Bool = true) -> Self {
        self.endRefreshing()

        guard let scrollView = self.superview as? UIScrollView else { return self }

        // 仅当当前处于“被拉下”状态时才重置 contentOffset
        let refreshOffset = -self.frame.height
        if scrollView.contentOffset.y <= refreshOffset {
            if animated {
                UIView.animate(withDuration: 0.25) {
                    scrollView.contentOffset.y = 0
                }
            } else {
                scrollView.contentOffset.y = 0
            }
        }
        return self
    }
}
