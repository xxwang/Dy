import WebKit
import os.log

// MARK: - 常用方法
public extension DyWrapper where Base: WKWebView {
    /// 清除网页缓存(异步操作)
    /// - Parameter completion: 缓存清除完成后的回调(在主线程调用)
    func clearCache(completion: DyAction? = nil) {
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
}
