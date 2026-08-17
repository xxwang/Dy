import UIKit

// MARK: - 链式属性
public extension SoloWrapper where Base: UIActivityViewController {
    /// 设置完整的排除类型列表(覆盖原有值)
    ///
    /// - Parameter types: 要排除的类型数组
    /// - Returns: `Self`
    @discardableResult
    func excludedActivityTypes(_ types: [UIActivity.ActivityType]) -> Self {
        base.excludedActivityTypes = types
        return self
    }

    /// 设置分享完成后的完整回调(包含返回项和错误)
    ///
    /// - Parameter handler: 完整的 `CompletionWithItemsHandler`
    /// - Returns: `Self`
    @discardableResult
    func completionWithItemsHandler(
        _ handler: @escaping UIActivityViewController.CompletionWithItemsHandler
    ) -> Self {
        base.completionWithItemsHandler = handler
        return self
    }

    /// 设置是否允许系统将某个活动提升为“突出活动”(显示在顶部区域)
    /// 默认为 `true`
    ///
    /// - Parameter allows: 是否允许突出显示
    /// - Returns: `Self`
    @available(iOS 15.4, *)
    @discardableResult
    func allowsProminentActivity(_ allows: Bool) -> Self {
        base.allowsProminentActivity = allows
        return self
    }

    /// 隐藏指定的活动分区(如联系人建议区域)
    ///
    /// - Parameter sections: 要隐藏的分区类型(`UIActivitySectionTypes`)
    /// - Returns: `Self`
    @available(iOS 18.0, *)
    @discardableResult
    func excludedActivitySectionTypes(_ sections: UIActivitySectionTypes) -> Self {
        base.excludedActivitySectionTypes = sections
        return self
    }
}
