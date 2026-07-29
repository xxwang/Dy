import QuartzCore
import UIKit

// MARK: - 方法
public extension CALayer {
    /// 将图层内容转为颜色 (`UIColor`)
    /// - Returns: 返回转换的颜色,如果失败则返回`nil`
    func dy_toUIColor() -> UIColor? {
        if let image = self.dy_toUIImage() {
            return UIColor(patternImage: image)
        }
        return nil
    }

    /// 将`CALayer`转换为`UIImage?`
    /// - Parameters:
    ///   - scale: 缩放比例,默认值为当前屏幕的scale,通常与设备的屏幕密度相匹配
    /// - Returns: 返回转换后的`UIImage`,如果失败则返回`nil`
    func dy_toUIImage(scale: CGFloat = DyScreen.screenScale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, scale)
        defer { UIGraphicsEndImageContext() }

        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        self.render(in: ctx)

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

// MARK: - 链式设置属性
public extension CALayer {
    /// 设置图层的 frame(位置与尺寸)
    /// - Parameter frame: 新的 frame
    /// - Returns: `Self`
    @discardableResult
    func dy_frame(_ frame: CGRect) -> Self {
        self.frame = frame
        return self
    }

    /// 设置背景颜色
    /// - Parameter color: 背景色;传 `nil` 可清除背景
    /// - Returns: `Self`
    @discardableResult
    func dy_backgroundColor(_ color: UIColor?) -> Self {
        self.backgroundColor = color?.cgColor
        return self
    }

    /// 设置是否隐藏图层
    /// - Parameter isHidden: `true` 隐藏,`false` 显示
    /// - Returns: `Self`
    @discardableResult
    func dy_isHidden(_ isHidden: Bool) -> Self {
        self.isHidden = isHidden
        return self
    }

    /// 设置透明度(0.0 ～ 1.0)
    /// - Parameter opacity: 透明度值
    /// - Returns: `Self`
    @discardableResult
    func dy_opacity(_ opacity: Float) -> Self {
        self.opacity = opacity
        return self
    }

    /// 设置边框宽度
    /// - Parameter width: 边框宽度(≥ 0)
    /// - Returns: `Self`
    @discardableResult
    func dy_borderWidth(_ width: CGFloat) -> Self {
        self.borderWidth = max(width, 0)
        return self
    }

    /// 设置边框颜色
    /// - Parameter color: 边框颜色;传 `nil` 可清除边框
    /// - Returns: `Self`
    @discardableResult
    func dy_borderColor(_ color: UIColor?) -> Self {
        self.borderColor = color?.cgColor
        return self
    }

    /// 设置是否裁剪子图层超出边界的内容
    /// - Parameter masksToBounds: `true` 裁剪,`false` 不裁剪(默认)
    /// - Returns: `Self`
    @discardableResult
    func dy_masksToBounds(_ masksToBounds: Bool = true) -> Self {
        self.masksToBounds = masksToBounds
        return self
    }

    /// 设置统一圆角半径
    /// - Parameter cornerRadius: 圆角半径
    /// - Returns: `Self`
    @discardableResult
    func dy_cornerRadius(_ cornerRadius: CGFloat) -> Self {
        self.cornerRadius = max(cornerRadius, 0)
        return self
    }

    /// 设置要圆角化的角
    /// - Parameter corners: 要圆角化的角
    /// - Returns: `Self`
    @discardableResult
    func dy_maskedCorners(_ maskedCorners: CACornerMask) -> Self {
        self.maskedCorners = maskedCorners
        return self
    }

    /// 设置指定角的圆角(iOS 11+ 高效实现,旧版本自动降级)
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 要圆角化的角(如 `.topLeft`, `.bottomRight` 等)
    /// - Returns: `Self`
    /// - Important: 在 iOS < 11 时,此方法依赖 `bounds` 已确定若图层尺寸后续变化,
    ///   需手动重新调用或自行管理 mask 更新
    @discardableResult
    func dy_roundedCorners(_ radius: CGFloat, corners: CACornerMask) -> Self {
        self.cornerRadius = max(radius, 0)
        self.maskedCorners = corners
        return self
    }

    /// 设置阴影颜色
    /// - Parameter color: 阴影颜色;传 `nil` 可清除阴影
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowColor(_ color: UIColor?) -> Self {
        self.shadowColor = color?.cgColor
        return self
    }

