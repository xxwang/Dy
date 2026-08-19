import UIKit
import SoloCore

open class SoloCollectionViewController: SoloViewController {
    /// `UICollectionView`
    open lazy var collectionView = UICollectionView.collectionView(
        scrollDirection: self.collectionViewScrollDirection
    )
    .solo
    .dataSource(self)
    .delegate(self)
    .build()

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - SoloSetupable
@objc extension SoloCollectionViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        if self.naview.superview != nil {
            self.view.insertSubview(
                self.collectionView,
                belowSubview: self.naview
            )
        } else {
            self.view.addSubview(self.collectionView)
        }
        self.updateNaview()
    }
}

// MARK: - 支持子类重写的方法
@objc extension SoloCollectionViewController {
    /// 更新导航栏位置及受影响的视图
    override open func updateNaview() {
        super.updateNaview()

        let topMargin = self.naview.isHidden ? 0 : SoloScreen.navBarTotalHeight
        self.collectionView.solo
            .frame(CGRect(
                x: 0,
                y: topMargin,
                width: self.view.solo.width,
                height: self.view.solo.height - topMargin
            ))
    }

    /// 设置`UICollectionView`滚动方向
    open var collectionViewScrollDirection: UICollectionView.ScrollDirection {
        return .vertical
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
@objc extension SoloCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return SoloCollectionViewCell()
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .zero
    }

    /// 滚动方向
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

    /// 滚动垂直方向
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.01
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .zero
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return SoloCollectionReusableView()
    }
}
