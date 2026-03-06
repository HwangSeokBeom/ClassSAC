//
//  SignupViewModel.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class SignupViewModel {

    struct Input {
        let email: String
        let nick: String
        let password: String
        let passwordConfirm: String
    }

    struct Output {
        let emailMessage: String?
        let nickMessage: String?
        let passwordMessage: String?
        let passwordConfirmMessage: String?
        let isSignupButtonEnabled: Bool
    }

    private let joinUseCase: JoinUseCase

    var onJoinSuccess: ((UserSession) -> Void)?
    var onJoinFailure: ((String) -> Void)?

    init(joinUseCase: JoinUseCase) {
        self.joinUseCase = joinUseCase
    }

    func transform(input: Input) -> Output {
        let trimmedEmail = input.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNick = input.nick.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = input.password.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPasswordConfirm = input.passwordConfirm.trimmingCharacters(in: .whitespacesAndNewlines)

        let emailMessage = signupFieldMessage(
            text: trimmedEmail,
            emptyMessage: "이메일을 입력해주세요."
        )

        let nickMessage = signupFieldMessage(
            text: trimmedNick,
            emptyMessage: "닉네임을 입력해주세요."
        )

        let passwordMessage = signupFieldMessage(
            text: trimmedPassword,
            emptyMessage: "비밀번호를 입력해주세요."
        )

        let passwordConfirmMessage: String?
        if trimmedPasswordConfirm.isEmpty {
            passwordConfirmMessage = "비밀번호 확인을 입력해주세요."
        } else if !AuthValidationPolicy.isValidLength(trimmedPasswordConfirm) {
            passwordConfirmMessage = AuthValidationPolicy.lengthGuideMessage
        } else if trimmedPassword != trimmedPasswordConfirm {
            passwordConfirmMessage = "비밀번호가 일치하지 않습니다."
        } else {
            passwordConfirmMessage = nil
        }

        let isSignupButtonEnabled =
            emailMessage == nil &&
            nickMessage == nil &&
            passwordMessage == nil &&
            passwordConfirmMessage == nil

        return Output(
            emailMessage: emailMessage,
            nickMessage: nickMessage,
            passwordMessage: passwordMessage,
            passwordConfirmMessage: passwordConfirmMessage,
            isSignupButtonEnabled: isSignupButtonEnabled
        )
    }

    func didTapSignupButton(input: Input) {
        let output = transform(input: input)

        guard output.isSignupButtonEnabled else {
            return
        }

        joinUseCase.execute(
            email: input.email,
            password: input.password,
            nick: input.nick
        ) { [weak self] result in
            switch result {
            case .success(let userSession):
                self?.onJoinSuccess?(userSession)

            case .failure(let error):
                self?.onJoinFailure?(error.userMessage)
            }
        }
    }

    private func signupFieldMessage(text: String, emptyMessage: String) -> String? {
        if text.isEmpty {
            return emptyMessage
        }

        if !AuthValidationPolicy.isValidLength(text) {
            return AuthValidationPolicy.lengthGuideMessage
        }

        return nil
    }
}
