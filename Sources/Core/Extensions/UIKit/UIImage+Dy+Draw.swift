import UIKit

// MARK: - 圆角纯色图片绘制
public extension DyWrapper where Base: UIImage {
    /// 创建一个指定尺寸、背景色和圆角的纯色图片,可选添加边框
    ///
    /// 此方法适用于生成头像占位图、按钮背景等场景
    ///
    /// - Parameters:
    ///   - size: 图片尺寸若宽度或高度 ≤ 0,则返回空图片
    ///   - bgColor: 背景填充颜色,不可为透明色(但允许)
    ///   - cornerRadii: 每个圆角的半径(宽高可不同)
    ///   - corners: 需要应用圆角的角,默认为 `.allCorners`
    ///   - borderColor: 边框颜色若为 `nil` 或 `borderWidth ≤ 0`,则不绘制边框
    ///   - borderWidth: 边框宽度必须 > 0 才会绘制边框
    /// - Returns: 生成的 `UIImage` 实例;若输入无效则返回空图片
    static func drawRoundedImage(
        size: CGSize,
        bgColor: UIColor,
        cornerRadii: CGSize,
        corners: UIRectCorner = .allCorners,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat = 0
    ) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let rect = CGRect(origin: .zero, size: size)

            // 绘制圆角背景
            let backgroundPath = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: cornerRadii
            )
            bgColor.setFill()
            backgroundPath.fill()

            // 绘制边框(如果需要)
            if let borderColor, borderWidth > 0 {
                backgroundPath.lineWidth = borderWidth
                borderColor.setStroke()
                backgroundPath.stroke()
            }
        }
    }
}

// MARK: - 基础形状图标绘制
public extension DyWrapper where Base: UIImage {
    /// 箭头方向枚举,用于控制箭头或三角形的朝向
    enum DyArrowDirection: Int, CaseIterable {
        case up = 0 // < 向上
        case down = 1 // < 向下
        case left = 2 // < 向左
        case right = 3 // < 向右
    }

