import Foundation

public final class DyQueue {
    private var onceTokens: Set<String> = []
    private let onceLock = NSLock()

    public static let shared = DyQueue()
    private init() {}
}

// MARK: - 异步执行
public extension DyQueue {
    /// 在主线程异步执行指定任务
    ///
    /// 适用于从后台线程切换回主线程以更新 UI
    ///
    /// - Parameter task: 要在主线程执行的逃逸闭包
    ///
    /// - Example:
    ///   ```swift
    ///   DyQueue.shared.asyncOnMain {
    ///       self.statusLabel.text = "加载完成"
    ///   }
    ///   ```
    func asyncOnMain(_ task: @escaping DyAction) {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.main.async(execute: workItem)
    }

    /// 在全局并发队列中异步执行任务
    ///
    /// 使用指定的服务质量（QoS）等级，适合执行非 UI 的后台工作，如网络请求、文件读写或计算密集型任务
    ///
    /// - Parameters:
    ///   - qos: 服务质量等级，默认为 `.default`
    ///     常用值：
    ///       - `.userInitiated`：用户触发的即时任务（如点击按钮后加载数据）
    ///       - `.utility`：长时间运行的实用任务（如下载、导入）
    ///       - `.background`：低优先级后台任务（如日志上传）
    ///   - work: 要在后台执行的逃逸闭包
    ///
    /// - Example:
    ///   ```swift
    ///   DyQueue.shared.asyncOnGlobal(qos: .userInitiated) {
    ///       let data = fetchDataFromDisk()
    ///       DyQueue.shared.asyncOnMain {
    ///           self.updateUI(with: data)
    ///       }
    ///   }
    ///   ```
    func asyncOnGlobal(
        qos: DispatchQoS.QoSClass = .default,
        execute task: @escaping DyAction
    ) {
        let workItem = DispatchWorkItem(block: task)
        DispatchQueue.global(qos: qos).async(execute: workItem)
    }
}

// MARK: - 串行与并发任务组
public extension DyQueue {
    /// 串行执行多个任务，并在全部完成后于主线程回调
    ///
    /// 所有任务按顺序在一个私有串行队列中执行，避免资源竞争完成回调自动切回主线程，便于更新 UI
    ///
    /// - Parameters:
    ///   - tasks: 要顺序执行的任务数组建议使用 `@Sendable` 闭包以符合 Swift 并发模型
    ///   - then: 所有任务完成后在主线程执行的回调闭包
    ///
    /// - Example:
    ///   ```swift
    ///   let tasks: [@Sendable () -> Void] = [
    ///       { print("步骤1：初始化") },
    ///       { Thread.sleep(forTimeInterval: 0.2); print("步骤2：处理数据") }
    ///   ]
    ///   DyQueue.shared.executeSerially(tasks) {
    ///       print("所有串行任务完成，刷新界面")
    ///   }
    ///   ```
    func executeSerially(
        _ tasks: [DyAction],
        then completion: @escaping DyAction
    ) {
        let serialQueue = DispatchQueue(label: "com.dy.serial-task-queue")
        serialQueue.async {
            for task in tasks {
                task()
            }
            self.asyncOnMain(completion)
        }
    }

