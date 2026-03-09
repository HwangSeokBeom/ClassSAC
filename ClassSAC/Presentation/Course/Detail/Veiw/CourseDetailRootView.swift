//
//  CourseDetailRootView.swift
//  ClassSAC
//
//  Created by Hwangseokbeom on 3/9/26.
//

import UIKit
import SnapKit

final class CourseDetailRootView: BaseRootView {

    let scrollView = UIScrollView()
    let contentView = UIView()

    let imageCollectionView: UICollectionView = {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.minimumLineSpacing = 0

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: collectionViewFlowLayout
        )
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    let imagePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = AppColor.textPrimary
        pageControl.pageIndicatorTintColor = AppColor.textTertiary.withAlphaComponent(0.4)
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()

    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        button.tintColor = AppColor.textPrimary
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        return button
    }()

    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white.withAlphaComponent(0.88)
        button.tintColor = AppColor.accentPrimary
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.setImage(AppIcon.heart.image, for: .normal)
        return button
    }()

    let categoryTagLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.textColor = AppColor.tagOrange
        label.backgroundColor = AppColor.tagOrangeBg
        label.font = AppFont.caption.font
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 0
        return label
    }()

    let priceContainerView = UIView()

    let originalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textTertiary
        label.numberOfLines = 1
        return label
    }()

    let salePriceLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    let discountPercentLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.title.font
        label.textColor = AppColor.accentPrimary
        label.numberOfLines = 1
        return label
    }()

    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()

    let durationInfoView = CourseDetailInfoView()
    let locationInfoView = CourseDetailInfoView()
    let capacityInfoView = CourseDetailInfoView()

    let introductionSectionView = CourseDetailSectionHeaderView()
    let introductionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textSecondary
        label.numberOfLines = 0
        return label
    }()

    let creatorSectionView = CourseDetailSectionHeaderView()
    let creatorCardView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColor.bgSurface
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = AppColor.borderSubtle.cgColor
        return view
    }()

    let creatorProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = AppColor.bgMuted
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()

    let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body.font
        label.textColor = AppColor.textPrimary
        label.numberOfLines = 1
        return label
    }()

    let communitySectionView = CourseDetailSectionHeaderView()
    let communityCountLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.caption.font
        label.textColor = AppColor.textSecondary
        label.textAlignment = .right
        return label
    }()

    let firstCommentPreviewView = CourseCommentPreviewView()
    let secondCommentPreviewView = CourseCommentPreviewView()

    let moreCommentsButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        configuration.title = "커뮤니티 더보기"
        configuration.image = UIImage(systemName: "chevron.right")
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 6

        let button = UIButton(configuration: configuration)
        button.tintColor = AppColor.accentPrimary
        button.setTitleColor(AppColor.accentPrimary, for: .normal)

        button.titleLabel?.font = AppFont.caption.font

        return button
    }()

    let loadingIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override func configureHierarchy() {
        [
            scrollView,
            loadingIndicatorView
        ].forEach { addSubview($0) }

        [
            contentView
        ].forEach { scrollView.addSubview($0) }

        [
            imageCollectionView,
            imagePageControl,
            backButton,
            likeButton,
            categoryTagLabel,
            titleLabel,
            priceContainerView,
            infoStackView,
            introductionSectionView,
            introductionLabel,
            creatorSectionView,
            creatorCardView,
            communitySectionView,
            communityCountLabel,
            firstCommentPreviewView,
            secondCommentPreviewView,
            moreCommentsButton
        ].forEach { contentView.addSubview($0) }

        [
            originalPriceLabel,
            priceStackView
        ].forEach { priceContainerView.addSubview($0) }

        [
            salePriceLabel,
            discountPercentLabel
        ].forEach { priceStackView.addArrangedSubview($0) }

        [
            durationInfoView,
            locationInfoView,
            capacityInfoView
        ].forEach { infoStackView.addArrangedSubview($0) }

        [
            creatorProfileImageView,
            creatorNameLabel
        ].forEach { creatorCardView.addSubview($0) }
    }

    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }

        imageCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(imageCollectionView.snp.width).multipliedBy(0.74)
        }

        imagePageControl.snp.makeConstraints { make in
            make.centerX.equalTo(imageCollectionView)
            make.bottom.equalTo(imageCollectionView).inset(14)
        }

        backButton.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(44)
        }

        likeButton.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView).offset(16)
            make.trailing.equalToSuperview().inset(20)
            make.size.equalTo(44)
        }

        categoryTagLabel.snp.makeConstraints { make in
            make.top.equalTo(imageCollectionView.snp.bottom).offset(18)
            make.leading.equalToSuperview().offset(22)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(categoryTagLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        priceContainerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        originalPriceLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        priceStackView.snp.makeConstraints { make in
            make.top.equalTo(originalPriceLabel.snp.bottom).offset(4)
            make.leading.trailing.bottom.equalToSuperview()
        }

        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(priceContainerView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(84)
        }

        introductionSectionView.snp.makeConstraints { make in
            make.top.equalTo(infoStackView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }

        introductionLabel.snp.makeConstraints { make in
            make.top.equalTo(introductionSectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        creatorSectionView.snp.makeConstraints { make in
            make.top.equalTo(introductionLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(22)
        }

        creatorCardView.snp.makeConstraints { make in
            make.top.equalTo(creatorSectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
            make.height.equalTo(88)
        }

        creatorProfileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(48)
        }

        creatorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorProfileImageView.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        communitySectionView.snp.makeConstraints { make in
            make.top.equalTo(creatorCardView.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(22)
            make.height.equalTo(22)
        }

        communityCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(communitySectionView)
            make.trailing.equalToSuperview().inset(22)
            make.leading.greaterThanOrEqualTo(communitySectionView.snp.trailing).offset(12)
        }

        firstCommentPreviewView.snp.makeConstraints { make in
            make.top.equalTo(communitySectionView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        secondCommentPreviewView.snp.makeConstraints { make in
            make.top.equalTo(firstCommentPreviewView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(22)
        }

        moreCommentsButton.snp.makeConstraints { make in
            make.top.equalTo(secondCommentPreviewView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(28)
        }

        loadingIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func configureView() {
        backgroundColor = AppColor.bgPrimary

        introductionSectionView.configure(title: "클래스 소개")
        creatorSectionView.configure(title: "강사 소개")
        communitySectionView.configure(title: "커뮤니티")

        durationInfoView.configure(
            icon: UIImage(systemName: "clock"),
            value: "미정"
        )

        locationInfoView.configure(
            icon: UIImage(systemName: "mappin.and.ellipse"),
            value: "미정"
        )

        capacityInfoView.configure(
            icon: UIImage(systemName: "person.2"),
            value: "미정"
        )

        originalPriceLabel.isHidden = true
        discountPercentLabel.isHidden = true
        firstCommentPreviewView.isHidden = true
        secondCommentPreviewView.isHidden = true
    }
}
