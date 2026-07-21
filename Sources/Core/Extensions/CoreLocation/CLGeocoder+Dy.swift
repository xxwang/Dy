import CoreLocation

// MARK: - 方法
public extension CLGeocoder {
    /// 反向地理编码：将经纬度转换为地址信息
    ///
    /// - Parameters:
    ///   - location: 要反编码的位置
    ///   - completionHandler: 回调,返回 placemarks 或 error
    ///
    /// - 注意：
    ///   - 结果语言由系统区域设置决定,无法通过 API 强制指定
    ///   - 不要复用 CLGeocoder 实例,每次调用应新建
    ///
    /// - Example:HealthKit
    ///   ```swift
    ///   let loc = CLLocation(latitude: 39.9042, longitude: 116.4074)
    ///   CLGeocoder.dy_reverseGeocodeLocation(loc) { marks, error in
    ///       if let name = marks?.first?.name {
    ///           print("地点: \(name)")
    ///       }
    ///   }
    ///   ```
    static func dy_reverseGeocodeLocation(
        _ location: CLLocation,
        completionHandler: @escaping CLGeocodeCompletionHandler
    ) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: completionHandler)
    }

    /// 地理编码：将地址字符串转换为经纬度
    ///
    /// - Parameters:
    ///   - addressString: 地址文本(建议包含城市和国家以提高精度)
    ///   - completionHandler: 回调
    ///
    /// - Example:
    ///   ```swift
    ///   CLGeocoder.dy_geocodeAddressString("北京市") { marks, error in
    ///       if let coord = marks?.first?.location?.coordinate {
    ///           print("坐标: \(coord.latitude), \(coord.longitude)")
    ///       }
    ///   }
    ///   ```
    static func dy_geocodeAddressString(
        _ addressString: String,
        completionHandler: @escaping CLGeocodeCompletionHandler
    ) {
        CLGeocoder().geocodeAddressString(addressString, completionHandler: completionHandler)
    }
}
