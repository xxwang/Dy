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
        .dy_uiDelegate(self)
        .dy_navigationDelegate(self)

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - 脚本消息处理器管理(iOS 13 安全)

    /// 已注册脚本消息处理器名称,用于在 deinit 时(尤其 iOS 13)逐个移除,避免 WKWebView 强引用导致的内存泄漏
    private var dy_scriptMessageHandlerNames: Set<String> = []

    /// 注册脚本消息处理器(自动记录名称,deinit 时统一清理)
    /// - Parameters:
    ///   - handler: 消息处理器(通常为 `self`)
    ///   - name: 处理器名称
    open func dy_addScriptMessageHandler(_ handler: WKScriptMessageHandler, name: String) {
        userContentController.add(handler, name: name)
        dy_scriptMessageHandlerNames.insert(name)
    }

    /// 移除指定名称的脚本消息处理器(iOS 13 / 14+ 均安全)
    /// - Parameter name: 处理器名称
    open func dy_removeScriptMessageHandler(forName name: String) {
        userContentController.removeScriptMessageHandler(forName: name)
        dy_scriptMessageHandlerNames.remove(name)
    }

    deinit {
        if #available(iOS 14.0, *) {
            self.userContentController.removeAllScriptMessageHandlers()
        } else {
            // iOS 13 无 removeAllScriptMessageHandlers,逐个移除以打破 WKWebView 对 VC 的强引用
            for name in dy_scriptMessageHandlerNames {
                self.userContentController.removeScriptMessageHandler(forName: name)
            }
        }
        dy_scriptMessageHandlerNames.removeAll()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyWebViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.webView,
            belowSubview: self.naview
        )

        self.webView.dy_frame(CGRect(
            x: 0,
            y: DyScreen.navBarTotalHeight,
            width: self.view.dy_width,
            height: self.view.dy_height - DyScreen.navBarTotalHeight
        ))
    }

    /// 更新导航栏及受影响的其它view
    override open func updateNaview() {
        super.updateNaview()

        self.webView.dy_frame(CGRect(
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
