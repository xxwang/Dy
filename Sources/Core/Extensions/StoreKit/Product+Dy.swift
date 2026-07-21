import StoreKit

@available(iOS 15.0, *)
public extension Product {
    /// 商品的本地化价格字符串
    var priceStr: String {
        self.price.formatted(.currency(code: self.priceFormatStyle.currencyCode))
    }
}
