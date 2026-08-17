import Foundation
import Combine

open class SoloViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    public init() {}

    open class func viewModel() -> SoloViewModel {
        SoloViewModel()
    }
}
