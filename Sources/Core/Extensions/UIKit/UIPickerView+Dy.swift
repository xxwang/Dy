import UIKit

// MARK: - 链式设置属性
public extension UIPickerView {
    /// 设置代理
    /// - Parameter delegate: 实现 `UIPickerViewDelegate` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func dy_delegate(_ delegate: UIPickerViewDelegate?) -> Self {
        self.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 实现 `UIPickerViewDataSource` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func dy_dataSource(_ dataSource: UIPickerViewDataSource?) -> Self {
        self.dataSource = dataSource
        return self
    }
}
