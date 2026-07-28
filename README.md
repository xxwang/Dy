# Dy

轻量级 Swift 扩展工具库 — 为 UIKit、Foundation、CoreGraphics 等提供 `dy_` 前缀的扩展方法，不污染原生类型。

```swift
import DyTemplate  // 一行引入全部模块（DyCore + DyComponent + DyLogger）

// 链式配置 UIView
view
    .dy_backgroundColor(.white)
    .dy_cornerRadius(8)
    .dy_masksToBounds(true)

// UIColor 便捷初始化
let color = UIColor(hex: "#FF5722")

// UserDefaults 属性包装器
@DyStoreWrapper("userName", default: "")
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

DyTemplate 会自动重导出 DyCore + DyComponent + DyLogger，是推荐的一站式导入方式。按需也可以只导入子模块：

| 导入 | 包含 | 适用场景 |
|------|------|----------|
| `import DyTemplate` | DyCore + DyComponent + DyLogger | **推荐，一站式引入** |
| `import DyComponent` | DyCore + 导航栏等组件 | 只需组件 |
| `import DyCore` | 核心扩展 + 工具类 | 最轻量 |
| `import DyLogger` | 日志系统 | 独立日志 |

---

## 功能目录

### 链式 API 核心

所有扩展方法使用 `dy_` 前缀，每个 setter 返回 `Self`，支持 `.` 链式调用。

```swift
// UIView 链式配置
view
    .dy_backgroundColor(.white)
    .dy_cornerRadius(8)
    .dy_masksToBounds(true)

// UIButton
button
    .dy_title("提交", for: .normal)
    .dy_titleColor(.white, for: .normal)

// UILabel
label
    .dy_text("标题")
    .dy_font(.boldSystemFont(ofSize: 18))
    .dy_textAlignment(.center)
```

### 工厂方法

一行创建预配置好的 UIKit 组件：

```swift
let tableView = UITableView.dy_tableView()        // grouped 样式 + 一键配置
let collectionView = UICollectionView.dy_vCollectionView()  // 垂直滚动
let scrollView = UIScrollView.dy_scrollView()     // 隐藏指示器
let textView = UITextView.dy_textView()            // 隐藏滚动条
let webView = WKWebView.dy_webView()              // 默认配置
```

### 声明式视图构建

`@resultBuilder` 风格的子视图组装：

```swift
let container = UIView {
    UILabel()
        .dy_text("你好")
        .dy_font(.systemFont(ofSize: 16))
    UIButton(type: .system)
        .dy_title("点击", for: .normal)
    if showImage {
        UIImageView(image: UIImage(systemName: "star"))
    }
}
```

### UserDefaults 属性包装器

自动处理原生类型 + Codable 类型的存取：

```swift
@DyStoreWrapper("userName", default: "")
var userName: String

@DyStoreWrapper("lastVisit", default: nil)
var lastVisit: Date?  // Codable 类型自动 JSON 编解码

$userName.remove()  // 删除存储值
```

### 颜色工具

```swift
UIColor(hex: "#FF5722")               // 3/4/6/8 位 hex
UIColor(r: 255, g: 87, b: 34)         // 0-255 RGB
UIColor(light: .white, dark: .black)  // 深浅模式动态色
UIColor(hex: 0xFF5722)                // Int hex
UIColor.dy_random                      // 随机色
color.dy_toHexString()                 // → "#FF5722"
```

### 屏幕适配

基于设计稿自动计算适配比例：

```swift
DyScreen.setupSketch(size: CGSize(width: 375, height: 812))

16.fitWidth      // 按设计稿宽度等比缩放
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

// 添加文件输出
if let fileDest = DyFileDestination(filePath: logPath) {
    DyLogger.shared.addDestination(fileDest)
}

// 全局函数
dy_logDebug("调试信息")
dy_logInfo("数据加载完成")
dy_logWarn("网络请求超时")
dy_logErr("解析失败")
dy_logFatal("致命错误")

// 生产环境调高级别
DyLogger.shared.minimumLevel = .warn  // 只输出 warn 及以上
```

### 触觉反馈

```swift
DyHaptic.shared.lightImpact()         // 轻量
DyHaptic.shared.mediumImpact()        // 中等（最常用）
DyHaptic.shared.heavyImpact()         // 强力
DyHaptic.shared.selectionChanged()    // 选择变化
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
object.dy_className       // "MyViewController"
object.dy_fullClassName   // "App.MyViewController"
```

### NSAttributedString

```swift
let range = attributedString.dy_NSRange(of: "Hello")  // 查找子串范围
let size = attributedString.dy_size(maxWidth: 200)     // 计算尺寸
let mutable = attributedString.dy_toMutable()          // 转可变
```

### Codable 快捷操作

```swift
let jsonData = myModel.dy_jsonData()          // 编码为 Data
let jsonString = myModel.dy_jsonString()      // 编码为 JSON 字符串
let model = MyModel.dy_from(jsonData: data)   // 从 Data 解码
```

### Collection 扩展

```swift
// 安全下标
array[dy_safe: 100]          // nil 而不是 crash
array.dy_randomElement()     // 随机元素
array.dy_removeFirst(where:) // 条件移除

// Dictionary
dict.dy_jsonString()         // 转 JSON 字符串
"key=1&name=test".dy_urlParameters  // ["key": "1", "name": "test"]
```

### UIView 视图操作

```swift
view.dy_snapshot()           // 截图 → UIImage?
view.dy_removeAllSubviews()  // 移除所有子视图
view.dy_addSubviews([v1, v2]) // 批量添加
view.dy_fadeIn(duration: 0.3) // 淡入动画
view.dy_fadeOut(duration: 0.3) // 淡出动画
```

### UITableView / UICollectionView 简化

```swift
// 注册 + 复用
tableView.dy_register(MyCell.self)
let cell = tableView.dy_dequeueReusableCell(MyCell.self, for: indexPath)

// CollectionView
collectionView.dy_register(MyCell.self)
let cell = collectionView.dy_dequeueReusableCell(MyCell.self, for: indexPath)
```

### 视图加载

```swift
// 从 XIB 加载
let view = MyView.loadView()

// 从 Storyboard 加载
let vc = MyViewController.loadViewController(from: "Main")
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
| `DyStoreWrapper` | @propertyWrapper UserDefaults |

---

## Template 基类 (MVVM 脚手架)

`import DyTemplate` 后可用：

| 控制器 | 视图 | 数据层 |
|--------|------|--------|
| `DyViewController` | `DyView` | `DyViewModel` |
| `DyNavigationController` | `DyLabel` | `DyModel` |
| `DyTabBarController` | `DyButton` | `DyDataModel` |
| `DyTableViewController` | `DyImageView` | `DyRepository` |
| `DyCollectionViewController` | `DyTextField` | |
| `DyScrollViewController` | `DyTableViewCell` | |
| `DyWebViewController` | `DyCollectionViewCell` | |
| `DySheetViewController` | `DyTabBar` | |
| `DyBubbleViewController` | `DyControl` | |

容器：`DyAlertView`（弹窗）、`DySheetView`（底部面板）

---

## 设计原则

- **不污染原生类型** — 扩展方法统一 `dy_` 前缀
- **链式调用** — setter 返回 `Self`，支持连续配置
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
