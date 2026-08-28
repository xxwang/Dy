# Dy

轻量级 Swift 扩展工具库。基于 `DyExtension` 协议 + `DyWrapper` 泛型命名空间，为 UIKit、Foundation、CoreGraphics、QuartzCore、MapKit、WebKit 等提供 `.dy` 链式 API 与批量工具扩展，**不污染原生类型**。

```swift
import Dy   // 一键引入全部模块

// 链式配置视图（引用类型，无需 .build()）
let view = UIView()
    .dy
    .backgroundColor(.white)
    .cornerRadius(8)
    .masksToBounds(true)

// 值类型链式（返回新副本）
let point = CGPoint(x: 10, y: 20)
    .dy.with { $0.x += 5; $0.y *= 2 }

// 颜色便捷初始化
let color = UIColor(hex: "#FF5722")

// UserDefaults 属性包装器
@DyDataStore("userName", default: "")
var userName: String
```

## 模块

| 产品（SPM Target） | 路径 | 内容 |
|--------------------|------|------|
| `DyCore` | `Sources/Core` | 核心：`.dy` 命名空间、Chain 链式 API、Extensions、通用工具类 |
| `DyCombineCocoa` | `Sources/CombineCocoa` | Combine + UIKit 事件封装（`dy_*Publisher`） |
| `DyLogger` | `Sources/Logger` | 5 级日志 + 可插拔输出目标 |
| `Dy` | `Sources/Dy` | 聚合模块，`@_exported` 重导出以上全部 |

> `import Dy` 会一并重导出 `DyCore`、`DyCombineCocoa`、`DyLogger`（含 `UIKit` / `Combine`），是推荐的一站式引入方式。按需也可只 `import DyCore` / `import DyCombineCocoa` / `import DyLogger`。

## 安装

Swift Package Manager：

```swift
// Package.swift
.package(url: "https://github.com/xxwang/Dy.git", branch: "main")

// Xcode: File → Add Package Dependency → 输入仓库 URL
```

平台要求：**iOS 13.0+**，无任何第三方依赖。

---

## 链式 API 核心

所有扩展通过 `.dy` 命名空间访问，基于两个入口（定义于 `Sources/Core/Protocols/DyExtension.swift`）：

- **实例入口** `object.dy` → `DyWrapper<Object>`
- **类型入口** `Type.dy` → `DyWrapper<Type.Type>`（用于配置静态/类属性）

`DyWrapper<Base>` 提供四个通用方法：

```swift
let v = UIView()
    .dy.build()                          // 取出被包装的实例

CGPoint(x: 0, y: 0)
    .dy.with { $0.x = 10 }               // 值类型：操作副本并返回新值

[1, 2, 3].dy.do { print($0) }            // 副作用：仅执行闭包

UILabel().dy.then { $0.text = "hi" }     // 引用类型：配置并返回自身，可继续链式
```

### Chain 链式配置

`Sources/Core/Chain/` 按系统框架组织，为各类型提供**同名 setter 链式方法**，全部返回 `Self`。引用类型可省略 `.build()`：

```swift
let label = UILabel()
    .dy
    .text("标题")
    .font(.boldSystemFont(ofSize: 18))
    .textColor(.red)
    .textAlignment(.center)
    .numberOfLines(0)

let button = UIButton(type: .system)
    .dy
    .title("提交", for: .normal)
    .titleColor(.white, for: .normal)
    .backgroundColor(.systemBlue)
    .cornerRadius(8)

let layer = CAGradientLayer()
    .dy
    .colors([UIColor.red.cgColor, UIColor.blue.cgColor])
    .locations([0, 1])
    .startPoint(CGPoint(x: 0, y: 0))
    .endPoint(CGPoint(x: 1, y: 1))
```

支持 Chain 的类型覆盖：`UIView`/`UIButton`/`UILabel`/`UITextField`/`UITextView`/`UIImageView`/`UICollectionView`/`UITableView`/`UIScrollView`/`UIStackView`/`UIViewController`/`CALayer`/`CAAnimation` 系列、`CAGradientLayer`、`MKMapView`、`WKWebView`、`NSAttributedString`、`Date`、`Timer`、`UIEdgeInsets` 等 60+ 类型。

