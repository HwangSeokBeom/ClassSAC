//
//  AppFlowCoordinator.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import RxSwift

final class AppFlowCoordinator {

    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    private var authFlowCoordinator: AuthFlowCoordinator?
    private var courseFlowCoordinator: CourseFlowCoordinator?

    private let disposeBag = DisposeBag()

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
        let sessionRepository = appDIContainer.makeSessionRepository()

        sessionRepository.clearSession()
            .subscribe(onCompleted: { [weak self] in
                self?.courseFlowCoordinator = nil
                self?.showAuthFlow()
            })
            .disposed(by: disposeBag)
    }

    private func handleLogoutRequested() {
        let sessionRepository = appDIContainer.makeSessionRepository()

        sessionRepository.clearSession()
            .subscribe(onCompleted: { [weak self] in
                self?.courseFlowCoordinator = nil
                self?.showAuthFlow()
            })
            .disposed(by: disposeBag)
    }

    private func showAuthFlow() {
        courseFlowCoordinator = nil

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
        let courseSceneDIContainer = appDIContainer.makeCourseSceneDIContainer()

        let courseFlowCoordinator = CourseFlowCoordinator(
            courseSceneDIContainer: courseSceneDIContainer,
            onLogoutRequested: { [weak self] in
                self?.handleLogoutRequested()
            }
        )

        let mainTabBarController = courseFlowCoordinator.start()

        self.courseFlowCoordinator = courseFlowCoordinator

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBarController
            window.makeKeyAndVisible()
        }
    }
}