    /// 绘制一个由三条线段组成的箭头图标(开放式路径,仅描边)
    ///
    /// - Parameters:
    ///   - size: 图标尺寸若任一维度 ≤ 0,返回空图片
    ///   - color: 箭头线条颜色
    ///   - lineWidth: 线条宽度,建议 ≥ 1
    ///   - direction: 箭头指向方向
    /// - Returns: 渲染后的箭头图片
    static func drawArrow(
        size: CGSize,
        color: UIColor,
        lineWidth: CGFloat,
        direction: DyArrowDirection
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.lineJoinStyle = .round

            let halfWidth = size.width / 2
            let halfHeight = size.height / 2
            let margin = max(lineWidth / 2, 0)

            switch direction {
            case .up:
                path.move(to: CGPoint(x: halfWidth, y: margin))
                path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
                path.addLine(to: CGPoint(x: margin, y: size.height - margin))
            case .down:
                path.move(to: CGPoint(x: margin, y: margin))
                path.addLine(to: CGPoint(x: size.width - margin, y: margin))
                path.addLine(to: CGPoint(x: halfWidth, y: size.height - margin))
            case .left:
                path.move(to: CGPoint(x: margin, y: halfHeight))
                path.addLine(to: CGPoint(x: size.width - margin, y: margin))
                path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
            case .right:
                path.move(to: CGPoint(x: size.width - margin, y: halfHeight))
                path.addLine(to: CGPoint(x: margin, y: margin))
                path.addLine(to: CGPoint(x: margin, y: size.height - margin))
            }

            color.setStroke()
            path.stroke()
        }
    }

    /// 绘制一个实心三角形图标
    ///
    /// - Parameters:
    ///   - size: 图标尺寸若任一维度 ≤ 0,返回空图片
    ///   - fillColor: 填充颜色
    ///   - direction: 三角形尖角方向
    /// - Returns: 渲染后的三角形图片
    static func drawTriangle(
        size: CGSize,
        fillColor: UIColor,
        direction: DyArrowDirection
    ) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath()

            switch direction {
            case .up:
                path.move(to: CGPoint(x: size.width / 2, y: 0))
                path.addLine(to: CGPoint(x: 0, y: size.height))
                path.addLine(to: CGPoint(x: size.width, y: size.height))
            case .down:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size.width, y: 0))
                path.addLine(to: CGPoint(x: size.width / 2, y: size.height))
            case .left:
                path.move(to: CGPoint(x: 0, y: size.height / 2))
                path.addLine(to: CGPoint(x: size.width, y: 0))
                path.addLine(to: CGPoint(x: size.width, y: size.height))
            case .right:
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
                path.addLine(to: CGPoint(x: 0, y: size.height))
            }

            path.close()
            fillColor.setFill()
            path.fill()
        }
    }

    /// 绘制一个带圆角边框的对勾(✓)图标
    ///
    /// - Parameters:
    ///   - size: 图标整体尺寸
    ///   - fillColor: 对勾颜色
    ///   - lineWidth: 对勾线条宽度
    ///   - insets: 对勾相对于图标的内边距
    ///   - cornerRadii: 边框圆角半径
    ///   - corners: 应用圆角的角
    ///   - borderColor: 边框颜色(可选)
    ///   - borderWidth: 边框宽度(≤0 则不绘制)
    /// - Returns: 渲染后的对勾图标
    static func drawCheckmark(
        size: CGSize,
        fillColor: UIColor,
        lineWidth: CGFloat,
        insets: UIEdgeInsets,
        cornerRadii: CGSize,
        corners: UIRectCorner,
        borderColor: UIColor?,
        borderWidth: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0 else {
            return UIImage()
        }

        // 安全处理 insets：确保内容区域有效
        let contentWidth = max(size.width - insets.left - insets.right, 0)
        let contentHeight = max(size.height - insets.top - insets.bottom, 0)
        guard contentWidth > 0, contentHeight > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let rect = CGRect(origin: .zero, size: size)

            // 绘制可选边框
            if let borderColor, borderWidth > 0 {
                let borderPath = UIBezierPath(
                    roundedRect: rect,
                    byRoundingCorners: corners,
                    cornerRadii: cornerRadii
                )
                borderColor.setFill()
                borderPath.fill()

                // 内部裁剪区域(避免边框覆盖内容)
                let innerRect = rect.insetBy(dx: borderWidth, dy: borderWidth)
                let clipPath = UIBezierPath(
                    roundedRect: innerRect,
                    byRoundingCorners: corners,
                    cornerRadii: CGSize(
                        width: max(cornerRadii.width - borderWidth, 0),
                        height: max(cornerRadii.height - borderWidth, 0)
                    )
                )
                clipPath.addClip()
            }

            // 绘制对勾
            let checkRect = CGRect(
                x: insets.left,
                y: insets.top,
                width: contentWidth,
                height: contentHeight
            )

            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.lineJoinStyle = .round

            let spacing = max(lineWidth / 2, 0)
            let startPoint = CGPoint(x: checkRect.minX + spacing, y: checkRect.midY)
            let midPoint = CGPoint(x: checkRect.midX - spacing, y: checkRect.maxY - spacing)
            let endPoint = CGPoint(x: checkRect.maxX - spacing, y: checkRect.minY + spacing)

            path.move(to: startPoint)
            path.addLine(to: midPoint)
            path.addLine(to: endPoint)

            fillColor.setStroke()
            path.stroke()
        }
    }

    /// 绘制一个叉号(✕)图标
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - lineColor: 线条颜色
    ///   - lineWidth: 线条宽度
    /// - Returns: 渲染后的叉号图片
    static func drawCross(
        size: CGSize,
        lineColor: UIColor,
        lineWidth: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round

            let margin = max(lineWidth / 2, 0)
            path.move(to: CGPoint(x: margin, y: margin))
            path.addLine(to: CGPoint(x: size.width - margin, y: size.height - margin))
            path.move(to: CGPoint(x: size.width - margin, y: margin))
            path.addLine(to: CGPoint(x: margin, y: size.height - margin))

            lineColor.setStroke()
            path.stroke()
        }
    }

    /// 绘制一个加号(＋)图标
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - lineColor: 线条颜色
    ///   - lineWidth: 线条宽度
    /// - Returns: 渲染后的加号图片
    static func drawPlus(
        size: CGSize,
        lineColor: UIColor,
        lineWidth: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round

            let margin = max(lineWidth / 2, 0)
            let centerX = size.width / 2
            let centerY = size.height / 2

            path.move(to: CGPoint(x: margin, y: centerY))
            path.addLine(to: CGPoint(x: size.width - margin, y: centerY))
            path.move(to: CGPoint(x: centerX, y: margin))
            path.addLine(to: CGPoint(x: centerX, y: size.height - margin))

            lineColor.setStroke()
            path.stroke()
        }
    }

    /// 绘制一个空心圆
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - lineColor: 圆环颜色
    ///   - lineWidth: 圆环线宽
    /// - Returns: 渲染后的空心圆图片
    static func drawCircle(
        size: CGSize,
        lineColor: UIColor,
        lineWidth: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let diameter = min(size.width, size.height) - lineWidth
            guard diameter > 0 else {
                return
            }
            let rect = CGRect(
                x: (size.width - diameter) / 2,
                y: (size.height - diameter) / 2,
                width: diameter,
                height: diameter
            )

            let path = UIBezierPath(ovalIn: rect)
            path.lineWidth = lineWidth
            lineColor.setStroke()
            path.stroke()
        }
    }

    /// 绘制一个实心圆
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - color: 填充颜色
    ///   - insets: 内边距,默认为 `.zero`
    /// - Returns: 渲染后的实心圆图片
    static func drawSolidCircle(
        size: CGSize,
        color: UIColor,
        insets: UIEdgeInsets = .zero
    ) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        let contentWidth = max(size.width - insets.left - insets.right, 0)
        let contentHeight = max(size.height - insets.top - insets.bottom, 0)
        guard contentWidth > 0, contentHeight > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let rect = CGRect(
                x: insets.left,
                y: insets.top,
                width: contentWidth,
                height: contentHeight
            )
            let path = UIBezierPath(ovalIn: rect)
            color.setFill()
            path.fill()
        }
    }

    /// 绘制双圆选择按钮样式：外圈空心,内圈实心
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - lineColor: 外圈和内圈颜色(通常一致)
    ///   - lineWidth: 外圈线宽
    ///   - innerSpacing: 内圈与外圈之间的间距(≥0)
    /// - Returns: 渲染后的双圆图标
    static func drawDoubleCircle(
        size: CGSize,
        lineColor: UIColor,
        lineWidth: CGFloat,
        innerSpacing: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, lineWidth >= 0, innerSpacing >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            // 外圆
            let outerDiameter = min(size.width, size.height) - lineWidth
            guard outerDiameter > 0 else { return }
            let outerRect = CGRect(
                x: (size.width - outerDiameter) / 2,
                y: (size.height - outerDiameter) / 2,
                width: outerDiameter,
                height: outerDiameter
            )
            let outerPath = UIBezierPath(ovalIn: outerRect)
            outerPath.lineWidth = lineWidth
            lineColor.setStroke()
            outerPath.stroke()

            // 内圆
            let innerDiameter = max(outerDiameter - 2 * innerSpacing, 0)
            guard innerDiameter > 0 else { return }
            let innerRect = CGRect(
                x: (size.width - innerDiameter) / 2,
                y: (size.height - innerDiameter) / 2,
                width: innerDiameter,
                height: innerDiameter
            )
            let innerPath = UIBezierPath(ovalIn: innerRect)
            lineColor.setFill()
            innerPath.fill()
        }
    }

    /// 绘制两个同心实心圆(常用于状态指示器)
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - outerColor: 外圆颜色
    ///   - innerColor: 内圆颜色
    ///   - spacing: 内圆与外圆之间的间距(≥0)
    /// - Returns: 渲染后的双实心圆图片
    static func drawDoubleSolidCircle(
        size: CGSize,
        outerColor: UIColor,
        innerColor: UIColor,
        spacing: CGFloat
    ) -> UIImage {
        guard size.width > 0, size.height > 0, spacing >= 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            // 外圆
            let outerRect = CGRect(origin: .zero, size: size)
            let outerPath = UIBezierPath(ovalIn: outerRect)
            outerColor.setFill()
            outerPath.fill()

            // 内圆
            let innerSize = CGSize(
                width: max(size.width - 2 * spacing, 0),
                height: max(size.height - 2 * spacing, 0)
            )
            guard innerSize.width > 0, innerSize.height > 0 else { return }
            let innerRect = CGRect(
                x: spacing,
                y: spacing,
                width: innerSize.width,
                height: innerSize.height
            )
            let innerPath = UIBezierPath(ovalIn: innerRect)
            innerColor.setFill()
            innerPath.fill()
        }
    }

    /// 绘制一个五角星(实心填充)
    ///
    /// - Parameters:
    ///   - size: 图标尺寸
    ///   - color: 填充颜色
    /// - Returns: 渲染后的五角星图片
    static func drawStar(
        size: CGSize,
        color: UIColor
    ) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 * 0.9 // 留一点边距
            let path = UIBezierPath()

            // 五角星顶点角度：72° 间隔,从顶部开始
            for i in 0 ..< 5 {
                let angle = CGFloat(i) * (2 * .pi / 5) - .pi / 2
                let x = center.x + cos(angle) * radius
                let y = center.y + sin(angle) * radius
                if i == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            path.close()
            color.setFill()
            path.fill()
        }
    }
}

