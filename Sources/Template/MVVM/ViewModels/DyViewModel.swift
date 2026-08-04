import Foundation
import Combine

open nonisolated class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    public init() {}

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
