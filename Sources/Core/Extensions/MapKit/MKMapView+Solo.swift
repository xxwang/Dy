import MapKit

// MARK: - 复用
public extension MKMapView {
    /// 尝试从重用队列中获取指定类型的注解视图(无关联注解)
    ///
    /// - Returns: 可重用视图,若无可重用项则返回 `nil`
    /// - Note: 适用于动态创建视图的场景,但通常应使用带 `for:` 的版本
    func solo_dequeueReusableAnnotationView<T: MKAnnotationView>(withClass annotationViewClass: T.Type) -> T? {
        self.dequeueReusableAnnotationView(withIdentifier: String(describing: T.self)) as? T
    }

    /// 从重用队列中获取指定类型的注解视图,并绑定到给定注解
    ///
    /// - Important: 必须先通过 `register(annotationViewWithClass:)` 注册该类,
    ///   否则会触发运行时崩溃
    ///
    /// - Returns: 非空的注解视图实例
    ///
    /// - Example(在 `mapView(_:viewFor:)` 中使用):
    ///   ```swift
    ///   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    ///       guard !(annotation is MKUserLocation) else { return nil }
    ///       return mapView.solo_dequeueReusableAnnotationView(withClass: CustomPinView.self, for: annotation)
    ///   }
    ///   ```
    func solo_dequeueReusableAnnotationView<T: MKAnnotationView>(
        withClass annotationViewClass: T.Type,
        for annotation: MKAnnotation
    ) -> T {
        // 强制转换是安全的,前提是已正确注册
        guard let view = self.dequeueReusableAnnotationView(
            withIdentifier: String(describing: T.self),
            for: annotation
        ) as? T else {
            assertionFailure("Failed to dequeue annotation view of type \(T.self). Did you forget to register it?")
            return T(annotation: annotation, reuseIdentifier: String(describing: T.self))
        }
        return view
    }
}

// MARK: - 缩放控制
public extension MKMapView {
    /// 缩放地图以显示一组坐标,并添加指定边距
    ///
    /// - Parameters:
    ///   - coordinates: 要包含的地理坐标数组
    ///   - meter: 单点时的可视范围半径(单位：米)
    ///   - edgePadding: 地图边缘留白
    ///   - animated: 是否启用动画
    ///
    /// - Note:
    ///   - 若仅有一个点,使用 `MKCoordinateRegion` 以米为单位设置范围
    ///   - 若有多个点,使用 `MKPolygon.boundingMapRect` 计算包围矩形
    ///   - `不支持跨越国际日期变更线(±180°)的坐标集合`
    func solo_zoom(
        to coordinates: [CLLocationCoordinate2D],
        meter: Double,
        edgePadding: UIEdgeInsets = .zero,
        animated: Bool = true
    ) {
        guard !coordinates.isEmpty else { return }

        if coordinates.count == 1 {
            let region = MKCoordinateRegion(
                center: coordinates[0],
                latitudinalMeters: meter,
                longitudinalMeters: meter
            )
            self.setRegion(region, animated: animated)
        } else {
            // 使用 MKPolygon 自动计算 boundingMapRect
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            self.setVisibleMapRect(polygon.boundingMapRect, edgePadding: edgePadding, animated: animated)
        }
    }

    /// 缩放地图至指定地理区域
    ///
    /// - Parameters:
    ///   - region: 目标区域
    ///   - edgePadding: 边缘留白
    ///   - animated: 是否启用动画
    ///
    /// - Note: 依赖 `MKMapRect.regionToMapRect(_:)` 扩展(需确保已实现)
    func solo_zoom(to region: MKCoordinateRegion, edgePadding: UIEdgeInsets = .zero, animated: Bool = true) {
        let mapRect = MKMapRect.solo_regionToMapRect(region)
        self.setVisibleMapRect(mapRect, edgePadding: edgePadding, animated: animated)
    }
}

// MARK: - 工具方法
public extension MKMapView {
    /// 添加多个注解,可选择是否先清除现有注解
    func solo_addAnnotations(_ annotations: [MKAnnotation], clearExisting: Bool = false) {
        if clearExisting {
            self.removeAnnotations(self.annotations)
        }
        self.addAnnotations(annotations)
    }

    /// 将视图中的点转换为地理坐标
    func solo_convertPointToCoordinate(_ point: CGPoint) -> CLLocationCoordinate2D {
        self.convert(point, toCoordinateFrom: self)
    }

    /// 将地理坐标转换为视图中的点
    func solo_convertCoordinateToPoint(_ coordinate: CLLocationCoordinate2D) -> CGPoint {
        self.convert(coordinate, toPointTo: self)
    }

    /// 判断某坐标是否在当前可见地图区域内
    func solo_isCoordinateVisible(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let mapPoint = MKMapPoint(coordinate)
        return self.visibleMapRect.contains(mapPoint)
    }
}
