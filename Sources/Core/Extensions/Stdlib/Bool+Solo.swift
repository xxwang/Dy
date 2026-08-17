import Foundation

extension Bool: SoloExtension {}

// MARK: - 类型转换
public extension SoloWrapper where Base == Bool {
    /// 将布尔值转换为对应的整数值
    func toInt() -> Int {
        return base ? 1 : 0
    }

    /// 将布尔值转换为对应的浮点数值
    func toFloat() -> Float {
        return base ? 1.0 : 0.0
    }

    /// 将布尔值转换为对应的双精度浮点数值
    func toDouble() -> Double {
        return base ? 1.0 : 0.0
    }

    /// 将布尔值转换为其标准字符串表示形式
    func toString() -> String {
        return base ? "true" : "false"
    }
}
