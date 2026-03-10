//
//  AppDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation
import UIKit

final class AppDIContainer {

    private lazy var accessTokenStore: AccessTokenStoring = UserDefaultsAccessTokenStore()

    private lazy var httpClient: ClassSACHTTPClienting = ClassSACNetworkFactory.makeHTTPClient(
        sesacKeyValue: Secrets.sesacKey,
        accessTokenStore: accessTokenStore
    )

    private lazy var currentUserStore: CurrentUserStoring = UserDefaultsCurrentUserStore()

    func makeAccessTokenStore() -> AccessTokenStoring {
        accessTokenStore
    }

    func makeCurrentUserStore() -> CurrentUserStoring {
        currentUserStore
    }

    func makeSessionRepository() -> SessionRepository {
        DefaultSessionRepository(
            accessTokenStore: accessTokenStore,
            currentUserStore: currentUserStore
        )
    }

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        AuthSceneDIContainer(
            httpClient: httpClient,
            accessTokenStore: accessTokenStore,
            currentUserStore: currentUserStore,
            appDIContainer: self
        )
    }

    func makeCourseSceneDIContainer() -> CourseSceneDIContainer {
        CourseSceneDIContainer(
            httpClient: httpClient,
            accessTokenStore: accessTokenStore,
            currentUserStore: currentUserStore
        )
    }
}
