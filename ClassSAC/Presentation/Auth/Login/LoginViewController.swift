//
//  LoginViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/5/26.
//

import UIKit

final class LoginViewController: UIViewController {

    private let rootView = LoginRootView()
    private let viewModel: LoginViewModel
    private weak var authFlowCoordinator: AuthFlowCoordinator?

    init(
        viewModel: LoginViewModel,
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
        view = rootView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setupActions()
        enableKeyboardDismissGesture()
        updateLoginValidationUI()
    }

    private func bind() {
        viewModel.onLoginSuccess = { [weak self] _ in
            self?.authFlowCoordinator?.finishAuthFlow()
        }

        viewModel.onLoginFailure = { [weak self] message in
            self?.showNetworkAlert(message: message)
        }
    }

    private func setupActions() {
        rootView.onTapLoginButton = { [weak self] _, _ in
            self?.attemptLogin()
        }

        rootView.onTapSignupButton = { [weak self] in
            self?.authFlowCoordinator?.showSignup()
        }

        rootView.setEmailEditingTarget(self, action: #selector(emailTextDidChange))
        rootView.setPasswordEditingTarget(self, action: #selector(passwordTextDidChange))

        rootView.setEmailTextFieldDelegate(self)
        rootView.setPasswordTextFieldDelegate(self)
        rootView.setEmailReturnTarget(self, action: #selector(emailTextFieldDidReturn))
        rootView.setPasswordReturnTarget(self, action: #selector(passwordTextFieldDidReturn))
    }

    private func attemptLogin() {
        let input = LoginViewModel.Input(
            email: rootView.emailText,
            password: rootView.passwordText
        )

        let output = viewModel.transform(input: input)

        guard output.isLoginButtonEnabled else {
            applyLoginOutput(output)
            return
        }

        rootView.dismissKeyboard()
        viewModel.didTapLoginButton(input: input)
    }

    @objc private func emailTextDidChange() {
        updateLoginValidationUI()
    }

    @objc private func passwordTextDidChange() {
        updateLoginValidationUI()
    }

    @objc private func emailTextFieldDidReturn() {
        rootView.focusPasswordTextField()
    }

    @objc private func passwordTextFieldDidReturn() {
        attemptLogin()
    }

    private func updateLoginValidationUI() {
        let input = LoginViewModel.Input(
            email: rootView.emailText,
            password: rootView.passwordText
        )

        let output = viewModel.transform(input: input)
        applyLoginOutput(output)
    }

    private func applyLoginOutput(_ output: LoginViewModel.Output) {
        rootView.setStatus(rootView.emailStatusLabel, message: output.emailMessage)
        rootView.setStatus(rootView.passwordStatusLabel, message: output.passwordMessage)
        rootView.setLoginButton(enabled: output.isLoginButtonEnabled)
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        rootView.dismissKeyboard()
        return true
    }
}
