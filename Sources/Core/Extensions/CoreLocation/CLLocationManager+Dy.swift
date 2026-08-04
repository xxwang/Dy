import CoreLocation

// MARK: - 属性
public extension DyWrapper where Base: CLLocationManager {
    /// 获取当前位置的经纬度(在定位成功之后使用)
    var coordinate: CLLocationCoordinate2D? {
        return base.location?.coordinate
    }
}
