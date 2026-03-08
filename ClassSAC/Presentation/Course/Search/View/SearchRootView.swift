//
//  SearchRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class SearchRootView: BaseRootView {

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "클래스 검색"
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.backgroundImage = UIImage()
        searchBar.tintColor = AppColor.textPrimary
        return searchBar
    }()

    let courseCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        collectionView.register(
            CourseListCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseListCollectionViewCell.identifier
        )
        return collectionView
    }()

    let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        indicatorView.isUserInteractionEnabled = false
        return indicatorView
    }()

    override func configureHierarchy() {
        [
            searchBar,
            courseCollectionView,
            emptyMessageLabel,
            loadingIndicatorView
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(44)
        }

        courseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(16)
            make.horizontalEdges.bottom.equalToSuperview()
        }

        emptyMessageLabel.snp.makeConstraints { make in
            make.center.equalTo(courseCollectionView)
            make.horizontalEdges.equalToSuperview().inset(40)
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalTo(courseCollectionView)
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary
    }
}
