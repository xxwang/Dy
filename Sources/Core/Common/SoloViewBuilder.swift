import UIKit

@resultBuilder
public struct SoloViewBuilder {
    /// 构建多个子视图(基本用法)
    public static func buildBlock(_ components: UIView...) -> [UIView] {
        components
    }

    /// 支持空闭包(无子视图)
    public static func buildBlock() -> [UIView] {
        []
    }

    /// 支持可选视图(`if` 条件)
    public static func buildOptional(_ component: [UIView]?) -> [UIView] {
        component ?? []
    }

    /// 支持 `if-else` 分支(`true` 分支)
    public static func buildEither(first component: [UIView]) -> [UIView] {
        component
    }

    /// 支持 `if-else `分支(`false` 分支)
    public static func buildEither(second component: [UIView]) -> [UIView] {
        component
    }

    /// 支持 `for-in `循环
    public static func buildArray(_ components: [[UIView]]) -> [UIView] {
        components.flatMap(\.self)
    }
}

// MARK: - UIView
public extension UIView {
    /// 使用 `SoloViewBuilder` 声明式地添加子视图
    ///
    /// - Parameter configure: 可选的配置闭包,在添加子视图后调用(可用于设置约束等)
    /// - Parameter content: 视图构建器闭包,返回一组子视图
    ///
    /// - Example:
    /// ```swift
    /// let container = UIView {
    ///     UILabel()
    ///     UIButton(type: .system)
    ///     if showImage {
    ///         UIImageView(image: UIImage(systemName: "star"))
    ///     }
    /// } configure: {
    ///     $0.backgroundColor = .systemBackground
    /// }
    /// ```
    convenience init(
        @SoloViewBuilder content: () -> [UIView],
        configure: SoloAction1<UIView>? = nil
    ) {
        self.init()

        // 添加子视图
        let subviews = content()
        for subview in subviews {
            // 默认关闭 autoresizing mask(推荐使用 Auto Layout)
            subview.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(subview)
        }

        // 可选的额外配置(如背景色、约束等)
        configure?(self)
    }
}
