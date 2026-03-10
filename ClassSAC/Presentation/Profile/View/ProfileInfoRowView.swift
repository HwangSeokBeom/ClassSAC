//
//  ProfileInfoRowView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit
import SnapKit

final class ProfileInfoRowView: BaseRootView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = AppColor.textTertiary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textTertiary
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }()

    func configure(
        icon: UIImage?,
        title: String,
        value: String
    ) {
        iconImageView.image = icon
        titleLabel.text = title
        valueLabel.text = value
    }
    
    override func configureHierarchy() {
        [
            iconImageView,
            titleLabel,
            valueLabel
        ].forEach { addSubview($0) }
    }

    override func configureLayout() {

        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(18)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }

        valueLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgSurface
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = AppColor.borderSubtle.cgColor
        clipsToBounds = true
    }
}

