import UIKit
import WebKit

// MARK: - UIView
@objc extension UIView {
    /// 创建一个默认配置的 `UIView` 实例
    open class func view() -> UIView {
        return UIView()
    }
}

// MARK: - UIStackView
@objc extension UIStackView {
    /// 创建一个水平布局的 `UIStackView`,默认对齐方式为 `.fill`,分布方式为 `.equalSpacing`
    open class func hStackView() -> UIStackView {
        return UIStackView()
            .dy
            .axis(.horizontal)
            .alignment(.fill)
            .distribution(.equalSpacing)
            .build()
    }

    /// 创建一个垂直布局的 `UIStackView`,默认对齐方式为 `.fill`,分布方式为 `.equalSpacing`
    open class func vStackView() -> UIStackView {
        return UIStackView()
            .dy
            .axis(.vertical)
            .alignment(.fill)
            .distribution(.equalSpacing)
            .build()
    }
}

// MARK: - UIWindow
@objc extension UIWindow {
    /// 创建一个默认 `UIWindow` 实例(frame 为 `.zero`)
    open class func window() -> UIWindow {
        return UIWindow(frame: .zero)
    }
}

// MARK: - UIScrollView
@objc extension UIScrollView {
    /// 创建一个默认 `UIScrollView`,隐藏滚动指示器
    open class func scrollView() -> UIScrollView {
        return UIScrollView()
            .dy
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(false)
            .build()
    }
}

// MARK: - UITableView
@objc extension UITableView {
    /// 创建一个默认配置的 `UITableView`(`grouped` 样式),启用自动尺寸、透明背景、无分隔线等
    open class func tableView(_ style: UITableView.Style = .grouped) -> UITableView {
        let tableView = UITableView(frame: .zero, style: style)
            .dy
            .rowHeight(UITableView.automaticDimension)
            .sectionHeaderHeight(UITableView.automaticDimension)
            .sectionFooterHeight(UITableView.automaticDimension)
            .backgroundColor(.clear)
            .separatorStyle(.none)
            .keyboardDismissMode(.onDrag)
            .contentInsetAdjustmentBehavior(.never)
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(false)
            .cellLayoutMarginsFollowReadableWidth(false)

        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding(0)
        }
        return tableView.build()
    }
}

// MARK: - UICollectionView
@objc extension UICollectionView {
    /// 创建一个 `UICollectionView`,使用 `UICollectionViewFlowLayout`
    /// - Parameter scrollDirection: 滚动方向
    /// - Returns: `UICollectionView`
    open class func collectionView(scrollDirection: UICollectionView.ScrollDirection = .vertical) -> UICollectionView {
        let layout = UICollectionViewFlowLayout.layout()
            .dy
            .scrollDirection(scrollDirection)
            .build()

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .dy
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(false)
            .backgroundColor(.clear)
            .build()
    }
}

// MARK: - UICollectionReusableView
@objc extension UICollectionReusableView {
    open class func collectionReusableView() -> UICollectionReusableView {
        UICollectionReusableView()
    }
}

// MARK: - UICollectionViewFlowLayout
@objc extension UICollectionViewFlowLayout {
    /// 创建一个默认的 `UICollectionViewFlowLayout` 实例
    open class func layout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
    }
}

// MARK: - UIControl
@objc extension UIControl {
    /// 创建一个默认 `UIControl` 实例
    open class func control() -> UIControl {
        return UIControl()
    }
}

// MARK: - UIButton
@objc extension UIButton {
    /// 创建一个自定义类型的 `UIButton`
    open class func button() -> UIButton {
        return UIButton(type: .custom)
            .dy
            .isHighlighted(false)
            .build()
    }

    /// 创建一个纯文本样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func plain() -> UIButton {
        let configuration = UIButton.Configuration.plain()
        return UIButton(configuration: configuration)
    }

    /// 创建一个着色样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func tinted() -> UIButton {
        let configuration = UIButton.Configuration.tinted()
        return UIButton(configuration: configuration)
    }

    /// 创建一个灰色样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func gray() -> UIButton {
        let configuration = UIButton.Configuration.gray()
        return UIButton(configuration: configuration)
    }

    /// 创建一个填充样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func filled() -> UIButton {
        let configuration = UIButton.Configuration.filled()
        return UIButton(configuration: configuration)
    }

    /// 创建一个无边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func borderless() -> UIButton {
        let configuration = UIButton.Configuration.borderless()
        return UIButton(configuration: configuration)
    }

    /// 创建一个边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func bordered() -> UIButton {
        let configuration = UIButton.Configuration.bordered()
        return UIButton(configuration: configuration)
    }

    /// 创建一个着色边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func borderedTinted() -> UIButton {
        let configuration = UIButton.Configuration.borderedTinted()
        return UIButton(configuration: configuration)
    }

    /// 创建一个突出边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func borderedProminent() -> UIButton {
        let configuration = UIButton.Configuration.borderedProminent()
        return UIButton(configuration: configuration)
    }
}

