//
//  LoginViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class LoginViewModel {

    private let loginUseCase: LoginUseCase

    var onLoginSuccess: ((UserSession) -> Void)?
    var onLoginFailure: ((String) -> Void)?

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login(email: String, password: String) {
        loginUseCase.execute(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let session):
                self?.onLoginSuccess?(session)

            case .failure(let error):
                self?.onLoginFailure?(error.userMessage)
            }
        }
    }

    func validateLoginInput(email: String, password: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        return !trimmedEmail.isEmpty && !trimmedPassword.isEmpty
    }
}
