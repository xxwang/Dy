import Foundation

open class DyDataModel: DyModel, Codable {
    override public nonisolated init() {
        super.init()
    }

    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}