    /// 设置阴影透明度(0.0 ～ 1.0)
    /// - Parameter opacity: 阴影不透明度
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowOpacity(_ opacity: Float) -> Self {
        self.shadowOpacity = min(max(opacity, 0), 1)
        return self
    }

    /// 设置阴影偏移量
    /// - Parameter offset: 偏移(正 x 向右,正 y 向下)
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowOffset(_ offset: CGSize) -> Self {
        self.shadowOffset = offset
        return self
    }

    /// 设置阴影模糊半径
    /// - Parameter radius: 模糊半径(≥ 0)
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowRadius(_ radius: CGFloat) -> Self {
        self.shadowRadius = max(radius, 0)
        return self
    }

    /// 设置阴影路径(提升性能,避免离屏渲染)
    /// - Parameter path: 自定义阴影轮廓路径
    /// - Returns: `Self`
    @discardableResult
    func dy_shadowPath(_ path: CGPath) -> Self {
        self.shadowPath = path
        return self
    }

    /// 快速启用/禁用阴影(透明度设为 0.5 或 0)
    /// - Parameter hasShadow: 是否显示阴影
    /// - Returns: `Self`
    /// - Note: 此方法会覆盖 `shadowOpacity`,如需自定义透明度请直接使用 `shadowOpacity`
    @discardableResult
    func dy_showShadow(_ hasShadow: Bool) -> Self {
        self.shadowOpacity = hasShadow ? 0.5 : 0
        return self
    }

    /// 启用或禁用光栅化(将图层预渲染为位图)
    /// - Parameter shouldRasterize: 是否启用光栅化
    /// - Returns: `Self`
    /// - Important: 启用后建议调用 `dy_rasterizationScale(DyScreen.screenScale)` 以适配 Retina 屏幕
    @discardableResult
    func dy_shouldRasterize(_ shouldRasterize: Bool) -> Self {
        self.shouldRasterize = shouldRasterize
        return self
    }

    /// 设置光栅化缩放比例(通常等于屏幕 scale)
    /// - Parameter scale: 缩放因子(如 `DyScreen.screenScale`)
    /// - Returns: `Self`
    @discardableResult
    func dy_rasterizationScale(_ scale: CGFloat) -> Self {
        self.rasterizationScale = max(scale, 1)
        return self
    }

    /// 将当前图层添加到指定 UIView 的 layer 中
    /// - Parameter view: 目标视图
    /// - Returns: `Self`
    @discardableResult
    func dy_add2(_ view: UIView) -> Self {
        view.layer.addSublayer(self)
        return self
    }

    /// 将当前图层添加到指定 CALayer 中
    /// - Parameter layer: 目标图层
    /// - Returns: `Self`
    @discardableResult
    func dy_add2(_ layer: CALayer) -> Self {
        layer.addSublayer(self)
        return self
    }

    /// 相对旋转图层(绕 Z 轴)
    /// - Parameter angle: 旋转角度(弧度)正值为顺时针
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`如需绝对旋转,请重置 transform 后再设置
    @discardableResult
    func dy_rotate(by angle: CGFloat) -> Self {
        self.transform = CATransform3DRotate(self.transform, angle, 0, 0, 1)
        return self
    }

    /// 相对缩放图层(等比缩放 X/Y 轴)
    /// - Parameter scale: 缩放因子(>1 放大,<1 缩小)
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`
    @discardableResult
    func dy_scale(by scale: CGFloat) -> Self {
        self.transform = CATransform3DScale(self.transform, scale, scale, 1)
        return self
    }

    /// 相对平移图层
    /// - Parameter translation: 平移向量(x: 水平, y: 垂直)
    /// - Returns: `Self`
    /// - Note: 此为`累积变换`
    @discardableResult
    func dy_translate(by translation: CGPoint) -> Self {
        self.transform = CATransform3DTranslate(self.transform, translation.x, translation.y, 0)
        return self
    }

    /// 设置遮罩图层
    /// - Parameter mask: 用作遮罩的图层(仅 alpha 通道生效)
    /// - Returns: `Self`
    @discardableResult
    func dy_mask(_ mask: CALayer) -> Self {
        self.mask = mask
        return self
    }
}
