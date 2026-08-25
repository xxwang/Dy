# Dy

轻量级 Swift 扩展工具库 — 基于 `DyWrapper` 命名空间模式，为 UIKit、Foundation、CoreGraphics 等提供 `.dy.` 链式 API，不污染原生类型。

```swift
// 一行引入全部模块（DyCore + DyComponent + DyTemplate + DyCombineCocoa + DyLogger）
import Dy

// 链式配置 UIView
let view = UIView()
    .dy   
    .backgroundColor(.white)
    .cornerRadius(8)
    .masksToBounds(true)
    .build()

// UIColor 便捷初始化
let color = UIColor(hex: "#FF5722")

// UserDefaults 属性包装器
@DyDataStore("userName", default: "")
var userName: String
```

## 安装

Swift Package Manager：

```swift
// Package.swift
.package(url: "https://github.com/xxwang/Dy.git", branch: "main")

// Xcode: File → Add Package Dependency → 输入仓库 URL
```

## 模块选择

`import Dy` 会自动重导出全部子模块，是推荐的一站式导入方式。按需也可以只导入子模块：

| 导入 | 包含 | 适用场景 |
|------|------|----------|
| `import Dy` | DyCore + DyComponent + DyTemplate + DyCombineCocoa + DyLogger | **推荐，一站式引入** |
| `import DyTemplate` | DyCore + DyComponent | 链式 API + 组件 + MVVM 脚手架 |
| `import DyComponent` | DyCore + 组件 | 只需组件 |
| `import DyCore` | 核心扩展 + 工具类 | 最轻量 |
| `import DyLogger` | 日志系统 | 独立日志 |
| `import DyCombineCocoa` | Combine + UIKit 事件封装 | Combine 场景 |

---

## 功能目录

### 链式 API 核心

所有扩展方法通过 `.dy` 命名空间访问，每个 setter 返回 `DyWrapper` 实例，支持链式调用。引用类型（UIView 等）可省略 `.build()`。

```swift
// UIView 链式配置
let view = UIView()
    .dy    
    .backgroundColor(.white)
    .cornerRadius(8)
    .masksToBounds(true)
    .build()

// UIButton
let button = UIButton(type: .system)
    .dy    
    .title("提交", for: .normal)
    .titleColor(.white, for: .normal)
    .build()

// UILabel
let label = UILabel()
    .dy    
    .text("标题")
    .font(.boldSystemFont(ofSize: 18))
    .textAlignment(.center)
    .build()
```

值类型（`Array`、`CGRect`、`UIColor` 等）上的非链式工具方法同样位于 `.dy` 命名空间，例如 `array.dy.safe(at: 100)`、`color.dy.toHexString()`。

### 声明式视图构建

`@DyViewBuilder` 风格的子视图组装：

```swift
let container = UIView {
    UILabel()
        .dy        
        .text("你好")
        .font(.systemFont(ofSize: 16))
        .build()
    UIButton(type: .system)
        .dy        
        .title("点击", for: .normal)
        .build()
    if showImage {
        UIImageView(image: UIImage(systemName: "star"))
    }
}
```

### UserDefaults 属性包装器

`@DyDataStore` 自动处理原生类型 + Codable 类型的存取：

```swift
@DyDataStore("userName", default: "")
var userName: String

@DyDataStore("lastVisit", default: nil)
var lastVisit: Date?  // Codable 类型自动 JSON 编解码

$userName.remove()  // 删除存储值
```

### 颜色工具

```swift
UIColor(hex: "#FF5722")               // 3/4/6/8 位 hex
UIColor(r: 255, g: 87, b: 34)         // 0-255 RGB
UIColor(light: .white, dark: .black)  // 深浅模式动态色
UIColor(hex: 0xFF5722)                // Int hex
UIColor.dy.random                   // 随机色
color.dy.toHexString()              // → "#FF5722"
```

### 屏幕适配

基于设计稿自动计算适配比例：

