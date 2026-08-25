import UIKit
import WebKit
import SoloCore

open class SoloWebViewController: SoloViewController {
    /// 用户脚本控制器
    open lazy var userContentController = WKUserContentController()

    /// `WKWebView`配置文件
    open lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration.solo_default()
        configuration.userContentController = self.userContentController
        return configuration
    }()

    /// `WKWebView`浏览器视图
    open lazy var webView = WKWebView.init(frame: .zero, configuration: self.configuration)
        .solo.uiDelegate(self)
        .navigationDelegate(self)
        .build()

    /// 已注册脚本消息处理器名称,用于在 deinit 时(尤其 iOS 13)逐个移除,避免 WKWebView 强引用导致的内存泄漏
    private var scriptMessageHandlerNames: Set<String> = []

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - 脚本消息处理器管理(iOS 13 安全)

    /// 弱引用转发脚本消息处理器:打破 `WKUserContentController` 强引用 handler 造成的循环引用
    /// (`WKUserContentController` 会强引用其添加的 handler,若直接传入 `self` 则
    /// `self → userContentController → self` 形成循环,导致 `deinit` 永不触发、handler 永不被移除)。
    private class WeakScriptMessageHandler: NSObject, WKScriptMessageHandler {
        weak var target: WKScriptMessageHandler?
        init(_ target: WKScriptMessageHandler) {
            self.target = target
        }

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            target?.userContentController(userContentController, didReceive: message)
        }
    }

    /// 注册脚本消息处理器(自动记录名称,deinit 时统一清理)
    /// - Parameters:
    ///   - handler: 消息处理器(通常为 `self`);内部以弱引用包装,不会因此持有 `self`
    ///   - name: 处理器名称
    open func addScriptMessageHandler(_ handler: WKScriptMessageHandler, name: String) {
        self.userContentController.add(WeakScriptMessageHandler(handler), name: name)
        self.scriptMessageHandlerNames.insert(name)
    }

    /// 移除指定名称的脚本消息处理器(iOS 13 / 14+ 均安全)
    /// - Parameter name: 处理器名称
    open func removeScriptMessageHandler(forName name: String) {
        self.userContentController.removeScriptMessageHandler(forName: name)
        self.scriptMessageHandlerNames.remove(name)
    }

    deinit {
        // handler 已通过 WeakScriptMessageHandler 弱引用转发,不会阻止本对象释放,deinit 可正常触发
        if #available(iOS 14.0, *) {
            self.userContentController.removeAllScriptMessageHandlers()
        } else {
            // iOS 13 无 removeAllScriptMessageHandlers,逐个移除
            for name in self.scriptMessageHandlerNames {
                self.userContentController.removeScriptMessageHandler(forName: name)
            }
        }
        self.scriptMessageHandlerNames.removeAll()
    }
}

// MARK: - SoloSetupable
@objc extension SoloWebViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        if self.naview.superview != nil {
            self.view.insertSubview(
                self.webView,
                belowSubview: self.naview
            )
        } else {
            self.view.addSubview(self.webView)
        }

        self.updateNaview()
    }
}

// MARK: - 支持子类重写的方法
@objc extension SoloWebViewController {
    /// 更新导航栏位置及受影响的视图
    override open func updateNaview() {
        super.updateNaview()

        let topMargin = self.naview.isHidden ? 0 : SoloScreen.navBarTotalHeight
        self.webView
            .solo
            .frame(CGRect(
                x: 0,
                y: topMargin,
                width: self.view.solo_width,
                height: self.view.solo_height - topMargin
            ))
    }
}

// MARK: - WKNavigationDelegate
@objc extension SoloWebViewController: WKNavigationDelegate {
    /// 网页开始加载
    open func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}

    /// 网页加载完成
    open func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {}

    /// 网页加载失败
    open func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {}
}

// MARK: - WKUIDelegate
@objc extension SoloWebViewController: WKUIDelegate {}

// MARK: - WKScriptMessageHandler
@objc extension SoloWebViewController: WKScriptMessageHandler {
    open func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {}
}
