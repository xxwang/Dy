import Foundation

open class DyRepository {
    public nonisolated init() {}

    open class func repository() -> DyRepository {
        DyRepository()
    }
}
