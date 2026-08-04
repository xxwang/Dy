import Foundation
import DyCore

extension DyModel: DyExtension {}

@MainActor
open class DyDataModel: DyModel, Codable {
    override public nonisolated init() {
        super.init()
    }

    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}
