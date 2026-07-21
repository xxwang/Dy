import HealthKit

// MARK: - 数值提取
public extension HKStatistics {
    /// 获取总和的数值(需指定与数据匹配的单位)
    ///
    /// - Parameter unit: 与统计类型一致的单位(如步数用 `.count()`,距离用 `.meter()`)
    /// - Returns: 总和数值,若无数据或单位不兼容则返回 `nil`
    func dy_totalValue(for unit: HKUnit) -> Double? {
        guard let quantity = sumQuantity() else { return nil }
        return quantity.doubleValue(for: unit)
    }

    /// 获取平均值的数值(需指定与数据匹配的单位)
    ///
    /// - Parameter unit: 与统计类型一致的单位
    /// - Returns: 平均值,若无数据或单位不兼容则返回 `nil`
    func dy_averageValue(for unit: HKUnit) -> Double? {
        guard let quantity = averageQuantity() else { return nil }
        return quantity.doubleValue(for: unit)
    }
}
