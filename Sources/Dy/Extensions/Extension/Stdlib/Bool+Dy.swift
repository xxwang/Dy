import Foundation

// MARK: - 类型转换
public extension Bool {
    /// 将布尔值转换为对应的整数值
    func dy_toInt() -> Int {
        return self ? 1 : 0
    }

    /// 将布尔值转换为对应的浮点数值
    func dy_toFloat() -> Float {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为对应的双精度浮点数值
    func dy_toDouble() -> Double {
        return self ? 1.0 : 0.0
    }

    /// 将布尔值转换为其标准字符串表示形式
    func dy_toString() -> String {
        return self ? "true" : "false"
    }
}
