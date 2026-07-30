import UIKit
import WebKit

// MARK: - UIView
@objc extension UIView {
    /// 创建一个默认配置的 `UIView` 实例
    open class func dy_view() -> UIView {
        return UIView()
    }
}

// MARK: - UIStackView
@objc extension UIStackView {
    /// 创建一个水平布局的 `UIStackView`,默认对齐方式为 `.fill`,分布方式为 `.equalSpacing`
    open class func dy_hStackView() -> UIStackView {
        return UIStackView()
            .dy_axis(.horizontal)
            .dy_alignment(.fill)
            .dy_distribution(.equalSpacing)
    }

    /// 创建一个垂直布局的 `UIStackView`,默认对齐方式为 `.fill`,分布方式为 `.equalSpacing`
    open class func dy_vStackView() -> UIStackView {
        return UIStackView()
            .dy_axis(.vertical)
            .dy_alignment(.fill)
            .dy_distribution(.equalSpacing)
    }
}

// MARK: - UIWindow
@objc extension UIWindow {
    /// 创建一个默认 `UIWindow` 实例(frame 为 `.zero`)
    open class func dy_window() -> UIWindow {
        return UIWindow(frame: .zero)
    }
}

// MARK: - UIScrollView
@objc extension UIScrollView {
    /// 创建一个默认 `UIScrollView`,隐藏滚动指示器
    open class func dy_scrollView() -> UIScrollView {
        return UIScrollView()
            .dy_showsHorizontalScrollIndicator(false)
            .dy_showsVerticalScrollIndicator(false)
    }
}

// MARK: - UITableView
@objc extension UITableView {
    /// 创建一个默认配置的 `UITableView`(`grouped` 样式),启用自动尺寸、透明背景、无分隔线等
    open class func dy_tableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
            .dy_rowHeight(UITableView.automaticDimension)
            .dy_sectionHeaderHeight(UITableView.automaticDimension)
            .dy_sectionFooterHeight(UITableView.automaticDimension)
            .dy_backgroundColor(.clear)
            .dy_separatorStyle(.none)
            .dy_keyboardDismissMode(.onDrag)
            .dy_contentInsetAdjustmentBehavior(.never)
            .dy_showsHorizontalScrollIndicator(false)
            .dy_showsVerticalScrollIndicator(false)
            .dy_cellLayoutMarginsFollowReadableWidth(false)

        if #available(iOS 15.0, *) {
            tableView.dy_sectionHeaderTopPadding(0)
        }
        return tableView
    }
}

// MARK: - UICollectionView
@objc extension UICollectionView {
    /// 创建一个水平滚动的 `UICollectionView`,使用 `UICollectionViewFlowLayout`
    open class func dy_hCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout.dy_layout()
            .dy_scrollDirection(.horizontal)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .dy_showsHorizontalScrollIndicator(false)
            .dy_showsVerticalScrollIndicator(false)
            .dy_backgroundColor(.clear)
    }

    /// 创建一个垂直滚动的 `UICollectionView`,使用 `UICollectionViewFlowLayout`
    open class func dy_vCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout.dy_layout()
            .dy_scrollDirection(.vertical)

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
            .dy_showsHorizontalScrollIndicator(false)
            .dy_showsVerticalScrollIndicator(false)
            .dy_backgroundColor(.clear)
    }
}

// MARK: - UICollectionReusableView
@objc extension UICollectionReusableView {
    open class func dy_collectionReusableView() -> UICollectionReusableView {
        UICollectionReusableView()
    }
}

// MARK: - UICollectionViewFlowLayout
@objc extension UICollectionViewFlowLayout {
    /// 创建一个默认的 `UICollectionViewFlowLayout` 实例
    open class func dy_layout() -> UICollectionViewFlowLayout {
        return UICollectionViewFlowLayout()
    }
}

// MARK: - UIControl
@objc extension UIControl {
    /// 创建一个默认 `UIControl` 实例
    open class func dy_control() -> UIControl {
        return UIControl()
    }
}

// MARK: - UIButton
@objc extension UIButton {
    /// 创建一个自定义类型的 `UIButton`
    open class func dy_button() -> UIButton {
        return UIButton(type: .custom)
            .dy_isHighlighted(false)
    }

    /// 创建一个纯文本样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_plain() -> UIButton {
        let configuration = UIButton.Configuration.plain()
        return UIButton(configuration: configuration)
    }

    /// 创建一个着色样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_tinted() -> UIButton {
        let configuration = UIButton.Configuration.tinted()
        return UIButton(configuration: configuration)
    }

    /// 创建一个灰色样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_gray() -> UIButton {
        let configuration = UIButton.Configuration.gray()
        return UIButton(configuration: configuration)
    }

    /// 创建一个填充样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_filled() -> UIButton {
        let configuration = UIButton.Configuration.filled()
        return UIButton(configuration: configuration)
    }

    /// 创建一个无边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_borderless() -> UIButton {
        let configuration = UIButton.Configuration.borderless()
        return UIButton(configuration: configuration)
    }

    /// 创建一个边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_bordered() -> UIButton {
        let configuration = UIButton.Configuration.bordered()
        return UIButton(configuration: configuration)
    }

    /// 创建一个着色边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_borderedTinted() -> UIButton {
        let configuration = UIButton.Configuration.borderedTinted()
        return UIButton(configuration: configuration)
    }

    /// 创建一个突出边框样式的 `UIButton`
    @available(iOS 15.0, *)
    open class func dy_borderedProminent() -> UIButton {
        let configuration = UIButton.Configuration.borderedProminent()
        return UIButton(configuration: configuration)
    }
}

