import Foundation

// MARK: - 方法
public extension IndexPath {
    /// 返回适合日志打印的可读字符串(仅适用于二维结构,如 UITableView / UICollectionView)
    ///
    /// - Returns: 格式如 `"[section: 0, row: 5]"`;若为多维 IndexPath,则返回标准描述
    ///
    /// - Note: 此属性主要用于调试或日志输出,`不应用于业务逻辑`
    ///
    /// - Example:
    ///   ```swift
    ///   let ip = IndexPath(row: 2, section: 1)
    ///   print(ip.solo_string()) // [section: 1, row: 2]
    ///   ```
    func solo_string() -> String {
        if self.count == 2 {
            return "[section: \(self.section), row: \(self.row)]"
        } else {
            // 多维情况：如 (0, 1, 2) 表示 section=0, row=1, item=2
            let components = self.map(String.init).joined(separator: ", ")
            return "IndexPath(\(components))"
        }
    }

    /// 创建一个在当前 IndexPath 基础上偏移指定行数和节数的新 IndexPath
    ///
    /// - Parameters:
    ///   - row: 行偏移量(可为负数)
    ///   - section: 节偏移量(可为负数)
    /// - Returns: 新的 `IndexPath`
    ///
    /// - Note: 不进行边界检查(由调用方确保有效性)
    ///
    /// - Example:
    ///   ```swift
    ///   let current = IndexPath(row: 3, section: 1)
    ///   let next = current.solo_offset(row: 1)          // (row: 4, section: 1)
    ///   let prevSection = current.solo_offset(section: -1) // (row: 3, section: 0)
    ///   ```
    func solo_offset(row: Int = 0, section: Int = 0) -> IndexPath {
        return IndexPath(row: self.row + row, section: self.section + section)
    }
}
