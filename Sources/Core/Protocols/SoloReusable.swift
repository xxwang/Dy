import UIKit

public protocol SoloReusable: AnyObject {}
public extension SoloReusable {
    /// 复用标识
    static var solo_identifier: String {
        let clsName = SoloHelper.shared.className(Self.self)
        return "\(clsName)_identifier"
    }
}

extension UICollectionReusableView: SoloReusable {}
extension UITableViewCell: SoloReusable {}
extension UITableViewHeaderFooterView: SoloReusable {}