```swift
DyScreen.setupSketch(size: CGSize(width: 375, height: 812))

16.fitWidth      // 按设计稿宽度等比缩放（Int / CGFloat 均支持）
20.fitHeight     // 按设计稿高度等比缩放

DyScreen.screenWidth     // 当前屏幕宽
DyScreen.safeAreaTop     // 安全区顶部
DyScreen.statusBarHeight // 状态栏高
DyScreen.navBarTotalHeight  // 状态栏 + 导航栏
```

### 设备信息

```swift
DyHelper.shared.isSimulator           // 是否模拟器
DyHelper.shared.isDebug               // 是否 DEBUG
DyHelper.shared.isPad / isPhone       // 设备类型
DyHelper.shared.isIPhoneXSeries       // 全面屏
DyHelper.shared.identifierForVendor   // IDFV
DyHelper.shared.advertisingIdentifier // IDFA（需授权）
DyHelper.shared.systemVersion         // 系统版本号
```

### 日志系统

5 级日志，可插拔输出目标：

```swift
// 添加控制台输出
DyLogger.shared.addDestination(DyConsoleDestination())

// 添加文件输出（filePath 无效时 init 返回 nil）
if let fileDest = DyFileDestination(filePath: logPath) {
    DyLogger.shared.addDestination(fileDest)
}

// 记录日志
DyLogger.shared.debug("调试信息")
DyLogger.shared.info("数据加载完成")
DyLogger.shared.warn("网络请求超时")
DyLogger.shared.error("解析失败")
DyLogger.shared.fatal("致命错误")

// 生产环境调高级别
DyLogger.shared.minimumLevel = .warn  // 只输出 warn 及以上
```

### 触觉反馈

```swift
DyHaptic.shared.lightImpact()         // 轻量
DyHaptic.shared.mediumImpact()        // 中等（最常用）
DyHaptic.shared.heavyImpact()         // 强力
DyHaptic.shared.rigidImpact()         // 刚性
DyHaptic.shared.notification(.success) // 通知反馈
```

### 权限管理

统一入口，一劳永逸：

```swift
// 查询状态
let status = DyPerChecker.shared.checkStatus(for: .camera)

// 请求权限
DyPerChecker.shared.request(.photoLibrary) { result in
    switch result {
    case .authorized:     loadPhotos()
    case .denied:           showSettingsAlert()
    }
}
```

### 队列与定时器

```swift
// 防抖（搜索框输入）
let debouncedSearch = DyQueue.shared.debounced(delay: 0.3) {
    performSearch()
}

// 串行任务
DyQueue.shared.executeSerially([task1, task2, task3]) {
    print("全部完成")
}

// 倒计时
DyQueue.shared.countdownTimer(every: 1.0, times: 5) { _, remaining in
    print("剩余 \(remaining) 秒")
}

// 一次性执行
DyQueue.shared.executeOnce(token: "app.init") {
    setupAnalytics()
}
```

### 沙盒路径

```swift
DyPath.shared.documentsPath           // Documents 目录
DyPath.shared.cachesPath              // Caches 目录
DyPath.shared.path(inDocuments: "data/config.json")  // 子路径
DyPath.shared.createFile(at: path)    // 创建空文件
DyPath.shared.exists(at: path)        // 路径是否存在
```

### NSObject / KVO

```swift
object.dy.className       // "MyViewController"
MyViewController.dy.className  // 类型级类名
```

### NSAttributedString

```swift
let range = attributedString.dy.nsRange(of: "Hello")  // 查找子串范围
let size = attributedString.dy.size(maxWidth: 200)    // 计算尺寸
let mutable = attributedString.dy.toMutable()         // 转可变
```

### Codable 快捷操作

```swift
let data = myModel.dy.encode()              // 编码为 Data?
let string = myModel.dy.toString()          // 编码为 JSON 字符串
let model = MyModel.dy.decode(from: data)   // 从 Data 解码
```

### Collection 扩展

```swift
// 安全访问
array.dy.safe(at: 100)         // nil 而不是 crash

// 随机元素 / 条件移除
array.dy.removeRandomElement() // 随机移除并返回元素
array.dy.removeFirst(where:)   // 移除第一个匹配元素
array.dy.removeDuplicates()    // 去重（保持首次出现顺序）

// 旋转
array.dy.rotated(by: 1)        // 返回右旋 1 位的新数组
array.dy.rotate(by: -1)        // 原地左旋 1 位
```

