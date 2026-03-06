//
//  MainTabBarController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import SnapKit

final class MainTabBarController: UITabBarController {

    private let floatingTabBarView = FloatingTabBarView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureView()
        configureHierarchy()
        configureLayout()
        bind()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.isHidden = true
    }

    private func configureViewControllers() {
        let classBrowseViewController = ListViewController()
        let searchViewController = SearchViewController()
        let favoriteViewController = FavoriteViewController()

        let classBrowseNavigationController = UINavigationController(rootViewController: classBrowseViewController)
        let searchNavigationController = UINavigationController(rootViewController: searchViewController)
        let favoriteNavigationController = UINavigationController(rootViewController: favoriteViewController)

        viewControllers = [
            classBrowseNavigationController,
            searchNavigationController,
            favoriteNavigationController
        ]

        selectedIndex = 0
    }

    private func configureView() {
        view.backgroundColor = AppColor.bgPrimary
        tabBar.isHidden = true
        floatingTabBarView.updateSelectedIndex(0)
    }

    private func configureHierarchy() {
        [
            floatingTabBarView
        ].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        floatingTabBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(28)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(72)
        }
    }

    private func bind() {
        floatingTabBarView.onTapList = { [weak self] in
            self?.selectTab(index: 0)
        }

        floatingTabBarView.onTapSearch = { [weak self] in
            self?.selectTab(index: 1)
        }

        floatingTabBarView.onTapFavorite = { [weak self] in
            self?.selectTab(index: 2)
        }
    }

    private func selectTab(index: Int) {
        selectedIndex = index
        floatingTabBarView.updateSelectedIndex(index)
    }
}
