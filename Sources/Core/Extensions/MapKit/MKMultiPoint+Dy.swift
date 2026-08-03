import MapKit

// MARK: - 属性
public extension DyWrapper where Base: MKMultiPoint {
    /// 获取多点对象(如 `MKPolyline`、`MKPolygon`)中包含的所有地理坐标
    ///
    /// 此属性将底层 C 数组安全地转换为 Swift 的 `[CLLocationCoordinate2D]` 数组,
    /// 适用于遍历、计算中心点、导出轨迹等场景
    ///
    /// - Returns: 坐标数组若无任何点,返回空数组
    ///
    /// - Note:
    ///   - 返回的是`副本`,修改此数组不会影响原 `MKMultiPoint` 对象
    ///   - 坐标顺序与原始数据一致(例如 polyline 的路径顺序)
    ///
    /// - Example:
    ///   ```swift
    ///   let polyline = MKPolyline(coordinates: myCoords)
    ///   let allCoords = polyline.dy.coordinates
    ///   print("共有 \(allCoords.count) 个点")
    ///   ```
    var coordinates: [CLLocationCoordinate2D] {
        let count = base.pointCount
        guard count > 0 else { return [] }

        // 创建一个可变数组,用无效坐标占位(会被完全覆盖)
        var coordinates = [CLLocationCoordinate2D](
            repeating: kCLLocationCoordinate2DInvalid,
            count: count
        )

        // ⚠️ 注意：这里必须使用 NSRange,因为 getCoordinates 只接受 NSRange(在 iOS <14)
        let range = NSRange(location: 0, length: count)
        base.getCoordinates(&coordinates, range: range)

        return coordinates
    }
}
