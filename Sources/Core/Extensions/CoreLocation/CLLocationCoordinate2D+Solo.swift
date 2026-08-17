import CoreLocation

extension CLLocationCoordinate2D: SoloExtension {}

// MARK: - 方法
public extension SoloWrapper where Base == CLLocationCoordinate2D {
    /// 将当前坐标转换为 `CLLocation` 实例
    ///
    /// - Returns: 对应的 `CLLocation` 对象(无海拔、速度等附加信息)
    ///
    /// - Example:
    ///   ```swift
    ///   let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let location = coordinate.solo.toLocation()
    ///   print("纬度: \(location.coordinate.latitude), 经度: \(location.coordinate.longitude)")
    ///   ```
    func toLocation() -> CLLocation {
        CLLocation(latitude: base.latitude, longitude: base.longitude)
    }

    /// 计算当前坐标与另一个坐标之间的`大圆距离`(地球表面最短距离)
    ///
    /// - 使用 `CLLocation.distance(from:)` 实现,基于 WGS-84 椭球模型
    /// - 单位：`米(meters)`
    /// - 精度适用于大多数地理应用(如导航、附近搜索)
    ///
    /// - Parameter other: 目标坐标
    /// - Returns: 两点间的距离(单位：米)
    ///
    /// - Example:
    ///   ```swift
    ///   let sanFrancisco = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
    ///   let losAngeles = CLLocationCoordinate2D(latitude: 34.0522, longitude: -118.2437)
    ///   let distanceInMeters = sanFrancisco.solo.distance(to: losAngeles)
    ///   print("距离: \(distanceInMeters) 米") // 约 558,000 米
    ///   ```
    func distance(to other: CLLocationCoordinate2D) -> CLLocationDistance {
        self.toLocation().distance(from: other.solo.toLocation())
    }
}
