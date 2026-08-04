import Foundation
import DyCore

open class DyDataModel: DyModel, Codable {
    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}

extension DyDataModel: DyExtension {}
