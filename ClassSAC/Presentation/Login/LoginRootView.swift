//
//  LoginRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit
import SnapKit

final class LoginRootView: BaseRootView {

    var onTapLoginButton: ((String, String) -> Void)?
    var onTapSignupButton: (() -> Void)?

    private let heroIllustrationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let formContainerView = UIView()

    private let emailFieldTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    private let passwordFieldTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    private let emailIconTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.envelope.image,
        placeholderText: "jack@jack.com",
        keyboardType: .emailAddress,
        isSecureTextEntry: false,
        rightAccessoryType: .none
    )

    private let passwordIconTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.lock.image,
        placeholderText: "123456",
        keyboardType: .default,
        isSecureTextEntry: true,
        rightAccessoryType: .toggleSecure
    )

    private let loginActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.title.font
        button.backgroundColor = AppColor.accentPrimary
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()

    private let signupPromptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1

        let normalText = "계정이 없으신가요? "
        let actionText = "회원가입"

        let attributedText = NSMutableAttributedString(
            string: normalText,
            attributes: [
                .foregroundColor: AppColor.textSecondary,
                .font: AppFont.body.font
            ]
        )

        attributedText.append(NSAttributedString(
            string: actionText,
            attributes: [
                .foregroundColor: AppColor.accentPrimary,
                .font: AppFont.button.font
            ]
        ))

        label.attributedText = attributedText
        return label
    }()

    private let signupTapOverlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()

    var emailText: String { emailIconTextFieldView.text }
    var passwordText: String { passwordIconTextFieldView.text }

    override func configureHierarchy() {
        [
            heroIllustrationImageView,
            formContainerView
        ]
        .forEach { addSubview($0) }

        [
            emailFieldTitleLabel,
            emailIconTextFieldView,
            passwordFieldTitleLabel,
            passwordIconTextFieldView,
            loginActionButton,
            signupPromptLabel,
            signupTapOverlayButton
        ]
        .forEach { formContainerView.addSubview($0) }
    }

    override func configureLayout() {
        applyResponsiveLayoutConstraints()
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary

        loginActionButton.addTarget(self, action: #selector(didTapLoginActionButton), for: .touchUpInside)
        signupTapOverlayButton.addTarget(self, action: #selector(didTapSignupTapOverlayButton), for: .touchUpInside)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass {
            applyResponsiveLayoutConstraints()
            layoutIfNeeded()
        }
    }

    private func applyResponsiveLayoutConstraints() {

        heroIllustrationImageView.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()

            if traitCollection.horizontalSizeClass == .regular {
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.45)
                make.width.lessThanOrEqualTo(520)
            } else {
                make.width.lessThanOrEqualToSuperview().multipliedBy(0.75)
                make.width.lessThanOrEqualTo(380)
            }

            make.height.equalTo(heroIllustrationImageView.snp.width).multipliedBy(0.8)

            if traitCollection.horizontalSizeClass == .regular {
                make.top.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(24)
            } else {
                make.top.equalTo(safeAreaLayoutGuide).offset(24)
            }
        }

        formContainerView.snp.remakeConstraints { make in
            make.top.equalTo(heroIllustrationImageView.snp.bottom).offset(12)

            if traitCollection.horizontalSizeClass == .regular {
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview().inset(22)
                make.trailing.lessThanOrEqualToSuperview().inset(22)
                make.width.equalToSuperview().multipliedBy(0.72).priority(.high)
                make.width.lessThanOrEqualTo(720)

                make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(24)
                make.centerY.equalToSuperview().priority(.low)
            } else {
                make.leading.trailing.equalToSuperview().inset(22)
            }
            
        }

        emailFieldTitleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        emailIconTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(emailFieldTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        passwordFieldTitleLabel.snp.remakeConstraints { make in
            make.top.equalTo(emailIconTextFieldView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
        }

        passwordIconTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(passwordFieldTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        loginActionButton.snp.remakeConstraints { make in
            make.top.equalTo(passwordIconTextFieldView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        signupPromptLabel.snp.remakeConstraints { make in
            make.top.equalTo(loginActionButton.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        signupTapOverlayButton.snp.remakeConstraints { make in
            make.edges.equalTo(signupPromptLabel)
        }
    }

    @objc private func didTapLoginActionButton() {
        onTapLoginButton?(emailIconTextFieldView.text, passwordIconTextFieldView.text)
    }

    @objc private func didTapSignupTapOverlayButton() {
        onTapSignupButton?()
    }
}
