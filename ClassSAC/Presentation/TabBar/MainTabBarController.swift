//
//  MainTabBarController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit

final class MainTabBarController: UITabBarController {

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
        let listViewController = ListViewController()
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
        tabBarMinimizeBehavior = .never

        tabBar.tintColor = AppColor.accentPrimary
        tabBar.unselectedItemTintColor = AppColor.textPrimary
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .clear
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        tabBar.layer.masksToBounds = false
        tabBar.layer.shadowColor = UIColor.clear.cgColor
        tabBar.layer.shadowOpacity = 0
        tabBar.layer.shadowRadius = 0
        tabBar.layer.shadowOffset = .zero

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        tabBarAppearance.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        tabBarAppearance.shadowColor = .clear

        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = AppColor.textPrimary
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: AppColor.textPrimary,
            .font: UIFont.systemFont(ofSize: 10, weight: .semibold)
        ]

        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = AppColor.accentPrimary
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: AppColor.accentPrimary,
            .font: UIFont.systemFont(ofSize: 10, weight: .bold)
        ]

        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
