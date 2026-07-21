import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIStackView {
    /// 设置子视图的排列轴向(水平或垂直)
    /// - Parameter axis: 布局轴向
    /// - Returns: `Self`
    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        base.axis = axis
        return self
    }

    /// 设置沿堆栈轴向的子视图分布策略
    /// - Parameter distribution: 分布方式(如填充、等宽、等间距等)
    /// - Returns: `Self`
    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        base.distribution = distribution
        return self
    }

    /// 设置垂直于堆栈轴向的子视图对齐方式
    /// - Parameter alignment: 对齐模式(如居中、顶部对齐、填充等)
    /// - Returns: `Self`
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        base.alignment = alignment
        return self
    }

    /// 设置默认的子视图间距
    /// - Parameter spacing: 相邻子视图之间的间距值
    /// - Returns: `Self`
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        base.spacing = spacing
        return self
    }

    /// 为指定的排列子视图之后设置自定义间距(仅 iOS 11 及以上,Dy 最低支持 iOS 14,故安全使用)
    ///
    /// - Parameters:
    ///   - spacing: 自定义间距值
    ///   - arrangedSubview: 作为参考的子视图,间距将应用在其之后
    /// - Returns: `Self`
    @discardableResult
    func customSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
        base.setCustomSpacing(spacing, after: arrangedSubview)
        return self
    }

    /// 启用或禁用基线相对布局(适用于包含文本的垂直堆栈)
    /// - Parameter enabled: 是否启用基线相对布局
    /// - Returns: `Self`
    @discardableResult
    func baselineRelativeArrangement(_ enabled: Bool) -> Self {
        base.isBaselineRelativeArrangement = enabled
        return self
    }

    /// 启用或禁用以布局边距(layout margins)作为布局参考
    /// - Parameter enabled: 是否以布局边距为基准进行子视图排布
    /// - Returns: `Self`
    @discardableResult
    func layoutMarginsRelativeArrangement(_ enabled: Bool) -> Self {
        base.isLayoutMarginsRelativeArrangement = enabled
        return self
    }

    /// 设置堆栈视图的布局边距
    /// - Parameter margins: 四周边距(上、左、下、右)
    /// - Returns: `Self`
    @discardableResult
    func layoutMargins(_ margins: UIEdgeInsets) -> Self {
        base.layoutMargins = margins
        return self
    }

    /// 设置是否继承父视图的布局边距
    /// - Parameter preserves: 是否保留父视图的布局边距
    /// - Returns: `Self`
    @discardableResult
    func preservesSuperviewLayoutMargins(_ preserves: Bool) -> Self {
        base.preservesSuperviewLayoutMargins = preserves
        return self
    }
}

// MARK: - 方法
public extension DyWrapper where Base: UIStackView {
    /// 批量添加多个排列子视图
    /// - Parameter views: 要添加的视图数组
    /// - Returns: `Self`
    @discardableResult
    func addArrangedSubviews(_ views: [UIView]) -> Self {
        for view in views {
            base.addArrangedSubview(view)
        }
        return self
    }

    /// 添加单个排列子视图
    /// - Parameter view: 要添加的子视图
    /// - Returns: `Self`
    @discardableResult
    func addArrangedSubview(_ view: UIView) -> Self {
        base.addArrangedSubview(view)
        return self
    }

    /// 从堆栈中移除指定的排列子视图,并将其从父视图中彻底移除
    /// - Parameter view: 要移除的子视图
    /// - Returns: `Self`
    @discardableResult
    func removeArrangedSubview(_ view: UIView) -> Self {
        base.removeArrangedSubview(view)
        view.removeFromSuperview()
        return self
    }

    /// 移除所有排列子视图,并将它们从父视图中彻底移除
    /// - Returns: `Self`
    @discardableResult
    func removeAllArrangedSubviews() -> Self {
        for view in base.arrangedSubviews {
            base.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        return self
    }
}