// MARK: - UISwitch
@objc extension UISwitch {
    /// 创建一个默认 `UISwitch` 实例
    open class func dy_switch() -> UISwitch {
        return UISwitch()
    }
}

// MARK: - UITabBar
@objc extension UITabBar {
    /// 创建一个默认 `UITabBar` 实例
    open class func dy_tabBar() -> UITabBar {
        return UITabBar()
    }
}

// MARK: - UITabBarItem
@objc extension UITabBarItem {
    /// 创建一个默认 `UITabBarItem` 实例
    open class func dy_tabBarItem() -> UITabBarItem {
        return UITabBarItem()
    }
}

// MARK: - UIBarButtonItem
@objc extension UIBarButtonItem {
    /// 创建一个默认 `UIBarButtonItem` 实例
    open class func dy_barButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem()
    }
}

// MARK: - UINavigationBar
@objc extension UINavigationBar {
    /// 创建一个默认 `UINavigationBar` 实例
    open class func dy_navigationBar() -> UINavigationBar {
        return UINavigationBar()
    }
}

// MARK: - UINavigationItem
@objc extension UINavigationItem {
    /// 创建一个默认 `UINavigationItem` 实例
    open class func dy_navigationItem() -> UINavigationItem {
        return UINavigationItem()
    }
}

// MARK: - UIDatePicker
@objc extension UIDatePicker {
    /// 创建一个默认 `UIDatePicker` 实例(`frame` 为 `.zero`)
    open class func dy_datePicker() -> UIDatePicker {
        return UIDatePicker(frame: .zero)
    }
}

// MARK: - UIPickerView
@objc extension UIPickerView {
    /// 创建一个默认 `UIPickerView` 实例
    open class func dy_pickerView() -> UIPickerView {
        return UIPickerView()
    }
}

// MARK: - UIImageView
@objc extension UIImageView {
    /// 创建一个默认 `UIImageView` 实例
    open class func dy_imageView() -> UIImageView {
        return UIImageView()
    }
}

// MARK: - UILabel
@objc extension UILabel {
    /// 创建一个默认 `UILabel` 实例
    open class func dy_label() -> UILabel {
        return UILabel()
    }
}

// MARK: - UIPageControl
@objc extension UIPageControl {
    /// 创建一个默认 `UIPageControl` 实例
    open class func dy_pageControl() -> UIPageControl {
        return UIPageControl()
    }
}

// MARK: - UIRefreshControl
@objc extension UIRefreshControl {
    /// 创建一个默认 `UIRefreshControl` 实例
    open class func dy_refreshControl() -> UIRefreshControl {
        return UIRefreshControl()
    }
}

// MARK: - UISegmentedControl
@objc extension UISegmentedControl {
    /// 创建一个默认 `UISegmentedControl` 实例
    open class func dy_segmentedControl() -> UISegmentedControl {
        return UISegmentedControl()
    }
}

// MARK: - UIActivityIndicatorView
@objc extension UIActivityIndicatorView {
    /// 创建一个默认 `UIActivityIndicatorView` 实例
    open class func dy_activityIndicatorView() -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
}

// MARK: - UIProgressView
@objc extension UIProgressView {
    /// 创建一个默认 `UIProgressView` 实例
    open class func dy_progressView() -> UIProgressView {
        return UIProgressView()
    }
}

// MARK: - UISlider
@objc extension UISlider {
    /// 创建一个默认 `UISlider` 实例
    open class func dy_slider() -> UISlider {
        return UISlider()
    }
}

// MARK: - UISearchBar
@objc extension UISearchBar {
    /// 创建一个默认 `UISearchBar` 实例
    open class func dy_searchBar() -> UISearchBar {
        return UISearchBar()
    }
}

// MARK: - UITextField
@objc extension UITextField {
    /// 创建一个默认 `UITextField` 实例
    open class func dy_textField() -> UITextField {
        return UITextField()
    }
}

// MARK: - UITextView
@objc extension UITextView {
    /// 创建一个默认 `UITextView` 实例,隐藏滚动指示器
    open class func dy_textView() -> UITextView {
        return UITextView()
            .dy_showsHorizontalScrollIndicator(false)
            .dy_showsVerticalScrollIndicator(false)
    }
}

