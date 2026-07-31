import UIKit

/// 关联属性键:记录 `dy_allowMoveItem` 添加的长按手势,供 `dy_disableMoveItem` 精准移除
private var dy_moveItemGestureKey: UInt8 = 0

// MARK: - 常用方法
public extension UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func dy_allowMoveItem() {
        let longPress = UILongPressGestureRecognizer()
        longPress.dy
            .onStateChanged { [weak self, weak longPress] state in
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
        self.addGestureRecognizer(longPress)
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

// MARK: - 复用
public extension UICollectionView {
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
