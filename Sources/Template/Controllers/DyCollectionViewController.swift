import UIKit
import DyCore

open class DyCollectionViewController: DyViewController {
    /// `UICollectionView`
    open lazy var collectionView = UICollectionView.dy_vCollectionView()
        .dy_dataSource(self)
        .dy_delegate(self)

    override open func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 支持子类重写的方法
@objc extension DyCollectionViewController {
    /// 控制器初始化样式
    override open func setupUI() {
        super.setupUI()

        // 添加到导航栏下面 确保导航栏阴影可以正常显示
        self.view.insertSubview(
            self.collectionView,
            belowSubview: self.naview
        )
        self.collectionView.dy_frame(CGRect(
            x: 0,
            y: DyScreen.navBarTotalHeight,
            width: self.view.dy_width,
            height: self.view.dy_height - DyScreen.navBarTotalHeight
        ))
    }

    /// 更新导航栏及受影响的其它view
    override open func updateNaview() {
        super.updateNaview()

        self.collectionView.dy_frame(CGRect(
            x: 0,
            y: DyScreen.navBarTotalHeight,
            width: self.view.dy_width,
            height: self.view.dy_height - DyScreen.navBarTotalHeight
        ))
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
@objc extension DyCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return DyCollectionViewCell()
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
        return DyCollectionReusableView()
    }
}
