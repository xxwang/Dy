import UIKit
import Foundation

// MARK: - 属性
public extension NSAttributedString {
    /// 获取属性字符串起始位置(索引 0)处的有效属性字典
    ///
    /// 如果字符串为空,返回空字典
    var dy_attributes: [NSAttributedString.Key: Any] {
        guard self.length > 0 else { return [:] }
        return self.attributes(at: 0, effectiveRange: nil)
    }

    /// 返回覆盖整个属性字符串的 `NSRange`
    var dy_fullNSRange: NSRange {
        Foundation.NSRange(location: 0, length: self.length)
    }
}

// MARK: - 类型转换
public extension NSAttributedString {
    /// 将当前不可变属性字符串转换为可变属性字符串
    func dy_nSMutableAttributedString() -> NSMutableAttributedString {
        NSMutableAttributedString(attributedString: self)
    }
}

// MARK: - 查找子字符串范围(返回 NSRange)
public extension NSAttributedString {
    /// 返回子字符串 `substring` 在属性字符串中`首次出现`的 `NSRange`
    ///
    /// - 注意：返回的 `NSRange` 基于 `UTF-16 码元(code units)`,与 `NSAttributedString.length` 一致
    /// - 若未找到,返回 `{location: NSNotFound, length: 0}`
    ///
    /// - Parameter substring: 要查找的子字符串
    /// - Returns: 对应的 `NSRange`
    func dy_nsRange(of substring: String) -> NSRange {
        let str = self.string
        guard let range = str.range(of: substring) else {
            return Foundation.NSRange(location: NSNotFound, length: 0)
        }
        let loc = str.utf16.distance(from: str.startIndex, to: range.lowerBound)
        let len = str.utf16.distance(from: range.lowerBound, to: range.upperBound)
        return Foundation.NSRange(location: loc, length: len)
    }

    /// 返回多个子字符串在属性字符串中的`所有匹配项`的 `NSRange` 数组
    ///
    /// - 每个 `substring` 会独立查找全部出现位置
    /// - 结果按输入顺序和文本中出现顺序排列
    /// - 所有 `NSRange` 均基于 `UTF-16 索引`,适用于 `NSAttributedString` 的属性设置
    ///
    /// - Parameter substrings: 要查找的子字符串数组
    /// - Returns: 所有匹配的 `NSRange`
    func dy_allNSRanges(of substrings: [String]) -> [NSRange] {
        var allRanges: [NSRange] = []
        let baseString = self.string

        for text in substrings {
            guard !text.isEmpty else { continue }
            var searchStart = baseString.startIndex

            while let range = baseString.range(of: text, range: searchStart ..< baseString.endIndex) {
                let loc = baseString.utf16.distance(from: baseString.startIndex, to: range.lowerBound)
                let len = baseString.utf16.distance(from: range.lowerBound, to: range.upperBound)
                allRanges.append(Foundation.NSRange(location: loc, length: len))

                // 防止空字符串导致无限循环
                if range.lowerBound == range.upperBound {
                    break
                }
                searchStart = range.upperBound
            }
        }
        return allRanges
    }
}

// MARK: - 尺寸计算
public extension NSAttributedString {
    /// 计算属性字符串在指定最大宽度下的包围尺寸(向上取整)
    ///
    /// 使用 `.usesLineFragmentOrigin` 和 `.usesFontLeading` 选项,
    /// 行为与 `UILabel` 的文本布局一致
    ///
    /// - Parameter maxWidth: 最大允许宽度默认为 `.greatestFiniteMagnitude`(无宽度限制)
    /// - Parameter ceilResult: 是否对结果向上取整(默认 `true`)
    /// - Returns: 计算出的 `CGSize`(宽高均向上取整)
    func dy_viewSize(maxWidth: CGFloat = .greatestFiniteMagnitude, ceilResult: Bool = true) -> CGSize {
        let constraint = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = self.boundingRect(
            with: constraint,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            context: nil
        )
        let size = rect.size
        return ceilResult ? CGSize(width: Darwin.ceil(size.width), height: Darwin.ceil(size.height)) : size
    }
}

// MARK: - 运算符重载
public extension NSAttributedString {
    /// 将右侧的 `NSAttributedString` 追加到左侧可变引用上
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let mutable = NSMutableAttributedString(attributedString: lhs)
        mutable.append(rhs)
        lhs = NSAttributedString(attributedString: mutable)
    }

    /// 将右侧的普通字符串(无属性)追加到左侧属性字符串
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }

    /// 合并两个属性字符串,返回新的不可变实例
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let mutable = NSMutableAttributedString(attributedString: lhs)
        mutable.append(rhs)
        return NSAttributedString(attributedString: mutable)
    }

    /// 将属性字符串与普通字符串合并(普通字符串无特殊属性)
    static func + (lhs: NSAttributedString, rhs: String) -> NSAttributedString {
        lhs + NSAttributedString(string: rhs)
    }
}
