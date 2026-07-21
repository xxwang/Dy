import HealthKit

// MARK: - 属性
public extension HKQuantitySample {
    /// 获取健康数据记录的本地时间字符串
    var dy_formattedStartDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self.startDate)
    }

    /// 获取心率的区间
    var dy_heartRateZone: String {
        let heartRate = self.quantity.doubleValue(for: HKUnit(from: "count/min"))

        switch heartRate {
        case 0 ..< 60:
            return "低"
        case 60 ..< 100:
            return "正常"
        case 100 ..< 140:
            return "轻度运动"
        case 140 ..< 180:
            return "中度运动"
        default:
            return "高强度运动"
        }
    }
}
