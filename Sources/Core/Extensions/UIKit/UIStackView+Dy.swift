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
        completion: DyAction1<Bool>? = nil
    ) {
        if animated {
            UIView.animate(
                withDuration: duration,
                delay: delay,
                options: options,
                animations: {
                    self.dy_switchViews(firstView, secondView)
                    self.superview?.layoutIfNeeded()
                },
                completion: completion
            )
        } else {
            self.dy_switchViews(firstView, secondView)
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

// MARK: - 链式设置属性
public extension UIStackView {
    /// 设置子视图的排列轴向(水平或垂直)
    /// - Parameter axis: 布局轴向
    /// - Returns: `Self`
    @discardableResult
    func dy_axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        self.axis = axis
        return self
    }

    /// 设置沿堆栈轴向的子视图分布策略
    /// - Parameter distribution: 分布方式(如填充、等宽、等间距等)
    /// - Returns: `Self`
    @discardableResult
    func dy_distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }

    /// 设置垂直于堆栈轴向的子视图对齐方式
    /// - Parameter alignment: 对齐模式(如居中、顶部对齐、填充等)
    /// - Returns: `Self`
    @discardableResult
    func dy_alignment(_ alignment: UIStackView.Alignment) -> Self {
        self.alignment = alignment
        return self
    }

    /// 设置默认的子视图间距
    /// - Parameter spacing: 相邻子视图之间的间距值
    /// - Returns: `Self`
    @discardableResult
    func dy_spacing(_ spacing: CGFloat) -> Self {
        self.spacing = spacing
        return self
    }

    /// 为指定的排列子视图之后设置自定义间距(仅 iOS 11 及以上,Dy 最低支持 iOS 14,故安全使用)
    ///
    /// - Parameters:
    ///   - spacing: 自定义间距值
    ///   - arrangedSubview: 作为参考的子视图,间距将应用在其之后
    /// - Returns: `Self`
    @discardableResult
    func dy_customSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        self.setCustomSpacing(spacing, after: arrangedSubview)
        return self
    }

    /// 启用或禁用基线相对布局(适用于包含文本的垂直堆栈)
    /// - Parameter enabled: 是否启用基线相对布局
    /// - Returns: `Self`
    @discardableResult
    func dy_baselineRelativeArrangement(_ enabled: Bool) -> Self {
        self.isBaselineRelativeArrangement = enabled
        return self
    }

    /// 启用或禁用以布局边距(layout margins)作为布局参考
    /// - Parameter enabled: 是否以布局边距为基准进行子视图排布
    /// - Returns: `Self`
    @discardableResult
    func dy_layoutMarginsRelativeArrangement(_ enabled: Bool) -> Self {
        self.isLayoutMarginsRelativeArrangement = enabled
        return self
    }

    /// 设置堆栈视图的布局边距
    /// - Parameter margins: 四周边距(上、左、下、右)
    /// - Returns: `Self`
    @discardableResult
    override func dy_layoutMargins(_ margins: UIEdgeInsets) -> Self {
        self.layoutMargins = margins
        return self
    }

    /// 设置是否继承父视图的布局边距
    /// - Parameter preserves: 是否保留父视图的布局边距
    /// - Returns: `Self`
    @discardableResult
    override func dy_preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        self.preservesSuperviewLayoutMargins = preserves
        return self
    }
}

// MARK: - 链式方法
public extension UIStackView {
    /// 批量添加多个排列子视图
    /// - Parameter views: 要添加的视图数组
    /// - Returns: `Self`
    @discardableResult
    func dy_addArrangedSubviews(_ views: [UIView]) -> Self {
        for view in views {
            self.addArrangedSubview(view)
        }
        return self
    }

    /// 添加单个排列子视图
    /// - Parameter view: 要添加的子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_addArrangedSubview(_ view: UIView) -> Self {
        self.addArrangedSubview(view)
        return self
    }

    /// 从堆栈中移除指定的排列子视图,并将其从父视图中彻底移除
    /// - Parameter view: 要移除的子视图
    /// - Returns: `Self`
    @discardableResult
    func dy_removeArrangedSubview(_ view: UIView) -> Self {
        self.removeArrangedSubview(view)
        view.removeFromSuperview()
        return self
    }

    /// 移除所有排列子视图,并将它们从父视图中彻底移除
    /// - Returns: `Self`
    @discardableResult
    func dy_removeAllArrangedSubviews() -> Self {
        for view in self.arrangedSubviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        return self
    }
}