    /// 并发执行多个任务，并在全部完成后于主线程回调
    ///
    /// 所有任务并行提交到全局队列，利用多核性能加速执行使用 `DispatchGroup` 确保所有任务完成后再通知
    ///
    /// - Parameters:
    ///   - tasks: 要并发执行的任务数组
    ///   - then: 所有任务完成后在主线程执行的回调闭包
    ///
    /// - Example:
    ///   ```swift
    ///   let tasks: [@Sendable () -> Void] = [
    ///       { API.fetchUserProfile() },
    ///       { API.fetchUserSettings() }
    ///   ]
    ///   DyQueue.shared.executeConcurrently(tasks) {
    ///       self.reloadData()
    ///   }
    ///   ```
    func executeConcurrently(
        _ tasks: [DyAction],
        then completion: @escaping DyAction
    ) {
        let group = DispatchGroup()
        for task in tasks {
            group.enter()
            DispatchQueue.global().async {
                task()
                group.leave()
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
}

// MARK: - 定时器
public extension DyQueue {
    /// 创建一个重复触发的定时器（在主线程执行）
    ///
    /// 适合周期性 UI 更新，如倒计时、轮播图、心跳检测等
    /// 返回的 `DispatchSourceTimer` 需要被强引用持有，否则会被释放导致定时器停止
    ///
    /// - Parameters:
    ///   - every: 触发间隔（秒），必须大于 0
    ///   - handler: 每次触发时调用的闭包，传入定时器自身（可用于调用 `cancel()` 停止）
    /// - Returns: 定时器对象（需强引用）
    ///
    /// - Example:
    ///   ```swift
    ///   var timer: DispatchSourceTimer?
    ///   timer = DyQueue.shared.timer(every: 1.0) { _ in
    ///       print("每秒触发一次")
    ///   }
    ///   // 停止定时器：timer?.cancel()
    ///   ```
    @discardableResult
    func timer(
        every interval: TimeInterval,
        handler: @escaping DyAction1<DispatchSourceTimer>
    ) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(queue: .main)
        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler { handler(timer) }
        timer.resume()
        return timer
    }

    /// 创建一个倒计时定时器（固定次数后自动停止）
    ///
    /// 自动在触发指定次数后取消自身，无需手动管理生命周期
    ///
    /// - Parameters:
    ///   - every: 每次触发的间隔时间（秒）
    ///   - times: 总共触发次数，必须大于 0
    ///   - handler: 每次触发时的回调，传入定时器和剩余次数（从 `count - 1` 到 `0`）
    /// - Returns: 定时器对象；若 `times <= 0` 则返回 `nil`
    ///
    /// - Example:
    ///   ```swift
    ///   DyQueue.shared.countdownTimer(every: 1.0, times: 3) { _, remaining in
    ///       print("倒计时: \(remaining + 1)")
    ///       if remaining == 0 {
    ///           print("时间到！")
    ///       }
    ///   }
    ///   // 输出：3, 2, 1, "时间到！"
    ///   ```
    @discardableResult
    func countdownTimer(
        every interval: TimeInterval,
        times count: Int,
        handler: @escaping DyAction2<DispatchSourceTimer, Int>
    ) -> DispatchSourceTimer? {
        guard count > 0 else { return nil }

        let timer = DispatchSource.makeTimerSource(queue: .main)
        var remaining = count

        timer.schedule(deadline: .now(), repeating: interval)
        timer.setEventHandler {
            remaining -= 1
            handler(timer, remaining)
            if remaining <= 0 {
                timer.cancel()
            }
        }
        timer.resume()
        return timer
    }
}

// MARK: - 延迟执行
public extension DyQueue {
    /// 延迟一段时间后，在指定队列执行任务
    ///
    /// 封装 `DispatchQueue.asyncAfter`，提供更灵活的参数控制
    ///
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - on: 执行队列，默认为主队列（`.main`）
    ///   - qos: 服务质量，默认为 `.unspecified`（继承队列默认 QoS）
    ///   - flags: 工作项标志，如 `.barrier`
    ///   - execute: 要延迟执行的任务
    ///
    /// - Example:
    ///   ```swift
    ///   DyQueue.shared.delayed(2.0, on: .main) {
    ///       self.showToast("操作成功")
    ///   }
    ///   ```
    func delayed(
        _ delay: TimeInterval,
        on queue: DispatchQueue = .main,
        qos: DispatchQoS = .unspecified,
        flags: DispatchWorkItemFlags = [],
        execute work: @escaping DyAction
    ) {
        queue.asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }

    /// 在全局队列中延迟执行任务，并在完成后自动回调主线程
    ///
    /// 返回 `DispatchWorkItem`，支持手动取消整个延迟任务（包括回调）
    ///
    /// - Parameters:
    ///   - delay: 延迟时间（秒）
    ///   - execute: 在后台延迟执行的任务
    ///   - then: 任务完成后在主线程执行的可选回调
    /// - Returns: 可取消的工作项（调用 `cancel()` 可终止任务及回调）
    ///
    /// - Example:
    ///   ```swift
    ///   let item = DyQueue.shared.backgroundDelayed(3.0) {
    ///       print("后台任务执行中...")
    ///   } then: {
    ///       print("回到主线程更新 UI")
    ///   }
    ///   // 如需取消：item.cancel()
    ///   ```
    @discardableResult
    func backgroundDelayed(
        _ delay: TimeInterval,
        execute work: @escaping DyAction,
        then completion: DyAction? = nil
    ) -> DispatchWorkItem {
        let workItem = DispatchWorkItem(block: work)
        if let completion {
            workItem.notify(queue: .main, execute: completion)
        }
        DispatchQueue.global().asyncAfter(deadline: .now() + delay, execute: workItem)
        return workItem
    }
}

// MARK: - 防抖 (Debounce)
public extension DyQueue {
    /// 创建一个防抖函数：频繁调用时，只执行最后一次（延迟后）
    ///
    /// 常用于搜索框输入、滚动监听、按钮防连点等场景
    /// 每次调用返回的闭包会自动取消之前未执行的计划任务
    ///
    /// - Parameters:
    ///   - delay: 防抖延迟时间（秒），例如 `0.3` 表示停止调用 0.3 秒后执行
    ///   - on: 执行队列，默认为主队列（适合 UI 操作）
    ///   - execute: 要防抖执行的任务
    /// - Returns: 一个可调用的闭包，每次调用都会重置防抖计时器
    ///
    /// - Example:
    ///   ```swift
    ///   let debouncedSearch = DyQueue.shared.debounced(delay: 0.3) {
    ///       self.performSearch(query: searchBar.text)
    ///   }
    ///   searchBar.onTextChange = { _ in
    ///       debouncedSearch() // 频繁输入，只执行最后一次
    ///   }
    ///   ```
    func debounced(
        delay: TimeInterval,
        on queue: DispatchQueue = .main,
        execute work: @escaping DyAction
    ) -> () -> Void {
        var pendingWorkItem: DispatchWorkItem?
        return {
            pendingWorkItem?.cancel()
            let newWorkItem = DispatchWorkItem(block: work)
            pendingWorkItem = newWorkItem
            queue.asyncAfter(deadline: .now() + delay, execute: newWorkItem)
        }
    }
}

// MARK: - 一次性执行 (Once)
public extension DyQueue {
    /// 确保某段代码在整个程序生命周期内只执行一次（基于 token）
    ///
    /// 适用于初始化、埋点、权限请求等只需执行一次的操作
    ///
    /// ⚠️ 注意：
    /// - `token` 应全局唯一（推荐格式：`"com.yourapp.feature.init"`）
    /// - 内部使用 `Set<String>` 存储已执行 token，token 数量应有限，避免内存无限增长
    /// - 如需大量动态 token，建议改用静态变量或单例控制
    ///
    /// - Parameters:
    ///   - token: 唯一标识符，用于区分不同的一次性任务
    ///   - execute: 要执行的一次性任务
    ///
    /// - Example:
    ///   ```swift
    ///   DyQueue.shared.executeOnce(token: "app.setup.analytics") {
    ///       Analytics.shared.setup()
    ///   }
    ///   ```
    func executeOnce(token: String, execute work: DyAction) {
        onceLock.lock()
        defer { onceLock.unlock() }

        if !onceTokens.contains(token) {
            onceTokens.insert(token)
            work()
        }
    }
}
