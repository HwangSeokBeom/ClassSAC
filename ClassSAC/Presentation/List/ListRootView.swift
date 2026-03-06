//
//  ListRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import SnapKit

final class ListRootView: BaseRootView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "클래스 조회"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "조회 화면"
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        return label
    }()

    override func configureHierarchy() {
        [
            titleLabel,
            descriptionLabel
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary
    }
}
