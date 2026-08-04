import Foundation
import Combine

open class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    public nonisolated init() {}

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
