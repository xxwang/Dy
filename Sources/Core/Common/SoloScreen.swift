import UIKit

/// 屏幕尺寸信息
/// 因为包含可通过 `setupSketch` 修改的可变静态属性 `sketchSize`，
/// 读写通过 `NSLock` 保护。
public final class SoloScreen {
    private static let lock = NSLock()

    /// 设计稿参考尺寸。读写通过 lock 保护
    public private(set) static var sketchSize: CGSize = .init(width: 375, height: 812)

    /// 配置设计稿尺寸,用于后续的自动适配计算
    /// - Parameter size: 设计稿的逻辑尺寸(单位：`pt`)
    public static func setupSketch(size: CGSize) {
        lock.lock()
        sketchSize = size
        lock.unlock()
    }
}

// MARK: - 屏幕基础几何信息
public extension SoloScreen {
    /// 当前主屏幕的边界,会随设备旋转动态变化
    static var screenBounds: CGRect {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.screen.bounds ?? UIScreen.main.bounds
    }

    /// 当前屏幕尺寸
    static var screenSize: CGSize {
        screenBounds.size
    }

    /// 屏幕宽度
    static var screenWidth: CGFloat {
        screenBounds.width
    }

    /// 屏幕高度
    static var screenHeight: CGFloat {
        screenBounds.height
    }

    /// 屏幕缩放
    static var screenScale: CGFloat {
        let scene = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
        return scene?.screen.scale ?? UIScreen.main.scale
    }
}

// MARK: - 安全区域(Safe Area)信息
public extension SoloScreen {
    /// 当前 `keyWindow` 的安全区域插值
    static var safeAreaInsets: UIEdgeInsets {
        return UIWindow.solo.keyWindow?.safeAreaInsets ?? .zero
    }

    /// 安全区顶部高度(通常为状态栏 + 导航栏下方留白)
    static var safeAreaTop: CGFloat {
        safeAreaInsets.top
    }

    /// 安全区底部高度(通常为 `Home Indicator `或底部留白)
    static var safeAreaBottom: CGFloat {
        safeAreaInsets.bottom
    }

    /// 安全区左侧宽度
    static var safeAreaLeft: CGFloat {
        safeAreaInsets.left
    }

    /// 安全区右侧宽度
    static var safeAreaRight: CGFloat {
        safeAreaInsets.right
    }
}

// MARK: - 状态栏与导航栏高度
public extension SoloScreen {
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        UIWindow.solo.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }

    /// 导航栏高度
    static var navigationBarHeight: CGFloat {
        max(UINavigationBar.appearance().frame.height, 44)
    }

    /// 导航栏总高度 = 状态栏 + 导航栏
    static var navBarTotalHeight: CGFloat {
        statusBarHeight + navigationBarHeight
    }
}

// MARK: - 标签栏(TabBar)高度
public extension SoloScreen {
    /// 标签栏高度
    static var tabBarHeight: CGFloat {
        max(UITabBar.appearance().frame.height, 49)
    }

    /// 标签栏总高度 = 标签栏 + 底部安全区
    static var tabBarTotalHeight: CGFloat {
        tabBarHeight + safeAreaBottom
    }
}

// MARK: - 适配比例计算(基于设计稿)
public extension SoloScreen {
    /// 宽度方向的缩放比例
    /// - Note: 供 `fitWidth` / `fitLarger` / `fitSmaller` 等扩展使用，采用"短边/长边自适应"策略：
    ///   - 竖屏：屏幕短边 / 设计稿短边
    ///   - 横屏：屏幕长边 / 设计稿长边
    ///   即横屏时它实际按"长边"计算，并非字面的宽度比例。如需严格按当前宽度缩放，请用 `screenWidth / sketchSize.width`。
    static var widthRatio: CGFloat {
        let isLandscape = self.screenWidth > self.screenHeight
        lock.lock()
        let sketch = sketchSize
        lock.unlock()

        if isLandscape {
            let sketchLongSide = max(sketch.width, sketch.height)
            let screenLongSide = max(self.screenWidth, self.screenHeight)
            return screenLongSide / sketchLongSide
        } else {
            let sketchShortSide = min(sketch.width, sketch.height)
            let screenShortSide = min(self.screenWidth, self.screenHeight)
            return screenShortSide / sketchShortSide
        }
    }

