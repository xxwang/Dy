import UIKit

// MARK: - 常用方法
public extension UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func dy_allowMoveItem() {
        self
            .dy
            .onLongPressGestureRecognizer { [weak self] recognizer in
                guard let self else { return }

                let location = recognizer.location(in: self)
                switch recognizer.state {
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
    }

    /// 禁用拖拽移动功能(移除所有长按手势)
    func dy_disableMoveItem() {
        self.gestureRecognizers?
            .compactMap { $0 as? UILongPressGestureRecognizer }
            .forEach(removeGestureRecognizer)
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