// MARK: - WKWebView
@objc extension WKWebView {
    /// 创建一个默认 `WKWebView` 实例
    open class func dy_webView() -> WKWebView {
        return WKWebView()
    }
}

// MARK: - CAShapeLayer
@objc extension CAShapeLayer {
    /// 创建一个默认 `CAShapeLayer` 实例
    open class func dy_shapeLayer() -> CAShapeLayer {
        return CAShapeLayer()
    }
}

// MARK: - UIAlertController
@objc extension UIAlertController {
    /// 创建一个 `alert` 样式的 `UIAlertController`
    open class func dy_alertController() -> UIAlertController {
        return UIAlertController(title: nil, message: nil, preferredStyle: .alert)
    }

    /// 创建一个 `actionSheet` 样式的 `UIAlertController`
    open class func dy_sheetController() -> UIAlertController {
        return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    }
}

// MARK: - UITabBarController
@objc extension UITabBarController {
    /// 创建一个默认 `UITabBarController` 实例
    open class func dy_tabBarController() -> UITabBarController {
        return UITabBarController()
    }
}

// MARK: - UINavigationController
@objc extension UINavigationController {
    /// 创建一个默认 `UINavigationController` 实例
    open class func dy_navigationController() -> UINavigationController {
        return UINavigationController()
    }
}

// MARK: - UIViewController
@objc extension UIViewController {
    /// 创建一个默认 `UIViewController` 实例
    open class func dy_viewController() -> UIViewController {
        return UIViewController()
    }
}

// MARK: - NSMutableParagraphStyle
@objc extension NSMutableParagraphStyle {
    /// 创建一个默认 `NSMutableParagraphStyle`,预设常用文本属性
    open class func dy_mutableParagraphStyle() -> NSMutableParagraphStyle {
        return NSMutableParagraphStyle()
            .dy_hyphenationFactor(1.0)
            .dy_firstLineHeadIndent(0.0)
            .dy_paragraphSpacingBefore(0.0)
            .dy_headIndent(0)
            .dy_tailIndent(0)
    }
}

// MARK: - UIGestureRecognizer
@objc extension UIGestureRecognizer {
    /// 创建一个基础手势识别器实例
    open class func dy_gestureRecognizer() -> UIGestureRecognizer {
        return UIGestureRecognizer()
    }
}

// MARK: - UIScreenEdgePanGestureRecognizer
@objc extension UIScreenEdgePanGestureRecognizer {
    /// 创建一个屏幕边缘平移手势识别器(常用于侧滑返回等交互)
    open class func dy_screenEdgePanGestureRecognizer() -> UIScreenEdgePanGestureRecognizer {
        return UIScreenEdgePanGestureRecognizer()
    }
}

// MARK: - UIHoverGestureRecognizer
@objc extension UIHoverGestureRecognizer {
    /// 创建一个悬停手势识别器(适用于支持指针的设备,如 iPad 外接鼠标)
    open class func dy_hoverGestureRecognizer() -> UIHoverGestureRecognizer {
        return UIHoverGestureRecognizer()
    }
}

// MARK: - UILongPressGestureRecognizer
@objc extension UILongPressGestureRecognizer {
    /// 创建一个长按手势识别器,默认触发时长为 0.5 秒
    open class func dy_longPressGestureRecognizer() -> UILongPressGestureRecognizer {
        return UILongPressGestureRecognizer()
    }
}

// MARK: - UIPanGestureRecognizer
@objc extension UIPanGestureRecognizer {
    /// 创建一个平移(拖拽)手势识别器,可检测任意方向的移动
    open class func dy_panGestureRecognizer() -> UIPanGestureRecognizer {
        return UIPanGestureRecognizer()
    }
}

// MARK: - UIPinchGestureRecognizer
@objc extension UIPinchGestureRecognizer {
    /// 创建一个捏合(缩放)手势识别器,常用于图片或地图的缩放操作
    open class func dy_pinchGestureRecognizer() -> UIPinchGestureRecognizer {
        return UIPinchGestureRecognizer()
    }
}

// MARK: - UIRotationGestureRecognizer
@objc extension UIRotationGestureRecognizer {
    /// 创建一个旋转手势识别器,通过两指旋转触发
    open class func dy_rotationGestureRecognizer() -> UIRotationGestureRecognizer {
        return UIRotationGestureRecognizer()
    }
}

// MARK: - UISwipeGestureRecognizer
@objc extension UISwipeGestureRecognizer {
    /// 创建一个轻扫(滑动)手势识别器,默认方向为右,需根据需要设置方向
    open class func dy_swipeGestureRecognizer() -> UISwipeGestureRecognizer {
        return UISwipeGestureRecognizer()
    }
}

// MARK: - UITapGestureRecognizer
@objc extension UITapGestureRecognizer {
    /// 创建一个点击(轻触)手势识别器,默认单击、单点触发
    open class func dy_tapGestureRecognizer() -> UITapGestureRecognizer {
        return UITapGestureRecognizer()
    }
}
