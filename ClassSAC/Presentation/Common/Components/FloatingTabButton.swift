//
//  FloatingTabButton.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import SnapKit

final class FloatingTabButton: UIButton {

    private let tabIconImageView = UIImageView()
    private let tabTitleLabel = UILabel()
    private let contentContainerView = UIView()

    init(titleText: String, image: UIImage?) {
        super.init(frame: .zero)
        configureView(titleText: titleText, image: image)
        configureHierarchy()
        configureLayout()
        setSelectedState(false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureView(titleText: String, image: UIImage?) {
        backgroundColor = .clear

        contentContainerView.backgroundColor = .clear
        contentContainerView.layer.cornerRadius = 24
        contentContainerView.isUserInteractionEnabled = false

        tabIconImageView.image = image
        tabIconImageView.contentMode = .scaleAspectFit
        tabIconImageView.tintColor = AppColor.textSecondary

        tabTitleLabel.text = titleText
        tabTitleLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        tabTitleLabel.textColor = AppColor.textSecondary
        tabTitleLabel.textAlignment = .center
    }

    private func configureHierarchy() {
        [
            contentContainerView
        ].forEach { addSubview($0) }

        [
            tabIconImageView,
            tabTitleLabel
        ].forEach { contentContainerView.addSubview($0) }
    }

    private func configureLayout() {
        contentContainerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(4)
        }

        tabIconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(20)
        }

        tabTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(tabIconImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func setSelectedState(_ isSelected: Bool) {
        if isSelected {
            contentContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.42)
            tabIconImageView.tintColor = AppColor.accentPrimary
            tabTitleLabel.textColor = AppColor.accentPrimary
        } else {
            contentContainerView.backgroundColor = .clear
            tabIconImageView.tintColor = AppColor.textSecondary
            tabTitleLabel.textColor = AppColor.textSecondary
        }
    }
}