### 手势链式（UIView）

```swift
let view = UIView()
    .dy
    .onTapGestureRecognizer { tap in
        print("单击")
    }
    .onLongPressGestureRecognizer(minimumDuration: 0.5) { press in
        print("长按")
    }
```

> 闭包被内部手势识别器强引用，闭包内使用 `self` 时请加 `[weak self]` 避免循环引用。

### 类型级配置

```swift
UIViewController.dy.do { $0.backgroundColor = .systemRed }   // 配置静态属性
```

---

## 扩展方法（`Sources/Core/Extensions/`）

按系统框架与领域组织，均带 `dy_` 前缀，直接作用于原生类型（无需 `.dy`）：

### UIKit

```swift
UIColor(hex: "#FF5722")                // 3/4/6/8 位 hex（非可选）
UIColor(argbHex: "#80FF5722")          // ARGB（含透明度，可选）
color.dy.alpha(0.5)                    // 透明度
color.dy_random                        // 随机色

let view = UIView()
view.dy.removeAllSubviews()            // 移除所有子视图
view.dy.hideKeyboard()                 // 收起键盘
view.dy_viewController                 // 最近的父控制器
view.dy_allSubviews                    // 递归所有子视图
view.dy_findSubview(ofType: MyView.self)
view.dy_captureScreenshot()            // 截图

label.dy_actualFontSize                // 实际字号
textField.dy_textPublisher             // 见 CombineCocoa

UIFont.dy_font(size: 16, weight: .medium)   // 任意字族（默认苹方），不参与 Dynamic Type
UIFont.dy_font(size: 16, weight: .medium)
    .dy_scaled(forTextStyle: .body)         // 响应系统 Dynamic Type 缩放
```

### Foundation

```swift
object.dy_className                    // "MyViewController"（实例）
MyClass.dy_className                   // "MyClass"（类型）
bundle.dy_appVersion                   // 版本号
date.dy_adding(days: 7)                // 日期运算
data.dy_bytes()                        // Data → [UInt8]
url.dy_appendParameters([...])         // URL 追加参数
```

### Protocols / Stdlib

```swift
[1, 2, 3].dy_average                   // 平均值
array.dy_safe(at: 100)                 // 安全下标，越界返回 nil
array.dy_removeDuplicates()            // 去重（保持顺序）
"hello".dy_uppercased()                // 字符串工具

model.dy_encode()                      // Codable → Data?
model.dy_string()                      // Codable → JSON 字符串
MyModel.dy_decode(from: data)          // Data → Codable
```

### 其他框架

- **CoreGraphics**：`CGPoint`/`CGSize`/`CGRect`/`CGColor`/`CGImage`/`CGAffineTransform` 等
- **QuartzCore**：`CALayer`/`CAGradientLayer`/`CATransform3D`/`CACornerMask` 动画与属性
- **MapKit**：`MKMapView`/`MKCoordinateRegion`/`MKPolyline` 等
- **WebKit**：`WKWebView`/`WKWebViewConfiguration`
- **CoreLocation**：`CLLocation`/`CLGeocoder`/`CLLocationManager` 等
- **AVFAudio**：`AVAudioSession`

---

## 工具类（`Sources/Core/Common/`）

| 类 | 功能 |
|----|------|
| `DyScreen` | 屏幕尺寸、安全区、状态栏/导航栏/标签栏高度、设计稿适配 |
| `DyHelper` | 设备信息（IDFV/IDFA/机型/系统版本/越狱检测等） |
| `DyPath` | 沙盒路径与文件操作 |
| `DyQueue` | 异步调度、防抖、定时器、一次性执行、串行/并发队列 |
| `DyHaptic` | 触觉反馈 |
| `DyPerChecker` | 权限状态查询与请求 |
| `DySymbol` | SF Symbol 便捷创建（单色/分层/调色板/多色） |
| `DyAppearance` | 全局 UI 外观配置 |
| `DySkinManager` | 主题切换观察 |
| `DyViewBuilder` | `@resultBuilder` 声明式子视图组装 |
| `DyScreenCaptureMonitor` | 录屏/投屏检测 |
| `DyPlist` | plist 读写 |
| `DyCreator` | 通用创建工具 |

