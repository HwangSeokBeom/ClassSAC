//
//  SignupViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit

final class SignupViewController: UIViewController {

    private let signupRootView = SignupRootView()
    private let viewModel: SignupViewModel
    private weak var authFlowCoordinator: AuthFlowCoordinator?

    init(
        viewModel: SignupViewModel,
        authFlowCoordinator: AuthFlowCoordinator
    ) {
        self.viewModel = viewModel
        self.authFlowCoordinator = authFlowCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = signupRootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupActions()
        setupKeyboardDismissGesture()
        applyTitleStyle()
        updateSignupValidationUI()

        registerForTraitChanges([UITraitHorizontalSizeClass.self]) { [weak self] (_: SignupViewController, _) in
            self?.applyTitleStyle()
        }
    }

    private func bind() {
        viewModel.onJoinSuccess = { [weak self] _ in
            guard let self else { return }

            self.signupRootView.dismissKeyboard()

            let alertController = UIAlertController(
                title: "회원가입 완료",
                message: "회원가입이 완료되었습니다. 로그인 화면으로 이동합니다.",
                preferredStyle: .alert
            )

            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                self.authFlowCoordinator?.showLogin()
            }

            alertController.addAction(confirmAction)
            self.present(alertController, animated: true)
        }

        viewModel.onJoinFailure = { [weak self] message in
            self?.showAlert(message: message)
        }
    }

    private func setupActions() {
        signupRootView.onTapSignupButton = { [weak self] in
            guard let self else { return }

            let input = SignupViewModel.Input(
                email: self.signupRootView.emailText,
                nick: self.signupRootView.nickText,
                password: self.signupRootView.passwordText,
                passwordConfirm: self.signupRootView.passwordConfirmText
            )

            let output = self.viewModel.transform(input: input)

            guard output.isSignupButtonEnabled else {
                self.applySignupOutput(output)
                return
            }

            self.signupRootView.dismissKeyboard()
            self.viewModel.didTapSignupButton(input: input)
        }

        signupRootView.onTapLoginButton = { [weak self] in
            self?.authFlowCoordinator?.showLogin()
        }

        signupRootView.setEmailEditingTarget(self, action: #selector(emailTextDidChange))
        signupRootView.setNicknameEditingTarget(self, action: #selector(nicknameTextDidChange))
        signupRootView.setPasswordEditingTarget(self, action: #selector(passwordTextDidChange))
        signupRootView.setPasswordConfirmEditingTarget(self, action: #selector(passwordConfirmTextDidChange))

        signupRootView.setEmailTextFieldDelegate(self)
        signupRootView.setNicknameTextFieldDelegate(self)
        signupRootView.setPasswordTextFieldDelegate(self)
        signupRootView.setPasswordConfirmTextFieldDelegate(self)

        signupRootView.setEmailReturnTarget(self, action: #selector(emailTextFieldDidReturn))
        signupRootView.setNicknameReturnTarget(self, action: #selector(nicknameTextFieldDidReturn))
        signupRootView.setPasswordReturnTarget(self, action: #selector(passwordTextFieldDidReturn))
        signupRootView.setPasswordConfirmReturnTarget(self, action: #selector(passwordConfirmTextFieldDidReturn))
    }

    private func setupKeyboardDismissGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapBackgroundView)
        )
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    private func applyTitleStyle() {
        let isRegular = traitCollection.horizontalSizeClass == .regular

        if isRegular {
            navigationItem.title = nil
            signupRootView.setInlineTitleHidden(false)
        } else {
            navigationItem.title = "회원가입"
            signupRootView.setInlineTitleHidden(true)
        }

        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    @objc private func emailTextDidChange() {
        updateSignupValidationUI()
    }

    @objc private func nicknameTextDidChange() {
        updateSignupValidationUI()
    }

    @objc private func passwordTextDidChange() {
        updateSignupValidationUI()
    }

    @objc private func passwordConfirmTextDidChange() {
        updateSignupValidationUI()
    }

    @objc private func emailTextFieldDidReturn() {
        signupRootView.focusNicknameTextField()
    }

    @objc private func nicknameTextFieldDidReturn() {
        signupRootView.focusPasswordTextField()
    }

    @objc private func passwordTextFieldDidReturn() {
        signupRootView.focusPasswordConfirmTextField()
    }

    @objc private func passwordConfirmTextFieldDidReturn() {
        signupRootView.dismissKeyboard()

        let input = SignupViewModel.Input(
            email: signupRootView.emailText,
            nick: signupRootView.nickText,
            password: signupRootView.passwordText,
            passwordConfirm: signupRootView.passwordConfirmText
        )

        let output = viewModel.transform(input: input)

        guard output.isSignupButtonEnabled else {
            applySignupOutput(output)
            return
        }

        viewModel.didTapSignupButton(input: input)
    }

    @objc
    private func didTapBackgroundView() {
        signupRootView.dismissKeyboard()
    }

    private func updateSignupValidationUI() {
        let input = SignupViewModel.Input(
            email: signupRootView.emailText,
            nick: signupRootView.nickText,
            password: signupRootView.passwordText,
            passwordConfirm: signupRootView.passwordConfirmText
        )

        let output = viewModel.transform(input: input)
        applySignupOutput(output)
    }

    private func applySignupOutput(_ output: SignupViewModel.Output) {
        signupRootView.setStatus(signupRootView.emailStatusLabel, message: output.emailMessage)
        signupRootView.setStatus(signupRootView.nicknameStatusLabel, message: output.nickMessage)
        signupRootView.setStatus(signupRootView.passwordStatusLabel, message: output.passwordMessage)
        signupRootView.setStatus(signupRootView.passwordConfirmStatusLabel, message: output.passwordConfirmMessage)
        signupRootView.setSignupButton(enabled: output.isSignupButtonEnabled)
    }

    private func showAlert(message: String) {
        let alertController = UIAlertController(
            title: "알림",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

extension SignupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
