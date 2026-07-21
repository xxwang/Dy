import UIKit

// MARK: - 构造方法
public extension UIStackView {
    /// 使用指定的子视图数组和布局属性初始化一个堆栈视图
    ///
    /// - Parameters:
    ///   - views: 要作为排列子视图添加的视图数组默认为空数组
    ///   - axis: 子视图的排列轴向(水平或垂直)默认为 `.horizontal`
    ///   - spacing: 相邻排列子视图之间的间距默认为 `0.0`
    ///   - distribution: 沿堆栈轴向的分布策略默认为 `.fill`
    ///   - alignment: 垂直于堆栈轴向的对齐方式默认为 `.fill`
    ///
    /// - Example:
    ///
    ///     let stackView = UIStackView(
    ///         views: [label, button],
    ///         axis: .vertical,
    ///         spacing: 8
    ///     )
    ///
    convenience init(
        views: [UIView] = [],
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0.0,
        distribution: UIStackView.Distribution = .fill,
        alignment: UIStackView.Alignment = .fill
    ) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
    }
}

// MARK: - 视图交换
public extension UIStackView {
    /// 无动画地交换两个排列子视图的位置
    ///
    /// - Parameters:
    ///   - firstView: 第一个要交换的视图
    ///   - secondView: 第二个要交换的视图
    func dy_switchViews(_ firstView: UIView, _ secondView: UIView) {
        guard
            let index1 = arrangedSubviews.firstIndex(of: firstView),
            let index2 = arrangedSubviews.firstIndex(of: secondView),
            index1 != index2
        else { return }

        // 先移除两个视图
        removeArrangedSubview(firstView)
        removeArrangedSubview(secondView)

        // 在交换后的位置重新插入
        insertArrangedSubview(firstView, at: index2 > index1 ? index2 - 1 : index2)
        insertArrangedSubview(secondView, at: index1)
    }

    /// 交换两个排列子视图的位置,可选择是否启用动画
    ///
    /// - Parameters:
    ///   - firstView: 第一个要交换的视图
    ///   - secondView: 第二个要交换的视图
    ///   - animated: 是否启用动画默认为 `false`
    ///   - duration: 动画持续时间(秒)默认为 `0.25`
    ///   - delay: 动画开始前的延迟时间(秒)默认为 `0`
    ///   - options: 动画选项默认为 `.curveEaseInOut`
    ///   - completion: 动画完成后的回调闭包默认为 `nil`
    func dy_swapViews(
        _ firstView: UIView,
        _ secondView: UIView,
        animated: Bool = false,
        duration: TimeInterval = 0.25,
        delay: TimeInterval = 0,
        options: UIView.AnimationOptions = .curveEaseInOut,
        completion: ((Bool) -> Void)? = nil
    ) {
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: options,
                animations: {
                    self.switchViews(firstView, secondView)
                    self.superview?.layoutIfNeeded()
                },
                completion: completion
            )
        } else {
            self.switchViews(firstView, secondView)
        }
    }
}

// MARK: - 工厂方法
public extension UIStackView {
    /// 创建一个水平方向的堆栈视图
    ///
    /// - Parameters:
    ///   - arrangedSubviews: 要加入堆栈的子视图数组默认为空数组
    ///   - spacing: 子视图之间的间距默认为 `0`
    /// - Returns: 一个新创建的 `UIStackView` 实例,其轴向为水平
    @discardableResult
    static func dy_horizontal(arrangedSubviews: [UIView] = [], spacing: CGFloat = 0) -> UIStackView {
        UIStackView(views: arrangedSubviews, axis: .horizontal, spacing: spacing)
    }

    /// 创建一个垂直方向的堆栈视图
    ///
    /// - Parameters:
    ///   - arrangedSubviews: 要加入堆栈的子视图数组默认为空数组
    ///   - spacing: 子视图之间的间距默认为 `0`
    /// - Returns: 一个新创建的 `UIStackView` 实例,其轴向为垂直
    @discardableResult
    static func dy_vertical(arrangedSubviews: [UIView] = [], spacing: CGFloat = 0) -> UIStackView {
        UIStackView(views: arrangedSubviews, axis: .vertical, spacing: spacing)
    }
}
