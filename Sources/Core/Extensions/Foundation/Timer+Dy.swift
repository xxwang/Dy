import Foundation

// MARK: - 定时器创建与调度
public extension Timer {
    /// 在主线程 `RunLoop` 中创建并自动调度的定时器
    ///
    /// - Warning: `RunLoop.main` 强持有 timer，timer 强引用 `block`。
    ///   若 `repeats: true` 且 block 内使用 `self`，必须使用 `[weak self]`
    ///   并配合手动调用 `invalidate()` 停止，否则会造成永久泄漏。
    /// - Parameters:
    ///   - mode: `RunLoop` 模式，默认为 `.common`（兼容滚动、拖拽等场景）
    ///   - timeInterval: 触发间隔（秒），必须大于 0
    ///   - repeats: 是否重复执行
    ///   - block: 回调闭包，传入当前 `Timer` 实例
    /// - Returns: 已添加到 `RunLoop.main` 的 `Timer` 实例
    /// - Note: 必须在主线程调用；使用后需手动调用 `invalidate()` 或通过 `pause()`/`resume()` 管理生命周期
    @discardableResult
    static func dy_scheduled(
        in mode: RunLoop.Mode = .common,
        timeInterval: TimeInterval,
        repeats: Bool,
        block: @escaping DyAction1<Timer>
    ) -> Timer {
        let timer = Timer(timeInterval: timeInterval, repeats: repeats, block: block)
        RunLoop.main.add(timer, forMode: mode)
        return timer
    }

    /// 执行一次性的延迟任务
    ///
    /// - Parameters:
    ///   - delay: 延迟时间（秒），必须 ≥ 0
    ///   - block: 延迟后执行的无参闭包
    /// - Note: 内部使用 `.common` 模式，确保在主线程执行；无需手动管理 timer 生命周期
    static func dy_after(_ delay: TimeInterval, block: @escaping DyAction) {
        // ⚠️ 必须持有 timer 引用，否则可能被提前释放
        let timer = dy_scheduled(timeInterval: delay, repeats: false) { _ in
            block()
        }
        // 无需外部持有，timer 在触发后自动失效
        _ = timer
    }

    /// 创建一个倒计时定时器，按指定间隔回调剩余时间，结束后执行完成回调
    ///
    /// - Parameters:
    ///   - duration: 总时长（秒），必须 > 0
    ///   - interval: 倒计时间隔（秒），默认为 1.0
    ///   - tick: 每次倒计时触发的回调，传入当前剩余时间（> 0）
    ///   - completion: 倒计时结束（剩余时间 ≤ 0）时的回调
    /// - Returns: 用于控制或取消倒计时的 `Timer` 实例
    /// - Precondition: `duration > 0`
    /// - Note: 所有回调均在主线程执行；倒计时基于实际经过时间，避免累积误差
    @discardableResult
    static func dy_countdown(
        from duration: TimeInterval,
        interval: TimeInterval = 1.0,
        tick: @escaping DyAction1<TimeInterval>,
        completion: @escaping DyAction
    ) -> Timer {
        precondition(duration > 0, "Duration must be positive")
        precondition(interval > 0, "Interval must be positive")

        let startTime = Date()
        let endTime = startTime.addingTimeInterval(duration)

        return dy_scheduled(timeInterval: interval, repeats: true) { timer in
            let now = Date()
            let remaining = endTime.timeIntervalSince(now)

            if remaining > 0 {
                tick(remaining)
            } else {
                completion()
                timer.invalidate()
            }
        }
    }
}

// MARK: - 定时器控制
public extension Timer {
    /// 暂停定时器
    ///
    /// - Note: 仅对有效（`isValid == true`）的定时器生效；通过设置 `fireDate` 为遥远未来实现暂停
    func dy_pause() {
        guard isValid else { return }
        fireDate = .distantFuture
    }

    /// 立即恢复已暂停的定时器
    ///
    /// - Note: 仅对有效定时器生效；恢复后将在下一个周期触发
    func dy_resume() {
        guard isValid else { return }
        fireDate = Date()
    }

    /// 延迟一段时间后恢复定时器
    ///
    /// - Parameter delay: 延迟时间（秒），必须 ≥ 0
    /// - Note: 仅对有效定时器生效
    func dy_resume(after delay: TimeInterval) {
        guard isValid else { return }
        fireDate = Date().addingTimeInterval(delay)
    }
}

// MARK: - 链式方法
public extension Timer {
    /// 设置运行模式
    /// - Parameter mode: 运行模式
    /// - Returns: `Self`
    @discardableResult
    func dy_mode(_ mode: RunLoop.Mode) -> Self {
        RunLoop.current.add(self, forMode: mode)
        return self
    }

    /// 立即启动
    /// - Returns: `Self`
    @discardableResult
    func dy_fire() -> Self {
        self.fire()
        return self
    }
}
