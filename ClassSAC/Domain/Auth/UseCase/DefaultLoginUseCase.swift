//
//  DefaultLoginUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import RxSwift

final class DefaultLoginUseCase: LoginUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String) -> Single<UserSession> {
        authRepository.login(email: email, password: password)
    }
}
