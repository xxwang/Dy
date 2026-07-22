import UIKit

// MARK: - 事件回调处理
extension UIGestureRecognizer {
    /// 关联属性键
    struct AssociatedKeys {
        static var recognized = UnsafeRawPointer(bitPattern: "UIGestureRecognizer.recognized".hashValue)!
        static var stateChanged = UnsafeRawPointer(bitPattern: "UIGestureRecognizer.stateChanged".hashValue)!
    }

    /// 手势识别成功时触发的闭包
    var dy_recognizedBlock: ((UIGestureRecognizer) -> Void)? {
        get { return self.dy_getAssociatedObject(forKey: AssociatedKeys.recognized) }
        set { self.dy_setAssociatedObject(newValue, forKey: AssociatedKeys.recognized) }
    }

    /// 手势状态变化时触发的闭包
    var dy_stateChangedBlock: ((UIGestureRecognizer.State) -> Void)? {
        get { return self.dy_getAssociatedObject(forKey: AssociatedKeys.stateChanged) }
        set { self.dy_setAssociatedObject(newValue, forKey: AssociatedKeys.stateChanged) }
    }

    /// 处理手势状态变化
    @objc func dy_stateChangeHandler() {
        // 状态回调
        self.dy_stateChangedBlock?(state)

        if state == .recognized {
            // 手势识别回调
            self.dy_recognizedBlock?(self)
        }
    }
}

// MARK: - 属性
public extension UIGestureRecognizer {
    /// 视图是否启用了用户交互
    var dy_canRecognizeGesture: Bool {
        self.view?.isUserInteractionEnabled == true
    }

    /// 获取手势在所属视图中的触摸位置
    var dy_locationInView: CGPoint {
        guard let view = self.view else { return .zero }
        return self.location(in: view)
    }
}
