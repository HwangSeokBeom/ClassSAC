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
        configureTabBarAppearance()
    }

    private func configureView() {
        view.backgroundColor = AppColor.bgPrimary
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
