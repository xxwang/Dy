#if canImport(CoreLocation)
    import CoreLocation

    // MARK: - 地理位置(地址转坐标)
    public extension DyWrapper where Base == String {
        /// 对当前地址字符串执行地理编码(地址 → 坐标)
        ///
        /// - Important: 此方法应在主线程调用,因为 `CLGeocoder` 的回调总是在主线程执行
        /// - Parameter completion: 完成回调,返回 `[CLPlacemark]?` 和 `Error?`
        ///
        /// - Example:
        ///   ```swift
        ///   "1600 Amphitheatre Parkway, Mountain View, CA".dy.geocode { placemarks, error in
        ///       if let coordinate = placemarks?.first?.location?.coordinate {
        ///           print("纬度: \(coordinate.latitude), 经度: \(coordinate.longitude)")
        ///       }
        ///   }
        ///   ```
        func geocode(completion: @escaping (CLGeocodeCompletionHandler)) {
            CLGeocoder().geocodeAddressString(base) { placemarks, error in
                DispatchQueue.main.async {
                    completion(placemarks, error)
                }
            }
        }
    }
#endif
