import Foundation
import Combine

@MainActor
open class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    public nonisolated init() {}

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
