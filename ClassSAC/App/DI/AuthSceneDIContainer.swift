//
//  AuthSceneDIContainer.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import Foundation

final class AuthSceneDIContainer {

    private let httpClient: ClassSACHTTPClienting
    private let accessTokenStore: AccessTokenStoring
    private let currentUserStore: CurrentUserStoring
    private unowned let appDIContainer: AppDIContainer

    init(
        httpClient: ClassSACHTTPClienting,
        accessTokenStore: AccessTokenStoring,
        currentUserStore: CurrentUserStoring,
        appDIContainer: AppDIContainer
    ) {
        self.httpClient = httpClient
        self.accessTokenStore = accessTokenStore
        self.currentUserStore = currentUserStore
        self.appDIContainer = appDIContainer
    }

    private lazy var authRemoteDataSource: AuthRemoteDataSource = AuthRemoteDataSource(
        httpClient: httpClient,
        accessTokenStore: accessTokenStore
    )

    private lazy var authRepository: AuthRepository = DefaultAuthRepository(
        authRemoteDataSource: authRemoteDataSource
    )

    private func makeLoginUseCase() -> LoginUseCase {
        DefaultLoginUseCase(authRepository: authRepository)
    }

    private func makeJoinUseCase() -> JoinUseCase {
        DefaultJoinUseCase(authRepository: authRepository)
    }

    func makeLoginViewController(authFlowCoordinator: AuthFlowCoordinator) -> LoginViewController {
        let loginViewModel = LoginViewModel(
            loginUseCase: makeLoginUseCase(),
            currentUserStore: currentUserStore
        )

        return LoginViewController(
            viewModel: loginViewModel,
            authFlowCoordinator: authFlowCoordinator
        )
    }

    func makeSignupViewController(authFlowCoordinator: AuthFlowCoordinator) -> SignupViewController {
        let signupViewModel = SignupViewModel(
            joinUseCase: makeJoinUseCase()
        )

        return SignupViewController(
            viewModel: signupViewModel,
            authFlowCoordinator: authFlowCoordinator
        )
    }
}
