import Foundation

@MainActor open class DyRepository {
    open class func repository() -> DyRepository {
        DyRepository()
    }
}
