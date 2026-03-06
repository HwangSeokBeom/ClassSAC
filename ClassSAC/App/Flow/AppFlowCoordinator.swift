//
//  AppFlowCoordinator.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit

final class AppFlowCoordinator {

    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    private var authFlowCoordinator: AuthFlowCoordinator?

    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        showAuthFlow()
    }

    private func showAuthFlow() {
        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()

        let authFlowCoordinator = AuthFlowCoordinator(
            navigationController: navigationController,
            authSceneDIContainer: authSceneDIContainer
        ) { [weak self] in
            self?.authFlowCoordinator = nil
        }

        self.authFlowCoordinator = authFlowCoordinator
        authFlowCoordinator.start()
    }
}
