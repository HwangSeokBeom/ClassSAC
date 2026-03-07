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

    func makeAccessTokenStore() -> AccessTokenStoring {
        accessTokenStore
    }

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        AuthSceneDIContainer(
            httpClient: httpClient,
            accessTokenStore: accessTokenStore,
            appDIContainer: self
        )
    }

    func makeCourseSceneDIContainer() -> CourseSceneDIContainer {
        CourseSceneDIContainer(
            httpClient: httpClient,
            accessTokenStore: accessTokenStore
        )
    }

    func makeMainTabBarController() -> MainTabBarController {
        MainTabBarController(
            courseSceneDIContainer: makeCourseSceneDIContainer()
        )
    }
}
