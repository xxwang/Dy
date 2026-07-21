import Foundation

open class DyDataModel: DyModel, Codable {
    override public init() {
        super.init()
    }

    public required init(from decoder: any Decoder) throws {
        super.init()
    }

    override open class func model() -> DyDataModel {
        DyDataModel()
    }
}
