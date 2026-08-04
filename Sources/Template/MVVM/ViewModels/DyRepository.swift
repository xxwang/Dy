import Foundation

@MainActor open class DyRepository {
    public nonisolated init() {}

    open class func repository() -> DyRepository {
        DyRepository()
    }
}
