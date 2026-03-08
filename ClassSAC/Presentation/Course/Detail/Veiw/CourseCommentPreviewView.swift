//
//  CourseCommentPreviewView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CourseCommentPreviewView: UIView {

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgMuted
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    let writerNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CourseCommentPreviewView {

    func configureHierarchy() {
        [
            profileImageView,
            writerNameLabel,
            createdAtLabel,
            contentLabel
        ].forEach { addSubview($0) }
    }

    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(14)
            make.size.equalTo(36)
        }

        writerNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(14)
        }

        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(writerNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(writerNameLabel)
            make.trailing.equalToSuperview().inset(14)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
        }
    }

    func configureView() {
        backgroundColor = AppColor.bgSurface
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = AppColor.borderSubtle.cgColor
    }
}
