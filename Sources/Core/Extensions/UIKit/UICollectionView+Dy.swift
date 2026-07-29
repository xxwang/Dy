import UIKit

/// 关联属性键:记录 `dy_allowMoveItem` 添加的长按手势,供 `dy_disableMoveItem` 精准移除
private var dy_moveItemGestureKey: UInt8 = 0

// MARK: - 常用方法
public extension UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func dy_allowMoveItem() {
        let longPress = UILongPressGestureRecognizer()
        longPress.dy_onStateChanged { [weak self, weak longPress] state in
            guard let self, let recognizer = longPress else { return }

            let location = recognizer.location(in: self)
            switch state {
            case .began:
                if let indexPath = self.indexPathForItem(at: location) {
                    self.beginInteractiveMovementForItem(at: indexPath)
                }
            case .changed:
                self.updateInteractiveMovementTargetPosition(location)
            case .ended:
                self.endInteractiveMovement()
            default:
                self.cancelInteractiveMovement()
            }
        }
        self.dy_addGestureRecognizer(longPress)
        self.dy_setAssociatedObject(longPress, forKey: &dy_moveItemGestureKey)
    }

    /// 禁用拖拽移动功能(仅移除 `dy_allowMoveItem` 添加的长按手势,不影响其它长按手势)
    func dy_disableMoveItem() {
        if let gesture = self.dy_getAssociatedObject(forKey: &dy_moveItemGestureKey) as? UILongPressGestureRecognizer {
            self.removeGestureRecognizer(gesture)
            self.dy_setAssociatedObject(nil, forKey: &dy_moveItemGestureKey)
        }
    }
}

// MARK: - UICollectionViewCell 注册与复用
public extension UICollectionView {
    /// 使用类名注册 `UICollectionViewCell`(适用于纯代码 `Cell`)
    /// - Parameter cellType: `Cell` 类型
    func dy_register(cellWithClass cellType: (some UICollectionViewCell).Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.identifier)
    }

    /// 使用 `Nib` 注册 `UICollectionViewCell`
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - cellType: `Cell` 类型
    func dy_register(nib: UINib?, forCellWithClass cellType: (some UICollectionViewCell).Type) {
        register(nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    /// 自动从同名 `XIB` 注册 `Cell`(`XIB` 文件名需与类名一致)
    /// - Parameters:
    ///   - cellType: `Cell` 类型
    ///   - bundleClass: 用于定位 `Bundle` 的参考类(默认为当前类)
    func dy_register(nibWithCellClass cellType: (some UICollectionViewCell).Type, at bundleClass: AnyClass? = nil) {
        let bundle = bundleClass.map { Bundle(for: $0) } ?? Bundle(for: cellType)
        let nib = UINib(nibName: cellType.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cellType.identifier)
    }

    /// 安全地复用 `Cell`(自动类型转换 + 断言)
    /// - Parameters:
    ///   - cellType: 期望的 Cell 类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的 `Cell` 实例
    /// - Throws: 若未注册或类型不匹配,程序将 crash(开发期快速暴露问题)
    func dy_dequeueReusableCell<T: UICollectionViewCell>(
        withClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.identifier,
            for: indexPath
        ) as? T else {
            fatalError("未能正确复用 Cell: \(cellType). 请确认已通过register 注册！")
        }
        return cell
    }
}

// MARK: - (Header/Footer)注册与复用
public extension UICollectionView {
    /// 使用类名注册补充视图(如 `Header`)
    /// - Parameters:
    ///   - kind: 视图种类(如 `UICollectionView.elementKindSectionHeader`)
    ///   - viewType: 视图类型
    func dy_register(supplementaryViewOfKind kind: String, withClass viewType: (some UICollectionReusableView).Type) {
        register(viewType, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.identifier)
    }

