import HealthKit

// MARK: - 数据保存
public extension HKHealthStore {
    /// 将健康数据样本同步保存到 HealthKit
    ///
    /// 此方法是对 `save(_:withCompletion:)` 的轻量封装,便于统一命名和调用
    ///
    /// - Parameters:
    ///   - sample: 要保存的健康数据样本(例如 `HKQuantitySample`)
    ///   - completion: 保存完成后的回调`success` 表示是否成功,`error` 包含失败原因(如有)
    func dy_saveSample(_ sample: HKSample, completion: @escaping DyAction2<Bool, Error?>) {
        save(sample, withCompletion: completion)
    }
}

// MARK: - 步数相关操作
public extension HKHealthStore {
    /// 监听新步数样本的写入事件(例如来自 iPhone 或 Apple Watch 的新记录)
    ///
    /// 此方法使用 `HKObserverQuery` 监听步数类型的写入,并在触发时获取`最新一条步数样本`
    /// 同时启用了后台交付(需在 `Info.plist` 中启用 `healthkit` background mode)
    ///
    /// - Important: 调用方必须持有返回的 `HKObserverQuery` 实例,并在不再需要监听时调用 `stop(_:)`,
    ///   否则可能导致内存泄漏或不必要的资源消耗
    ///
    /// - Parameter handler: 回调函数,返回最新步数样本(可能为 `nil`)或错误
    /// - Returns: 返回创建的 `HKObserverQuery` 实例,用于后续停止监听
    @discardableResult
    func dy_startStepSampleUpdates(
        handler: @escaping DyAction2<HKQuantitySample?, Error?>
    ) -> HKObserverQuery {
        // 获取步数类型,若不可用则立即失败
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            DispatchQueue.main.async {
                handler(nil, HKError(.errorInvalidArgument))
            }
            fatalError("步数类型不可用,通常不会发生")
        }

        // 创建观察者查询
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { [weak self] _, _, error in
            if let error {
                handler(nil, error)
                return
            }

            // 查询最新的一条步数样本(按时间倒序)
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let sampleQuery = HKSampleQuery(
                sampleType: stepType,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                let latestSample = samples?.first as? HKQuantitySample
                handler(latestSample, error)
            }

            self?.execute(sampleQuery)
        }

        // 执行查询
        execute(query)

        // 启用后台数据交付(即时模式)
        enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
            if !success {
                print("⚠️ 后台步数交付启用失败: \(error?.localizedDescription ?? "未知错误")")
            }
        }
        return query
    }

    /// 获取当日累计步数(从当天 00:00 至当前时间)
    ///
    /// 使用 `HKStatisticsQuery` 计算指定时间范围内的步数总和,适用于展示“今日步数”等场景
    ///
    /// - Parameter completion: 回调函数,返回当日总步数(`Int`)或错误
    ///   若无数据或查询失败,返回 `nil`
    func dy_fetchTodayStepCount(completion: @escaping DyAction2<Int?, Error?>) {
        guard let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, HKError(.errorInvalidArgument))
            return
        }

        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictEndDate)

        let statisticsQuery = HKStatisticsQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, error in
            if let error {
                completion(nil, error)
                return
            }

            guard let result else {
                completion(nil, NSError(domain: "HealthKit", code: -1, userInfo: [NSLocalizedDescriptionKey: "统计结果为空"]))
                return
            }

            // 步数单位为 count()
            let totalSteps = result.sumQuantity()?.doubleValue(for: .count()) ?? 0
            completion(Int(totalSteps), nil)
        }

        execute(statisticsQuery)
    }
}

// MARK: - 通用健康数据查询
public extension HKHealthStore {
    /// 通用方法：查询指定类型的健康数据样本
    ///
    /// 支持自定义谓词、数量限制和排序方式,适用于大多数读取场景
    ///
    /// - Parameters:
    ///   - type: 要查询的样本类型(如步数、心率等)
    ///   - predicate: 查询条件(可为 `nil` 表示无过滤)
    ///   - limit: 最大返回样本数(默认无限制)
    ///   - sortDescriptors: 排序规则(默认按开始时间降序,即最新在前)
    ///   - completion: 查询完成回调,返回样本数组或错误
    func dy_querySamples(
        ofType type: HKSampleType,
        predicate: NSPredicate? = nil,
        limit: Int = HKObjectQueryNoLimit,
        sortDescriptors: [NSSortDescriptor]? = [
            NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false),
        ],
        completion: @escaping DyAction2<[HKSample]?, Error?>
    ) {
        let query = HKSampleQuery(
            sampleType: type,
            predicate: predicate,
            limit: limit,
            sortDescriptors: sortDescriptors
        ) { _, results, error in
            completion(results, error)
        }

        execute(query)
    }
}
