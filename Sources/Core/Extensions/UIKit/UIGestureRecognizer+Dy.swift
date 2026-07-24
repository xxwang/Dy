import UIKit

// MARK: - 事件回调处理
extension UIGestureRecognizer {
    /// 关联属性键
    struct AssociatedKeys {
        static var recognized = UnsafeRawPointer(bitPattern: "UIGestureRecognizer.recognized".hashValue)!
        static var stateChanged = UnsafeRawPointer(bitPattern: "UIGestureRecognizer.stateChanged".hashValue)!
    }

    /// 手势识别成功时触发的闭包
    var dy_recognizedBlock: DyAction1<UIGestureRecognizer>? {
        get { return self.dy_getAssociatedObject(forKey: AssociatedKeys.recognized) }
        set { self.dy_setAssociatedObject(newValue, forKey: AssociatedKeys.recognized) }
    }

    /// 手势状态变化时触发的闭包
    var dy_stateChangedBlock: DyAction1<UIGestureRecognizer.State>? {
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

// MARK: - 链式设置属性
public extension UIGestureRecognizer {
    /// 启用或禁用手势识别器
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func dy_isEnabled(_ enabled: Bool) -> Self {
        self.isEnabled = enabled
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: (any UIGestureRecognizerDelegate)?) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置是否取消传递触摸事件到视图
    /// - Parameter flag: 若为 true，则手势识别期间视图不会收到 touch 事件
    /// - Returns: `Self`
    @discardableResult
    func dy_cancelsTouchesInView(_ flag: Bool) -> Self {
        self.cancelsTouchesInView = flag
        return self
    }

    /// 设置是否延迟触发 touchesBegan
    /// - Parameter flag: 若为 true，系统会等待手势识别失败后再发送 touchesBegan
    /// - Returns: `Self`
    @discardableResult
    func dy_delaysTouchesBegan(_ flag: Bool) -> Self {
        self.delaysTouchesBegan = flag
        return self
    }

    /// 设置是否延迟触发 touchesEnded
    /// - Parameter flag: 若为 true，系统会短暂延迟 touchesEnded 以确认手势未激活
    /// - Returns: `Self`
    @discardableResult
    func dy_delaysTouchesEnded(_ flag: Bool) -> Self {
        self.delaysTouchesEnded = flag
        return self
    }

    /// 设置允许的触摸类型（如直接触摸、间接触摸）
    /// - Parameter types: 触摸类型数组（使用 `UITouch.TouchType` 的 rawValue）
    /// - Returns: `Self`
    @discardableResult
    func dy_allowedTouchTypes(_ types: [NSNumber]) -> Self {
        self.allowedTouchTypes = types
        return self
    }

    /// 设置允许的按压类型（用于 tvOS 或外接键盘）
    /// - Parameter types: 按压类型数组
    /// - Returns: `Self`
    @discardableResult
    func dy_allowedPressTypes(_ types: [NSNumber]) -> Self {
        self.allowedPressTypes = types
        return self
    }

    /// 设置是否要求独占触摸类型
    /// - Parameter flag: 若为 true，则仅当所有触摸匹配指定类型时才触发
    /// - Returns: `Self`
    @discardableResult
    func dy_requiresExclusiveTouchType(_ flag: Bool) -> Self {
        self.requiresExclusiveTouchType = flag
        return self
    }

    /// 设置手势识别器的名称（用于调试或无障碍）
    /// - Parameter name: 名称字符串
    /// - Returns: `Self`
    @discardableResult
    func dy_name(_ name: String?) -> Self {
        self.name = name
        return self
    }
}

// MARK: - 链式方法
public extension UIGestureRecognizer {
    /// 添加`target-action`
    /// - Parameters:
    ///   - target: 响应对象
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func dy_addTarget(_ target: Any, action: Selector) -> Self {
        self.addTarget(target, action: action)
        return self
    }

    /// 移除`target-action`
    /// - Parameters:
    ///   - target: 响应对象
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func dy_removeTarget(_ target: Any?, action: Selector?) -> Self {
        self.removeTarget(target, action: action)
        return self
    }

    /// 设置当前手势必须在另一个手势失败后才能识别
    /// - Parameter otherGestureRecognizer: 被依赖的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dy_require(toFail otherGestureRecognizer: UIGestureRecognizer) -> Self {
        self.require(toFail: otherGestureRecognizer)
        return self
    }
}

// MARK: - 链式方法自定义
public extension UIGestureRecognizer {
    /// 将手势识别器添加到指定视图
    /// - Parameter view: 目标视图
    /// - Returns: `Self`
    @discardableResult
    func dy_add2(_ view: UIView) -> Self {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(self)
        return self
    }

    /// 从当前视图中移除该手势识别器
    /// - Returns: `Self`
    @discardableResult
    func dy_removeGestureRecognizer() -> Self {
        self.view?.removeGestureRecognizer(self)
        return self
    }

    /// 设置手势识别成功(`.recognized`)时的回调
    /// - Warning: 闭包被手势识别器**强引用**（通过关联对象存储）。若闭包内使用 `self`，
    ///   请务必使用 `[weak self]`（如 `{ [weak self] recognizer in ... }`），
    ///   否则 `view → gesture → block → self → view` 会造成循环引用泄漏。
    /// - Parameter block: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func dy_onRecognized(_ block: @escaping DyAction1<UIGestureRecognizer>) -> Self {
        self.dy_recognizedBlock = block
        self.removeTarget(self, action: #selector(UIGestureRecognizer.dy_stateChangeHandler))
        self.addTarget(self, action: #selector(UIGestureRecognizer.dy_stateChangeHandler))
        return self
    }

    /// 监听手势状态变化(如 `began`, `changed`, `ended` 等)
    /// - Warning: 闭包被手势识别器**强引用**。若闭包内使用 `self`，
    ///   请使用 `[weak self]` 避免循环引用泄漏。
    /// - Parameter block: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func dy_onStateChanged(_ block: @escaping DyAction1<UIGestureRecognizer.State>) -> Self {
        self.dy_stateChangedBlock = block
        self.removeTarget(self, action: #selector(UIGestureRecognizer.dy_stateChangeHandler))
        self.addTarget(self, action: #selector(UIGestureRecognizer.dy_stateChangeHandler))
        return self
    }
}