    /// 使用 `Nib` 注册补充视图
    /// - Parameters:
    ///   - nib: `Nib` 对象
    ///   - kind: 视图种类
    ///   - viewType: 视图类型
    func dy_register(
        nib: UINib?,
        forSupplementaryViewOfKind kind: String,
        withClass viewType: (some UICollectionReusableView).Type
    ) {
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: viewType.identifier)
    }

    /// 安全地复用补充视图
    /// - Parameters:
    ///   - kind: 视图种类
    ///   - viewType: 期望类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的补充视图
    func dy_dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass viewType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewType.identifier,
            for: indexPath
        ) as? T else {
            fatalError("未能正确复用 Supplementary View: \(viewType). 请确认已注册！")
        }
        return view
    }
}

// MARK: - 链式设置属性
public extension UICollectionView {
    /// 设置 `delegate`
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UICollectionViewDelegate) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置 `dataSource`
    /// - Parameter dataSource: 数据源对象
    /// - Returns: `Self`
    @discardableResult
    func dy_dataSource(_ dataSource: UICollectionViewDataSource) -> Self {
        self.dataSource = dataSource
        return self
    }

    /// 设置键盘交互模式(如拖拽时自动收起键盘)
    /// - Parameter mode: 模式
    /// - Returns: `Self`
    @discardableResult
    func dy_keyboardDismissMode(_ mode: UIScrollView.KeyboardDismissMode) -> Self {
        self.keyboardDismissMode = mode
        return self
    }
}

// MARK: - 方法
public extension UICollectionView {
    /// 注册 `Cell` 类(纯代码方式),支持链式调用
    /// - Parameter cell: `UICollectionViewCell` 的子类类型
    /// - Returns: `Self`
    @discardableResult
    func dy_register(_ cell: (some UICollectionViewCell).Type) -> Self {
        self.dy_register(cellWithClass: cell)
        return self
    }

    /// 设置 `CollectionView` 布局,支持动画和完成回调
    /// - Parameters:
    ///   - layout: 布局对象
    ///   - animated: 是否动画
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func dy_collectionViewLayout(
        _ layout: UICollectionViewLayout,
        animated: Bool = true,
        completion: DyAction1<Bool>? = nil
    ) -> Self {
        self.setCollectionViewLayout(layout, animated: animated, completion: completion)
        return self
    }

    /// 滚动使指定区域可见
    /// - Parameters:
    ///   - rect: 可视区域
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollRectToVisible(_ rect: CGRect, animated: Bool = true) -> Self {
        self.scrollRectToVisible(rect, animated: animated)
        return self
    }

    /// 设置 `contentOffset`
    /// - Parameters:
    ///   - offset: 目标偏移量,默认为 .zero
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_contentOffset(_ offset: CGPoint = .zero, animated: Bool = true) -> Self {
        self.setContentOffset(offset, animated: animated)
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension UICollectionView {
    /// 滚动到指定 `Item`
    /// - Parameters:
    ///   - indexPath: `Item`索引
    ///   - scrollPosition: 滚动位置
    ///   - animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToItem(
        _ indexPath: IndexPath,
        at scrollPosition: UICollectionView.ScrollPosition = .top,
        animated: Bool = true
    ) -> Self {
        guard
            indexPath.section >= 0,
            indexPath.item >= 0,
            indexPath.section < self.numberOfSections,
            indexPath.item < self.numberOfItems(inSection: indexPath.section)
        else {
            return self
        }
        self.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
        return self
    }

    /// 滚动到顶部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToTop(animated: Bool = true) -> Self {
        self.setContentOffset(.zero, animated: animated)
        return self
    }

    /// 滚动到底部
    /// - Parameter animated: 是否动画
    /// - Returns: `Self`
    @discardableResult
    func dy_scrollToBottom(animated: Bool = true) -> Self {
        let yOffset = max(0, self.contentSize.height - self.bounds.height)
        self.setContentOffset(CGPoint(x: 0, y: yOffset), animated: animated)
        return self
    }
}