// MARK: - 多图合成
public extension DyWrapper where Base: UIImage {
    /// 更类型安全的多图合成方法(推荐使用)
    ///
    /// - Parameters:
    ///   - size: 画布尺寸
    ///   - items: 要绘制的图层列表
    /// - Returns: 合成后的图片
    struct DyDrawItem {
        let image: UIImage
        let rect: CGRect
    }

    /// 将多个图片按指定位置绘制到一个画布上
    ///
    /// - Important: 推荐使用 `[DrawItem]` 结构体替代字典,但为兼容现有接口保留此版本
    ///              若需类型安全,请考虑新增基于结构体的重载方法
    ///
    /// - Parameters:
    ///   - size: 画布尺寸
    ///   - images: 图片信息数组,每个元素为字典,必须包含：
    ///             - `"image"`: `UIImage`
    ///             - `"rect"`: `CGRect`
    /// - Returns: 合成后的图片;若尺寸无效或无有效图层,返回空图片
    static func drawImages(size: CGSize, images: [[String: Any]]) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            for item in images {
                guard
                    let image = item["image"] as? UIImage,
                    let rect = item["rect"] as? CGRect
                else {
                    continue
                }
                image.draw(in: rect)
            }
        }
    }

    /// 将多个图片按指定位置绘制到一个画布上(类型安全版本)
    ///
    /// - Parameters:
    ///   - size: 画布尺寸
    ///   - items: 图片与位置的组合列表
    /// - Returns: 合成后的图片
    static func drawImages(size: CGSize, items: [DyDrawItem]) -> UIImage {
        guard size.width > 0, size.height > 0 else {
            return UIImage()
        }

        return UIGraphicsImageRenderer(size: size).image { _ in
            for item in items {
                item.image.draw(in: item.rect)
            }
        }
    }
}
