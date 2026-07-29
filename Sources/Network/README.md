# DyNetwork

> 基于 [Alamofire](https://github.com/Alamofire/Alamofire) 的轻量网络层，借鉴 Moya 的 `TargetType` / `Plugin` 设计，**零 Moya 依赖**。
> 提供 **async/await** 与 **Combine** 两套相互独立的使用方式，内置全局配置、业务码解析、插件系统、文件上传/下载、防重复请求与调试 stub。
> 最低支持 **iOS 13**，依赖 Alamofire 5.12。

---

## 特性一览

- **接口集中定义**：用 `enum` 遵从 `DyEndpoint`，编译期拦住拼错路径 / 漏参数等低级错误。
- **两套互不相干的 API**：Combine（`DyNet+Combine`）与 async/await（`DyNet+Concurrency`），不混用 RxSwift 分支。
- **泛型模型回调**：`as:`（响应体即模型）与 `biz:`（业务码 `data` 字段）两种解码，直接拿到模型实例。
- **全局配置单例** `DyNetConfig`：多环境、全局头/参、超时、成功业务码，运行时可切。
- **插件系统** `DyNetPlugin`：鉴权头注入、日志、全局 Loading 计数等横切关注点抽离。
- **常用功能齐全**：上传（`.uploadMultipart`）、下载（`download` / `downloadPublisher`）、防重复请求（指纹去重）、调试 stub。
- **刻意不校验 HTTP 状态码**：4xx/5xx 仍走 success，由调用方按 `statusCode` 自行决策（见末尾设计说明）。

---

## 1. 定义接口（`DyEndpoint`）

```swift
import DyNetwork
import Alamofire

// 与后端约定的数据模型
struct User: Decodable {
    let id: Int
    let name: String
}

struct LoginForm: Encodable {
    let phone: String
    let code: String
}

// 后端约定 { code, message, data }，data 内部是列表
struct UserList: Decodable {
    let list: [User]
}

enum UserAPI {
    case profile
    case login(LoginForm)
    case uploadAvatar
    case downloadAvatar
}

extension UserAPI: DyEndpoint {
    // baseURL 默认从 DyNetConfig.shared 读取，这里可显式覆盖（如支付域名）
    var baseURL: URL { DyNetConfig.shared.baseURL }

    var path: String {
        switch self {
        case .profile:        return "/user/profile"
        case .login:          return "/user/login"
        case .uploadAvatar:   return "/user/avatar"
        case .downloadAvatar: return "/user/avatar/file"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .profile, .downloadAvatar: return .get
        case .login, .uploadAvatar:     return .post
        }
    }

    // 请求任务：决定这次请求“带什么”
    var task: DyTask {
        switch self {
        case .profile, .downloadAvatar:
            return .plain
        case let .login(form):
            return .json(form)                       // Encodable 直接作为 JSON 体
        case .uploadAvatar:
            return .uploadMultipart { form in        // 文件上传
                if let data = UIImage(named: "avatar")?.jpegData(compressionQuality: 0.8) {
                    form.append(data, withName: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
                }
            }
        }
    }

    var headers: HTTPHeaders { HTTPHeaders() }       // 默认空，全局头会自动注入
    var sampleData: Data { Data() }                  // stub 调试用样例（见第 10 节）
}
```

`DyTask` 的四种取值：

| 取值 | 含义 |
|---|---|
| `.plain` | 无参请求 |
| `.parameters(parameters:encoding:)` | 普通参数，配合 `URLEncoding` / `JSONEncoding` 等 |
| `.json(Encodable)` | 将 `Encodable` 作为 JSON 请求体（最常用） |
| `.uploadMultipart((MultipartFormData) -> Void)` | 上传 multipart 表单 |

---

## 2. 配置全局参数（`DyNetConfig`）

建议在 App 启动时于主线程完成初始配置：

```swift
let config = DyNetConfig.shared
config.setup(environment: .production, baseURL: URL(string: "https://api.example.com")!)
config.timeout = 15                       // 默认超时（秒）；接口可单独用 requestTimeout 覆盖
config.successCode = 200                  // 业务成功码，供 mapBusiness 默认判定
config.updateGlobalHeaders(HTTPHeaders(["Authorization": "Bearer \(token)"]))

// 登录后刷新 token
config.updateGlobalHeaders(HTTPHeaders(["Authorization": "Bearer \(newToken)"]))
// config.removeGlobalHeader("Authorization")
// config.clearGlobalHeaders()

// 全局参数（仅合并进 .parameters 任务，接口参数覆盖同名项）
config.updateGlobalParameters(["appVersion": "1.0.0"])

// 切成测试环境
config.setup(environment: .testing, baseURL: URL(string: "https://test.api.example.com")!)
```

> 登录接口通常**不应带旧 token**，可在 `DyEndpoint` 里把 `ignoresGlobalHeaders` 返回 `true`。

---

## 3. 发起请求

### 3.1 async/await

```swift
// 便捷共享实例（无插件）；需要插件时自建（见第 8 节）
let net = DyNet.shared

// 原始响应：自行处理 body
let resp = try await net.request(UserAPI.profile)
let rawText = resp.string              // 响应文本（调试用）
print(resp.statusCode)                 // HTTP 状态码（始终可见）

// 泛型：响应体本身就是模型
let user: User = try await net.request(UserAPI.profile, as: User.self)

// 泛型：响应体是 { code, message, data }，直接取 data
let users: UserList = try await net.request(UserAPI.login(form), biz: UserList.self)

// 无 data 的业务接口：用 DyEmpty 占位
let _: DyEmpty = try await net.request(UserAPI.login(form), biz: DyEmpty.self)
```

### 3.2 Combine

```swift
import Combine

// 原始响应订阅（Output == DyResponse 时可用 sinkDy 简化样板）
let c1 = net.requestPublisher(UserAPI.profile)
    .sinkDy { response in
        print(response.statusCode)
    } receiveError: { error in
        print(error.localizedDescription)
    }

// 泛型：响应体即模型
let c2 = net.publisher(UserAPI.profile, as: User.self)
    .sink(receiveCompletion: { completion in
        if case let .failure(e) = completion { print(e) }
    }, receiveValue: { (user: User) in
        print(user.name)
    })

// 泛型：业务码 data 模型
let c3 = net.publisher(UserAPI.login(form), biz: UserList.self)
    .sink(receiveCompletion: { _ in }, receiveValue: { (list: UserList) in
        print(list.list.count)
    })
```

> `sinkDy(receiveValue:receiveError:)` 仅适用于 `AnyPublisher<DyResponse, DyNetError>`（即 `requestPublisher`）。
> 泛型 `publisher(as:)` / `publisher(biz:)` 返回 `AnyPublisher<T, DyNetError>`，用常规 `.sink` 即可。

---

## 4. 泛型模型回调：`as:` vs `biz:`

| 标签 | 响应体结构 | 解码目标 |
|---|---|---|
| `as:` | 直接就是模型（如 `{"id":1,"name":"Tom"}`） | `T` |
| `biz:` | 业务码包裹 `{code,message,data}` | `data` 里的 `T` |

```swift
// as：body 即 User
let u: User = try await net.request(api, as: User.self)

// biz：body 是 {code,message,data}，data 即 UserList
let l: UserList = try await net.request(api, biz: UserList.self)
```

---

## 5. 业务码包裹（`DyBizResponse` / `DyEmpty`）

后端若约定 `{ "code": 200, "message": "ok", "data": {...}, "timestamp": 123 }`，
可用 `biz:` 自动解析并按 `successCode` 判定成败：

- 业务码非零 → 抛 `DyNetError.business(code:message:)`
- 业务成功但 `data` 为空 → 抛 `DyNetError.emptyResponseData`

也可手动解析原始 `DyResponse`：

```swift
let resp = try await net.request(api)
let wrapper = try resp.mapBusiness(UserList.self)        // 等价于 biz:，默认 successCode
// 或显式指定成功码：
let wrapper2 = try resp.mapBusiness(UserList.self, successCode: 0)
// 或只拿原始模型（不校验业务码）：
let raw = try resp.map(UserList.self)
```

`DyBizResponse<T>` 字段：`code` / `message` / `data` / `timestamp`，以及 `isSuccess`。
无 data 的接口用 `DyEmpty` 占位：`let _: DyEmpty = try resp.mapBusiness(DyEmpty.self)`。

---

## 6. 上传

上传通过 `DyEndpoint.task = .uploadMultipart` 声明（见第 1 节示例），随后像普通请求一样发起：

```swift
// 上传走普通请求入口，框架内部自动走 Alamofire 的 UploadRequest
let _: DyEmpty = try await net.request(UserAPI.uploadAvatar, biz: DyEmpty.self)
```

---

## 7. 下载

下载复用 `DyEndpoint.task`（`.plain` / `.parameters`），落盘到指定路径或系统临时目录。

```swift
// async/await
let (resp, fileURL) = try await net.download(
    UserAPI.downloadAvatar,
    to: localDestinationURL,            // 为 nil 时由系统决定临时位置
    progress: { p in print("进度", p) } // 0~1
)
print("已保存到", fileURL)

// Combine
let c = net.downloadPublisher(
    UserAPI.downloadAvatar,
    to: localDestinationURL,
    progress: { p in print(p) }
).sink(receiveCompletion: { _ in },
       receiveValue: { (resp, fileURL) in print(fileURL) })
```

> 下载场景的 `DyResponse.data` 为空，文件以 `URL` 形式随响应一起返回。

---

## 8. 插件（`DyNetPlugin`）

插件用于把「鉴权头注入、日志、Loading 计数、统一报错」等横切逻辑从业务里抽离。
所有方法都有空默认实现，按需重写即可：

```swift
public protocol DyNetPlugin: Sendable {
    func prepare(_ request: URLRequest, endpoint: DyEndpoint) -> URLRequest
    func willSend(_ request: Request, endpoint: DyEndpoint)
    func didReceive(_ result: Result<DyResponse, DyNetError>, endpoint: DyEndpoint)
}
```

**内置插件：**

```swift
// 日志插件：用 os_log 打印请求/响应概要
let logger = DyLoggerPlugin()

// 全局 Loading 计数插件：每次发出 +1，收到响应 -1
let counter = DyLoadingCounter { inFlight in
    UIApplication.shared.isNetworkActivityIndicatorVisible = inFlight > 0
}
let loading = DyLoadingPlugin(counter: counter)

// 带插件的网络实例（共享实例 DyNet.shared 不带插件）
let net = DyNet(plugins: [logger, loading])
```

**自定义插件示例（统一注入/刷新签名）：**

```swift
struct SignPlugin: DyNetPlugin {
    func prepare(_ request: URLRequest, endpoint: DyEndpoint) -> URLRequest {
        var req = request
        req.setValue("\(Int(Date().timeIntervalSince1970))", forHTTPHeaderField: "X-Timestamp")
        return req
    }
}
```

---

## 9. 防重复请求（指纹去重）

连点按钮可能发出重复请求。开启 `trackInflights` 后，相同 `method + url + body` 指纹的并发请求会复用同一个底层 Alamofire 请求（Alamofire 支持在同一请求上追加多个 `responseData`）。上传任务不参与去重。

```swift
let net = DyNet(trackInflights: true)
```

---

## 10. 调试 Stub（`DyStub`）

单元测试 / 界面联调时，可让接口直接返回 `sampleData`，跳过真实网络：

```swift
let net = DyNet(stubClosure: { _ in .delayed(seconds: 1) })
// .never      —— 走真实网络（默认）
// .immediate  —— 立即返回
// .delayed(seconds: 1) —— 延迟 1 秒返回，模拟网络耗时
```

> stub 返回的内容来自 `DyEndpoint.sampleData`（默认空 `Data`）。要给 stub 返回有意义的 JSON，记得在接口里实现 `var sampleData: Data`。

---

## 11. 错误处理（`DyNetError`）

只有**传输层失败**（无网、超时、TLS 等）才会走 `DyNetError`；HTTP 4xx/5xx 仍作为正常 `DyResponse` 返回（见设计说明）。

```swift
do {
    let user: User = try await net.request(UserAPI.profile, as: User.self)
    // ...
} catch let error as DyNetError {
    switch error {
    case let .business(code, message):
        print("业务失败", code, message)
    case .emptyResponseData:
        print("响应成功但无 data")
    case let .decodeFailure(e):
        print("解析失败", e)
    case let .underlying(e):            // Alamofire 底层错误
        print("网络失败", e)
    case let .encodeFailure(e):
        print("参数编码失败", e)
    case let .message(text):
        print(text)
    default:
        break
    }
}
```

可错误类型：`invalidURL` / `encodeFailure` / `underlying` / `network` / `message` / `business(code:message:)` / `emptyResponseData` / `decodeFailure`。

---

## 12. 设计说明：为什么不校验 HTTP 状态码

按设计，**无论 2xx 还是 4xx/5xx，只要传输成功就进入 success**，错误以 `DyResponse` 形式返回，由调用方自行根据 `statusCode` 决策（如 401 跳登录）。
只有连接层失败（无网 / 超时 / TLS）才抛 `DyNetError`。

这与 Moya 的默认行为一致，也避免了“HTTP 层与业务层双重失败”的困扰。与此**不冲突**的是：业务码校验（`mapBusiness` / `biz:`）校验的是 **body 内的业务 `code`**，而非 HTTP 状态码，且为可选（opt-in）。

```swift
let resp = try await net.request(api)
switch resp.statusCode {
case 200...299: /* 成功 */ break
case 401:       /* 跳登录 */ break
default:        /* 其它 */ break
}
```
