//
//  AppDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class AppDIContainer {

    private lazy var accessTokenStore: AccessTokenStoring = UserDefaultsAccessTokenStore()

    private lazy var httpClient: ClassSACHTTPClienting = ClassSACNetworkFactory.makeHTTPClient(
        sesacKeyValue: Secrets.sesacKey,
        accessTokenStore: accessTokenStore
    )

    func makeAuthSceneDIContainer() -> AuthSceneDIContainer {
        AuthSceneDIContainer(
            httpClient: httpClient,
            accessTokenStore: accessTokenStore,
            appDIContainer: self
        )
    }
}
