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
    private let emailHeaderRowView = UIView()
    private let passwordHeaderRowView = UIView()

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

    let emailStatusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.accentPrimary
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()

    let passwordStatusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.accentPrimary
        label.textAlignment = .right
        label.isHidden = true
        return label
    }()

    private let emailIconTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.envelope.image,
        placeholderText: "이메일을 입력하세요",
        keyboardType: .emailAddress,
        isSecureTextEntry: false,
        rightAccessoryType: .none
    )

    private let passwordIconTextFieldView = IconTextFieldView(
        leftIcon: AppIcon.lock.image,
        placeholderText: "비밀번호를 입력하세요",
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
        button.isEnabled = false
        button.alpha = 0.5
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

        attributedText.append(
            NSAttributedString(
                string: actionText,
                attributes: [
                    .foregroundColor: AppColor.accentPrimary,
                    .font: AppFont.button.font
                ]
            )
        )

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
        ].forEach { addSubview($0) }

        [
            emailFieldTitleLabel,
            emailStatusLabel
        ].forEach { emailHeaderRowView.addSubview($0) }

        [
            passwordFieldTitleLabel,
            passwordStatusLabel
        ].forEach { passwordHeaderRowView.addSubview($0) }

        [
            emailHeaderRowView,
            emailIconTextFieldView,
            passwordHeaderRowView,
            passwordIconTextFieldView,
            loginActionButton,
            signupPromptLabel,
            signupTapOverlayButton
        ].forEach { formContainerView.addSubview($0) }
    }

    override func configureLayout() {
        applyResponsiveLayoutConstraints()
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary

        loginActionButton.addTarget(self, action: #selector(didTapLoginActionButton), for: .touchUpInside)
        signupTapOverlayButton.addTarget(self, action: #selector(didTapSignupTapOverlayButton), for: .touchUpInside)

        emailIconTextFieldView.setReturnKeyType(.next)
        passwordIconTextFieldView.setReturnKeyType(.done)

        if #available(iOS 17.0, *) {
            registerForTraitChanges([UITraitHorizontalSizeClass.self]) { [weak self] (_: Self, _) in
                guard let self else { return }
                self.applyResponsiveLayoutConstraints()
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
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

        emailHeaderRowView.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        emailFieldTitleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        emailStatusLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        emailIconTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(emailHeaderRowView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(48)
        }

        passwordHeaderRowView.snp.remakeConstraints { make in
            make.top.equalTo(emailIconTextFieldView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(18)
        }

        passwordFieldTitleLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        passwordStatusLabel.snp.remakeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        passwordIconTextFieldView.snp.remakeConstraints { make in
            make.top.equalTo(passwordHeaderRowView.snp.bottom).offset(8)
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

    func setStatus(_ label: UILabel, message: String?) {
        label.text = message
        label.isHidden = (message == nil)
    }

    func setLoginButton(enabled: Bool) {
        loginActionButton.isEnabled = enabled
        loginActionButton.alpha = enabled ? 1.0 : 0.5
    }

    func setEmailEditingTarget(_ target: Any?, action: Selector) {
        emailIconTextFieldView.addTextFieldTarget(target, action: action, for: .editingChanged)
    }

    func setPasswordEditingTarget(_ target: Any?, action: Selector) {
        passwordIconTextFieldView.addTextFieldTarget(target, action: action, for: .editingChanged)
    }

    func setEmailReturnTarget(_ target: Any?, action: Selector) {
        emailIconTextFieldView.addTextFieldTarget(target, action: action, for: .editingDidEndOnExit)
    }

    func setPasswordReturnTarget(_ target: Any?, action: Selector) {
        passwordIconTextFieldView.addTextFieldTarget(target, action: action, for: .editingDidEndOnExit)
    }

    func setEmailTextFieldDelegate(_ delegate: UITextFieldDelegate?) {
        emailIconTextFieldView.setTextFieldDelegate(delegate)
    }

    func setPasswordTextFieldDelegate(_ delegate: UITextFieldDelegate?) {
        passwordIconTextFieldView.setTextFieldDelegate(delegate)
    }

    func focusPasswordTextField() {
        passwordIconTextFieldView.focus()
    }

    func dismissKeyboard() {
        endEditing(true)
    }

    @objc
    private func didTapLoginActionButton() {
        onTapLoginButton?(emailText, passwordText)
    }

    @objc
    private func didTapSignupTapOverlayButton() {
        onTapSignupButton?()
    }
}
