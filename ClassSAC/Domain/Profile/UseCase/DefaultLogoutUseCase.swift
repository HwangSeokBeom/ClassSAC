//
//  DefaultLogoutUseCase.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

final class DefaultLogoutUseCase: LogoutUseCase {

    private let sessionRepository: SessionRepository

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    func execute() -> Completable {
        sessionRepository.clearSession()
    }
}
