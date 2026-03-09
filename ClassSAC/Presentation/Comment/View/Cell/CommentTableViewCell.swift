//
//  CommentTableViewCell.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CommentTableViewCell: UITableViewCell {

    static let identifier = "CommentTableViewCell"

    var onTapEditButton: ((String) -> Void)?
    var onTapDeleteButton: ((String) -> Void)?

    private var commentID: String?

    private let containerView = UIView()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgMuted
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let writerNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textTertiary
        button.setImage(AppIcon.pencil.image, for: .normal)
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textTertiary
        button.setImage(AppIcon.trash.image, for: .normal)
        return button
    }()

    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
        bindAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        viewModel: CommentCellViewModel,
        thumbnailProvider: CourseThumbnailProviding
    ) {
        commentID = viewModel.commentID
        writerNameLabel.text = viewModel.writerNickname
        createdAtLabel.text = viewModel.createdAtText
        contentLabel.text = viewModel.contentText

        editButton.isHidden = viewModel.isEditButtonHidden
        deleteButton.isHidden = viewModel.isDeleteButtonHidden

        thumbnailProvider.loadThumbnail(
            on: profileImageView,
            path: viewModel.writerProfileImagePath
        )
    }
}

private extension CommentTableViewCell {

    func configureHierarchy() {
        [
            containerView
        ].forEach { contentView.addSubview($0) }

        [
            profileImageView,
            writerNameLabel,
            createdAtLabel,
            editButton,
            deleteButton,
            contentLabel
        ].forEach { containerView.addSubview($0) }
    }

    func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(36)
        }

        writerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }

        createdAtLabel.snp.makeConstraints { make in
            make.top.equalTo(writerNameLabel.snp.bottom).offset(2)
            make.leading.equalTo(writerNameLabel)
            make.trailing.lessThanOrEqualTo(editButton.snp.leading).offset(-8)
        }

        deleteButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(20)
        }

        editButton.snp.makeConstraints { make in
            make.centerY.equalTo(deleteButton)
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
            make.size.equalTo(20)
        }

        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    func configureView() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func bindAction() {
        editButton.addAction(
            UIAction { [weak self] _ in
                guard let self, let commentID else { return }
                onTapEditButton?(commentID)
            },
            for: .touchUpInside
        )

        deleteButton.addAction(
            UIAction { [weak self] _ in
                guard let self, let commentID else { return }
                onTapDeleteButton?(commentID)
            },
            for: .touchUpInside
        )
    }
}