// MARK: - UISwitch
@objc extension UISwitch {
    /// 创建一个默认 `UISwitch` 实例
    open class func `switch`() -> UISwitch {
        return UISwitch()
    }
}

// MARK: - UITabBar
@objc extension UITabBar {
    /// 创建一个默认 `UITabBar` 实例
    open class func tabBar() -> UITabBar {
        return UITabBar()
    }
}

// MARK: - UITabBarItem
@objc extension UITabBarItem {
    /// 创建一个默认 `UITabBarItem` 实例
    open class func tabBarItem() -> UITabBarItem {
        return UITabBarItem()
    }
}

// MARK: - UIBarButtonItem
@objc extension UIBarButtonItem {
    /// 创建一个默认 `UIBarButtonItem` 实例
    open class func barButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem()
    }
}

// MARK: - UINavigationBar
@objc extension UINavigationBar {
    /// 创建一个默认 `UINavigationBar` 实例
    open class func navigationBar() -> UINavigationBar {
        return UINavigationBar()
    }
}

// MARK: - UINavigationItem
@objc extension UINavigationItem {
    /// 创建一个默认 `UINavigationItem` 实例
    open class func navigationItem() -> UINavigationItem {
        return UINavigationItem()
    }
}

// MARK: - UIDatePicker
@objc extension UIDatePicker {
    /// 创建一个默认 `UIDatePicker` 实例(`frame` 为 `.zero`)
    open class func datePicker() -> UIDatePicker {
        return UIDatePicker(frame: .zero)
    }
}

// MARK: - UIPickerView
@objc extension UIPickerView {
    /// 创建一个默认 `UIPickerView` 实例
    open class func pickerView() -> UIPickerView {
        return UIPickerView()
    }
}

// MARK: - UIImageView
@objc extension UIImageView {
    /// 创建一个默认 `UIImageView` 实例
    open class func imageView() -> UIImageView {
        return UIImageView()
    }
}

// MARK: - UILabel
@objc extension UILabel {
    /// 创建一个默认 `UILabel` 实例
    open class func label() -> UILabel {
        return UILabel()
    }
}

// MARK: - UIPageControl
@objc extension UIPageControl {
    /// 创建一个默认 `UIPageControl` 实例
    open class func pageControl() -> UIPageControl {
        return UIPageControl()
    }
}

// MARK: - UIRefreshControl
@objc extension UIRefreshControl {
    /// 创建一个默认 `UIRefreshControl` 实例
    open class func refreshControl() -> UIRefreshControl {
        return UIRefreshControl()
    }
}

// MARK: - UISegmentedControl
@objc extension UISegmentedControl {
    /// 创建一个默认 `UISegmentedControl` 实例
    open class func segmentedControl() -> UISegmentedControl {
        return UISegmentedControl()
    }
}

// MARK: - UIActivityIndicatorView
@objc extension UIActivityIndicatorView {
    /// 创建一个默认 `UIActivityIndicatorView` 实例
    open class func activityIndicatorView() -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
}

// MARK: - UIProgressView
@objc extension UIProgressView {
    /// 创建一个默认 `UIProgressView` 实例
    open class func progressView() -> UIProgressView {
        return UIProgressView()
    }
}

// MARK: - UISlider
@objc extension UISlider {
    /// 创建一个默认 `UISlider` 实例
    open class func slider() -> UISlider {
        return UISlider()
    }
}

// MARK: - UISearchBar
@objc extension UISearchBar {
    /// 创建一个默认 `UISearchBar` 实例
    open class func searchBar() -> UISearchBar {
        return UISearchBar()
    }
}

// MARK: - UITextField
@objc extension UITextField {
    /// 创建一个默认 `UITextField` 实例
    open class func textField() -> UITextField {
        return UITextField()
    }
}

// MARK: - UITextView
@objc extension UITextView {
    /// 创建一个默认 `UITextView` 实例,隐藏滚动指示器
    open class func textView() -> UITextView {
        return UITextView()
            .dy
            .showsHorizontalScrollIndicator(false)
            .showsVerticalScrollIndicator(false)
            .build()
    }
}

