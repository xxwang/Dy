import UIKit

// MARK: - 事件回调处理
extension UIGestureRecognizer {
    /// 关联属性键
    private enum Keys {
        static var recognized: UInt8 = 0
        static var stateChanged: UInt8 = 0
    }

    /// 手势识别成功时触发的闭包
    var recognizedBlock: DyAction1<UIGestureRecognizer>? {
        get { return self.dy.GetAO(forKey: &Keys.recognized) }
        set { self.dy.SetAO(newValue, forKey: &Keys.recognized) }
    }

    /// 手势状态变化时触发的闭包
    var stateChangedBlock: DyAction1<UIGestureRecognizer.State>? {
        get { return self.dy.GetAO(forKey: &Keys.stateChanged) }
        set { self.dy.SetAO(newValue, forKey: &Keys.stateChanged) }
    }

    /// 处理手势状态变化
    @objc func stateChangeHandler() {
        // 状态回调
        self.stateChangedBlock?(state)

        if state == .recognized {
            // 手势识别回调
            self.recognizedBlock?(self)
        }
    }
}

// MARK: - 属性
public extension DyWrapper where Base: UIGestureRecognizer {
    /// 视图是否启用了用户交互
    var canRecognizeGesture: Bool {
        base.view?.isUserInteractionEnabled == true
    }

    /// 获取手势在所属视图中的触摸位置
    var locationInView: CGPoint {
        guard let view = base.view else { return .zero }
        return base.location(in: view)
    }
}
