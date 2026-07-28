import StoreKit

@available(iOS 15.0, *)
public extension Product {
    /// 商品的本地化价格字符串
    var dy_displayPrice: String {
        self.displayPrice
    }
}