// MARK: - WKWebView
@objc extension WKWebView {
    /// 创建一个默认 `WKWebView` 实例
    open class func webView() -> WKWebView {
        return WKWebView()
    }
}

// MARK: - CAShapeLayer
@objc extension CAShapeLayer {
    /// 创建一个默认 `CAShapeLayer` 实例
    open class func shapeLayer() -> CAShapeLayer {
        return CAShapeLayer()
    }
}

// MARK: - UIAlertController
@objc extension UIAlertController {
    /// 创建一个 `alert` 样式的 `UIAlertController`
    open class func alertController() -> UIAlertController {
        return UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    }

    /// 创建一个 `actionSheet` 样式的 `UIAlertController`
    open class func sheetController() -> UIAlertController {
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }
}

// MARK: - UITabBarController
@objc extension UITabBarController {
    /// 创建一个默认 `UITabBarController` 实例
    open class func tabBarController() -> UITabBarController {
        return UITabBarController()
    }
}

// MARK: - UINavigationController
@objc extension UINavigationController {
    /// 创建一个默认 `UINavigationController` 实例
    open class func navigationController() -> UINavigationController {
        return UINavigationController()
    }
}

// MARK: - UIViewController
@objc extension UIViewController {
    /// 创建一个默认 `UIViewController` 实例
    open class func viewController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - NSMutableParagraphStyle
@objc extension NSMutableParagraphStyle {
    /// 创建一个默认 `NSMutableParagraphStyle`,预设常用文本属性
    open class func mutableParagraphStyle() -> NSMutableParagraphStyle {
        return NSMutableParagraphStyle()
            .dy
            .hyphenationFactor(1.0)
            .firstLineHeadIndent(0.0)
            .paragraphSpacingBefore(0.0)
            .headIndent(0)
            .tailIndent(0)
            .build()
    }
}

// MARK: - UIGestureRecognizer
@objc extension UIGestureRecognizer {
    /// 创建一个基础手势识别器实例
    open class func gestureRecognizer() -> UIGestureRecognizer {
        return UIGestureRecognizer()
    }
}

// MARK: - UIScreenEdgePanGestureRecognizer
@objc extension UIScreenEdgePanGestureRecognizer {
    /// 创建一个屏幕边缘平移手势识别器(常用于侧滑返回等交互)
    open class func screenEdgePanGestureRecognizer() -> UIScreenEdgePanGestureRecognizer {
        return UIScreenEdgePanGestureRecognizer()
    }
}

// MARK: - UIHoverGestureRecognizer
@objc extension UIHoverGestureRecognizer {
    /// 创建一个悬停手势识别器(适用于支持指针的设备,如 iPad 外接鼠标)
    open class func hoverGestureRecognizer() -> UIHoverGestureRecognizer {
        return UIHoverGestureRecognizer()
    }
}

// MARK: - UILongPressGestureRecognizer
@objc extension UILongPressGestureRecognizer {
    /// 创建一个长按手势识别器,默认触发时长为 0.5 秒
    open class func longPressGestureRecognizer() -> UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer()
    }
}

// MARK: - UIPanGestureRecognizer
@objc extension UIPanGestureRecognizer {
    /// 创建一个平移(拖拽)手势识别器,可检测任意方向的移动
    open class func panGestureRecognizer() -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer()
    }
}

// MARK: - UIPinchGestureRecognizer
@objc extension UIPinchGestureRecognizer {
    /// 创建一个捏合(缩放)手势识别器,常用于图片或地图的缩放操作
    open class func pinchGestureRecognizer() -> UIPinchGestureRecognizer {
        return UIPinchGestureRecognizer()
    }
}

// MARK: - UIRotationGestureRecognizer
@objc extension UIRotationGestureRecognizer {
    /// 创建一个旋转手势识别器,通过两指旋转触发
    open class func rotationGestureRecognizer() -> UIRotationGestureRecognizer {
        return UIRotationGestureRecognizer()
    }
}

// MARK: - UISwipeGestureRecognizer
@objc extension UISwipeGestureRecognizer {
    /// 创建一个轻扫(滑动)手势识别器,默认方向为右,需根据需要设置方向
    open class func swipeGestureRecognizer() -> UISwipeGestureRecognizer {
        return UISwipeGestureRecognizer()
    }
}

// MARK: - UITapGestureRecognizer
@objc extension UITapGestureRecognizer {
    /// 创建一个点击(轻触)手势识别器,默认单击、单点触发
    open class func tapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }
}
