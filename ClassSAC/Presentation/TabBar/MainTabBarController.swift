//
//  MainTabBarController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

    private let courseSceneDIContainer: CourseSceneDIContainer

    init(courseSceneDIContainer: CourseSceneDIContainer) {
        self.courseSceneDIContainer = courseSceneDIContainer
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureViewControllers()
        configureTabBarAppearance()
    }

    private func configureView() {
        view.backgroundColor = AppColor.bgPrimary
    }

    private func configureViewControllers() {
        let listViewController = courseSceneDIContainer.makeCourseListViewController()
        let searchViewController = SearchViewController()
        let favoriteViewController = FavoriteViewController()

        let listNavigationController = UINavigationController(rootViewController: listViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)

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

        viewControllers = [
            listNavigationController,
            searchNavigationController,
            favoriteNavigationController
        ]

        selectedIndex = 0
    }

    private func configureTabBarAppearance() {
        tabBar.tintColor = AppColor.accentPrimary
        tabBar.unselectedItemTintColor = AppColor.textPrimary
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        tabBarAppearance.backgroundColor = UIColor.white.withAlphaComponent(0.28)
        tabBarAppearance.shadowColor = UIColor.white.withAlphaComponent(0.15)

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = AppColor.textPrimary
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppColor.textPrimary,
            .font: AppFont.caption.font
        ]

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = AppColor.accentPrimary
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppColor.accentPrimary,
            .font: AppFont.caption.font
        ]

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
