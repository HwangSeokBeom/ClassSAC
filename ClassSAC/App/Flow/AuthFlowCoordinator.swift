//
//  AuthFlowCoordinator.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit

final class AuthFlowCoordinator {

    private let navigationController: UINavigationController
    private let authSceneDIContainer: AuthSceneDIContainer
    private let onFinish: (() -> Void)?
    private let onLoginSuccess: (() -> Void)?

    init(
        navigationController: UINavigationController,
        authSceneDIContainer: AuthSceneDIContainer,
        onFinish: (() -> Void)? = nil,
        onLoginSuccess: (() -> Void)? = nil
    ) {
        self.navigationController = navigationController
        self.authSceneDIContainer = authSceneDIContainer
        self.onFinish = onFinish
        self.onLoginSuccess = onLoginSuccess
    }

    func start() {
        showLogin()
    }

    func showLogin() {
        let loginViewController = authSceneDIContainer.makeLoginViewController(
            authFlowCoordinator: self
        )
        navigationController.setViewControllers([loginViewController], animated: false)
    }

    func showSignup() {
        let signupViewController = authSceneDIContainer.makeSignupViewController(
            authFlowCoordinator: self
        )
        navigationController.pushViewController(signupViewController, animated: true)
    }

    func finishAuthFlow() {
        onLoginSuccess?()
        onFinish?()
    }
}
