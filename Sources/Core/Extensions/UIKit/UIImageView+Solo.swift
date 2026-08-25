import UIKit

// MARK: - 图片加载
public extension UIImageView {
    /// 从 `URL` 加载网络图片
    /// - Parameters:
    ///   - url: 图片 URL
    ///   - placeholder: 占位图
    ///   - contentMode: 内容模式
    ///   - completion: 完成回调(主线程)
    func solo_loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        completion: SoloAction2<UIImage?, Error?>? = nil
    ) {
        self.contentMode = contentMode
        self.image = placeholder

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self else { return }

            if let error {
                DispatchQueue.main.async {
                    completion?(nil, error)
                }
                return
            }

            guard
                let data,
                let image = UIImage(data: data),
                (response as? HTTPURLResponse)?.statusCode == 200
            else {
                let err = NSError(domain: "UIImageView.loadImage", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid image data"])
                DispatchQueue.main.async {
                    completion?(nil, err)
                }
                return
            }

            DispatchQueue.main.async {
                self.image = image
                completion?(image, nil)
            }
        }
        task.resume()
    }
}
