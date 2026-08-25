import UIKit

// MARK: - 事件回调处理
extension UIGestureRecognizer {
    /// 关联属性键
    private enum SoloKeys {
        static var recognized: UInt8 = 0
        static var stateChanged: UInt8 = 0
    }

    /// 手势识别成功时触发的闭包
    var solo_recognizedBlock: SoloAction1<UIGestureRecognizer>? {
        get { return self.solo_GetAO(forKey: &SoloKeys.recognized) }
        set { self.solo_SetAO(newValue, forKey: &SoloKeys.recognized) }
    }

    /// 手势状态变化时触发的闭包
    var solo_stateChangedBlock: SoloAction1<UIGestureRecognizer.State>? {
        get { return self.solo_GetAO(forKey: &SoloKeys.stateChanged) }
        set { self.solo_SetAO(newValue, forKey: &SoloKeys.stateChanged) }
    }

    /// 处理手势状态变化
    @objc func stateChangeHandler() {
        // 状态回调
        self.solo_stateChangedBlock?(state)

        if state == .recognized {
            // 手势识别回调
            self.solo_recognizedBlock?(self)
        }
    }
}

// MARK: - 属性
public extension UIGestureRecognizer {
    /// 视图是否启用了用户交互
    var solo_canRecognizeGesture: Bool {
        self.view?.isUserInteractionEnabled == true
    }

    /// 获取手势在所属视图中的触摸位置
    var solo_locationInView: CGPoint {
        guard let view = self.view else { return .zero }
        return self.location(in: view)
    }
}
