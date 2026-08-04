import Foundation

@MainActor
open class DyModel {
    public nonisolated init() {}

    open class func model() -> DyModel {
        DyModel()
    }
}
