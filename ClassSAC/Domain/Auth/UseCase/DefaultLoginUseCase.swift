//
//  DefaultLoginUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class DefaultLoginUseCase: LoginUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(
        email: String,
        password: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    ) {
        authRepository.login(
            email: email,
            password: password,
            completion: completion
        )
    }
}