### 屏幕与适配

```swift
DyScreen.setupSketch(size: CGSize(width: 375, height: 812))  // 设设计稿

16.fitWidth          // 按设计稿宽度等比缩放（Int / CGFloat 均支持）
20.fitHeight         // 按设计稿高度等比缩放
12.fitLarger         // 宽高取较大
8.fitSmaller         // 宽高取较小

DyScreen.screenWidth / screenHeight / screenScale
DyScreen.safeAreaTop / safeAreaBottom
DyScreen.statusBarHeight
DyScreen.navBarTotalHeight          // 状态栏 + 导航栏
DyScreen.tabBarTotalHeight          // 标签栏 + 底部安全区
DyScreen.isCaptured                 // 是否录屏/投屏
```

### 设备信息

```swift
DyHelper.shared.isSimulator
DyHelper.shared.isDebug
DyHelper.shared.isPad / isPhone
DyHelper.shared.isIPhoneXSeries
DyHelper.shared.isJailbroken
DyHelper.shared.identifierForVendor   // IDFV
DyHelper.shared.advertisingIdentifier // IDFA（需授权）
DyHelper.shared.systemVersion
DyHelper.shared.className(Self.self)
```

### 队列与定时器

```swift
DyQueue.shared.debounced(delay: 0.3) { performSearch() }   // 防抖
DyQueue.shared.executeSerially([task1, task2]) { print("完成") }
DyQueue.shared.executeConcurrently([...])
DyQueue.shared.executeOnce(token: "app.init") { setupAnalytics() }
DyQueue.shared.countdownTimer(every: 1.0, times: 5) { _, remaining in }
DyQueue.shared.delayed(1.0) { ... }
```

### 沙盒路径

```swift
DyPath.shared.documentsDirPath
DyPath.shared.cachesDirPath
DyPath.shared.path(in: .caches, ...)        // 或 resolvePath
DyPath.shared.exists(at: path)
DyPath.shared.createFile(at: path)
DyPath.shared.remove(at: path)
```

### 触觉反馈

```swift
DyHaptic.shared.lightImpact()
DyHaptic.shared.mediumImpact()
DyHaptic.shared.heavyImpact()
DyHaptic.shared.rigidImpact()
DyHaptic.shared.softImpact()
DyHaptic.shared.selectionChanged()
DyHaptic.shared.notification(.success)
DyHaptic.shared.haptic(.medium, style: .rigid)   // 自定义强度
```

### 权限管理

```swift
DyPerChecker.shared.checkStatus(for: .camera)   // 查询状态
DyPerChecker.shared.request(.photoLibrary) { result in
    switch result {
    case .authorized:     loadPhotos()
    case .denied:         showSettingsAlert()
    }
}
// 便捷方法：checkCamera / requestCamera / checkMicrophone / requestLocation ...
```

### SF Symbol

```swift
DySymbol.monochrome("star.fill", size: 24, weight: .semibold)
DySymbol.hierarchical("star.fill", ...)
DySymbol.palette("star.fill", colors: [.yellow, .orange], ...)
DySymbol.multicolor("star.fill", ...)
```

### 声明式视图构建（`@DyViewBuilder`）

```swift
let container = UIView()
container.dy.addSubviews(
    DyViewBuilder.buildBlock(
        UILabel(),
        UIButton(type: .system),
        showImage ? UIImageView() : nil
    )
)
```

---

## 属性包装器（`@DyDataStore`）

用 `UserDefaults` 存储属性，自动处理原生类型与 `Codable` 的编解码：

```swift
@DyDataStore("userName", default: "")
var userName: String

@DyDataStore("lastVisit", default: nil)
var lastVisit: Date?          // Codable 自动 JSON 编解码

$userName.remove()            // 删除存储值
```

