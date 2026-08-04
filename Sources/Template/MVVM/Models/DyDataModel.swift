import Foundation

open nonisolated class DyDataModel: DyModel, Codable {
    override public init() {
        super.init()
    }

    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}
