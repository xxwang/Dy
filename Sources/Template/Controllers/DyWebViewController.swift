import UIKit
import WebKit
import DyCore

open class DyWebViewController: DyViewController {
    /// 用户脚本控制器
    open lazy var userContentController = WKUserContentController()

    /// `WKWebView`配置文件
    open lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration.dy_default()
        configuration.userContentController = self.userContentController
        return configuration
    }()

    /// `WKWebView`浏览器视图
    open lazy var webView = WKWebView.init(frame: .zero, configuration: self.configuration)
        .dy
        .uiDelegate(self)
        .navigationDelegate(self)
        .build()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyWebViewController {
    /// 控制器初始化样式
    override open func initUI() {
        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.webView,
            belowSubview: self.naview
        )
        self.webView
            .dy
            .frame(CGRect(
                x: 0,
                y: DyScreen.navBarTotalHeight,
                width: self.view.dy_width,
                height: self.view.dy_height - DyScreen.navBarTotalHeight
            ))
    }

    /// 更新导航栏及受影响的其它view
    override open func updateNaview() {
        super.updateNaview()

        self.webView
            .dy
            .frame(CGRect(
                x: 0,
                y: DyScreen.navBarTotalHeight,
                width: self.view.dy_width,
                height: self.view.dy_height - DyScreen.navBarTotalHeight
            ))
    }
}

// MARK: - WKNavigationDelegate
@objc extension DyWebViewController: WKNavigationDelegate {
    /// 网页开始加载
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}

    /// 网页加载完成
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}

    /// 网页加载失败
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}
}

// MARK: - WKUIDelegate
@objc extension DyWebViewController: WKUIDelegate {}

// MARK: - WKScriptMessageHandler
@objc extension DyWebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {}
}
