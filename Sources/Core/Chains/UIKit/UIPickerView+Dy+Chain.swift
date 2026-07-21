import UIKit

// MARK: - 属性
public extension DyWrapper where Base: UIPickerView {
    /// 设置代理
    /// - Parameter delegate: 实现 `UIPickerViewDelegate` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: UIPickerViewDelegate?) -> Self {
        base.delegate = delegate
        return self
    }

    /// 设置数据源
    /// - Parameter dataSource: 实现 `UIPickerViewDataSource` 协议的对象
    /// - Returns: `Self`
    @discardableResult
    func dataSource(_ dataSource: UIPickerViewDataSource?) -> Self {
        base.dataSource = dataSource
        return self
    }
}
