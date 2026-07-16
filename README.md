## Dy
✨ 轻量级 Swift 扩展工具库，通过统一的 `.dy` 命名空间，为 UIKit、Foundation 等常用类型提供简洁、安全、无污染的链式 API

## 安装
`Dy` 仅支持 Swift Package Manager (SPM)
在你的 `Package.swift` 文件中，将以下内容添加到 `dependencies` 中：

```swift
.package(url: "https://github.com/xxwang/Dy.git", branch: "main")
```
然后在目标依赖中加入 `Dy`

> 如果你在 Xcode 中使用：
> `File` → `Add Package Dependency...` → 输入仓库 URL 即可

## 使用方法
使用前请先导入模块：

```swift
import Dy
```

所有公开的扩展方法通过`.dy_`或者`.dy.`使用：
```
let view = UIView()
view.dy_xxx().dy_xxx()

let view = UIView()
view.dy.xxx()
```

## 自定义扩展
### 第一步`遵守协议`
```swift
// 让目标类型遵循 DyExtension 协议
extension YourType: DyExtension {}
```

### 第二步`实现方法`

实例扩展
```swift
extension DyWrapper where Base: UIView {
    @discardableResult
    func cornerRadius(_ radius: CGFloat) -> Base {
        base.layer.cornerRadius = radius
        return base
    }
}

let button = UIButton()
button.dy.cornerRadius(8)
```

类型扩展
```swift
extension DyWrapper where Base == UIColor {
    static var random: UIColor {
        let r = CGFloat.random(in: 0 ... 1)
        let g = CGFloat.random(in: 0 ... 1)
        let b = CGFloat.random(in: 0 ... 1)
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    }
}

let color = UIColor.dy.random
```

> 💡 所有内置扩展（如 UIView、UIColor 等）均采用相同机制实现


