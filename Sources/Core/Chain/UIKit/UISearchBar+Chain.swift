import UIKit

// MARK: - 链式设置属性
public extension DyWrapper where Base: UISearchBar {
    /// 设置占位符文本
    /// - Parameter placeholder: 占位文本
    /// - Returns: `Self`
    @discardableResult
    func placeholder(_ placeholder: String?) -> Self {
        base.placeholder = placeholder
        return self
    }

    /// 设置搜索栏样式
    /// - Parameter style: 样式
    /// - Returns: `Self`
    @discardableResult
    func searchBarStyle(_ style: UISearchBar.Style) -> Self {
        base.searchBarStyle = style
        return self
    }

    /// 设置文本框背景颜色
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func searchTextFieldBackgroundColor(_ color: UIColor?) -> Self {
        base.searchTextField.backgroundColor = color
        return self
    }

    /// 设置`tintColor`(影响光标、清除按钮、取消按钮等)
    /// - Parameter color: 颜色
    /// - Returns: `Self`
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        base.tintColor = color
        return self
    }

    /// 设置搜索文本的字体和颜色(通过 `searchTextField` 的 `attributedPlaceholder` 或直接设置)
    /// - Parameter attributes: 属性
    /// - Returns: `Self`
    @discardableResult
    func textAttributes(_ attributes: [NSAttributedString.Key: Any]?) -> Self {
        base.searchTextField.attributedPlaceholder = attributes.map {
            NSAttributedString(string: base.placeholder ?? "", attributes: $0)
        }
        return self
    }

    /// 设置代理
    /// - Parameter delegate: 代理对象
    /// - Returns: `Self`
    @discardableResult
    func delegate(_ delegate: (any UISearchBarDelegate)?) -> Self {
        base.delegate = delegate
        return self
    }
}

// MARK: - 链式方法(自定义)
public extension DyWrapper where Base: UISearchBar {
    /// 清空搜索文本
    /// - Returns: `Self`
    @discardableResult
    func clear() -> Self {
        base.text = ""
        base.searchTextField.text = ""
        base.searchTextField.attributedText = nil
        return self
    }

    /// 启用/禁用搜索栏
    /// - Parameter isEnabled: 是否启用
    /// - Returns: `Self`
    @discardableResult
    func isEnabled(_ isEnabled: Bool) -> Self {
        base.isUserInteractionEnabled = isEnabled
        base.alpha = isEnabled ? 1.0 : 0.5
        return self
    }
}
