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
        view.layer.cornerRadius = 38
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = AppColor.accentPrimary
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        label.numberOfLines = 1
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

    func configure(icon: UIImage?, value: String) {
        iconImageView.image = icon
        valueLabel.text = value
    }

    func updateValue(_ value: String) {
        valueLabel.text = value
    }
}

private extension CourseDetailInfoView {

    func configureHierarchy() {
        [
            circleBackgroundView
        ].forEach { addSubview($0) }

        [
            iconImageView,
            valueLabel
        ].forEach { circleBackgroundView.addSubview($0) }
    }

    func configureLayout() {
        circleBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(76)
        }

        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.size.equalTo(20)
        }

        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(6)
        }
    }
}
