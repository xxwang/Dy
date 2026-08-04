import Foundation
import Combine

open class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
