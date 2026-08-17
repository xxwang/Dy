import Foundation

// MARK: - 判断
public extension SoloWrapper where Base: SignedInteger {
    /// 判断当前整数是否为质数(素数)
    ///
    /// - Returns: 若数值 > 1 且仅能被 1 和自身整除,则返回 `true`;否则返回 `false`
    /// - Note: 使用优化的试除法(跳过偶数,上限为平方根),适用于大多数场景
    /// - Warning: 对极大整数(如 > 10^12)性能显著下降,建议用于中小数值
    ///
    /// - Example:
    ///     ```swift
    ///     print((7).solo.isPrime)   // true
    ///     print((8).solo.isPrime)   // false
    ///     print((1).solo.isPrime)   // false
    ///     ```
    var isPrime: Bool {
        guard base > 1 else { return false }
        if base == 2 {
            return true
        }
        if base.isMultiple(of: 2) {
            return false
        }

        // 使用 Self 类型进行安全计算,避免 Int 强制转换
        let limit = Base(Double(base).squareRoot().rounded(.up))
        var divisor: Base = 3
        while divisor <= limit {
            if base.isMultiple(of: divisor) {
                return false
            }
            divisor += 2 // 只检查奇数
        }
        return true
    }
}

// MARK: - 数值操作
public extension SoloWrapper where Base: SignedInteger {
    /// 将正整数转换为罗马数字表示
    ///
    /// - Returns: 罗马数字字符串(如 `"MCMXCIV"`);若数值 ≤ 0,返回 `nil`
    /// - Note: 仅支持 1 到 3999 的整数(传统罗马数字范围)
    ///
    /// - Example:
    ///     ```swift
    ///     print((1994).solo.toRomanNumeral() as Any) // "MCMXCIV"
    ///     print((0).solo.toRomanNumeral() as Any)    // nil
    ///     ```
    func toRomanNumeral() -> String? {
        guard base > 0, base <= 3999 else { return nil } // 罗马数字通常不超过 3999

        // 使用 (value, symbol) 元组数组,避免索引错位
        let mappings: [(value: Base, symbol: String)] = [
            (1000, "M"), (900, "CM"), (500, "D"), (400, "CD"),
            (100, "C"), (90, "XC"), (50, "L"), (40, "XL"),
            (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I"),
        ]

        var value = base
        var result = ""

        for mapping in mappings {
            while value >= mapping.value {
                result += mapping.symbol
                value -= mapping.value
            }
        }
        return result
    }

    /// 返回绝对值
    /// - Returns: 绝对值
    ///
    /// - Example:
    ///
    ///     let value = -42
    ///     print(value.solo.abs()) // 42
    ///
    func abs() -> Base {
        return Swift.abs(base)
    }

    /// 计算两个整数的最大公约数(GCD)
    ///
    /// - Parameter other: 另一个整数
    /// - Returns: 两数的 GCD(非负)
    ///
    /// - Example:
    ///     ```swift
    ///     print((12).solo.gcd(with: 15)) // 3
    ///     print((-8).solo.gcd(with: 12)) // 4
    ///     ```
    func gcd(with other: Base) -> Base {
        var a = Swift.abs(base)
        var b = Swift.abs(other)
        while b != 0 {
            (a, b) = (b, a % b)
        }
        return a
    }

    /// 计算两个整数的最小公倍数(LCM)
    ///
    /// - Parameter other: 另一个整数
    /// - Returns: 两数的 LCM若任一数为 0,返回 0
    /// - Note: 数学上 LCM(0, 0) 未定义,此处按惯例返回 0
    ///
    /// - Example:
    ///     ```swift
    ///     print((12).solo.lcm(with: 15)) // 60
    ///     print((0).solo.lcm(with: 5))   // 0
    ///     ```
    func lcm(with other: Base) -> Base {
        guard base != 0, other != 0 else { return 0 }
        return (Swift.abs(base) / self.gcd(with: other)) * Swift.abs(other)
    }

    /// 计算当前非负整数的阶乘
    ///
    /// - Returns: 阶乘结果(如 `5! = 120`);若数值 < 0,返回 `nil`
    /// - Warning: 阶乘增长极快,`Int` 类型在 `21!` 时即溢出
    ///   建议仅用于小数值(≤ 20)
    ///
    /// - Example:
    ///     ```swift
    ///     print((5).solo.factorial() as Any)  // Optional(120)
    ///     print((-1).solo.factorial() as Any) // nil
    ///     ```
    func factorial() -> Base? {
        guard base >= 0 else { return nil }

        // 将 20 转为 Self 类型进行安全比较
        let maxSafe: Base = 20
        guard base <= maxSafe else { return nil }

        var result: Base = 1
        // 将 2 转为 Self,并使用 stride 或循环
        var i: Base = 2
        while i <= base {
            result *= i
            i += 1
        }
        return result
    }

    /// 重复执行指定操作 N 次(N = 当前整数值)
    ///
    /// - Parameter body: 要重复执行的闭包
    /// - Note: 若当前值 ≤ 0,不执行任何操作
    ///
    /// - Example:
    ///     ```swift
    ///     (3).solo.times {
    ///         print("Hello!")
    ///     }
    ///     // 输出三次 "Hello!"
    ///     ```
    func times(_ body: SoloAction) {
        guard base > 0 else { return }
        var count: Base = 0
        while count < base {
            body()
            count += 1
        }
    }
}
