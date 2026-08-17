import UIKit

// MARK: - 约束查找
public extension SoloWrapper where Base: UIView {
    /// 获取当前视图的第一个宽度约束(仅限直接作用于 self 的约束)
    var widthConstraint: NSLayoutConstraint? {
        self.constraint(for: .width)
    }

    /// 获取当前视图的第一个高度约束
    var heightConstraint: NSLayoutConstraint? {
        self.constraint(for: .height)
    }

    /// 获取当前视图的第一个 leading 约束
    var leadingConstraint: NSLayoutConstraint? {
        self.constraint(for: .leading)
    }

    /// 获取当前视图的第一个 trailing 约束
    var trailingConstraint: NSLayoutConstraint? {
        self.constraint(for: .trailing)
    }

    /// 获取当前视图的第一个 top 约束
    var topConstraint: NSLayoutConstraint? {
        self.constraint(for: .top)
    }

    /// 获取当前视图的第一个 bottom 约束
    var bottomConstraint: NSLayoutConstraint? {
        self.constraint(for: .bottom)
    }

    /// 获取当前视图的第一个 centerX 约束
    var centerXConstraint: NSLayoutConstraint? {
        self.constraint(for: .centerX)
    }

    /// 获取当前视图的第一个 centerY 约束
    var centerYConstraint: NSLayoutConstraint? {
        self.constraint(for: .centerY)
    }

    /// 查找作用于当前视图的、指定布局属性的第一个 NSLayoutConstraint
    /// - Parameter attribute: 布局属性(如 .width, .leading 等)
    /// - Returns: 匹配的约束,若无则返回 nil
    private func constraint(for attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        // 检查自身的 constraints(通常为空,除非用 addConstraint 添加到自己)
        if let constraint = base.constraints.first(where: { constraint in
            self.isConstraint(constraint, affecting: base, with: attribute)
        }) {
            return constraint
        }

        // 检查父视图中的约束(绝大多数约束都在 superview.constraints 中)
        return base.superview?.constraints.first(where: { constraint in
            self.isConstraint(constraint, affecting: base, with: attribute)
        })
    }

    /// 判断一个约束是否作用于指定视图的指定属性
    private func isConstraint(_ constraint: NSLayoutConstraint,
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
public extension SoloWrapper where Base: UIView {
    /// 使用视觉格式语言 (VFL) 添加约束
    /// - Parameters:
    ///   - format: VFL 格式字符串(如 "H:|-[v0]-|")
    ///   - views: 按顺序传入的视图数组,自动映射为 v0, v1...
    ///   - options: 布局选项(如 .alignAllCenterY)
    ///   - metrics: 度量字典(如 ["spacing": 8])
    ///
    /// - Example:
    ///   ```swift
    ///   view.solo.addConstraints(
    ///       withFormat: "H:|-[v0]-|",
    ///       views: [label],
    ///       options: .alignAllCenterY
    ///   )
    ///   ```
    func addConstraints(
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
    ///   subview.solo.fillSuperview(insets: .init(top: 10, left: 10, bottom: 10, right: 10))
    ///   ```
    @discardableResult
    func fillSuperview(
        insets: UIEdgeInsets = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = base.superview else { return [] }
        base.translatesAutoresizingMaskIntoConstraints = false

        let top = base.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top)
        let leading = base.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left)
        let bottom = base.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        let trailing = base.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)

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
    ///   view.solo.centerInSuperview(offset: CGPoint(x: 0, y: 10))
    ///   ```
    @discardableResult
    func centerInSuperview(
        offset: CGPoint = .zero,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        guard let superview = base.superview else { return [] }
        base.translatesAutoresizingMaskIntoConstraints = false

        let centerX = base.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset.x)
        let centerY = base.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset.y)

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
    func centerXInSuperview(
        offset: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        guard let superview = base.superview else { return nil }
        base.translatesAutoresizingMaskIntoConstraints = false

        let constraint = base.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset)
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
    func centerYInSuperview(
        offset: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        guard let superview = base.superview else { return nil }
        base.translatesAutoresizingMaskIntoConstraints = false

        let constraint = base.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset)
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
    func constraintSize(
        _ size: CGSize,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        base.translatesAutoresizingMaskIntoConstraints = false

        let width = base.widthAnchor.constraint(equalToConstant: size.width)
        let height = base.heightAnchor.constraint(equalToConstant: size.height)

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
    func constraintWidth(
        _ width: CGFloat,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        base.translatesAutoresizingMaskIntoConstraints = false
        let constraint = base.widthAnchor.constraint(equalToConstant: width)
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
    func constraintHeight(
        _ height: CGFloat,
        priority: UILayoutPriority = .required
    ) -> NSLayoutConstraint? {
        base.translatesAutoresizingMaskIntoConstraints = false
        let constraint = base.heightAnchor.constraint(equalToConstant: height)
        constraint.priority = priority
        constraint.isActive = true
        return constraint
    }
}

// MARK: - 高级布局
public extension SoloWrapper where Base: UIView {
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
    ///   button.solo.anchor(
    ///       top: container.topAnchor,
    ///       leading: container.leadingAnchor,
    ///       width: 100,
    ///       height: 44
    ///   )
    ///   ```
    @discardableResult
    func anchor(
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
        base.translatesAutoresizingMaskIntoConstraints = false
        var constraints: [NSLayoutConstraint] = []

        if let top {
            let c = base.topAnchor.constraint(equalTo: top, constant: topOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let leading {
            let c = base.leadingAnchor.constraint(equalTo: leading, constant: leadingOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let bottom {
            // 注意：bottom 约束是 bottomAnchor = superview.bottomAnchor - offset
            let c = base.bottomAnchor.constraint(equalTo: bottom, constant: -bottomOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let trailing {
            let c = base.trailingAnchor.constraint(equalTo: trailing, constant: -trailingOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let centerX {
            let c = base.centerXAnchor.constraint(equalTo: centerX, constant: centerXOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let centerY {
            let c = base.centerYAnchor.constraint(equalTo: centerY, constant: centerYOffset)
            c.priority = priority
            constraints.append(c)
        }
        if let width {
            let c = base.widthAnchor.constraint(equalToConstant: width)
            c.priority = priority
            constraints.append(c)
        }
        if let height {
            let c = base.heightAnchor.constraint(equalToConstant: height)
            c.priority = priority
            constraints.append(c)
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }
}
