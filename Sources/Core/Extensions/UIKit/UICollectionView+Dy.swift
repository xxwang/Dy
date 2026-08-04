import UIKit

public extension UICollectionView {
    /// 关联属性键
    enum Keys {
        static var moveItemGestureKey: UInt8 = 0
    }
}

// MARK: - 常用方法
public extension DyWrapper where Base: UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func allowMoveItem() {
        let longPress = UILongPressGestureRecognizer()
        longPress
            .dy
            .onStateChanged { [weak base, weak longPress] state in
                guard let base, let recognizer = longPress else { return }

                let location = recognizer.location(in: base)
                switch state {
                case .began:
                    if let indexPath = base.indexPathForItem(at: location) {
                        base.beginInteractiveMovementForItem(at: indexPath)
                    }
                case .changed:
                    base.updateInteractiveMovementTargetPosition(location)
                case .ended:
                    base.endInteractiveMovement()
                default:
                    base.cancelInteractiveMovement()
                }
            }
        base.addGestureRecognizer(longPress)
        base.dy.SetAO(longPress, forKey: &Base.Keys.moveItemGestureKey)
    }

    /// 禁用拖拽移动功能(仅移除 `allowMoveItem` 添加的长按手势,不影响其它长按手势)
    func disableMoveItem() {
        if let gesture = base.dy.GetAO(forKey: &Base.Keys.moveItemGestureKey) as? UILongPressGestureRecognizer {
            base.removeGestureRecognizer(gesture)
            base.dy.SetAO(nil, forKey: &Base.Keys.moveItemGestureKey)
        }
    }
}

// MARK: - 复用
public extension DyWrapper where Base: UICollectionView {
    /// 安全地复用 `Cell`(自动类型转换 + 断言)
    /// - Parameters:
    ///   - cellType: 期望的 Cell 类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的 `Cell` 实例
    /// - Throws: 若未注册或类型不匹配,程序将 crash(开发期快速暴露问题)
    func dequeueReusableCell<T: UICollectionViewCell>(
        withClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = base.dequeueReusableCell(
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
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass viewType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let view = base.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewType.identifier,
            for: indexPath
        ) as? T else {
            fatalError("未能正确复用 Supplementary View: \(viewType). 请确认已注册！")
        }
        return view
    }
}
