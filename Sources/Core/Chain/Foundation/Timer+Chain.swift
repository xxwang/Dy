import Foundation

// MARK: - 链式方法
public extension SoloWrapper where Base: Timer {
    /// 设置运行模式
    /// - Parameter mode: 运行模式
    /// - Returns: `Self`
    @discardableResult
    func mode(_ mode: RunLoop.Mode) -> Self {
        RunLoop.current.add(base, forMode: mode)
        return self
    }

    /// 立即启动
    /// - Returns: `Self`
    @discardableResult
    func fire() -> Self {
        base.fire()
        return self
    }
}
