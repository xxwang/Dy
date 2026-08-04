import MapKit

extension MKCoordinateRegion: DyExtension {}

// MARK: - 角点计算
public extension DyWrapper where Base == MKCoordinateRegion {
    /// 获取当前区域的左上角地理坐标(最大纬度,最小经度)
    ///
    /// - Note:
    ///   - 假设区域不跨越国际日期变更线(±180° 经度)
    ///   - 不适用于极地附近(纬度 > 85°)的高精度场景
    var topLeftCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: base.center.latitude + base.span.latitudeDelta / 2,
            longitude: base.center.longitude - base.span.longitudeDelta / 2
        )
    }

    /// 获取当前区域的右下角地理坐标(最小纬度,最大经度)
    ///
    /// - Note: 同 `topLeftCoordinate`,有相同限制
    var bottomRightCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: base.center.latitude - base.span.latitudeDelta / 2,
            longitude: base.center.longitude + base.span.longitudeDelta / 2
        )
    }
}

// MARK: - 边界
public extension DyWrapper where Base == MKCoordinateRegion {
    /// 计算包含所有坐标的最小 `MKCoordinateRegion`,并添加指定边距
    ///
    /// - Parameters:
    ///   - coordinates: 非空坐标数组
    ///   - margin: 四周额外留白距离(单位：米)默认 100 米
    ///
    /// - Returns: 包含所有点并带有边距的区域
    ///
    /// - Important:
    ///   - `不支持跨越国际日期变更线(±180°)的坐标集合`
    ///   - 若输入为单点,会基于 `margin` 自动创建合理可视区域
    ///   - 边距通过近似地球球面模型转换为经纬度跨度
    ///
    /// - Example:
    ///   ```swift
    ///   let coords = [CLLocationCoordinate2D(latitude: 39.9, longitude: 116.4)]
    ///   let region = MKCoordinateRegion.dy.boundingRegion(for: coords, margin: 500)
    ///   ```
    static func boundingRegion(
        for coordinates: [CLLocationCoordinate2D],
        margin: CLLocationDistance = 100
    ) -> MKCoordinateRegion {
        guard !coordinates.isEmpty else {
            return MKCoordinateRegion()
        }

        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)

        let minLat = latitudes.min() ?? 0
        let maxLat = latitudes.max() ?? 0
        let minLon = longitudes.min() ?? 0
        let maxLon = longitudes.max() ?? 0

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        // 初始 span
        let span = MKCoordinateSpan(
            latitudeDelta: maxLat - minLat,
            longitudeDelta: maxLon - minLon
        )

        // 处理单点或 span 为 0 的情况
        if span.latitudeDelta == 0, span.longitudeDelta == 0 {
            // 单点：使用 margin 反推一个合理 span
            let tempRegion = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            return tempRegion.dy.expanded(by: margin)
        }

        let baseRegion = MKCoordinateRegion(center: center, span: span)
        return baseRegion.dy.expanded(by: margin)
    }

    /// 在当前区域四周扩展指定距离(米)
    ///
    /// - Parameter margin: 扩展距离(单位：米)
    /// - Returns: 扩展后的新区域
    ///
    /// - Note:
    ///   - 使用近似公式：1° 纬度 ≈ 111,000 米
    ///   - 经度缩放考虑纬度余弦(赤道最大,极地趋近于 0)
    ///   - 为避免极点附近数值不稳定,对 `cos(lat)` 设置下限(0.01)
    func expanded(by margin: CLLocationDistance) -> MKCoordinateRegion {
        // 防止在极点附近 cos(lat) → 0 导致 longitudeDelta 爆炸
        let latRadians = base.center.latitude * .pi / 180
        let cosLat = max(cos(latRadians), 0.01) // 下限 0.01 ≈ 纬度 84.26°

        // 将米转换为经纬度跨度
        let deltaLat = margin / 111000.0
        let deltaLon = margin / (111000.0 * cosLat)

        let newSpan = MKCoordinateSpan(
            latitudeDelta: base.span.latitudeDelta + deltaLat,
            longitudeDelta: base.span.longitudeDelta + deltaLon
        )

        return MKCoordinateRegion(center: base.center, span: newSpan)
    }
}
