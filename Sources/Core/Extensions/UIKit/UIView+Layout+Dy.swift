import UIKit

// MARK: - 约束查找
public extension UIView {
    /// 获取当前视图的第一个宽度约束(仅限直接作用于 self 的约束)
    var dy_widthConstraint: NSLayoutConstraint? {
        dy_constraint(for: .width)
    }

    /// 获取当前视图的第一个高度约束
    var dy_heightConstraint: NSLayoutConstraint? {
        dy_constraint(for: .height)
    }

    /// 获取当前视图的第一个 leading 约束
    var dy_leadingConstraint: NSLayoutConstraint? {
        dy_constraint(for: .leading)
    }

    /// 获取当前视图的第一个 trailing 约束
    var dy_trailingConstraint: NSLayoutConstraint? {
        dy_constraint(for: .trailing)
    }

    /// 获取当前视图的第一个 top 约束
    var dy_topConstraint: NSLayoutConstraint? {
        dy_constraint(for: .top)
    }

    /// 获取当前视图的第一个 bottom 约束
    var dy_bottomConstraint: NSLayoutConstraint? {
        dy_constraint(for: .bottom)
    }

    /// 获取当前视图的第一个 centerX 约束
    var dy_centerXConstraint: NSLayoutConstraint? {
        dy_constraint(for: .centerX)
    }

    /// 获取当前视图的第一个 centerY 约束
    var dy_centerYConstraint: NSLayoutConstraint? {
        dy_constraint(for: .centerY)
    }

    /// 查找作用于当前视图的、指定布局属性的第一个 NSLayoutConstraint
    /// - Parameter attribute: 布局属性(如 .width, .leading 等)
    /// - Returns: 匹配的约束,若无则返回 nil
    private func dy_constraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        // 检查自身的 constraints(通常为空,除非用 addConstraint 添加到自己)
        if let constraint = constraints.first(where: { constraint in
            dy_isConstraint(constraint, affecting: self, with: attribute)
        }) {
            return constraint
        }

        // 检查父视图中的约束(绝大多数约束都在 superview.constraints 中)
        return superview?.constraints.first(where: { constraint in
            dy_isConstraint(constraint, affecting: self, with: attribute)
        })
    }

    /// 判断一个约束是否作用于指定视图的指定属性
    private func dy_isConstraint(_ constraint: NSLayoutConstraint,
                                 affecting view: UIView,
                                 with attribute: NSLayoutConstraint.Attribute) -> Bool
    {
        // 检查 firstItem 是否为 view 且属性匹配
        if constraint.firstItem as? NSObject == view, constraint.firstAttribute == attribute {
            return true
        }
        // 检查 secondItem 是否为 view 且属性匹配
        if constraint.secondItem as? NSObject == view, constraint.secondAttribute == attribute {
            return true
        }
        return false
    }
}

// MARK: - 约束添加
public extension UIView {
    /// 使用视觉格式语言 (VFL) 添加约束
    /// - Parameters:
    ///   - format: VFL 格式字符串(如 "H:|-[v0]-|")
    ///   - views: 按顺序传入的视图数组,自动映射为 v0, v1...
    ///   - options: 布局选项(如 .alignAllCenterY)
    ///   - metrics: 度量字典(如 ["spacing": 8])
    ///
    /// - Example:
    ///   ```swift
    ///   view.dy_addConstraints(
    ///       withFormat: "H:|-[v0]-|",
    ///       views: [label],
    ///       options: .alignAllCenterY
    ///   )
    ///   ```
    func dy_addConstraints(
        withFormat format: String,
        views: [UIView],
        options: NSLayoutConstraint.FormatOptions = [],
        metrics: [String: Any]? = nil
    ) {
        var viewsDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict[key] = view
        }

