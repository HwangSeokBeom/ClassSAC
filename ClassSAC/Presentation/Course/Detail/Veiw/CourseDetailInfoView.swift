//
//  CourseDetailInfoView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CourseDetailInfoView: UIView {

    private let circleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.bgMuted
        view.layer.cornerRadius = 34
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = AppColor.accentPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textSecondary
        label.textAlignment = .center
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 0
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

    func configure(icon: UIImage?, title: String, value: String) {
        iconImageView.image = icon
        titleLabel.text = title
        valueLabel.text = value
    }

    func updateValue(_ value: String) {
        valueLabel.text = value
    }

    private func numberOfLines(label: UILabel) {
        label.numberOfLines = 1
    }
}

private extension CourseDetailInfoView {

    func configureHierarchy() {
        [
            circleBackgroundView,
            titleLabel,
            valueLabel
        ].forEach { addSubview($0) }

        [
            iconImageView
        ].forEach { circleBackgroundView.addSubview($0) }
    }

    func configureLayout() {
        circleBackgroundView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.size.equalTo(68)
        }

        iconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(circleBackgroundView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
}
