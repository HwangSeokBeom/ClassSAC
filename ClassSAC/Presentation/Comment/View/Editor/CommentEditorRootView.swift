//
//  CommentEditorRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CommentEditorRootView: BaseRootView {

    let dimmedBackgroundView = UIView()

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.bgPrimary
        view.layer.cornerRadius = 28
        view.layer.maskedCorners = [
            .layerMinXMinYCorner,
            .layerMaxXMinYCorner
        ]
        view.clipsToBounds = true
        return view
    }()

    let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.borderSubtle
        view.layer.cornerRadius = 2.5
        return view
    }()

    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textSecondary
        button.backgroundColor = AppColor.bgMuted
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(AppIcon.xmark.image, for: .normal)
        return button
    }()

    let navigationTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(AppColor.accentPrimary, for: .normal)
        button.titleLabel?.font = AppFont.body.font
        return button
    }()

    let categoryTagLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = AppColor.tagOrange
        label.backgroundColor = AppColor.tagOrangeBg
        label.font = AppFont.caption.font
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()

    let courseTitleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 2
        return label
    }()

    let editorContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.bgSurface
        view.layer.cornerRadius = 14
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.borderSubtle.cgColor
        return view
    }()

    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글을 작성해주세요."
        label.font = AppFont.body.font
        label.textColor = AppColor.textTertiary
        label.numberOfLines = 1
        return label
    }()

    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.font = AppFont.body.font
        textView.textColor = AppColor.textPrimary
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 30, right: 12)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textTertiary
        label.textAlignment = .right
        return label
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override func configureHierarchy() {
        [
            dimmedBackgroundView,
            containerView,
            loadingIndicatorView
        ].forEach { addSubview($0) }

        [
            grabberView,
            closeButton,
            navigationTitleLabel,
            confirmButton,
            categoryTagLabel,
            courseTitleLabel,
            editorContainerView
        ].forEach { containerView.addSubview($0) }

        [
            contentTextView,
            placeholderLabel,
            countLabel
        ].forEach { editorContainerView.addSubview($0) }
    }

    override func configureLayout() {
        dimmedBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        containerView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).offset(38)
        }

        grabberView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(44)
            make.height.equalTo(5)
        }

        closeButton.snp.makeConstraints { make in
            make.top.equalTo(grabberView.snp.bottom).offset(14)
            make.leading.equalToSuperview().offset(18)
            make.size.equalTo(40)
        }

        navigationTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.centerX.equalToSuperview()
        }

        confirmButton.snp.makeConstraints { make in
            make.centerY.equalTo(closeButton)
            make.trailing.equalToSuperview().inset(20)
        }

        categoryTagLabel.snp.makeConstraints { make in
            make.top.equalTo(closeButton.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(22)
        }

        courseTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTagLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        editorContainerView.snp.makeConstraints { make in
            make.top.equalTo(courseTitleLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(270)
        }

        contentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.leading.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().inset(12)
        }

        countLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(10)
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary
        dimmedBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.06)
    }

    func updateConfirmButtonTitle(_ title: String) {
        confirmButton.setTitle(title, for: .normal)
    }

    func updatePlaceholderVisibility(isHidden: Bool) {
        placeholderLabel.isHidden = isHidden
    }
}
