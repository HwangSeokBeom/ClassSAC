//
//  DefaultSessionRepository.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/10/26.
//

import Foundation
import RxSwift

final class DefaultSessionRepository: SessionRepository {

    private let accessTokenStore: AccessTokenStoring
    private let currentUserStore: CurrentUserStoring

    init(
        accessTokenStore: AccessTokenStoring,
        currentUserStore: CurrentUserStoring
    ) {
        self.accessTokenStore = accessTokenStore
        self.currentUserStore = currentUserStore
    }

    func clearSession() -> Completable {
        Completable.create { [weak self] completable in
            guard let self else {
                completable(.completed)
                return Disposables.create()
            }

            self.accessTokenStore.clear()
            self.currentUserStore.clearCurrentUserID()

            completable(.completed)

            return Disposables.create()
        }
    }
}
