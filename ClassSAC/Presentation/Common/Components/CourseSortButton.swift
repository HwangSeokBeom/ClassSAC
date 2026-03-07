//
//  CourseSortButton.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit
import SnapKit

final class CourseSortButton: UIButton {

    private let iconImageView = UIImageView()
    private let titleLabelView = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        [
            iconImageView,
            titleLabelView
        ].forEach { addSubview($0) }
    }

    private func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(14)
        }

        titleLabelView.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        backgroundColor = AppColor.bgSurface
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = AppColor.borderSubtle.cgColor

        iconImageView.image = AppIcon.sort.image
        iconImageView.tintColor = AppColor.textSecondary
        iconImageView.contentMode = .scaleAspectFit

        titleLabelView.font = AppFont.caption.font
        titleLabelView.textColor = AppColor.textSecondary
    }

    func configure(title: String) {
        titleLabelView.text = title
    }
}
