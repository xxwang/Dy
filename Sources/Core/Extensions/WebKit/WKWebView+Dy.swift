import WebKit

// MARK: - 辅助类
public extension WKWebView {
    /// 将闭包包装为WKScriptMessageHandler
    class DyScriptMessageHandler: NSObject, WKScriptMessageHandler {
        private let handler: DyAction1<WKScriptMessage>
        init(handler: @escaping DyAction1<WKScriptMessage>) {
            self.handler = handler
        }

        public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            handler(message)
        }
    }
}

// MARK: - 常用方法
public extension WKWebView {
    /// 清除网页缓存(异步操作)
    /// - Parameter completion: 缓存清除完成后的回调(在主线程调用)
    func dy_clearCache(completion: DyAction? = nil) {
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            guard !records.isEmpty else {
                DispatchQueue.main.async {
                    completion?()
                }
                return
            }

            let dispatchGroup = DispatchGroup()
            for record in records {
                dispatchGroup.enter()
                dataStore.removeData(
                    ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                    for: [record]
                ) {
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                completion?()
            }
        }
    }

    /// 执行 `JavaScript` 代码
    /// - Parameters:
    ///   - script: `JavaScript` 代码
    ///   - completion: 完成回调(已在主线程)
    func dy_executeJavaScript(script: String, completion: @escaping DyAction1<Result<Any?, Error>>) {
        self.evaluateJavaScript(script) { result, error in
            if let error {
                completion(.failure(error))
            } else {
                completion(.success(result))
            }
        }
    }
}
