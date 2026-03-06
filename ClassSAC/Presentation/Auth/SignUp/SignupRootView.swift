//
//  SignupRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit
import SnapKit

final class SignupRootView: BaseRootView {

    var onTapSignupButton: (() -> Void)?
    var onTapLoginButton: (() -> Void)?

    private let formContainerView = UIView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    private let emailHeaderRowView = UIView()
    private let nicknameHeaderRowView = UIView()
    private let passwordHeaderRowView = UIView()
    private let passwordConfirmHeaderRowView = UIView()

    private let emailTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이메일"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    private let nicknameTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    private let passwordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    private let passwordConfirmTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호 확인"
        label.textColor = AppColor.textPrimary
        label.font = AppFont.label.font
        return label
    }()

    let emailStatusLabel: UILabel = SignupRootView.makeStatusLabel()
    let nicknameStatusLabel: UILabel = SignupRootView.makeStatusLabel()
    let passwordStatusLabel: UILabel = SignupRootView.makeStatusLabel()
    let passwordConfirmStatusLabel: UILabel = SignupRootView.makeStatusLabel()

    let emailTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.envelope.image,
        placeholderText: "이메일을 입력하세요",
        keyboardType: .emailAddress,
        isSecureTextEntry: false,
        rightAccessoryType: .none
    )

    let nicknameTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.person.image,
        placeholderText: "닉네임을 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: false,
        rightAccessoryType: .none
    )

    let passwordTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.lock.image,
        placeholderText: "비밀번호를 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: true,
        rightAccessoryType: .toggleSecure
    )

    let passwordConfirmTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.lock.image,
        placeholderText: "비밀번호를 다시 입력하세요",
        keyboardType: .default,
        isSecureTextEntry: true,
        rightAccessoryType: .toggleSecure
    )

    let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = AppFont.title.font
        button.backgroundColor = AppColor.accentPrimary
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.isEnabled = false
        button.alpha = 0.5
        return button
    }()

    private let loginPromptLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1

        let normalText = "이미 계정이 있으신가요? "
        let actionText = "로그인"

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

    private let loginTapOverlayButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        return button
    }()

    override func configureHierarchy() {
        addSubview(formContainerView)

        [
            titleLabel,
            emailHeaderRowView, emailTextFieldView,
            nicknameHeaderRowView, nicknameTextFieldView,
            passwordHeaderRowView, passwordTextFieldView,
            passwordConfirmHeaderRowView, passwordConfirmTextFieldView,
            signupButton,
            loginPromptLabel,
            loginTapOverlayButton
        ].forEach { formContainerView.addSubview($0) }

        [emailTitleLabel, emailStatusLabel].forEach { emailHeaderRowView.addSubview($0) }
        [nicknameTitleLabel, nicknameStatusLabel].forEach { nicknameHeaderRowView.addSubview($0) }
        [passwordTitleLabel, passwordStatusLabel].forEach { passwordHeaderRowView.addSubview($0) }
        [passwordConfirmTitleLabel, passwordConfirmStatusLabel].forEach { passwordConfirmHeaderRowView.addSubview($0) }
    }

    override func configureLayout() {
        applyResponsiveLayoutConstraints()
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary

        signupButton.addTarget(self, action: #selector(didTapSignupButton), for: .touchUpInside)
        loginTapOverlayButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)

        emailTextFieldView.setReturnKeyType(.next)
        nicknameTextFieldView.setReturnKeyType(.next)
        passwordTextFieldView.setReturnKeyType(.next)
        passwordConfirmTextFieldView.setReturnKeyType(.done)
    }

    func setInlineTitleHidden(_ isHidden: Bool) {
        titleLabel.isHidden = isHidden
        setNeedsUpdateConstraints()
    }

    private func applyResponsiveLayoutConstraints() {

        let isRegular = (traitCollection.horizontalSizeClass == .regular)
        let inlineTitleVisible = !titleLabel.isHidden

        formContainerView.snp.remakeConstraints { make in
            if isRegular {
                make.centerX.equalToSuperview()
                make.leading.greaterThanOrEqualToSuperview().inset(22)
                make.trailing.lessThanOrEqualToSuperview().inset(22)
                make.width.equalToSuperview().multipliedBy(0.72).priority(.high)
                make.width.lessThanOrEqualTo(720)

                make.top.greaterThanOrEqualTo(safeAreaLayoutGuide).offset(24)
                make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide).inset(24)
                make.centerY.equalToSuperview().priority(.low)
            } else {
                make.leading.equalToSuperview().inset(22).priority(.high)
                make.trailing.equalToSuperview().inset(22).priority(.high)
                make.top.equalTo(safeAreaLayoutGuide).offset(28)
                make.centerX.equalToSuperview().priority(.high)
            }
        }

        titleLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        emailHeaderRowView.snp.remakeConstraints { make in
            if inlineTitleVisible {
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
            } else {
                make.top.equalToSuperview()
            }
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        layoutHeaderRow(emailHeaderRowView, title: emailTitleLabel, status: emailStatusLabel)

        emailTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(emailHeaderRowView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        nicknameHeaderRowView.snp.remakeConstraints { make in
            make.top.equalTo(emailTextFieldView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        layoutHeaderRow(nicknameHeaderRowView, title: nicknameTitleLabel, status: nicknameStatusLabel)

        nicknameTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameHeaderRowView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        passwordHeaderRowView.snp.remakeConstraints { make in
            make.top.equalTo(nicknameTextFieldView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        layoutHeaderRow(passwordHeaderRowView, title: passwordTitleLabel, status: passwordStatusLabel)

        passwordTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(passwordHeaderRowView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        passwordConfirmHeaderRowView.snp.remakeConstraints { make in
            make.top.equalTo(passwordTextFieldView.snp.bottom).offset(18)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        layoutHeaderRow(passwordConfirmHeaderRowView, title: passwordConfirmTitleLabel, status: passwordConfirmStatusLabel)

        passwordConfirmTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(passwordConfirmHeaderRowView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        signupButton.snp.remakeConstraints { make in
            make.top.equalTo(passwordConfirmTextFieldView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(52)
        }

        loginPromptLabel.snp.remakeConstraints { make in
            make.top.equalTo(signupButton.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        loginTapOverlayButton.snp.remakeConstraints { make in
            make.edges.equalTo(loginPromptLabel)
        }
    }

    private func layoutHeaderRow(_ rowView: UIView, title: UILabel, status: UILabel) {
        title.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        status.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }

    func setStatus(_ label: UILabel, message: String?) {
        label.text = message
        label.isHidden = (message == nil)
    }

    func setSignupButton(enabled: Bool) {
        signupButton.isEnabled = enabled
        signupButton.alpha = enabled ? 1.0 : 0.5
    }

    @objc private func didTapSignupButton() {
        onTapSignupButton?()
    }

    @objc private func didTapLoginButton() {
        onTapLoginButton?()
    }
}

private extension SignupRootView {
    static func makeStatusLabel() -> UILabel {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.accentPrimary
        label.textAlignment = .right
        label.isHidden = true
        return label
    }
}
