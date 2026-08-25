import MapKit

// MARK: - 构造方法
public extension MKPolyline {
    /// 使用 `CLLocationCoordinate2D` 数组创建一条折线(polyline)
    ///
    /// 此便利构造器简化了 `MKPolyline` 的初始化过程,无需手动处理指针和计数
    /// 内部会将坐标数组复制到 C 风格缓冲区,并传递给原生初始化方法
    ///
    /// - Note: 创建后,`MKPolyline` 持有坐标的独立副本,后续修改原数组不会影响折线
    ///
    /// - Parameter coordinates: 由地理坐标组成的非空数组若为空,将创建一条无效(无点)的折线
    ///
    /// - Example:
    ///   ```swift
    ///   let coords = [
    ///       CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074), // 北京
    ///       CLLocationCoordinate2D(latitude: 31.2304, longitude: 121.4737)  // 上海
    ///   ]
    ///   let route = MKPolyline(coordinates: coords)
    ///   mapView.addOverlay(route)
    ///   ```
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        var mutableCoordinates = coordinates
        self.init(coordinates: &mutableCoordinates, count: mutableCoordinates.count)
    }
}
