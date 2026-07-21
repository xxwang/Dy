import HealthKit

// MARK: - 判断活动目标完成状态
public extension HKActivitySummary {
    /// 是否已完成当日站立小时目标
    ///
    /// - Returns: `true` 表示已达成站立目标(≥ 目标小时数);否则为 `false`
    /// - Note: 若目标或实际值缺失,返回 `false`
    var dy_hasCompletedStandHoursGoal: Bool {
        return self.appleStandHoursGoal.compare(self.appleStandHours) != .orderedDescending
    }

    /// 是否已完成当日锻炼分钟目标
    ///
    /// - Returns: `true` 表示已达成锻炼时间目标(≥ 目标分钟数);否则为 `false`
    /// - Note: 若目标或实际值缺失,返回 `false`
    var dy_hasCompletedExerciseMinutesGoal: Bool {
        return self.appleExerciseTimeGoal.compare(self.appleExerciseTime) != .orderedDescending
    }

    /// 是否已完成当日活动能量(千卡)目标
    ///
    /// - Returns: `true` 表示已达成活动能量目标(≥ 目标千卡数);否则为 `false`
    /// - Note: 若目标或实际值缺失,返回 `false`
    var dy_hasCompletedActiveEnergyGoal: Bool {
        return self.activeEnergyBurnedGoal.compare(self.activeEnergyBurned) != .orderedDescending
    }
}
