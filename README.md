## Dy
✨ 轻量级`Swift`扩展工具，为`UIKit`、`Foundation`等常用类型提供简洁、安全、无污染的`链式API`

## 安装
`Dy`仅支持 `Swift Package Manager`
在你的 `Package.swift` 文件中，将以下内容添加到 `dependencies` 中：

```swift
.package(url: "https://github.com/xxwang/Dy.git", branch: "main")
```

> 如果你在 Xcode 中使用：
> `File` → `Add Package Dependency...` → 输入仓库`URL`即可

## 使用方法
使用前请先导入模块：

```swift
// 一些常用基类 + DyComponent + DyCore + DyLogger
import DyTemplate

// 组件 + DyCore
import DyComponent

// 常用工具 + 扩展
import DyCore

// 日志工具
import DyLogger
```