        let constraints = NSLayoutConstraint.constraints(
            withVisualFormat: format,
            options: options,
            metrics: metrics,
            views: viewsDict
        )
        NSLayoutConstraint.activate(constraints)
    }

    /// 将当前视图填充到父视图(支持内边距)
    /// - Parameters:
    ///   - insets: 内边距,默认 `.zero`
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 创建的 4 个约束数组
    ///
    /// - Example:
    ///   ```swift
    ///   subview.dy_fillSuperview(insets: .init(top: 10, left: 10, bottom: 10, right: 10))
    ///   ```
    @discardableResult
    func dy_fillSuperview(
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = self.superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false

        let top = topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        let leading = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        let bottom = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        let trailing = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)

        let constraints = [top, leading, bottom, trailing]
        for constraint in constraints {
            constraint.priority = priority
            constraint.isActive = true
        }
        return constraints
    }

    /// 将当前视图中心点对齐到父视图中心点
    /// - Parameters:
    ///   - offset: 偏移量(正 x 向右,正 y 向下),默认 `.zero`
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 2 个约束(centerX + centerY)
    ///
    /// - Example:
    ///   ```swift
    ///   view.dy_centerInSuperview(offset: CGPoint(x: 0, y: 10))
    ///   ```
    @discardableResult
    func dy_centerInSuperview(
        offset: CGPoint = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = self.superview else { return [] }
        translatesAutoresizingMaskIntoConstraints = false

        let centerX = centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x)
        let centerY = centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)

        let constraints = [centerX, centerY]
        for constraint in constraints {
            constraint.priority = priority
            constraint.isActive = true
        }
        return constraints
    }

    /// 将当前视图 centerX 对齐到父视图 centerX
    /// - Parameters:
    ///   - offset: X 方向偏移(正数向右),默认 0
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 创建的约束
    @discardableResult
    func dy_centerXInSuperview(
        offset: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        guard let superview = self.superview else { return nil }
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    /// 将当前视图 centerY 对齐到父视图 centerY
    /// - Parameters:
    ///   - offset: Y 方向偏移(正数向下),默认 0
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 创建的约束
    @discardableResult
    func dy_centerYInSuperview(
        offset: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        guard let superview = self.superview else { return nil }
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    /// 设置固定尺寸约束
    /// - Parameters:
    ///   - size: 目标尺寸
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 宽度和高度两个约束
    @discardableResult
    func dy_constraintSize(
        _ size: CGSize,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        let width = widthAnchor.constraint(equalToConstant: size.width)
        let height = heightAnchor.constraint(equalToConstant: size.height)

        let constraints = [width, height]
        for constraint in constraints {
            constraint.priority = priority
            constraint.isActive = true
        }
        return constraints
    }

    /// 设置固定宽度约束
    /// - Parameters:
    ///   - width: 宽度值
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 创建的宽度约束
    @discardableResult
    func dy_constraintWidth(
        _ width: CGFloat,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = widthAnchor.constraint(equalToConstant: width)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }

    /// 设置固定高度约束
    /// - Parameters:
    ///   - height: 高度值
    ///   - priority: 约束优先级,默认 `.required`
    /// - Returns: 创建的高度约束
    @discardableResult
    func dy_constraintHeight(
        _ height: CGFloat,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
}

// MARK: - 高级布局
public extension UIView {
    /// 灵活锚定视图到任意布局锚点
    /// - Parameters:
    ///   - top: 顶部对齐目标(如 superview.topAnchor)
    ///   - leading: 左侧对齐目标
    ///   - bottom: 底部对齐目标
    ///   - trailing: 右侧对齐目标
    ///   - centerX / centerY: 中心对齐目标
    ///   - width / height: 固定尺寸(可选)
    ///   - 所有 offset 参数：偏移量(注意 bottom/trailing 为负方向)
    ///   - priority: 统一设置所有约束的优先级
    /// - Returns: 创建的所有约束
    ///
    /// - Example:
    ///   ```swift
    ///   button.dy_anchor(
    ///       top: container.topAnchor,
    ///       leading: container.leadingAnchor,
    ///       width: 100,
    ///       height: 44
    ///   )
    ///   ```
    @discardableResult
    func dy_anchor(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        topOffset: CGFloat = 0,
        leadingOffset: CGFloat = 0,
        bottomOffset: CGFloat = 0,
        trailingOffset: CGFloat = 0,
        centerXOffset: CGFloat = 0,
        centerYOffset: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []

        if let top {
            let c = topAnchor.constraint(equalTo: top, constant: topOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let leading {
            let c = leadingAnchor.constraint(equalTo: leading, constant: leadingOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let bottom {
            // 注意：bottom 约束是 bottomAnchor = superview.bottomAnchor - offset
            let c = bottomAnchor.constraint(equalTo: bottom, constant: -bottomOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let trailing {
            let c = trailingAnchor.constraint(equalTo: trailing, constant: -trailingOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let centerX {
            let c = centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let centerY {
            let c = centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let width {
            let c = widthAnchor.constraint(equalToConstant: width)
            c.priority = priority
            constraints.append(c)
        }
        if let height {
            let c = heightAnchor.constraint(equalToConstant: height)
            c.priority = priority
            constraints.append(c)
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
