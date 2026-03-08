//
//  CourseDetailSectionHeaderView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CourseDetailSectionHeaderView: UIView {

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.textPrimary
        view.layer.cornerRadius = 1
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}

private extension CourseDetailSectionHeaderView {

    func configureHierarchy() {
        [
            indicatorView,
            titleLabel
        ].forEach { addSubview($0) }
    }

    func configureLayout() {
        indicatorView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.equalTo(18)
            make.height.equalTo(2)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(indicatorView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
}