支持原生类型（`Bool`/`Int`/`Float`/`Double`/`String`/`Date`/`Data`/`Array`/`Dictionary`）与任意 `Codable` 类型；不支持的类型会报错并清理。

---

## CombineCocoa（`import DyCombineCocoa`）

UIKit 事件封装为 Combine `Publisher`/`ControlProperty`，可用 `sink` 订阅、`assign`/`bind` 写回：

```swift
// 属性流（可读可写）
textField.dy_textPublisher
textField.dy_attributedTextPublisher
label.dy_textPublisher
switchView.dy_isOnPublisher
slider.dy_valuePublisher
stepper.dy_valuePublisher
segmented.dy_selectedSegmentIndexPublisher

// 事件流
button.dy_tapPublisher               // ControlEvent<Void>
control.dy_valueChangedPublisher

// 手势
view.dy_tapGesturePublisher
view.dy_longPressGesturePublisher
view.dy_panGesturePublisher
view.dy_swipeGesturePublisher(.left)
view.dy_pinchGesturePublisher
view.dy_rotationGesturePublisher
view.dy_screenEdgePanGesturePublisher

// 滚动
scrollView.dy_didScrollPublisher
scrollView.dy_willBeginDraggingPublisher
scrollView.dy_didEndDeceleratingPublisher
```

双向绑定：

```swift
// 订阅
textField.dy_textPublisher
    .sink { print("text: \($0 ?? "")") }
    .store(in: &cancellables)

// 写回 / 绑定
label.dy_textPublisher.bind(from: viewModel.titlePublisher)
```

---

## Logger（`import DyLogger`）

5 级日志，可插拔输出目标（控制台 / 文件）：

```swift
DyLogger.shared.addDestination(DyConsoleDestination())

if let fileDest = DyFileDestination(filePath: logPath) {
    DyLogger.shared.addDestination(fileDest)
}

DyLogger.shared.debug("调试")
DyLogger.shared.info("加载完成")
DyLogger.shared.warn("超时")
DyLogger.shared.error("解析失败")
DyLogger.shared.fatal("致命错误")

DyLogger.shared.minimumLevel = .warn   // 生产环境只输出 warn 及以上

// 全局便捷函数
dy_logInfo("数据加载完成")
dy_logError("解析失败")
```

---

## 设计原则

- **不污染原生类型** — 实例方法通过 `.dy` 命名空间（`DyWrapper`）隔离，工具类走 `DyXxx.shared` 单例。
- **链式调用** — Chain setter 返回 `DyWrapper`，支持连续配置；引用类型可省略 `.build()`。
- **双入口** — 实例 `object.dy` 与类型 `Type.dy`（配置静态/类属性）。
- **值类型安全** — `.with` 返回副本，不改原值。
- **健壮回退** — 字体字族、资源加载等不可用时优雅回退，不 crash。
- **iOS 13+** — 兼容旧设备，同时适配 iOS 16+ Scene API。

## 目录结构

```
Sources/
├── Dy/                  # 聚合模块入口（@_exported 重导出）
├── Core/
│   ├── Chain/           # 链式 API（UIKit/Foundation/QuartzCore/MapKit/WebKit...）
│   ├── Common/          # 工具类（DyScreen/DyHelper/DyPath/DyQueue...）
│   ├── Extensions/      # dy_ 前缀扩展（按框架组织）
│   ├── Protocols/       # DyExtension/DyReusable/DyLoadable/DySetupable
│   ├── Wrapper/         # @DyDataStore
│   └── Core.swift
├── CombineCocoa/        # Combine + UIKit 事件
└── Logger/              # DyLogger + 输出目标
```

## 协议

- `DyExtension` — 命名空间协议，所有扩展的基础（`.dy` 入口）
- `DyReusable` — 自动生成复用标识符（`dy_identifier`）
- `DyLoadable` — 从 XIB/Storyboard 加载
- `DySetupable` — MVVM 配置生命周期

## License

Apache 2.0
