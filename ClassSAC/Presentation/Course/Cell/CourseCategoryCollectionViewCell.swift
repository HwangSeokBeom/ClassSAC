//
//  CourseCategoryCollectionViewCell.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit
import SnapKit

final class CourseCategoryCollectionViewCell: UICollectionViewCell {

    static let identifier = "CourseCategoryCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            updateSelectionStyle(isSelected: isSelected)
        }
    }

    private func configureHierarchy() {
        [ titleLabel ].forEach { contentView.addSubview($0) }
    }

    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 14, bottom: 8, right: 14))
        }
    }

    private func configureView() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.clipsToBounds = true
        updateSelectionStyle(isSelected: false)
    }

    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        updateSelectionStyle(isSelected: isSelected)
    }

    private func updateSelectionStyle(isSelected: Bool) {
        if isSelected {
            contentView.backgroundColor = AppColor.accentPrimary
            contentView.layer.borderColor = AppColor.accentPrimary.cgColor
            titleLabel.textColor = .white
        } else {
            contentView.backgroundColor = AppColor.bgSurface
            contentView.layer.borderColor = AppColor.borderSubtle.cgColor
            titleLabel.textColor = AppColor.textSecondary
        }
    }
}
