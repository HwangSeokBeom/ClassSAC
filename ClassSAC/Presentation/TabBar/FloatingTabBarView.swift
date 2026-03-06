//
//  FloatingTabBarView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import SnapKit

final class FloatingTabBarView: BaseRootView {

    var onTapList: (() -> Void)?
    var onTapSearch: (() -> Void)?
    var onTapFavorite: (() -> Void)?

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let view = UIVisualEffectView(effect: blurEffect)
        view.clipsToBounds = true
        return view
    }()

    private let dimOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.28)
        view.isUserInteractionEnabled = false
        return view
    }()

    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    private let listTabButton = FloatingTabButton(
        titleText: "조회",
        image: AppIcon.book.image
    )

    private let searchTabButton = FloatingTabButton(
        titleText: "검색",
        image: AppIcon.search.image
    )

    private let favoriteTabButton = FloatingTabButton(
        titleText: "찜",
        image: AppIcon.heart.image
    )

    override func configureHierarchy() {
        [
            blurEffectView,
            dimOverlayView,
            tabStackView
        ].forEach { addSubview($0) }

        [
            listTabButton,
            searchTabButton,
            favoriteTabButton
        ].forEach { tabStackView.addArrangedSubview($0) }
    }

    override func configureLayout() {
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        dimOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tabStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }

    override func configureView() {
        backgroundColor = .clear
        clipsToBounds = false

        layer.cornerRadius = 36
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.withAlphaComponent(0.12).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 18
        layer.shadowOffset = CGSize(width: 0, height: 6)

        blurEffectView.layer.cornerRadius = 36
        blurEffectView.clipsToBounds = true

        dimOverlayView.layer.cornerRadius = 36
        dimOverlayView.clipsToBounds = true

        listTabButton.addTarget(self, action: #selector(didTapListTabButton), for: .touchUpInside)
        searchTabButton.addTarget(self, action: #selector(didTapSearchTabButton), for: .touchUpInside)
        favoriteTabButton.addTarget(self, action: #selector(didTapFavoriteTabButton), for: .touchUpInside)
    }

    func updateSelectedIndex(_ selectedIndex: Int) {
        listTabButton.setSelectedState(selectedIndex == 0)
        searchTabButton.setSelectedState(selectedIndex == 1)
        favoriteTabButton.setSelectedState(selectedIndex == 2)
    }

    @objc private func didTapListTabButton() {
        onTapList?()
    }

    @objc private func didTapSearchTabButton() {
        onTapSearch?()
    }

    @objc private func didTapFavoriteTabButton() {
        onTapFavorite?()
    }
}
