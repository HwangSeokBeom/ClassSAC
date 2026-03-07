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

        configureSessionExpiration()
    }

    func start() {
        showAuthFlow()
    }

    private func configureSessionExpiration() {
        AuthSessionManager.shared.setSessionExpiredHandler { [weak self] in
            self?.handleSessionExpired()
        }
    }

    private func handleSessionExpired() {

        let accessTokenStore = appDIContainer.makeAccessTokenStore()
        accessTokenStore.clear()

        showAuthFlow()
    }

    private func showAuthFlow() {

        let authSceneDIContainer = appDIContainer.makeAuthSceneDIContainer()

        let authFlowCoordinator = AuthFlowCoordinator(
            navigationController: navigationController,
            authSceneDIContainer: authSceneDIContainer,
            onFinish: { [weak self] in
                self?.authFlowCoordinator = nil
            },
            onLoginSuccess: { [weak self] in
                self?.showMainTabBar()
            }
        )

        self.authFlowCoordinator = authFlowCoordinator
        authFlowCoordinator.start()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    private func showMainTabBar() {

        let mainTabBarController = appDIContainer.makeMainTabBarController()

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {

            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
        }
    }
}
