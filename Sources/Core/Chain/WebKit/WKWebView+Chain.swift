import WebKit
import os.log

// MARK: - 链式属性
public extension DyWrapper where Base: WKWebView {
    /// 设置网页导航代理
    /// - Parameter delegate: 导航代理对象
    /// - Returns: `Self`
    @discardableResult
    func navigationDelegate(_ delegate: WKNavigationDelegate?) -> Self {
        base.navigationDelegate = delegate
        return self
    }

    /// 设置UI代理
    /// - Parameter delegate: UI代理对象
    /// - Returns: `Self`
    @discardableResult
    func uiDelegate(_ delegate: WKUIDelegate?) -> Self {
        base.uiDelegate = delegate
        return self
    }
}

// MARK: - 链式方法
public extension DyWrapper where Base: WKWebView {
    /// 手动刷新当前网页
    /// - Returns: `Self`
    @discardableResult
    func reload() -> Self {
        base.reload()
        return self
    }

    /// 设置自定义 `User-Agent`
    /// - Parameter userAgent: 自定义的 `User-Agent` 字符串
    /// - Returns: `Self`
    @discardableResult
    func customUserAgent(_ userAgent: String) -> Self {
        base.customUserAgent = userAgent
        return self
    }

    /// 返回
    /// - Returns: `Self`
    @discardableResult
    func goBack() -> Self {
        if base.canGoBack {
            base.goBack()
        }
        return self
    }

    /// 前进
    /// - Returns: `Self`
    @discardableResult
    func goForward() -> Self {
        if base.canGoForward {
            base.goForward()
        }
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension DyWrapper where Base: WKWebView {
    /// 使用`URL`字符串加载网页
    /// - Parameter string: 网页`URL`字符串
    /// - Returns: `Self`
    @discardableResult
    func load(from string: String?) -> Self {
        guard let string, let url = URL(string: string) else {
            return self
        }
        let request = URLRequest(url: url)
        base.load(request)
        return self
    }

    /// 使用URL对象加载网页
    /// - Parameter url: 网页URL对象
    /// - Returns: `Self`
    @discardableResult
    func load(from url: URL?) -> Self {
        guard let url else {
            return self
        }
        let request = URLRequest(url: url)
        base.load(request)
        return self
    }

    /// 加载本地 HTML 文件
    /// - Parameters:
    ///   - fileName: 本地 HTML 文件的名称(不含扩展名)
    ///   - bundle: 文件所在的 `Bundle`,默认为主包
    /// - Returns: `Self`
    @discardableResult
    func load(fileName: String, bundle: Bundle = .main) -> Self {
        guard let path = bundle.path(forResource: fileName, ofType: "html") else {
            os_log(.error, "⚠️ Warning: HTML file '%{public}@.html' not found in bundle.", fileName)
            return self
        }
        let fileURL = URL(fileURLWithPath: path)
        // 允许访问整个目录,以便加载 CSS/JavaScript 等资源
        let directoryURL = fileURL.deletingLastPathComponent()
        base.loadFileURL(fileURL, allowingReadAccessTo: directoryURL)
        return self
    }

    /// 禁止用户缩放网页(通过注入 viewport meta 标签)
    /// - Returns: `Self`
    @discardableResult
    func disableZoom() -> Self {
        let script = """
        var meta = document.createElement('meta');
        meta.name = 'viewport';
        meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
        document.getElementsByTagName('head')[0].appendChild(meta);
        """
        return self.injectScript(script: script, injectionTime: .atDocumentEnd)
    }
}

// MARK: - 链式脚本
public extension DyWrapper where Base: WKWebView {
    /// 向 `WKWebView` 注入 `JavaScript` 脚本
    /// - Parameters:
    ///   - script: 要注入的 JavaScript 代码
    ///   - injectionTime: 脚本注入时机,默认是 `.atDocumentStart`
    ///   - forMainFrameOnly: 是否只注入到主框架,默认是 `false`
    /// - Returns: `Self`
    @discardableResult
    func injectScript(
        script: String,
        injectionTime: WKUserScriptInjectionTime = .atDocumentStart,
        forMainFrameOnly: Bool = false
    ) -> Self {
        let userScript = WKUserScript(
            source: script,
            injectionTime: injectionTime,
            forMainFrameOnly: forMainFrameOnly
        )
        base.configuration.userContentController.addUserScript(userScript)
        return self
    }

    /// 执行 `JavaScript` 代码
    /// - Parameters:
    ///   - script: `JavaScript` 代码
    ///   - completion: 完成回调
    /// - Returns: `Self`
    @discardableResult
    func execScript(script: String, completion: @escaping DyAction1<Result<Any?, Error>>) -> Self {
        base.evaluateJavaScript(script) { result, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(result))
            }
        }
        return self
    }

    /// 添加脚本消息处理器
    /// - Parameters:
    ///   - scriptMessageHandler: 脚本消息处理器
    ///   - name: 消息名称(`JavaScript` 中通过 `window.webkit.messageHandlers.<name>.postMessage(...)` 调用)
    /// - Returns: `Self`
    @discardableResult
    func addScriptMessageHandler(
        _ scriptMessageHandler: any WKScriptMessageHandler,
        name: String
    ) -> Self {
        base.configuration.userContentController.add(scriptMessageHandler, name: name)
        return self
    }

    /// 移除消息处理器
    /// - Parameter name: 消息名称
    /// - Returns: `Self`
    @discardableResult
    func removeScriptMessageHandler(name: String) -> Self {
        base.configuration.userContentController.removeScriptMessageHandler(forName: name)
        return self
    }
}
