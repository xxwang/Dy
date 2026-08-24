import CoreLocation
import Foundation

// MARK: - 地理计算
public extension CLLocation {
    /// 计算当前地点与目标地点之间的大圆距离,并以指定单位返回
    ///
    /// - 使用 `CLLocation.distance(from:)` 内部实现,基于 WGS-84 椭球模型
    /// - 支持任意 `UnitLength` 单位(如 `.meters`, `.kilometers`, `.miles`)
    ///
    /// - Parameters:
    ///   - to: 目标位置
    ///   - unit: 返回距离的单位,默认为 `.meters`
    /// - Returns: 包含数值和单位的 `Measurement<UnitLength>` 对象
    ///
    /// - Example:
    ///   ```swift
    ///   let sf = CLLocation(latitude: 37.7749, longitude: -122.4194)
    ///   let la = CLLocation(latitude: 34.0522, longitude: -118.2437)
    ///   let distance = sf.solo_distance(to: la, unit: .kilometers)
    ///   print("距离: \(distance.value) \(distance.unit.symbol)") // e.g. "559.23 km"
    ///   ```
    func solo_distance(to location: CLLocation, unit: UnitLength = .meters) -> Measurement<UnitLength> {
        let meters = self.distance(from: location)
        return Measurement(value: meters, unit: .meters).converted(to: unit)
    }

    /// 计算两点间大圆路径的中点(球面中点)
    ///
    /// - 适用于地球表面两点间的几何中心估算
    /// - 结果是一个新的 `CLLocation`,时间戳为默认值(无实际时间意义)
    ///
    /// - Parameter to: 目标位置
    /// - Returns: 大圆路径的中点坐标
    ///
    /// - Note: 当两点重合或对跖点(antipodal)时,结果可能不稳定
    ///
    /// - Example:
    ///   ```swift
    ///   let midpoint = sf.solo_midPoint(to: la)
    ///   print("中点: \(midpoint.coordinate.latitude), \(midpoint.coordinate.longitude)")
    ///   ```
    func solo_midPoint(to destination: CLLocation) -> CLLocation {
        let lat1 = self.coordinate.latitude.solo_radians()
        let lon1 = self.coordinate.longitude.solo_radians()
        let lat2 = destination.coordinate.latitude.solo_radians()
        let lon2 = destination.coordinate.longitude.solo_radians()

        let deltaLon = lon2 - lon1

        let bx = cos(lat2) * cos(deltaLon)
        let by = cos(lat2) * sin(deltaLon)

        let lat3 = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + by * by))
        let lon3 = lon1 + atan2(by, cos(lat1) + bx)

        return CLLocation(
            latitude: lat3.solo_degrees(),
            longitude: lon3.solo_degrees()
        )
    }

    /// 计算从当前位置到目标位置的`初始方位角`(forward azimuth)
    ///
    /// - 方位角以正北为 0°,顺时针增加,范围 `[0, 360)` 度
    /// - 基于球面三角学,适用于导航、AR 指南针等场景
    ///
    /// - Parameter to: 目标位置
    /// - Returns: 方位角(单位：度)
    ///
    /// - Example:
    ///   ```swift
    ///   let bearing = sf.solo_bearing(to: la) // ≈ 135.0°(东南方向)
    ///   print("方位角: \(bearing)°")
    ///   ```
    func solo_bearing(to target: CLLocation) -> Double {
        let lat1 = self.coordinate.latitude.solo_radians()
        let lon1 = self.coordinate.longitude.solo_radians()
        let lat2 = target.coordinate.latitude.solo_radians()
        let lon2 = target.coordinate.longitude.solo_radians()

        let deltaLon = lon2 - lon1

        let y = sin(deltaLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)

        var bearing = atan2(y, x).solo_degrees()
        bearing = (bearing + 360).truncatingRemainder(dividingBy: 360)
        return bearing
    }

    /// 判断当前位置是否在目标位置的指定半径范围内
    ///
    /// - 使用大圆距离进行比较
    /// - 半径单位为`米`
    ///
    /// - Parameters:
    ///   - radius: 最大允许距离(单位：米)
    ///   - of: 目标位置
    /// - Returns: 若距离 ≤ 半径,返回 `true`;否则 `false`
    ///
    /// - Example:
    ///   ```swift
    ///   let near = sf.solo_isWithin(radius: 1000, of: la) // false
    ///   ```
    func solo_isWithin(radius: Double, of location: CLLocation) -> Bool {
        self.distance(from: location) <= radius
    }

    /// 获取以当前位置为中心、给定半径(米)的`正方形边界四个角点`
    ///
    /// - 用于地图可视区域、地理围栏预筛选等
    /// - 假设地球为球体(使用平均半径 6371 km)
    ///
    /// - ⚠️ `限制`：
    ///   - 在纬度 > 85° 或 < -85° 时精度显著下降(因经度收敛)
    ///   - 不适用于跨越极点或国际日期变更线的大范围区域
    ///
    /// - Parameter radius: 半径(单位：米)
    /// - Returns: 四个角点 `[topLeft, topRight, bottomLeft, bottomRight]`
    ///
    /// - Example:
    ///   ```swift
    ///   let bounds = sf.solo_boundaryCoordinates(radius: 1000) // 1km 范围
    ///   ```
    func solo_boundaryCoordinates(radius: Double) -> [CLLocationCoordinate2D] {
        let lat = self.coordinate.latitude
        let lon = self.coordinate.longitude

        // 防止极地附近 cos(lat) ≈ 0 导致除零或过大 deltaLon
        let clampedLat = min(max(lat, -85.0), 85.0)
        let latRad = clampedLat.solo_radians()

        let earthRadiusMeters = 6371000.0
        let deltaLat = radius / earthRadiusMeters * (180 / .pi)
        let deltaLon = radius / (earthRadiusMeters * cos(latRad)) * (180 / .pi)

        let topLeft = CLLocationCoordinate2D(latitude: lat + deltaLat, longitude: lon - deltaLon)
        let topRight = CLLocationCoordinate2D(latitude: lat + deltaLat, longitude: lon + deltaLon)
        let bottomLeft = CLLocationCoordinate2D(latitude: lat - deltaLat, longitude: lon - deltaLon)
        let bottomRight = CLLocationCoordinate2D(latitude: lat - deltaLat, longitude: lon + deltaLon)

        return [topLeft, topRight, bottomLeft, bottomRight]
    }
}

// MARK: - Array<CLLocation> 轨迹分析
public extension [CLLocation] {
    /// 计算位置序列的累计路径长度(考虑地球曲率)
    ///
    /// - 依次计算相邻点间的大圆距离并累加
    /// - 空数组或单点返回 0
    ///
    /// - Parameter unit: 返回单位,默认为 `.meters`
    /// - Returns: 总路径长度(`Measurement<UnitLength>`)
    ///
    /// - Example:
    ///   ```swift
    ///   let track = [pointA, pointB, pointC]
    ///   let total = track.solo_distance(unit: .kilometers)
    ///   print("总里程: \(total.value) km")
    ///   ```
    func solo_distance(unit: UnitLength = .meters) -> Measurement<UnitLength> {
        guard self.count > 1 else { return Measurement(value: 0, unit: unit) }

        var totalMeters: CLLocationDistance = 0
        for i in 0 ..< self.count - 1 {
            totalMeters += self[i].distance(from: self[i + 1])
        }

        return Measurement(value: totalMeters, unit: .meters).converted(to: unit)
    }
}
