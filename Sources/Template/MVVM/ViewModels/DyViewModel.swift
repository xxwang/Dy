import Foundation
import Combine

/// 视图模型基类：承载 UI 状态（@Published 等），所有成员默认在主线程（MainActor）上访问。
/// 标注 @MainActor 可避免业务子类在 Swift 6 / 严格并发下因 init() 隔离级别不匹配而报错
/// （子类 init 被推断为 MainActor-isolated，需与基类保持一致）。
@MainActor
open class DyViewModel: ObservableObject {
    public var cancellables = Set<AnyCancellable>()

    public init() {}

    open class func viewModel() -> DyViewModel {
        DyViewModel()
    }
}
