//
//  CourseListCollectionViewCell.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/7/26.
//

import UIKit
import SnapKit

final class CourseListCollectionViewCell: UICollectionViewCell {

    static let identifier = "CourseListCollectionViewCell"

    var onTapLikeButton: (() -> Void)?

    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgMuted
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        return imageView
    }()

    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = AppColor.accentPrimary
        return button
    }()

    private let categoryTagContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()

    private let categoryTagLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = .white
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.cardTitle.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 1
        return label
    }()

    private let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textTertiary
        label.numberOfLines = 1
        return label
    }()

    private let salePriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    private let discountPercentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.accentPrimary
        label.numberOfLines = 1
        return label
    }()

    private let bottomPriceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
        configureAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = nil
        descriptionLabel.text = nil
        categoryTagLabel.text = nil
        originalPriceLabel.attributedText = nil
        salePriceLabel.text = nil
        discountPercentLabel.text = nil

        originalPriceLabel.isHidden = false
        discountPercentLabel.isHidden = false

        thumbnailImageView.image = nil
        onTapLikeButton = nil
    }

    private func configureHierarchy() {
        [
            thumbnailImageView,
            likeButton,
            categoryTagContainerView,
            titleLabel,
            descriptionLabel,
            originalPriceLabel,
            bottomPriceStackView
        ].forEach { contentView.addSubview($0) }

        [
            categoryTagLabel
        ].forEach { categoryTagContainerView.addSubview($0) }

        [
            salePriceLabel,
            discountPercentLabel
        ].forEach { bottomPriceStackView.addArrangedSubview($0) }
    }

    private func configureLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView).offset(10)
            make.trailing.equalTo(thumbnailImageView).inset(10)
            make.size.equalTo(28)
        }

        categoryTagContainerView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImageView).offset(10)
            make.bottom.equalTo(thumbnailImageView).inset(10)
        }

        categoryTagLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10))
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
        }

        bottomPriceStackView.snp.makeConstraints { make in
            make.top.equalTo(originalPriceLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
    }

    private func configureView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        salePriceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        discountPercentLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    private func configureAction() {
        likeButton.addTarget(self, action: #selector(didTapLikeButton), for: .touchUpInside)
    }

    func configure(
        cellViewModel: CourseListCellViewModel,
        thumbnailProvider: CourseThumbnailProviding
    ) {
        titleLabel.text = cellViewModel.title
        descriptionLabel.text = cellViewModel.descriptionText
        categoryTagLabel.text = cellViewModel.categoryTitle

        let likeImage = cellViewModel.isLiked ? AppIcon.heartFill.image : AppIcon.heart.image
        likeButton.setImage(likeImage, for: .normal)

        if cellViewModel.isFree {
            originalPriceLabel.isHidden = true
            discountPercentLabel.isHidden = true

            salePriceLabel.text = "무료"
            salePriceLabel.textColor = AppColor.accentPrimary
        } else if cellViewModel.shouldShowDiscountPercent {
            originalPriceLabel.isHidden = false
            discountPercentLabel.isHidden = false

            if let originalPriceText = cellViewModel.originalPriceText {
                originalPriceLabel.attributedText = NSAttributedString(
                    string: originalPriceText,
                    attributes: [
                        .foregroundColor: AppColor.textTertiary,
                        .font: AppFont.body.font,
                        .strikethroughStyle: NSUnderlineStyle.single.rawValue
                    ]
                )
            } else {
                originalPriceLabel.attributedText = nil
            }

            salePriceLabel.text = cellViewModel.salePriceText
            salePriceLabel.textColor = AppColor.textPrimary
            discountPercentLabel.text = cellViewModel.discountPercentText
        } else {
            originalPriceLabel.isHidden = true
            discountPercentLabel.isHidden = true

            salePriceLabel.text = cellViewModel.salePriceText
            salePriceLabel.textColor = AppColor.textPrimary
        }

        thumbnailProvider.cancelLoad(on: thumbnailImageView)
        thumbnailProvider.loadThumbnail(
            on: thumbnailImageView,
            path: cellViewModel.thumbnailImageURLString
        )
    }

    @objc private func didTapLikeButton() {
        onTapLikeButton?()
    }
}
