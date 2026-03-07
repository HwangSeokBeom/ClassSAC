//
//  LoginViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class LoginViewModel {

    struct Input {
        let email: String
        let password: String
    }

    struct Output {
        let emailMessage: String?
        let passwordMessage: String?
        let isLoginButtonEnabled: Bool
    }

    private let loginUseCase: LoginUseCase

    var onLoginSuccess: ((UserSession) -> Void)?
    var onLoginFailure: ((String) -> Void)?

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func transform(input: Input) -> Output {
        let trimmedEmail = input.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = input.password.trimmingCharacters(in: .whitespacesAndNewlines)

        let emailMessage = emailMessage(trimmedEmail)

        let passwordMessage = loginFieldMessage(
            text: trimmedPassword,
            emptyMessage: "비밀번호를 입력해주세요."
        )

        let isLoginButtonEnabled = emailMessage == nil && passwordMessage == nil

        return Output(
            emailMessage: emailMessage,
            passwordMessage: passwordMessage,
            isLoginButtonEnabled: isLoginButtonEnabled
        )
    }

    private func emailMessage(_ email: String) -> String? {
        if email.isEmpty {
            return "이메일을 입력해주세요."
        }

        if !AuthValidationPolicy.isValidEmail(email) {
            return AuthValidationPolicy.emailGuideMessage
        }

        return nil
    }

    func didTapLoginButton(input: Input) {
        let trimmedEmail = input.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = input.password.trimmingCharacters(in: .whitespacesAndNewlines)

        let validatedInput = Input(
            email: trimmedEmail,
            password: trimmedPassword
        )

        let output = transform(input: validatedInput)

        guard output.isLoginButtonEnabled else {
            return
        }

        loginUseCase.execute(
            email: trimmedEmail,
            password: trimmedPassword
        ) { [weak self] result in
            switch result {
            case .success(let userSession):
                self?.onLoginSuccess?(userSession)

            case .failure(let error):
                self?.onLoginFailure?(error.userMessage)
            }
        }
    }

    private func loginFieldMessage(text: String, emptyMessage: String) -> String? {
        if text.isEmpty {
            return emptyMessage
        }

        if !AuthValidationPolicy.isValidLength(text) {
            return AuthValidationPolicy.lengthGuideMessage
        }

        return nil
    }
}
