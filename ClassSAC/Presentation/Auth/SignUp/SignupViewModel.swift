//
//  SignupViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class SignupViewModel {

    private let joinUseCase: JoinUseCase

    var onJoinSuccess: ((UserSession) -> Void)?
    var onJoinFailure: ((String) -> Void)?

    init(joinUseCase: JoinUseCase) {
        self.joinUseCase = joinUseCase
    }

    func join(email: String, password: String, nick: String) {
        joinUseCase.execute(
            email: email,
            password: password,
            nick: nick
        ) { [weak self] result in
            switch result {
            case .success(let session):
                self?.onJoinSuccess?(session)

            case .failure(let error):
                self?.onJoinFailure?(error.userMessage)
            }
        }
    }

    func validateSignupInput(
        email: String,
        password: String,
        passwordConfirm: String,
        nick: String
    ) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPasswordConfirm = passwordConfirm.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNick = nick.trimmingCharacters(in: .whitespacesAndNewlines)

        return !trimmedEmail.isEmpty &&
               !trimmedPassword.isEmpty &&
               !trimmedPasswordConfirm.isEmpty &&
               !trimmedNick.isEmpty &&
               trimmedPassword == trimmedPasswordConfirm
    }
}
