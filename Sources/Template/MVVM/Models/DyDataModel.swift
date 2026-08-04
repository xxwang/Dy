import Foundation
import DyCore

open class DyDataModel: DyModel, Codable {
    override public init() {
        super.init()
    }

    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}

extension DyDataModel: DyExtension {}
