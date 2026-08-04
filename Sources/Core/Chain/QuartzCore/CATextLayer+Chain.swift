import QuartzCore
import UIKit

// MARK: - 属性
public extension DyWrapper where Base: CATextLayer {
    /// 设置显示的文本内容
    /// - Parameter string: 要显示的字符串(支持 `NSAttributedString`,但此处仅设为 `String`)
    /// - Returns: `Self`
    @discardableResult
    func string(_ string: String) -> Self {
        base.string = string
        return self
    }

    /// 设置是否自动换行
    /// - Parameter isWrapped: `true` 启用自动换行;`false` 单行显示(默认)
    /// - Note: 当 `isWrapped = false` 时,`truncationMode` 才会生效
    /// - Returns: `Self`
    @discardableResult
    func isWrapped(_ isWrapped: Bool) -> Self {
        base.isWrapped = isWrapped
        return self
    }

    /// 设置文本截断模式(仅在 `isWrapped = false` 时有效)
    /// - Parameter truncationMode: 截断方式,如 `.end`(末尾...)、`.middle` 等
    /// - Returns: `Self`
    @discardableResult
    func truncationMode(_ truncationMode: CATextLayerTruncationMode) -> Self {
        base.truncationMode = truncationMode
        return self
    }

    /// 设置文本对齐方式
    /// - Parameter alignmentMode: 对齐模式
    ///   - `.natural`: 自然对齐(根据语言方向)
    ///   - `.left` / `.right` / `.center`: 左/右/居中
    ///   - `.justified`: 两端对齐(需多行)
    /// - Returns: `Self`
    @discardableResult
    func alignmentMode(_ alignmentMode: CATextLayerAlignmentMode) -> Self {
        base.alignmentMode = alignmentMode
        return self
    }

    /// 设置文本前景色(使用 `UIColor`)
    /// - Parameter foregroundColor: 文字颜色
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ foregroundColor: UIColor) -> Self {
        base.foregroundColor = foregroundColor.cgColor
        return self
    }

    /// 设置文本前景色(使用 `CGColor`)
    /// - Parameter foregroundColor: 文字颜色
    /// - Returns: `Self`
    @discardableResult
    func foregroundColor(_ foregroundColor: CGColor) -> Self {
        base.foregroundColor = foregroundColor
        return self
    }

    /// 设置内容缩放比例,用于适配 Retina 屏幕
    /// - Parameter scale: 缩放因子,默认为当前主屏幕缩放比例
    /// - Important: 若不设置,高分辨率屏幕可能出现模糊
    /// - Returns: `Self`
    @discardableResult
    func contentsScale(_ scale: CGFloat = DyScreen.screenScale) -> Self {
        base.contentsScale = scale
        return self
    }

    /// 设置字体(使用 `UIFont`)
    /// - Parameter font: 字体对象
    /// - Note: 内部转换为 `CTFont`若字体名无效,将 fallback 到系统默认字体
    /// - Returns: `Self`
    @discardableResult
    func font(_ font: UIFont) -> Self {
        base.font = CTFontCreateWithName(font.fontName as CFString, font.pointSize, nil)
        return self
    }

    /// 设置字体大小(不改变字体族)
    /// - Parameter fontSize: 字号(单位：point)
    /// - Returns: `Self`
    @discardableResult
    func fontSize(_ fontSize: CGFloat) -> Self {
        base.fontSize = fontSize
        return self
    }

    /// 一次性设置阴影效果
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - opacity: 不透明度(0.0 ～ 1.0)
    ///   - offset: 偏移量(正数表示向右/下偏移)
    ///   - radius: 模糊半径(越大越模糊)
    /// - Returns: `Self`
    @discardableResult
    func shadow(color: UIColor, opacity: Float, offset: CGSize, radius: CGFloat) -> Self {
        base.shadowColor = color.cgColor
        base.shadowOpacity = min(max(opacity, 0.0), 1.0)
        base.shadowOffset = offset
        base.shadowRadius = max(radius, 0)
        return self
    }

    /// 通过扩大 `frame` 来模拟内边距效果
    /// - Parameter insets: 内边距(正值表示文字区域向内缩进)
    /// - Important: 此方法会修改 `frame`,确保父容器足够大
    ///   例如：`insets = .init(top: 10, left: 10, bottom: 10, right: 10)`
    ///   会导致 `frame` 扩大 20pt(宽高各 +20)
    /// - Returns: `Self`
    @discardableResult
    func padding(by insets: UIEdgeInsets) -> Self {
        // 扩大 frame 以容纳 padding
        let newFrame = CGRect(
            x: base.frame.origin.x - insets.left,
            y: base.frame.origin.y - insets.top,
            width: base.frame.width + insets.left + insets.right,
            height: base.frame.height + insets.top + insets.bottom
        )
        base.frame = newFrame
        return self
    }
}
