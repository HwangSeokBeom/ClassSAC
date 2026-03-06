//
//  DefaultJoinUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import RxSwift

final class DefaultJoinUseCase: JoinUseCase {

    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute(email: String, password: String, nick: String) -> Single<UserSession> {
        authRepository.join(email: email, password: password, nick: nick)
    }
}
