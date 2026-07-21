import UIKit

// MARK: - 属性
@MainActor
public extension DyWrapper where Base: UIProgressView {
    /// 设置当前进度值
    ///
    /// - Parameter progress: 进度值,建议范围 `0.0` ～ `1.0`
    /// - Returns: `Self`
    @discardableResult
    func progress(_ progress: Float) -> Self {
        base.progress = progress
        return self
    }

    /// 设置进度视图的预定义样式
    ///
    /// - Parameter style: 样式类型(如 `.default`, `.bar`)
    /// - Returns: `Self`
    @discardableResult
    func progressViewStyle(_ style: UIProgressView.Style) -> Self {
        base.progressViewStyle = style
        return self
    }

    /// 设置已填充部分(进度条)的颜色
    ///
    /// - Parameter color: 进度条颜色,传入 `nil` 使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func progressTintColor(_ color: UIColor?) -> Self {
        base.progressTintColor = color
        return self
    }

    /// 设置背景轨道(未填充部分)的颜色
    ///
    /// - Parameter color: 轨道颜色,传入 `nil` 使用系统默认色
    /// - Returns: `Self`
    @discardableResult
    func trackTintColor(_ color: UIColor?) -> Self {
        base.trackTintColor = color
        return self
    }

    /// 设置自定义进度条图像(替代默认着色矩形)
    ///
    /// - Parameter image: 自定义图像,传入 `nil` 恢复默认样式
    /// - Returns: `Self`
    @discardableResult
    func progressImage(_ image: UIImage?) -> Self {
        base.progressImage = image
        return self
    }

    /// 设置自定义背景轨道图像
    ///
    /// - Parameter image: 自定义轨道图像,传入 `nil` 恢复默认样式
    /// - Returns: `Self`
    @discardableResult
    func trackImage(_ image: UIImage?) -> Self {
        base.trackImage = image
        return self
    }
}
