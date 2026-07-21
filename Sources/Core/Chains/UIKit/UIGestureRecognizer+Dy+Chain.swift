import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIGestureRecognizer {
    /// 启用或禁用手势识别器
    /// - Parameter enabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ enabled: Bool) -> Self {
        base.isEnabled = enabled
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UIGestureRecognizerDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置是否取消传递触摸事件到视图
    /// - Parameter flag: 若为 true，则手势识别期间视图不会收到 touch 事件
    /// - Returns: `Self`
    @discardableResult
    func cancelsTouchesInView(_ flag: Bool) -> Self {
        base.cancelsTouchesInView = flag
        return self
    }

    /// 设置是否延迟触发 touchesBegan
    /// - Parameter flag: 若为 true，系统会等待手势识别失败后再发送 touchesBegan
    /// - Returns: `Self`
    @discardableResult
    func delaysTouchesBegan(_ flag: Bool) -> Self {
        base.delaysTouchesBegan = flag
        return self
    }

    /// 设置是否延迟触发 touchesEnded
    /// - Parameter flag: 若为 true，系统会短暂延迟 touchesEnded 以确认手势未激活
    /// - Returns: `Self`
    @discardableResult
    func delaysTouchesEnded(_ flag: Bool) -> Self {
        base.delaysTouchesEnded = flag
        return self
    }

    /// 设置允许的触摸类型（如直接触摸、间接触摸）
    /// - Parameter types: 触摸类型数组（使用 `UITouch.TouchType` 的 rawValue）
    /// - Returns: `Self`
    @discardableResult
    func allowedTouchTypes(_ types: [NSNumber]) -> Self {
        base.allowedTouchTypes = types
        return self
    }

    /// 设置允许的按压类型（用于 tvOS 或外接键盘）
    /// - Parameter types: 按压类型数组
    /// - Returns: `Self`
    @discardableResult
    func allowedPressTypes(_ types: [NSNumber]) -> Self {
        base.allowedPressTypes = types
        return self
    }

    /// 设置是否要求独占触摸类型
    /// - Parameter flag: 若为 true，则仅当所有触摸匹配指定类型时才触发
    /// - Returns: `Self`
    @discardableResult
    func requiresExclusiveTouchType(_ flag: Bool) -> Self {
        base.requiresExclusiveTouchType = flag
        return self
    }

    /// 设置手势识别器的名称（用于调试或无障碍）
    /// - Parameter name: 名称字符串
    /// - Returns: `Self`
    @discardableResult
    func name(_ name: String?) -> Self {
        base.name = name
        return self
    }
}

// MARK: - 方法
public extension DyWrapper where Base: UIGestureRecognizer {
    /// 添加`target-action`
    /// - Parameters:
    ///   - target: 响应对象
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func addTarget(_ target: Any, action: Selector) -> Self {
        base.addTarget(target, action: action)
        return self
    }

    /// 移除`target-action`
    /// - Parameters:
    ///   - target: 响应对象
    ///   - action: 方法选择器
    /// - Returns: `Self`
    @discardableResult
    func removeTarget(_ target: Any?, action: Selector?) -> Self {
        base.removeTarget(target, action: action)
        return self
    }

    /// 设置当前手势必须在另一个手势失败后才能识别
    /// - Parameter otherGestureRecognizer: 被依赖的手势识别器
    /// - Returns: `Self`
    @discardableResult
    func require(toFail otherGestureRecognizer: UIGestureRecognizer) -> Self {
        base.require(toFail: otherGestureRecognizer)
        return self
    }
}

// MARK: - 自定义
public extension DyWrapper where Base: UIGestureRecognizer {
    /// 将手势识别器添加到指定视图
    /// - Parameter view: 目标视图
    /// - Returns: `Self`
    @discardableResult
    func add2(_ view: UIView) -> Self {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(self.base)
        return self
    }

    /// 从当前视图中移除该手势识别器
    /// - Returns: `Self`
    @discardableResult
    func removeGestureRecognizer() -> Self {
        base.view?.removeGestureRecognizer(self.base)
        return self
    }

    /// 设置手势识别成功(`.recognized`)时的回调
    /// - Parameter block: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func onRecognized(_ block: @escaping (UIGestureRecognizer) -> Void) -> Self {
        base.recognizedBlock = block
        self.removeTarget(self.base, action: #selector(UIGestureRecognizer.stateChangeHandler))
        self.addTarget(self.base, action: #selector(UIGestureRecognizer.stateChangeHandler))
        return self
    }

    /// 监听手势状态变化(如 `began`, `changed`, `ended` 等)
    /// - Parameter block: 回调闭包
    /// - Returns: `Self`
    @discardableResult
    func onStateChanged(_ block: @escaping (UIGestureRecognizer.State) -> Void) -> Self {
        base.stateChangedBlock = block
        self.removeTarget(self.base, action: #selector(UIGestureRecognizer.stateChangeHandler))
        self.addTarget(self.base, action: #selector(UIGestureRecognizer.stateChangeHandler))
        return self
    }
}
