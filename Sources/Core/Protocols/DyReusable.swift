import UIKit

public protocol DyReusable: AnyObject {}
public extension DyReusable {
    /// 复用标识
    static var identifier: String {
        let clsName = DyHelper.shared.className(Self.self)
        return "\(clsName)_identifier"
    }
}

extension UICollectionReusableView: DyReusable {}
extension UITableViewCell: DyReusable {}
extension UITableViewHeaderFooterView: DyReusable {}
