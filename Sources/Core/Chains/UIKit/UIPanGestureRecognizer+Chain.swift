import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIPanGestureRecognizer {
    /// 设置触发平移手势所需的最少触摸点数
    /// - Parameter count: 最小触摸数量，默认为 1
    /// - Returns: `Self`
    @discardableResult
    func minimumNumberOfTouches(_ count: Int) -> Self {
        base.minimumNumberOfTouches = count
        return self
    }

    /// 设置触发平移手势允许的最大触摸点数
    /// - Parameter count: 最大触摸数量，默认为 UINT_MAX（即无上限）
    /// - Returns: `Self`
    @discardableResult
    func maximumNumberOfTouches(_ count: Int) -> Self {
        base.maximumNumberOfTouches = count
        return self
    }

    /// 设置允许的滚动类型掩码（如惯性滚动、直接拖拽等）
    /// - Parameter mask: 滚动类型组合掩码
    /// - Returns: `Self`
    @discardableResult
    func allowedScrollTypesMask(_ mask: UIScrollTypeMask) -> Self {
        base.allowedScrollTypesMask = mask
        return self
    }
}

// MARK: - 方法
@MainActor
public extension DyWrapper where Base: UIPanGestureRecognizer {
    /// 设置当前平移偏移量（通常用于重置手势状态）
    /// - Parameters:
    ///   - translation: 平移向量（相对于起始点）
    ///   - view: 参考坐标系的视图，传 nil 表示使用窗口坐标系
    /// - Returns: `Self`
    @discardableResult
    func setTranslation(_ translation: CGPoint, in view: UIView?) -> Self {
        base.setTranslation(translation, in: view)
        return self
    }
}
