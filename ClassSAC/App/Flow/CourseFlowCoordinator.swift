//
//  CourseFlowCoordinator.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit

protocol CourseFlowCoordinating: AnyObject {
    func handle(route: CourseListRoute, from viewController: UIViewController)
    func handle(route: SearchRoute, from viewController: UIViewController)
    func handle(route: CourseDetailRoute, from viewController: UIViewController)
    func handleCommentListRoute(_ route: CommentListRoute, from viewController: UIViewController)
    func requestLogout()
}

final class CourseFlowCoordinator: CourseFlowCoordinating {

    private let courseSceneDIContainer: CourseSceneDIContainer
    private let onLogoutRequested: (() -> Void)?

    private let listNavigationController = UINavigationController()
    private let searchNavigationController = UINavigationController()
    private let favoriteNavigationController = UINavigationController()

    init(
        courseSceneDIContainer: CourseSceneDIContainer,
        onLogoutRequested: (() -> Void)? = nil
    ) {
        self.courseSceneDIContainer = courseSceneDIContainer
        self.onLogoutRequested = onLogoutRequested
    }

    func start() -> UITabBarController {
        let mainTabBarController = MainTabBarController()

        let courseListViewController = courseSceneDIContainer.makeCourseListViewController(
            courseFlowCoordinator: self
        )
        let searchViewController = courseSceneDIContainer.makeSearchViewController(
            courseFlowCoordinator: self
        )
        let favoriteViewController = courseSceneDIContainer.makeFavoriteViewController(
            courseFlowCoordinator: self
        )

        listNavigationController.setViewControllers([courseListViewController], animated: false)
        searchNavigationController.setViewControllers([searchViewController], animated: false)
        favoriteNavigationController.setViewControllers([favoriteViewController], animated: false)

        listNavigationController.tabBarItem = UITabBarItem(
            title: "조회",
            image: AppIcon.book.image,
            selectedImage: AppIcon.book.image
        )

        searchNavigationController.tabBarItem = UITabBarItem(
            title: "검색",
            image: AppIcon.search.image,
            selectedImage: AppIcon.search.image
        )

        favoriteNavigationController.tabBarItem = UITabBarItem(
            title: "찜",
            image: AppIcon.heart.image,
            selectedImage: AppIcon.heartFill.image
        )

        mainTabBarController.viewControllers = [
            listNavigationController,
            searchNavigationController,
            favoriteNavigationController
        ]
        mainTabBarController.selectedIndex = 0

        return mainTabBarController
    }

    func handle(route: CourseListRoute, from viewController: UIViewController) {
        switch route {
        case .notifications:
            let notificationsViewController = UIViewController()
            notificationsViewController.view.backgroundColor = AppColor.bgPrimary
            notificationsViewController.title = "알림"

            viewController.navigationController?.pushViewController(
                notificationsViewController,
                animated: true
            )

        case .profile:
            let profileViewController = courseSceneDIContainer.makeProfileViewController(
                courseFlowCoordinator: self
            )

            viewController.navigationController?.pushViewController(
                profileViewController,
                animated: true
            )

        case .courseDetail(let courseID):
            let courseDetailViewController = courseSceneDIContainer.makeCourseDetailViewController(
                courseID: courseID,
                courseFlowCoordinator: self
            )

            viewController.navigationController?.pushViewController(
                courseDetailViewController,
                animated: true
            )
        }
    }

    func handle(route: SearchRoute, from viewController: UIViewController) {
        switch route {
        case .courseDetail(let courseID):
            let courseDetailViewController = courseSceneDIContainer.makeCourseDetailViewController(
                courseID: courseID,
                courseFlowCoordinator: self
            )

            viewController.navigationController?.pushViewController(
                courseDetailViewController,
                animated: true
            )
        }
    }

    func handle(route: CourseDetailRoute, from viewController: UIViewController) {
        switch route {
        case .commentList(let courseID, let courseTitle, let categoryTitle):
            let commentListViewController = courseSceneDIContainer.makeCourseCommentListViewController(
                courseID: courseID,
                courseTitle: courseTitle,
                categoryTitle: categoryTitle,
                courseFlowCoordinator: self
            )

            viewController.navigationController?.pushViewController(
                commentListViewController,
                animated: true
            )
        }
    }

    func handleCommentListRoute(_ route: CommentListRoute, from viewController: UIViewController) {
        switch route {
        case .commentEditor(let context):
            let commentEditorViewController = courseSceneDIContainer.makeCommentEditorViewController(
                context: context
            )

            viewController.present(commentEditorViewController, animated: true)
        }
    }

    func requestLogout() {
        onLogoutRequested?()
    }
}
