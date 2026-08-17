import MapKit

// MARK: - 注册与复用
public extension SoloWrapper where Base: MKMapView {
    /// 注册自定义注解视图类,使用类名作为重用标识符
    ///
    /// - Parameter annotationViewClass: 继承自 `MKAnnotationView` 的类型
    ///
    /// - Returns: `Self`
    ///
    /// - Example:
    ///   ```swift
    ///   mapView.solo.register(annotationViewWithClass: CustomPinView.self)
    @discardableResult
    func register<T: MKAnnotationView>(annotationViewWithClass annotationViewClass: T.Type) -> Self {
        base.register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: T.self))
        return self
    }
}
