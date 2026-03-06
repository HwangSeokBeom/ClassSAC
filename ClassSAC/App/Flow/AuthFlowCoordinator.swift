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
    private var onFinish: (() -> Void)?

    init(
        navigationController: UINavigationController,
        authSceneDIContainer: AuthSceneDIContainer,
        onFinish: (() -> Void)? = nil
    ) {
        self.navigationController = navigationController
        self.authSceneDIContainer = authSceneDIContainer
        self.onFinish = onFinish
    }

    func start() {
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

    func showLogin() {
        navigationController.popViewController(animated: true)
    }
}
