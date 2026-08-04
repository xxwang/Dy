import UIKit

// MARK: - 图片加载
public extension DyWrapper where Base: UIImageView {
    /// 从 `URL` 加载网络图片
    /// - Parameters:
    ///   - url: 图片 URL
    ///   - placeholder: 占位图
    ///   - contentMode: 内容模式
    ///   - completion: 完成回调(主线程)
    func loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        contentMode: UIView.ContentMode = .scaleAspectFill,
        completion: DyAction2<UIImage?, Error?>? = nil
    ) {
        base.contentMode = contentMode
        base.image = placeholder

        let task = URLSession.shared.dataTask(with: url) { [weak base] data, response, error in
            guard let base else { return }

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
                base.image = image
                completion?(image, nil)
            }
        }
        task.resume()
    }
}
