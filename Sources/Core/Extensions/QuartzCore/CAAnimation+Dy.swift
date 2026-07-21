import QuartzCore

public extension CAAnimation {
    // MARK: - DyBlockAnimationDelegate
    class DyBlockAnimationDelegate: NSObject {
        /// 动画开始时触发的闭包
        var dy_onStart: ((CAAnimation) -> Void)?

        /// 动画结束时触发的闭包,`finished` 表示是否完整播放完毕
        var dy_onStop: ((CAAnimation, _ finished: Bool) -> Void)?

        override init() {
            super.init()
        }
    }
}

// MARK: - CAAnimationDelegate实现
extension CAAnimation.DyBlockAnimationDelegate: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        self.dy_onStart?(anim)
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.dy_onStop?(anim, flag)
    }
}
