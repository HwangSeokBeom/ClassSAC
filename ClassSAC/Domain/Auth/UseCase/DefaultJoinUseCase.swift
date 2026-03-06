//
//  DefaultJoinUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class DefaultJoinUseCase: JoinUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(
        email: String,
        password: String,
        nick: String,
        completion: @escaping (Result<UserSession, ClassSACAPIError>) -> Void
    ) {
        authRepository.join(
            email: email,
            password: password,
            nick: nick,
            completion: completion
        )
    }
}
