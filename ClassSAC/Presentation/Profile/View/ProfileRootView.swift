//
//  ProfileRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import UIKit
import SnapKit

final class ProfileRootView: BaseRootView {

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.textPrimary
        button.backgroundColor = AppColor.bgSurface
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 1
        button.layer.borderColor = AppColor.borderSubtle.cgColor
        button.setImage(AppIcon.chervronLeft.image, for: .normal)
        return button
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 프로필"
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgPrimary
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 44
        imageView.image = AppIcon.person3.image
        imageView.tintColor = AppColor.textTertiary
        return imageView
    }()

    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.cardTitle.font
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    private let nicknameRowView = ProfileInfoRowView()
    private let emailRowView = ProfileInfoRowView()

    let logoutButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "로그아웃"
        configuration.image = AppIcon.logout.image
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        configuration.baseBackgroundColor = AppColor.accentPrimary
        configuration.baseForegroundColor = .white

        let button = UIButton(configuration: configuration)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    private let contentContainerView = UIView()

    override func configureHierarchy() {
        [
            backButton,
            titleLabel,
            contentContainerView,
            loadingIndicatorView
        ].forEach { addSubview($0) }

        [
            profileImageView,
            nicknameLabel,
            nicknameRowView,
            emailRowView,
            logoutButton
        ].forEach { contentContainerView.addSubview($0) }
    }

    override func configureLayout() {
        backButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(36)
        }

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }

        contentContainerView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(88)
        }

        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
        }

        nicknameRowView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }

        emailRowView.snp.makeConstraints { make in
            make.top.equalTo(nicknameRowView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(54)
        }

        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(emailRowView.snp.bottom).offset(28)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalToSuperview()
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary

        nicknameRowView.configure(
            icon: AppIcon.person.image,
            title: "닉네임",
            value: ""
        )

        emailRowView.configure(
            icon: AppIcon.envelope.image,
            title: "이메일",
            value: ""
        )
    }

    func render(state: ProfileViewState) {
        nicknameLabel.text = state.nick

        nicknameRowView.configure(
            icon: AppIcon.person.image,
            title: "닉네임",
            value: state.nick
        )

        emailRowView.configure(
            icon: AppIcon.envelope.image,
            title: "이메일",
            value: state.email
        )

        if state.isLoading {
            loadingIndicatorView.startAnimating()
        } else {
            loadingIndicatorView.stopAnimating()
        }
    }

    func updateProfileImage(_ image: UIImage?) {
        profileImageView.image = image ?? AppIcon.person3.image
    }
}