### UIView 视图操作

```swift
view.dy.captureScreenshot()           // 截图 → UIImage?
view.dy.removeAllSubviews()           // 移除所有子视图
view.dy.addSubviews([v1, v2])         // 批量添加
view.dy.fadeIn()                      // 淡入动画
view.dy.fadeOut()                     // 淡出动画
view.dy.shake()                       // 抖动动画
view.dy.hideKeyboard()                // 收起键盘
view.dy.addShadow()                   // 添加阴影
```

### UITableView / UICollectionView 简化

```swift
// 注册 + 复用（类型安全）
tableView.dy.register(withCellClass: MyCell.self)
let cell = tableView.dy.dequeueReusableCell(withCellClass: MyCell.self, for: indexPath)

// CollectionView
collectionView.dy.register(withCellClass: MyCell.self)
let cell = collectionView.dy.dequeueReusableCell(withCellClass: MyCell.self, for: indexPath)
```

### 视图加载

```swift
// 从 XIB 加载
let view = MyView.loadView()

// 从 Storyboard 加载
let vc = MyViewController.loadViewController(from: "Main")
```

### Combine 事件（DyCombineCocoa）

```swift
// 属性事件流
textField.dy_textPublisher          // 输入变化
switchView.dy_isOnPublisher         // 开关变化
button.dy_tapPublisher              // 点击事件（见 UIControl+Combine）

// 手势事件
view.dy_tapGesturePublisher
view.dy_longPressGesturePublisher
```

---

## 完整可用工具类

| 类 | 功能 |
|----|------|
| `DyScreen` | 屏幕尺寸、安全区、适配比例 |
| `DyHelper` | 设备信息、IDFV/IDFA、系统版本 |
| `DyPath` | 沙盒路径管理、文件操作 |
| `DyQueue` | 异步调度、防抖、定时器、一次性执行 |
| `DyHaptic` | 触觉反馈 |
| `DyPerChecker` | 权限状态查询与请求 |
| `DyLogger` | 5 级日志 + 可插拔输出 |
| `DyPlist` | plist 文件读写 |
| `DySymbol` | SF Symbol 便捷创建 |
| `DyAppearance` | 全局 UI 外观配置 |
| `DySkinManager` | 主题切换观察 |
| `DyViewBuilder` | 声明式子视图组装 |
| `DyDataStore` | @propertyWrapper UserDefaults 存取 |

---

## Template 基类 (MVVM 脚手架)

`import DyTemplate` 后可用：

| 控制器 | 视图 | 数据层 |
|--------|------|--------|
| `DyViewController` | `DyView` | `DyViewModel` |
| `DyNavigationController` | `DyLabel` | `DyModel` |
| `DyTabBarController` | `DyButton` | `DyRepository` |
| `DyTableViewController` | `DyImageView` | |
| `DyCollectionViewController` | `DyTextField` | |
| `DyScrollViewController` | `DyTableViewCell` | |
| `DyWebViewController` | `DyCollectionViewCell` | |
| `DySheetViewController` | `DyCollectionReusableView` | |
| `DyBubbleViewController` | `DyControl` | |
| | `DyTabBar` | |

容器：`DyAlertView`（弹窗）、`DySheetView`（底部面板）

---

## 设计原则

- **不污染原生类型** — 实例扩展通过 `.dy` 命名空间（`DyWrapper`）隔离，类工具走 `DyXxx.shared`
- **链式调用** — setter 返回 `DyWrapper`，支持连续配置，引用类型可省略 `.build()`
- **明确错误** — Debug 用 `assertionFailure`，Release 可控 crash
- **iOS 13+** — 兼容旧设备，同时适配 iOS 16+ Scene API

---

## 协议

- `DyExtension` — 命名空间协议，所有扩展的基础
- `DyLoadable` — 从 XIB/Storyboard 加载
- `DyReusable` — 自动生成复用标识符
- `DySetupable` — MVVM 配置生命周期 (setupUI → bindEvents → bindViewModel → fetchData → updateUI)

## License

Apache 2.0
