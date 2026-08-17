import CoreLocation

// MARK: - 方法
public extension SoloWrapper where Base == CLVisit {
    /// 将当前访问记录(`CLVisit`)转换为 `CLLocation` 实例
    ///
    /// - 使用 `coordinate` 作为位置
    /// - 使用 `arrivalDate` 作为时间戳(`timestamp`)
    /// - 海拔、速度等属性设为默认值(因 `CLVisit` 不提供这些信息)
    ///
    /// 此转换便于复用基于 `CLLocation` 的工具方法(如距离计算)
    ///
    /// - Returns: 对应的 `CLLocation` 对象
    ///
    /// - Example:
    ///   ```swift
    ///   func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
    ///       let location = visit.solo.toLocation()
    ///       print("访问位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    ///       print("到达时间: \(location.timestamp)")
    ///   }
    ///   ```
    func toLocation() -> CLLocation {
        CLLocation(
            coordinate: base.coordinate,
            altitude: 0, // CLVisit 不提供 altitude
            horizontalAccuracy: base.horizontalAccuracy,
            verticalAccuracy: -1, // CLVisit 无 verticalAccuracy,设为无效值
            course: -1, // 无效值
            speed: -1, // 无效值
            timestamp: base.arrivalDate
        )
    }
}
