import UIKit

// MARK: - 链式设置属性
public extension UIPanGestureRecognizer {
    /// 设置触发平移手势所需的最少触摸点数
    /// - Parameter count: 最小触摸数量，默认为 1
    /// - Returns: `Self`
    @discardableResult
    func dy_minimumNumberOfTouches(_ count: Int) -> Self {
        self.minimumNumberOfTouches = count
        return self
    }

    /// 设置触发平移手势允许的最大触摸点数
    /// - Parameter count: 最大触摸数量，默认为 UINT_MAX（即无上限）
    /// - Returns: `Self`
    @discardableResult
    func dy_maximumNumberOfTouches(_ count: Int) -> Self {
        self.maximumNumberOfTouches = count
        return self
    }

    /// 设置允许的滚动类型掩码（如惯性滚动、直接拖拽等）
    /// - Parameter mask: 滚动类型组合掩码
    /// - Returns: `Self`
    @available(iOS 13.4, *)
    @discardableResult
    func dy_allowedScrollTypesMask(_ mask: UIScrollTypeMask) -> Self {
        self.allowedScrollTypesMask = mask
        return self
    }
}

// MARK: - 链式方法
public extension UIPanGestureRecognizer {
    /// 设置当前平移偏移量（通常用于重置手势状态）
    /// - Parameters:
    ///   - translation: 平移向量（相对于起始点）
    ///   - view: 参考坐标系的视图，传 nil 表示使用窗口坐标系
    /// - Returns: `Self`
    @discardableResult
    func dy_setTranslation(_ translation: CGPoint, in view: UIView?) -> Self {
        self.setTranslation(translation, in: view)
        return self
    }
}