    /// 高度方向的缩放比例
    static var heightRatio: CGFloat {
        let isLandscape = self.screenWidth > self.screenHeight
        lock.lock()
        let sketch = sketchSize
        lock.unlock()

        if isLandscape {
            let sketchShortSide = min(sketch.width, sketch.height)
            let screenShortSide = min(self.screenWidth, self.screenHeight)
            return screenShortSide / sketchShortSide
        } else {
            let sketchLongSide = max(sketch.width, sketch.height)
            let screenLongSide = max(self.screenWidth, self.screenHeight)
            return screenLongSide / sketchLongSide
        }
    }
}

// MARK: - 屏幕捕获检测
public extension SoloScreen {
    /// 当前是否正在录屏或投屏
    /// iOS 11+ 优先使用 Scene API; 低版本回退到 UIScreen.main
    static var isCaptured: Bool {
        if #available(iOS 11.0, *) {
            let scene = UIApplication.shared.connectedScenes
                .first { $0.activationState == .foregroundActive } as? UIWindowScene
            return scene?.screen.isCaptured ?? false
        }
        return UIScreen.main.isCaptured
    }
}

// MARK: - 内部适配计算方法
private extension SoloScreen {
    /// 根据设计图宽度计算适配后的宽度
    static func calcWidth(from value: Any) -> CGFloat {
        return self.widthRatio * self.anyToCGFloat(from: value)
    }

    /// 根据设计图高度计算适配后的高度
    static func calcHeight(from value: Any) -> CGFloat {
        return self.heightRatio * self.anyToCGFloat(from: value)
    }

    /// 计算适配后的最大值(根据设计图的宽度和高度,选择较大的值
    static func calcMax(from value: Any) -> CGFloat {
        return max(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    /// 计算适配后的最小值(根据设计图的宽度和高度,选择较小的值)
    static func calcMin(from value: Any) -> CGFloat {
        return min(self.calcWidth(from: value), self.calcHeight(from: value))
    }

    /// 将输入的值转换为 `CGFloat` 类型
    static func anyToCGFloat(from value: Any) -> CGFloat {
        if let value = value as? CGFloat {
            return value
        }
        if let value = value as? Double {
            return CGFloat(value)
        }
        if let value = value as? Float {
            return CGFloat(value)
        }
        if let value = value as? Int {
            return CGFloat(value)
        }
        return 0
    }
}

// MARK: - 整数适配扩展
public extension BinaryInteger {
    /// 适配宽度(将整数值按设计图宽度比例适配)
    var fitWidth: CGFloat {
        SoloScreen.calcWidth(from: self)
    }

    /// 适配高度(将整数值按设计图高度比例适配)
    var fitHeight: CGFloat {
        SoloScreen.calcHeight(from: self)
    }

    /// 适配最大值(根据设计图宽度和高度适配后的最大值)
    var fitLarger: CGFloat {
        SoloScreen.calcMax(from: self)
    }

    /// 适配最小值(根据设计图宽度和高度适配后的最小值)
    var fitSmaller: CGFloat {
        SoloScreen.calcMin(from: self)
    }
}

// MARK: - 浮动数字适配扩展
public extension BinaryFloatingPoint {
    /// 适配宽度(将浮动数字按设计图宽度比例适配)
    var fitWidth: CGFloat {
        SoloScreen.calcWidth(from: self)
    }

    /// 适配高度(将浮动数字按设计图高度比例适配)
    var fitHeight: CGFloat {
        SoloScreen.calcHeight(from: self)
    }

    /// 适配最大值(根据设计图宽度和高度适配后的最大值)
    var fitLarger: CGFloat {
        SoloScreen.calcMax(from: self)
    }

    /// 适配最小值(根据设计图宽度和高度适配后的最小值)
    var fitSmaller: CGFloat {
        SoloScreen.calcMin(from: self)
    }
}
