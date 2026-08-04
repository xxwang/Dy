import Foundation
import Combine

@MainActor open class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
