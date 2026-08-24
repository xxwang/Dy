import UIKit

public extension UICollectionView {
    /// 关联属性键
    enum SoloKeys {
        static var moveItemGestureKey: UInt8 = 0
    }
}

// MARK: - 常用方法
public extension UICollectionView {
    /// 启用长按拖拽移动 `Item` 功能(自动添加长按手势并处理交互式移动)
    func solo_allowMoveItem() {
        let longPress = UILongPressGestureRecognizer()
        longPress
            .solo
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
        self.solo_SetAO(longPress, forKey: &SoloKeys.moveItemGestureKey)
    }

    /// 禁用拖拽移动功能(仅移除 `allowMoveItem` 添加的长按手势,不影响其它长按手势)
    func solo_disableMoveItem() {
        if let gesture = self.solo_GetAO(forKey: &SoloKeys.moveItemGestureKey) as? UILongPressGestureRecognizer {
            self.removeGestureRecognizer(gesture)
            self.solo_SetAO(nil, forKey: &SoloKeys.moveItemGestureKey)
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
    func solo_dequeueReusableCell<T: UICollectionViewCell>(
        withClass cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let cell = self.dequeueReusableCell(
            withReuseIdentifier: cellType.solo_identifier,
            for: indexPath
        ) as? T else {
            assertionFailure("未能正确复用 Cell: \(cellType). 请确认已通过register 注册！")
            return T()
        }
        return cell
    }

    /// 安全地复用补充视图
    /// - Parameters:
    ///   - kind: 视图种类
    ///   - viewType: 期望类型
    ///   - indexPath: 位置
    /// - Returns: 类型安全的补充视图
    func solo_dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        withClass viewType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        guard let view = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: viewType.solo_identifier,
            for: indexPath
        ) as? T else {
            assertionFailure("未能正确复用 Supplementary View: \(viewType). 请确认已注册！")
            return T()
        }
        return view
    }
}
