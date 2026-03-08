//
//  SearchRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class SearchRootView: BaseRootView {

    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "클래스 검색"
        textField.font = AppFont.body.font
        textField.textColor = AppColor.textPrimary
        textField.backgroundColor = AppColor.bgMuted
        textField.layer.cornerRadius = 22
        textField.returnKeyType = .search
        textField.clearButtonMode = .whileEditing
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no

        let imageView = UIImageView(image: AppIcon.search.image)
        imageView.tintColor = AppColor.textSecondary
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 18)

        let leftContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 18))
        leftContainerView.isUserInteractionEnabled = false
        leftContainerView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }

        textField.leftView = leftContainerView
        return textField
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
            searchTextField,
            courseCollectionView,
            emptyMessageLabel,
            loadingIndicatorView
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(44)
        }

        courseCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(16)
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
