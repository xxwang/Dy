import WebKit

// MARK: - 属性
public extension SoloWrapper where Base: WKWebViewConfiguration {
    /// 默认的 `WKWebViewConfiguration` 配置实例
    static func `default`() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        // 是否允许视频在网页内联播放(而非强制全屏)
        configuration.allowsInlineMediaPlayback = true
        // 是否禁止渐进式渲染(即等待整个页面加载完成后再显示)
        configuration.suppressesIncrementalRendering = false
        // 是否允许执行网页中的 JavaScript(默认就是 true)
        if #available(iOS 14.0, *) {
            configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            configuration.preferences.javaScriptEnabled = true
        }
        // 是否允许 JavaScript 自动打开新窗口(如 window.open)设为 false 可防止恶意弹窗
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = false
        // 设置最小字体大小(防止网页使用过小文字影响可读性)
        configuration.preferences.minimumFontSize = 12
        // 是否启用欺诈网站警告(类似 Safari 的安全提示)
        configuration.preferences.isFraudulentWebsiteWarningEnabled = true

        return configuration
    }
}
