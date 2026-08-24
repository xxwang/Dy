import CoreLocation

// MARK: - 属性
public extension CLLocationManager {
    /// 获取当前位置的经纬度(在定位成功之后使用)
    var solo_coordinate: CLLocationCoordinate2D? {
        return self.location?.coordinate
    }
}
