import UIKit

public protocol DyReusable: AnyObject {}
public extension DyReusable {
    /// 复用标识
    static var identifier: String {
        var clsName = NSStringFromClass(Self.self)
        clsName = clsName.split(separator: ".").last.map(String.init) ?? clsName
        return "\(clsName)_identifier"
    }
}

extension UICollectionReusableView: DyReusable {}
extension UITableViewCell: DyReusable {}
extension UITableViewHeaderFooterView: DyReusable {}
