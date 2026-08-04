import Foundation

open nonisolated class DyRepository {
    public init() {}

    open class func repository() -> DyRepository {
        DyRepository()
    }
}
