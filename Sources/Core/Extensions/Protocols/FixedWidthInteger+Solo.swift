import Foundation

// MARK: - 字节转换(仅适用于固定宽度整数)
public extension SoloWrapper where Base: FixedWidthInteger {
    /// 将整数转换为大端字节序(`Big-Endian`)的 `[UInt8]` 数组
    ///
    /// - Returns: 表示该整数的字节数组,高位字节在前
    ///
    /// - Example:
    ///   ```swift
    ///     let bytes = (0x1234 as UInt16).solo.bytes // [0x12, 0x34]
    ///     ```
    var bytes: [UInt8] {
        withUnsafeBytes(of: base.bigEndian) { Array($0) }
    }

    /// 将整数转换为小端字节序(`Little-Endian`)的 `[UInt8]` 数组
    var littleEndianBytes: [UInt8] {
        withUnsafeBytes(of: base.littleEndian) { Array($0) }
    }
}
