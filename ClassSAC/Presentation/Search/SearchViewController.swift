//
//  SearchViewController.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/6/26.
//

import UIKit
import SnapKit

final class SearchViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 화면"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = AppColor.textPrimary
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureHierarchy()
        configureLayout()
    }

    private func configureView() {
        view.backgroundColor = AppColor.bgPrimary
        navigationItem.title = "검색"
    }

    private func configureHierarchy() {
        [
            titleLabel
        ].forEach { view.addSubview($0) }
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
