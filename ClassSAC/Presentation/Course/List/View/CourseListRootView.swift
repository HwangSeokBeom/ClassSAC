//
//  CourseListRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit
import SnapKit

final class CourseListRootView: BaseRootView {

    let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppIcon.bell.image, for: .normal)
        button.tintColor = AppColor.textPrimary
        button.backgroundColor = AppColor.bgSurface
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.borderSubtle.cgColor
        return button
    }()

    let profileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(AppIcon.person.image, for: .normal)
        button.tintColor = AppColor.textPrimary
        button.backgroundColor = AppColor.bgSurface
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.borderSubtle.cgColor
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "클래스 조회"
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    let categoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    let courseCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.label.font
        label.textColor = AppColor.textPrimary
        label.text = "0개"
        return label
    }()

    let sortButton = CourseSortButton()

    let courseCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 14
        let horizontalInset: CGFloat = 22
        let itemWidth = (UIScreen.main.bounds.width - (horizontalInset * 2) - spacing) / 2
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 94)
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 120, right: horizontalInset)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    private let headerContainerView = UIView()
    private let fixedTopContainerView = UIView()
    private let countSortContainerView = UIView()

    override func configureHierarchy() {
        [
            fixedTopContainerView,
            courseCollectionView
        ].forEach { addSubview($0) }

        [
            notificationButton,
            titleLabel,
            profileButton,
            categoryCollectionView,
            countSortContainerView
        ].forEach { fixedTopContainerView.addSubview($0) }

        [
            courseCountLabel,
            sortButton
        ].forEach { countSortContainerView.addSubview($0) }
    }

    override func configureLayout() {
        fixedTopContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }

        notificationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(22)
            make.size.equalTo(40)
        }

        profileButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(22)
            make.size.equalTo(40)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(notificationButton)
            make.centerX.equalToSuperview()
        }

        categoryCollectionView.snp.makeConstraints { make in
            make.top.equalTo(notificationButton.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(38)
        }

        countSortContainerView.snp.makeConstraints { make in
            make.top.equalTo(categoryCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(32)
        }

        courseCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }

        sortButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(22)
            make.centerY.equalToSuperview()
            make.height.equalTo(32)
        }

        courseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fixedTopContainerView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary
        fixedTopContainerView.backgroundColor = AppColor.bgPrimary
        sortButton.configure(title: "최신순")

        categoryCollectionView.register(
            CourseCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseCategoryCollectionViewCell.identifier
        )

        courseCollectionView.register(
            CourseListCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseListCollectionViewCell.identifier
        )
    }

    func updateSortButtonTitle(sortType: CourseSortType) {
        switch sortType {
        case .latest:
            sortButton.configure(title: "최신순")
        case .originalPriceDescending:
            sortButton.configure(title: "금액 높은 순")
        }
    }
}
